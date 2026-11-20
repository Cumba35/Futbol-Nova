extends RefCounted
class_name NovaOriginalClubImporter

const ROSTERS_PATH := "res://data/players/nova_original_club_rosters_2026.json"
const CUSTOM_PLAYERS_PATH := "res://data/custom_players.json"
const PLAYER_STATISTICS = preload("res://scripts/data/player_statistics_service.gd")
const REQUIRED_CUSTOM_PLAYER_IDS := ["NOVA-PLAYER-0035", "NOVA-PLAYER-0036", "NOVA-PLAYER-0037"]

static func import_into_registry(registry: NovaFootballDataRegistry) -> Dictionary:
	if registry == null:
		return {"ok": false, "teams_added": 0, "players_added": 0, "errors": ["Registro no disponible."]}
	var errors := PackedStringArray()
	var roster_data := _read_json(ROSTERS_PATH, errors)
	var custom_data := _read_json(CUSTOM_PLAYERS_PATH, errors)
	if not errors.is_empty():
		return _result(false, 0, 0, errors)
	var custom_by_id: Dictionary = {}
	for raw_player in custom_data.get("players", []):
		if raw_player is Dictionary:
			custom_by_id[str(raw_player.get("id", ""))] = raw_player
	var pending_players: Array = []
	for player_id in REQUIRED_CUSTOM_PLAYER_IDS:
		if not custom_by_id.has(player_id):
			errors.append("Falta el perfil confirmado requerido: " + player_id)
			continue
		var canonical := _canonicalize_custom_player(custom_by_id[player_id])
		if not registry.players_by_id.has(player_id):
			pending_players.append(canonical)
	for raw_player in roster_data.get("players", []):
		if not raw_player is Dictionary:
			errors.append("La plantilla contiene un perfil no válido.")
			continue
		var player_id := str(raw_player.get("id", ""))
		if player_id.is_empty():
			errors.append("La plantilla contiene un jugador sin ID.")
			continue
		if not registry.players_by_id.has(player_id):
			pending_players.append(raw_player.duplicate(true))
	if not errors.is_empty():
		return _result(false, 0, 0, errors)
	var added := registry.register_players(pending_players)
	if added != pending_players.size():
		for error in registry.last_errors:
			errors.append(str(error))
		return _result(false, 0, added, errors)
	var teams_added := 0
	for raw_team in roster_data.get("clubs", []):
		if not raw_team is Dictionary:
			errors.append("Definición de club original inválida.")
			continue
		var team_id := str(raw_team.get("id", ""))
		var player_ids: Array = raw_team.get("player_ids", [])
		if team_id.is_empty() or player_ids.size() != 22:
			errors.append("El club %s debe declarar exactamente 22 jugadores." % team_id)
			continue
		var unique_ids := {}
		for player_id in player_ids:
			var key := str(player_id)
			if key.is_empty() or unique_ids.has(key):
				errors.append("ID vacío o duplicado en la plantilla de " + team_id + ": " + key)
			unique_ids[key] = true
			if not registry.players_by_id.has(key):
				errors.append("Jugador no registrado para " + team_id + ": " + key)
		if not errors.is_empty():
			continue
		var team := {
			"id": team_id,
			"name": str(raw_team.get("name", team_id)),
			"country_id": str(raw_team.get("country_id", "CUB")),
			"season": "2026",
			"competition_id": "",
			"division_level": 0,
			"competition_level": 0,
			"player_ids": player_ids.duplicate(),
			"fictional": true,
			"identity": {
				"identity_type": "owner_created_original_club",
				"stadium_id": str(raw_team.get("stadium_id", "")),
				"roster_source": ROSTERS_PATH
			}
		}
		if registry.teams_by_id.has(team_id):
			var existing: Dictionary = registry.teams_by_id[team_id]
			if str(existing.get("name", "")) != str(team.name):
				errors.append("Ya existe un club con ID reservado y nombre distinto: " + team_id)
			else:
				existing["player_ids"] = player_ids.duplicate()
				existing["identity"] = team.identity.duplicate(true)
		elif registry.register_team(team):
			teams_added += 1
		else:
			errors.append("No se pudo registrar el club original: " + team_id)
	if not errors.is_empty():
		return _result(false, teams_added, added, errors)
	for raw_team in roster_data.get("clubs", []):
		var team_id := str(raw_team.get("id", ""))
		var roster: Array = registry.get_team_roster(team_id)
		if roster.size() != 22:
			errors.append("Plantilla no resuelta para %s: %d/22." % [team_id, roster.size()])
		var eleven: Array[String] = []
		for player in roster:
			if player is Dictionary and not str(player.get("id", "")).is_empty():
				if eleven.size() < 11:
					eleven.append(str(player.id))
		if eleven.size() != 11:
			errors.append("No se pudo construir un once para " + team_id)
	return _result(errors.is_empty(), teams_added, added, errors)

static func _canonicalize_custom_player(source: Dictionary) -> Dictionary:
	var player := source.duplicate(true)
	player["display_name"] = str(player.get("display_name", player.get("name", player.get("full_name", ""))))
	player["primary_position"] = str(player.get("primary_position", player.get("position", "")))
	player["nationality_id"] = str(player.get("nationality_id", player.get("nationality", "UNK")))
	player["estimated_overall"] = int(player.get("estimated_overall", player.get("overall", 50)))
	player["club_id"] = str(player.get("club_id", ""))
	return PLAYER_STATISTICS.normalize_player(player)

static func _read_json(path: String, errors: PackedStringArray) -> Dictionary:
	if not FileAccess.file_exists(path):
		errors.append("No existe el archivo: " + path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		errors.append("No se pudo abrir: " + path)
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		errors.append("JSON inválido: " + path)
		return {}
	return parsed

static func _result(ok: bool, teams_added: int, players_added: int, errors: PackedStringArray) -> Dictionary:
	return {"ok": ok, "teams_added": teams_added, "players_added": players_added, "errors": errors}
