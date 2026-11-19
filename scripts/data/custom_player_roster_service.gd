extends Node
class_name NovaCustomPlayerRosterService

const ROSTER_PATH := "user://custom_player_roster.json"
const SELECTION_PATH := "user://online_custom_player_selection.json"
const SCHEMA_VERSION := "1.1.0"
const PREVIOUS_SCHEMA_VERSION := "1.0.0"
const PLAYER_STATISTICS = preload("res://scripts/data/player_statistics_service.gd")

var _players: Array = []
var _team_assignments: Dictionary = {}
var _selected_online_player_id := ""
var _loaded := false

func _ready() -> void:
	_load_roster()
	_load_selection()

func add_created_player(player: Dictionary) -> Dictionary:
	if str(player.get("origin", "user_created")) != "user_created":
		return {"ok": false, "error": "Solo se pueden guardar aquí jugadores creados por el usuario."}
	var normalized_player: Dictionary = PLAYER_STATISTICS.normalize_player(player)
	normalized_player["origin"] = "user_created"
	var player_id := str(normalized_player.get("id", "")).strip_edges()
	var player_name := str(normalized_player.get("display_name", normalized_player.get("full_name", ""))).strip_edges()
	var attributes: Dictionary = normalized_player.get("attributes", {})
	if player_id.is_empty() or player_name.length() < 2 or attributes.size() != 35:
		return {"ok": false, "error": "La ficha personalizada está incompleta; se requieren identidad y 35 atributos."}
	_load_roster()
	for index in range(_players.size()):
		if str(_players[index].get("id", "")) == player_id:
			var previous_player: Dictionary = _players[index].duplicate(true)
			_players[index] = normalized_player.duplicate(true)
			if not _save_roster():
				_players[index] = previous_player
				return {"ok": false, "error": "No se pudo actualizar el jugador personalizado."}
			return {"ok": true, "player_id": player_id}
	_players.append(normalized_player.duplicate(true))
	if not _save_roster():
		_players.pop_back()
		return {"ok": false, "error": "No se pudo guardar el archivo independiente de jugadores personalizados."}
	return {"ok": true, "player_id": player_id}

func get_created_players() -> Array:
	_load_roster()
	return _players.duplicate(true)

func assign_created_player_to_team(player_id: String, team_id: String) -> Dictionary:
	_load_roster()
	player_id = player_id.strip_edges()
	team_id = team_id.strip_edges()
	if player_id.is_empty() or team_id.is_empty():
		return {"ok": false, "error": "Selecciona un jugador y un club válido."}
	var player_exists := false
	for player in _players:
		if str(player.get("id", "")) == player_id:
			player_exists = true
			break
	if not player_exists:
		return {"ok": false, "error": "Solo puedes incorporar jugadores que hayas creado."}
	var football_data: Node = get_node_or_null("/root/FootballData")
	if football_data != null:
		var registry: Variant = football_data.get("registry")
		if registry == null or not registry.teams_by_id.has(team_id):
			return {"ok": false, "error": "El club seleccionado no existe en el catálogo."}
	var previous_assignments := _team_assignments.duplicate(true)
	for assigned_team_id in _team_assignments.keys():
		var ids: Array = _team_assignments[assigned_team_id]
		ids.erase(player_id)
		if ids.is_empty():
			_team_assignments.erase(assigned_team_id)
	_team_assignments[team_id] = _team_assignments.get(team_id, []).duplicate()
	if not _team_assignments[team_id].has(player_id):
		_team_assignments[team_id].append(player_id)
	if not _save_roster():
		_team_assignments = previous_assignments
		return {"ok": false, "error": "No se pudo guardar la incorporación a la plantilla."}
	return {"ok": true, "player_id": player_id, "team_id": team_id}

func remove_created_player_from_team(player_id: String, team_id: String) -> Dictionary:
	_load_roster()
	if not _team_assignments.has(team_id):
		return {"ok": false, "error": "Ese jugador no está asignado a este club."}
	var previous_assignments := _team_assignments.duplicate(true)
	var ids: Array = _team_assignments[team_id]
	ids.erase(player_id)
	if ids.is_empty():
		_team_assignments.erase(team_id)
	if not _save_roster():
		_team_assignments = previous_assignments
		return {"ok": false, "error": "No se pudo guardar el cambio de plantilla."}
	return {"ok": true, "player_id": player_id, "team_id": team_id}

func get_players_for_team(team_id: String) -> Array:
	_load_roster()
	var result: Array = []
	var assigned_ids: Array = _team_assignments.get(team_id, [])
	for player in _players:
		if str(player.get("id", "")) in assigned_ids:
			result.append(player.duplicate(true))
	return result

func get_assigned_team_id(player_id: String) -> String:
	_load_roster()
	for team_id in _team_assignments:
		if player_id in _team_assignments[team_id]:
			return str(team_id)
	return ""

func get_online_selected_player_id() -> String:
	_load_selection()
	return _selected_online_player_id

func get_online_selected_player() -> Dictionary:
	_load_roster()
	_load_selection()
	for player in _players:
		if str(player.get("id", "")) == _selected_online_player_id:
			return player.duplicate(true)
	return {}

func select_for_online(player_id: String) -> Dictionary:
	_load_roster()
	var found := false
	for player in _players:
		if str(player.get("id", "")) == player_id:
			found = true
			break
	if not found:
		return {"ok": false, "error": "Ese jugador no pertenece a tu lista de futbolistas creados."}
	var previous_selection := _selected_online_player_id
	_selected_online_player_id = player_id
	if not _save_selection():
		_selected_online_player_id = previous_selection
		return {"ok": false, "error": "No se pudo guardar la selección para Online."}
	return {"ok": true, "player_id": player_id}

func clear_online_selection() -> void:
	_selected_online_player_id = ""
	_save_selection()

func _load_roster() -> void:
	if _loaded:
		return
	_loaded = true
	if not FileAccess.file_exists(ROSTER_PATH):
		return
	var file := FileAccess.open(ROSTER_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary and str(parsed.get("schema_version", "")) in [SCHEMA_VERSION, PREVIOUS_SCHEMA_VERSION] and parsed.get("players", []) is Array:
		_players = []
		for player in parsed.get("players", []):
			if player is Dictionary and str(player.get("origin", "user_created")) == "user_created":
				var normalized_player: Dictionary = PLAYER_STATISTICS.normalize_player(player)
				normalized_player["origin"] = "user_created"
				_players.append(normalized_player)
		var assignments = parsed.get("team_assignments", {})
		_team_assignments = assignments.duplicate(true) if assignments is Dictionary else {}
		for team_id in _team_assignments.keys():
			if not _team_assignments[team_id] is Array:
				_team_assignments.erase(team_id)
				continue
			var valid_ids: Array = []
			for player_id in _team_assignments[team_id]:
				for player in _players:
					if str(player.get("id", "")) == str(player_id):
						valid_ids.append(str(player_id))
						break
			_team_assignments[team_id] = valid_ids
		for team_id in _team_assignments.keys().duplicate():
			if _team_assignments[team_id].is_empty():
				_team_assignments.erase(team_id)

func _load_selection() -> void:
	if not _selected_online_player_id.is_empty() or not FileAccess.file_exists(SELECTION_PATH):
		return
	var file := FileAccess.open(SELECTION_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		_selected_online_player_id = str(parsed.get("player_id", ""))
	if not _selected_online_player_id.is_empty() and get_online_selected_player().is_empty():
		_selected_online_player_id = ""

func _save_roster() -> bool:
	return _write_json_atomically(ROSTER_PATH, {"schema_version": SCHEMA_VERSION, "players": _players, "team_assignments": _team_assignments})

func _save_selection() -> bool:
	return _write_json_atomically(SELECTION_PATH, {"schema_version": SCHEMA_VERSION, "player_id": _selected_online_player_id})

func _write_json_atomically(path: String, data: Dictionary) -> bool:
	var temporary_path := path + ".tmp"
	var file := FileAccess.open(temporary_path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(data, "\t"))
	file.flush()
	var write_error := file.get_error()
	file.close()
	if write_error != OK:
		return false
	var absolute_path := ProjectSettings.globalize_path(path)
	var temporary_absolute := ProjectSettings.globalize_path(temporary_path)
	if FileAccess.file_exists(path):
		var backup_absolute := ProjectSettings.globalize_path(path + ".bak")
		if FileAccess.file_exists(path + ".bak"):
			DirAccess.remove_absolute(backup_absolute)
		var backup_error := DirAccess.rename_absolute(absolute_path, backup_absolute)
		if backup_error != OK:
			return false
	var rename_error := DirAccess.rename_absolute(temporary_absolute, absolute_path)
	if rename_error != OK:
		var backup_path := ProjectSettings.globalize_path(path + ".bak")
		if FileAccess.file_exists(backup_path):
			DirAccess.rename_absolute(backup_path, absolute_path)
		return false
	return true
