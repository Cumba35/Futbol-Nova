package com.nova.futbolnova;

import android.content.Context;
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.HashMap;
import java.util.Map;

/** Reads the repository's canonical offline JSON data. It never promotes draft data to playable content. */
final class CanonicalDataRepository {
    static final class Team {
        final String id, name, competitionId, division;
        final JSONArray players;
        Team(String id, String name, String competitionId, String division, JSONArray players) {
            this.id=id; this.name=name; this.competitionId=competitionId; this.division=division; this.players=players;
        }
        boolean isPlayable() {
            if (players == null || players.length() != 22) return false;
            Set<String> ids = new HashSet<>();
            for (int i=0;i<players.length();i++) {
                String id=players.optJSONObject(i)==null?"":players.optJSONObject(i).optString("id","");
                if (id.isEmpty() || !ids.add(id)) return false;
            }
            return true;
        }
    }
    static final class Module {
        final String id,name,category,status,description;
        final boolean downloadable;
        Module(JSONObject o) {
            id=o.optString("id",""); name=o.optString("name","Módulo");
            category=o.optString("category","General"); status=o.optString("status","planned");
            description=o.optString("role",o.optString("description",""));
            downloadable=o.optBoolean("downloadable",false);
        }
        boolean installedOrReady(){return "installed".equals(status)||"available".equals(status)||"ready".equals(status);}
    }

    final List<Team> playableTeams = new ArrayList<>();
    final List<Module> modules = new ArrayList<>();
    final List<JSONObject> customPlayers = new ArrayList<>();
    final Map<String,JSONObject> customPlayersById = new HashMap<>();
    final List<String> warnings = new ArrayList<>();
    int baseClubCount, generatedClubCount, customPlayerCount, baseLeagueCount;
    int firstDivisionTeams, secondDivisionTeams;
    String dataVersion="";

    CanonicalDataRepository(Context context) {
        try {
            JSONObject custom=read(context,"custom_players.json");
            JSONArray customPlayers=custom.optJSONArray("players");
            customPlayerCount=customPlayers==null?0:customPlayers.length();
            if(customPlayers!=null) for(int i=0;i<customPlayers.length();i++){JSONObject p=customPlayers.getJSONObject(i);this.customPlayers.add(p);this.customPlayersById.put(p.optString("id",""),p);}
            dataVersion=custom.optString("schema_version","unknown");
            JSONObject base=read(context,"base_league_clubs_2026.json");
            baseClubCount=base.optInt("club_count",base.optJSONArray("clubs")==null?0:base.optJSONArray("clubs").length());
            JSONObject global=read(context,"global_clubs.generated.json");
            generatedClubCount=global.optJSONArray("clubs")==null?0:global.optJSONArray("clubs").length();
            JSONObject leagues=read(context,"league_content_manifest.json");
            baseLeagueCount=leagues.optJSONArray("base_leagues")==null?0:leagues.optJSONArray("base_leagues").length();
            loadModules(context);
            loadRosterFile(context,"players/cuba_first_division.json","Primera división");
            loadRosterFile(context,"players/cuba_second_division.json","Segunda división");
            if(playableTeams.isEmpty()) warnings.add("No se encontraron plantillas completas y únicas para un amistoso.");
        } catch (Exception e) {
            warnings.add("Error leyendo datos canónicos: "+e.getMessage());
        }
    }

    private void loadModules(Context c) throws Exception {
        JSONObject manifest=read(c,"optional_modules_catalog.json");
        JSONArray a=manifest.optJSONArray("modules");
        if(a!=null) for(int i=0;i<a.length();i++) modules.add(new Module(a.getJSONObject(i)));
    }
    private void loadRosterFile(Context c,String file,String division) {
        try {
            JSONObject root=read(c,file);
            JSONArray rosters=root.optJSONArray("rosters");
            if(rosters==null)return;
            for(int i=0;i<rosters.length();i++) {
                JSONObject r=rosters.getJSONObject(i);
                JSONArray players=r.optJSONArray("players");
                Team t=new Team(r.optString("club_id",""),r.optString("club_name","Club"),
                    r.optString("competition_id",""),division,players);
                if(t.isPlayable()) playableTeams.add(t);
                else warnings.add("Plantilla no habilitada: "+t.name+" (requiere 22 jugadores únicos).");
            }
            if("Primera división".equals(division)) firstDivisionTeams=rosters.length();
            else secondDivisionTeams=rosters.length();
        } catch(Exception e) { warnings.add("No se pudo cargar "+file+": "+e.getMessage()); }
    }
    JSONObject read(Context c,String name) throws Exception {
        try(InputStream in=c.getAssets().open(name); ByteArrayOutputStream out=new ByteArrayOutputStream()) {
            byte[] b=new byte[16384]; int n;
            while((n=in.read(b))>0) out.write(b,0,n);
            return new JSONObject(out.toString(StandardCharsets.UTF_8.name()));
        }
    }
    void applyTeam(int slotStart, Team team) {
        if(team==null||!team.isPlayable())return;
        JSONArray keys=null;
        try { keys=readKeysForTeam(team); } catch(Exception ignored) {}
        String[] attributeKeys={"acc","spd","attp","fin","shot","long","vol","pen","vis","cross","fk","short","longp","curve","agi","bal","react","ctrl","drib","comp","int","head","aware","tack","slide","jump","sta","str","agr","dive","hand","kick","ref","gkspd","gkpos"};
        for(int i=0;i<22;i++) {
            JSONObject p=team.players.optJSONObject(i); if(p==null)continue;
            JSONArray values=p.optJSONArray("attributes");
            float acc=attribute(values,0,70),spd=attribute(values,1,70),drib=attribute(values,18,70);
            float aware=attribute(values,22,70),tack=attribute(values,23,70),slide=attribute(values,24,70);
            int overall=p.optInt("estimated_overall",70);
            float height=(float)p.optDouble("height_cm",175);
            JSONObject custom=customPlayersById.get(p.optString("id",""));
            if(custom!=null){
                JSONObject ca=custom.optJSONObject("attributes");
                if(ca!=null){acc=(float)ca.optDouble("acc",acc);spd=(float)ca.optDouble("spd",spd);drib=(float)ca.optDouble("drib",drib);aware=(float)ca.optDouble("aware",aware);tack=(float)ca.optDouble("tack",tack);slide=(float)ca.optDouble("slide",slide);}
                overall=custom.optInt("overall",overall);height=(float)custom.optDouble("height_cm",height);
            }
            MainActivity.nativeSetPlayerProfile(slotStart+i,height,overall,(acc+spd)*.5f,drib,(aware+tack+slide)/3.0f);
        }
    }
    private static float attribute(JSONArray a,int index,float fallback) {
        return a!=null&&index<a.length()?(float)a.optDouble(index,fallback):fallback;
    }
}
