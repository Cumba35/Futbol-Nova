package com.nova.futbolnova;

import android.app.Activity;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.view.View;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Color;
import android.view.MotionEvent;
import android.widget.FrameLayout;
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

public final class MainActivity extends Activity {
    static { System.loadLibrary("futbolnova"); }
    private GameSurface game;

    private static native void nativeTouch(float x, float y, int action, int width, int height);
    private static native void nativePause(boolean paused);
    private static native void nativeSetPlayerProfile(int slot, float heightCm, int overall, float pace, float dribbling, float defending);

    @Override public void onCreate(Bundle state) {
        super.onCreate(state);
        getWindow().getDecorView().setSystemUiVisibility(
            View.SYSTEM_UI_FLAG_FULLSCREEN | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
            View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY | View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
            View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
        FrameLayout root = new FrameLayout(this);
        game = new GameSurface();
        root.addView(game);
        root.addView(new TouchHud());
        setContentView(root);
    }

    @Override protected void onPause() { super.onPause(); if (game != null) game.onPause(); nativePause(true); }
    @Override protected void onResume() { super.onResume(); if (game != null) game.onResume(); nativePause(false); }

    private final class GameSurface extends GLSurfaceView {
        GameSurface() {
            super(MainActivity.this);
            setEGLContextClientVersion(3);
            setPreserveEGLContextOnPause(true);
            setRenderer(new Renderer() {
                @Override public void onSurfaceCreated(javax.microedition.khronos.opengles.GL10 gl,
                        javax.microedition.khronos.egl.EGLConfig config) { nativeInit(); loadCanonicalPlayerProfiles(); }
                @Override public void onSurfaceChanged(javax.microedition.khronos.opengles.GL10 gl, int w, int h) { nativeResize(w, h); }
                @Override public void onDrawFrame(javax.microedition.khronos.opengles.GL10 gl) { nativeFrame(); }
            });
            setRenderMode(GLSurfaceView.RENDERMODE_CONTINUOUSLY);
        }
    }

    private void loadCanonicalPlayerProfiles() {
        try (InputStream in = getAssets().open("custom_players.json");
             ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[8192]; int n;
            while ((n = in.read(buffer)) > 0) out.write(buffer, 0, n);
            JSONObject root = new JSONObject(out.toString(StandardCharsets.UTF_8.name()));
            JSONArray players = root.getJSONArray("players");
            for (int i = 0; i < players.length(); i++) {
                JSONObject p = players.getJSONObject(i);
                String id = p.optString("id", "");
                JSONObject a = p.optJSONObject("attributes");
                if (a == null) continue;
                if ("NOVA-PLAYER-0035".equals(id))
                    nativeSetPlayerProfile(10, (float)p.optDouble("height_cm", 171), p.optInt("overall", 92),
                        (float)((a.optDouble("acc",90)+a.optDouble("spd",90))/2.0),
                        (float)a.optDouble("drib",91), (float)a.optDouble("aware",84));
                else if ("NOVA-PLAYER-0036".equals(id))
                    nativeSetPlayerProfile(15, (float)p.optDouble("height_cm", 180), p.optInt("overall", 94),
                        (float)((a.optDouble("acc",76)+a.optDouble("spd",76))/2.0),
                        (float)a.optDouble("drib",74), (float)a.optDouble("aware",97));
            }
        } catch (Exception ex) {
            android.util.Log.e("FutbolNova", "No se pudieron cargar perfiles canónicos; se usarán perfiles base.", ex);
        }
    }

    private native void nativeInit();
    private native void nativeResize(int width, int height);
    private native void nativeFrame();

    private final class TouchHud extends View {
        private final Paint p = new Paint(3);
        TouchHud() { super(MainActivity.this); setLayerType(View.LAYER_TYPE_SOFTWARE, null); }
        @Override protected void onDraw(Canvas c) {
            float w=getWidth(), h=getHeight(), s=Math.min(w,h);
            p.setStyle(Paint.Style.STROKE); p.setStrokeWidth(3); p.setColor(0xB8C9F45A);
            c.drawCircle(s*.17f,h*.79f,s*.105f,p);
            p.setStyle(Paint.Style.FILL); p.setColor(0xB8C9F45A);
            c.drawCircle(s*.17f,h*.79f,s*.035f,p);
            drawButton(c,p,w-s*.18f,h*.77f,s*.07f,"TIRO");
            drawButton(c,p,w-s*.31f,h*.60f,s*.055f,"PASE");
            drawButton(c,p,w-s*.18f,h*.58f,s*.055f,"REGATE");
            drawButton(c,p,w-s*.18f,h*.92f,s*.055f,"PRESIÓN");
        }
        private void drawButton(Canvas c, Paint p, float x,float y,float r,String label) {
            p.setStyle(Paint.Style.STROKE); p.setStrokeWidth(3); p.setColor(0xD8C9F45A); c.drawCircle(x,y,r,p);
            p.setStyle(Paint.Style.FILL); p.setColor(Color.WHITE); p.setTextAlign(Paint.Align.CENTER);
            p.setTextSize(Math.max(12,r*.34f)); c.drawText(label,x,y+ p.getTextSize()*.35f,p);
        }
        @Override public boolean onTouchEvent(MotionEvent e) {
            nativeTouch(e.getX(),e.getY(),e.getActionMasked(),getWidth(),getHeight());
            return true;
        }
    }
}
