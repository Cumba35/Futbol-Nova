extends CanvasLayer
class_name NovaPreMatchSetup

signal match_requested(settings: Dictionary)
signal setup_closed

const PANEL_COLOR := Color("#12291d")
const PANEL_ALT := Color("#1b3827")
const ACCENT := Color("#c8f45a")
const TEXT_COLOR := Color("#f4f7ef")
const MUTED := Color("#a8b7aa")
const STADIUM_BUILDER = preload("res://scripts/stadiums/stadium_builder.gd")
const STARTING_POSITION_PRIORITY := [
	["POR", "GK", "G"],
	["LI", "CAI"],
	["DFC"],
	["DFC"],
	["LD", "CAD"],
	["MCD", "MC"],
	["MC", "MCO", "INTERIOR_IZQUIERDO", "INTERIOR_DERECHO"],
	["MCO", "SD", "MC"],
	["EI", "MI", "CAI"],
	["DC", "SD"],
	["ED", "MD", "CAD"]
]

static func get_default_team_indices(team_ids: Array[String]) -> Dictionary:
	var home_index := team_ids.find("FN-ESP-REAL-MADRID")
	var away_index := team_ids.find("FN-ESP-BARCELONA")
	if home_index < 0 and not team_ids.is_empty():
		home_index = 0
	if away_index < 0 or away_index == home_index:
		away_index = -1
		for index in range(team_ids.size()):
			if index != home_index:
				away_index = index
				break
	return {"home": home_index, "away": away_index}

static func _player_rating(raw_player: Variant) -> int:
	if not raw_player is Dictionary:
		return -1
	return int(raw_player.get("overall", raw_player.get("estimated_overall", raw_player.get("overall_rating", 0))))

static func build_starting_eleven(roster: Array) -> Array[String]:
	var selected: Array[String] = []
	var used_ids := {}
	var ordered_roster := roster.duplicate(true)
	ordered_roster.sort_custom(func(a, b):
		var rating_a := _player_rating(a)
		var rating_b := _player_rating(b)
		if rating_a == rating_b:
			var id_a := str(a.get("id", "")) if a is Dictionary else ""
			var id_b := str(b.get("id", "")) if b is Dictionary else ""
			return id_a < id_b
		return rating_a > rating_b
	)
	for preferred_positions in STARTING_POSITION_PRIORITY:
		var selected_id := ""
		# Respect the tactical priority order first, then the player's rating.
		# This prevents a high-rated MCO from occupying the MC slot when a
		# natural MC is available for that position and the next slot is MCO.
		for preferred_position in preferred_positions:
			for raw_player in ordered_roster:
				if not raw_player is Dictionary:
					continue
				var player_id := str(raw_player.get("id", ""))
				var primary_position := str(raw_player.get("primary_position", raw_player.get("position", ""))).to_upper()
				if not player_id.is_empty() and not used_ids.has(player_id) and primary_position == str(preferred_position):
					selected_id = player_id
					break
			if not selected_id.is_empty():
				break
			# A secondary position is considered before moving to the next
			# tactical position, but never reuses a player already selected.
			for raw_player in ordered_roster:
				if not raw_player is Dictionary:
					continue
				var player_id := str(raw_player.get("id", ""))
				if player_id.is_empty() or used_ids.has(player_id):
					continue
				var secondary_positions: Variant = raw_player.get("secondary_positions", [])
				if secondary_positions is Array and secondary_positions.any(func(position): return str(position).to_upper() == str(preferred_position)):
					selected_id = player_id
					break
			if not selected_id.is_empty():
				break
		if selected_id.is_empty():
			for raw_player in ordered_roster:
				if not raw_player is Dictionary:
					continue
				var fallback_id := str(raw_player.get("id", ""))
				if not fallback_id.is_empty() and not used_ids.has(fallback_id):
					selected_id = fallback_id
					break
		if selected_id.is_empty():
			return []
		used_ids[selected_id] = true
		selected.append(selected_id)
	return selected

var _home_teams: OptionButton
var _away_teams: OptionButton
var _summary: Label
var _stadiums: OptionButton
var _half_length: OptionButton
var _clock_mode: OptionButton
var _extra_time: CheckBox
var _penalties: CheckBox
var _start_button: Button
var _team_ids: Array[String] = []
var _custom_players: OptionButton
var _roster_status: Label

func _ready() -> void:
	_build_interface()
	_load_eligible_teams()

func _build_interface() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = Color(0.008, 0.025, 0.016, 0.96)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.add_theme_constant_override("margin_left", 12)
	center.add_theme_constant_override("margin_right", 12)
	center.add_theme_constant_override("margin_top", 12)
	center.add_theme_constant_override("margin_bottom", 12)
	add_child(center)

	var panel := PanelContainer.new()
	var viewport_size := get_viewport().get_visible_rect().size
	var compact_layout := viewport_size.x < 560.0 or viewport_size.y < 480.0
	panel.custom_minimum_size = Vector2(minf(620.0, maxf(300.0, viewport_size.x - 32.0)), minf(620.0, maxf(300.0, viewport_size.y - 32.0)))
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var style := StyleBoxFlat.new()
	style.bg_color = PANEL_COLOR
	style.border_color = ACCENT
	style.set_border_width_all(2)
	style.set_corner_radius_all(18)
	style.content_margin_left = 22
	style.content_margin_right = 22
	style.content_margin_top = 18
	style.content_margin_bottom = 18
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)

	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(scroll)
	var column := VBoxContainer.new()
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.add_theme_constant_override("separation", 14)
	scroll.add_child(column)

	var heading := Label.new()
	heading.text = "PREPARAR PARTIDO AMISTOSO"
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 24)
	heading.add_theme_color_override("font_color", ACCENT)
	column.add_child(heading)

	var description := Label.new()
	description.text = "Selecciona dos clubes con plantillas verificadas. La selección solo afecta a este encuentro."
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description.add_theme_color_override("font_color", MUTED)
	column.add_child(description)

	var teams_row: BoxContainer = VBoxContainer.new() if compact_layout else HBoxContainer.new()
	teams_row.add_theme_constant_override("separation", 12 if compact_layout else 16)
	teams_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(teams_row)

	var home_column := VBoxContainer.new()
	home_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	teams_row.add_child(home_column)
	var home_title := Label.new()
	home_title.text = "LOCAL"
	home_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	home_title.add_theme_font_size_override("font_size", 18)
	home_title.add_theme_color_override("font_color", TEXT_COLOR)
	home_column.add_child(home_title)
	_home_teams = OptionButton.new()
	_home_teams.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_home_teams.custom_minimum_size.y = 48
	_home_teams.item_selected.connect(_on_team_selection_changed)
	home_column.add_child(_home_teams)

	var versus := Label.new()
	versus.text = "VS"
	versus.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	versus.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	versus.add_theme_font_size_override("font_size", 28)
	versus.add_theme_color_override("font_color", ACCENT)
	teams_row.add_child(versus)

	var away_column := VBoxContainer.new()
	away_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	teams_row.add_child(away_column)
	var away_title := Label.new()
	away_title.text = "VISITANTE"
	away_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	away_title.add_theme_font_size_override("font_size", 18)
	away_title.add_theme_color_override("font_color", TEXT_COLOR)
	away_column.add_child(away_title)
	_away_teams = OptionButton.new()
	_away_teams.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_away_teams.custom_minimum_size.y = 48
	_away_teams.item_selected.connect(_on_team_selection_changed)
	away_column.add_child(_away_teams)

	var custom_roster_title := Label.new()
	custom_roster_title.text = "JUGADORES PERSONALIZADOS"
	custom_roster_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	custom_roster_title.add_theme_color_override("font_color", ACCENT)
	column.add_child(custom_roster_title)
	var custom_roster_help := Label.new()
	custom_roster_help.text = "Incorpora tus futbolistas creados a la plantilla del club local o visitante. La asignación queda guardada."
	custom_roster_help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	custom_roster_help.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	custom_roster_help.add_theme_color_override("font_color", MUTED)
	column.add_child(custom_roster_help)
	_custom_players = OptionButton.new()
	_custom_players.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_custom_players.custom_minimum_size.y = 44
	column.add_child(_custom_players)
	var roster_actions := HBoxContainer.new()
	roster_actions.alignment = BoxContainer.ALIGNMENT_CENTER
	roster_actions.add_theme_constant_override("separation", 8)
	column.add_child(roster_actions)
	var add_home_button := Button.new()
	add_home_button.text = "AÑADIR AL LOCAL"
	add_home_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_home_button.custom_minimum_size.y = 44
	add_home_button.pressed.connect(_assign_custom_player_to_selected_team.bind(true))
	roster_actions.add_child(add_home_button)
	var add_away_button := Button.new()
	add_away_button.text = "AÑADIR AL VISITANTE"
	add_away_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_away_button.custom_minimum_size.y = 44
	add_away_button.pressed.connect(_assign_custom_player_to_selected_team.bind(false))
	roster_actions.add_child(add_away_button)
	_roster_status = Label.new()
	_roster_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_roster_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_roster_status.add_theme_color_override("font_color", MUTED)
	column.add_child(_roster_status)
	_refresh_custom_player_options()

	_summary = Label.new()
	_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_summary.add_theme_color_override("font_color", MUTED)
	column.add_child(_summary)

	var stadium_title := Label.new()
	stadium_title.text = "ESTADIO"
	stadium_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stadium_title.add_theme_color_override("font_color", TEXT_COLOR)
	column.add_child(stadium_title)
	_stadiums = OptionButton.new()
	_stadiums.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_stadiums.custom_minimum_size.y = 44
	for stadium in STADIUM_BUILDER.get_catalog():
		_stadiums.add_item(str(stadium.get("name", "Estadio")))
		_stadiums.set_item_metadata(_stadiums.item_count - 1, str(stadium.get("id", "")))
	if _stadiums.item_count > 0:
		_stadiums.select(0)
	column.add_child(_stadiums)

	var match_options := GridContainer.new()
	match_options.columns = 2
	match_options.add_theme_constant_override("h_separation", 14)
	match_options.add_theme_constant_override("v_separation", 8)
	column.add_child(match_options)
	_half_length = OptionButton.new()
	_half_length.add_item("3 min por tiempo", 3)
	_half_length.add_item("5 min por tiempo", 5)
	_half_length.add_item("6 min por tiempo", 6)
	_half_length.add_item("8 min por tiempo", 8)
	_half_length.add_item("10 min por tiempo", 10)
	_half_length.add_item("15 min por tiempo", 15)
	_half_length.add_item("20 min por tiempo", 20)
	_half_length.select(1)
	match_options.add_child(_half_length)
	_clock_mode = OptionButton.new()
	_clock_mode.add_item("Reloj continuo", 0)
	_clock_mode.add_item("Reloj detenido", 1)
	_clock_mode.select(0)
	match_options.add_child(_clock_mode)
	_extra_time = CheckBox.new()
	_extra_time.text = "Permitir prórroga"
	match_options.add_child(_extra_time)
	_penalties = CheckBox.new()
	_penalties.text = "Tanda de penaltis (en desarrollo)"
	_penalties.disabled = true
	match_options.add_child(_penalties)

	var actions := HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	actions.add_theme_constant_override("separation", 12)
	column.add_child(actions)
	var cancel_button := Button.new()
	cancel_button.text = "VOLVER"
	cancel_button.custom_minimum_size = Vector2(140, 48)
	cancel_button.pressed.connect(_close)
	actions.add_child(cancel_button)
	_start_button = Button.new()
	_start_button.text = "INICIAR AMISTOSO"
	_start_button.custom_minimum_size = Vector2(220, 48)
	_start_button.disabled = true
	_start_button.pressed.connect(_start_match)
	actions.add_child(_start_button)

func _get_custom_roster_service() -> Node:
	return get_node_or_null("/root/CustomPlayerRoster")

func _refresh_custom_player_options() -> void:
	if _custom_players == null:
		return
	_custom_players.clear()
	var service := _get_custom_roster_service()
	if service == null:
		_custom_players.add_item("Registro de jugadores no disponible")
		_custom_players.set_item_disabled(0, true)
		return
	var players: Array = service.call("get_created_players")
	for player in players:
		if not player is Dictionary:
			continue
		var player_id := str(player.get("id", "")).strip_edges()
		if player_id.is_empty():
			continue
		var name := str(player.get("display_name", player.get("full_name", player_id)))
		var assigned_team := str(service.call("get_assigned_team_id", player_id))
		var suffix := " • " + assigned_team if not assigned_team.is_empty() else " • Sin club"
		_custom_players.add_item(name + suffix)
		_custom_players.set_item_metadata(_custom_players.item_count - 1, player_id)
	if _custom_players.item_count == 0:
		_custom_players.add_item("No hay jugadores personalizados guardados")
		_custom_players.set_item_disabled(0, true)
	else:
		_custom_players.select(0)

func _selected_custom_player_id() -> String:
	if _custom_players == null or _custom_players.item_count == 0 or _custom_players.selected < 0:
		return ""
	return str(_custom_players.get_item_metadata(_custom_players.selected))

func _assign_custom_player_to_selected_team(home_team: bool) -> void:
	var player_id := _selected_custom_player_id()
	var team_id := _selected_team_id(_home_teams if home_team else _away_teams)
	var service := _get_custom_roster_service()
	if service == null or player_id.is_empty() or team_id.is_empty():
		if _roster_status != null:
			_roster_status.text = "Selecciona un jugador personalizado y un club."
		return
	var result: Dictionary = service.call("assign_created_player_to_team", player_id, team_id)
	if bool(result.get("ok", false)):
		var registry: Variant = _get_football_registry()
		var team_name := str(registry.teams_by_id.get(team_id, {}).get("name", team_id)) if registry != null else team_id
		_roster_status.text = "Jugador incorporado a " + team_name + ". La plantilla se guardó correctamente."
	else:
		_roster_status.text = str(result.get("error", "No se pudo modificar la plantilla."))
	_refresh_custom_player_options()
	_refresh_validation()

func _get_combined_team_roster(team_id: String) -> Array:
	var registry: Variant = _get_football_registry()
	if registry == null or not registry.teams_by_id.has(team_id):
		return []
	# The shared registry already merges official and assigned custom players.
	return registry.get_team_roster(team_id)

func _get_football_registry() -> Variant:
	var football_data_service: Node = get_node_or_null("/root/FootballData")
	return football_data_service.get("registry") if football_data_service != null else null

func _load_eligible_teams() -> void:
	_home_teams.clear()
	_away_teams.clear()
	_team_ids.clear()
	var registry: Variant = _get_football_registry()
	if registry == null:
		_summary.text = "El catálogo de clubes no está disponible. No se puede iniciar el amistoso."
		return

	var ids: Array = registry.teams_by_id.keys()
	ids.sort()
	for raw_id in ids:
		var team_id := str(raw_id)
		var team: Dictionary = registry.teams_by_id[team_id]
		var roster: Array = _get_combined_team_roster(team_id)
		if roster.is_empty():
			continue
		var display_name := str(team.get("name", team.get("short_name", team_id))).strip_edges()
		if display_name.is_empty():
			display_name = team_id
		_home_teams.add_item(display_name)
		_away_teams.add_item(display_name)
		var item_index := _home_teams.item_count - 1
		_home_teams.set_item_metadata(item_index, team_id)
		_away_teams.set_item_metadata(item_index, team_id)
		_team_ids.append(team_id)

	if _team_ids.size() >= 2:
		var defaults := get_default_team_indices(_team_ids)
		var home_index := int(defaults.get("home", -1))
		var away_index := int(defaults.get("away", -1))
		if home_index >= 0 and away_index >= 0 and home_index != away_index:
			_home_teams.select(home_index)
			_away_teams.select(away_index)
			_refresh_validation()
		else:
			_summary.text = "No se pudieron asignar dos clubes diferentes para el amistoso."
			_start_button.disabled = true
	else:
		_summary.text = "Se necesitan al menos dos clubes con once jugadores válidos."
		_start_button.disabled = true

func _selected_team_id(selector: OptionButton) -> String:
	if selector == null or selector.item_count == 0 or selector.selected < 0:
		return ""
	return str(selector.get_item_metadata(selector.selected))

func _refresh_validation() -> void:
	var home_id := _selected_team_id(_home_teams)
	var away_id := _selected_team_id(_away_teams)
	var valid := not home_id.is_empty() and not away_id.is_empty() and home_id != away_id
	var registry: Variant = _get_football_registry()
	valid = valid and registry != null
	var home_roster: Array = _get_combined_team_roster(home_id) if valid else []
	var away_roster: Array = _get_combined_team_roster(away_id) if valid else []
	valid = valid and home_roster.size() >= 11 and away_roster.size() >= 11
	valid = valid and not _selected_stadium_id().is_empty()
	_start_button.disabled = not valid
	if home_id == away_id and not home_id.is_empty():
		_summary.text = "El equipo local y el visitante deben ser diferentes."
	elif valid:
		_summary.text = "Plantillas verificadas: %d jugadores locales y %d visitantes. Alineaciones iniciales: 11 por equipo." % [home_roster.size(), away_roster.size()]
	else:
		_summary.text = "No se pudo validar una de las plantillas. El partido permanece bloqueado."

func _selected_stadium_id() -> String:
	if _stadiums == null or _stadiums.item_count == 0 or _stadiums.selected < 0:
		return ""
	return str(_stadiums.get_item_metadata(_stadiums.selected))

func _on_team_selection_changed(_index: int) -> void:
	_refresh_validation()

func _start_match() -> void:
	_refresh_validation()
	if _start_button.disabled:
		return
	var home_id := _selected_team_id(_home_teams)
	var away_id := _selected_team_id(_away_teams)
	var registry: Variant = _get_football_registry()
	if registry == null or not registry.teams_by_id.has(home_id) or not registry.teams_by_id.has(away_id):
		_summary.text = "El catálogo de clubes dejó de estar disponible. No se puede iniciar el amistoso."
		_start_button.disabled = true
		return
	var home_team: Dictionary = registry.teams_by_id[home_id]
	var away_team: Dictionary = registry.teams_by_id[away_id]
	var home_roster: Array = _get_combined_team_roster(home_id)
	var away_roster: Array = _get_combined_team_roster(away_id)
	var home_player_ids := build_starting_eleven(home_roster)
	var away_player_ids := build_starting_eleven(away_roster)
	var players_by_id: Dictionary = {}
	for raw_player in home_roster + away_roster:
		if raw_player is Dictionary:
			var player_id := str(raw_player.get("id", "")).strip_edges()
			if not player_id.is_empty():
				players_by_id[player_id] = raw_player.duplicate(true)
	if home_player_ids.size() != 11 or away_player_ids.size() != 11:
		_summary.text = "La plantilla contiene un identificador de jugador inválido."
		_start_button.disabled = true
		return
	match_requested.emit({
		"match_type": "friendly",
		"home_team_id": home_id,
		"away_team_id": away_id,
		"home_team_name": str(home_team.get("name", home_id)),
		"away_team_name": str(away_team.get("name", away_id)),
		"home_player_ids": home_player_ids,
		"away_player_ids": away_player_ids,
		"players_by_id": players_by_id,
		"stadium_id": _selected_stadium_id(),
		"half_length_minutes": _half_length.get_selected_id(),
		"clock_mode": "stopped" if _clock_mode.get_selected_id() == 1 else "continuous",
		"extra_time_enabled": _extra_time.button_pressed,
		"competition_allows_extra_time": _extra_time.button_pressed,
		"penalties_enabled": _penalties.button_pressed,
		"competition_allows_penalties": _penalties.button_pressed
	})
	queue_free()

func _close() -> void:
	setup_closed.emit()
	queue_free()
