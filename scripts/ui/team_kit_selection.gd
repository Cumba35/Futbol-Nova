extends CanvasLayer
class_name NovaTeamKitSelection

signal confirmed(selection: Dictionary)
signal cancelled

const ACCENT := Color("#ff0755")
const PALETTE := [
	Color("#173c91"), Color("#b51f32"), Color("#08784c"), Color("#e0e0e0"),
	Color("#171923"), Color("#e6b52d"), Color("#5b318b"), Color("#168d9d"),
	Color("#f06b24"), Color("#6c283e")
]
const KIT_LABELS := ["LOCAL", "VISITANTE", "PORTERO"]

var teams: Array[Dictionary] = []
var team_ids: Array[String] = []
var home_team_id := ""
var away_team_id := ""
var home_kit_index := 0
var away_kit_index := 1

var _home_name: Label
var _away_name: Label
var _home_kit_name: Label
var _away_kit_name: Label
var _home_preview: SubViewport
var _away_preview: SubViewport
var _home_crest: Label
var _away_crest: Label

func configure(team_catalog: Dictionary, eligible_ids: Array[String], selected_home: String, selected_away: String) -> void:
	team_ids = eligible_ids.duplicate()
	for team_id in team_ids:
		if team_catalog.has(team_id) and team_catalog[team_id] is Dictionary:
			teams.append(team_catalog[team_id].duplicate(true))
	home_team_id = selected_home
	away_team_id = selected_away

func _ready() -> void:
	_build_screen()
	_refresh_all()

func _build_screen() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = Color(0.015, 0.018, 0.035, 0.98)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.add_theme_constant_override("margin_left", 18)
	center.add_theme_constant_override("margin_right", 18)
	center.add_theme_constant_override("margin_top", 12)
	center.add_theme_constant_override("margin_bottom", 12)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(1120, 650)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color("#101522")
	panel_style.border_color = Color("#30394d")
	panel_style.set_border_width_all(1)
	panel_style.set_content_margin_all(18)
	panel.add_theme_stylebox_override("panel", panel_style)
	center.add_child(panel)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 12)
	panel.add_child(root)

	var heading := Label.new()
	heading.text = "EQUIPOS Y UNIFORMES"
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 27)
	heading.add_theme_color_override("font_color", Color.WHITE)
	root.add_child(heading)

	var subheading := Label.new()
	subheading.text = "ELIGE LOS CLUBES Y SUS EQUIPACIONES PARA ESTE PARTIDO"
	subheading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subheading.add_theme_font_size_override("font_size", 12)
	subheading.add_theme_color_override("font_color", Color("#9ca8bc"))
	root.add_child(subheading)

	var columns := HBoxContainer.new()
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 16)
	root.add_child(columns)
	_build_team_column(columns, true)
	var versus := Label.new()
	versus.text = "VS"
	versus.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	versus.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	versus.add_theme_font_size_override("font_size", 30)
	versus.add_theme_color_override("font_color", ACCENT)
	columns.add_child(versus)
	_build_team_column(columns, false)

	var footer := HBoxContainer.new()
	footer.alignment = BoxContainer.ALIGNMENT_CENTER
	footer.add_theme_constant_override("separation", 16)
	root.add_child(footer)
	var cancel_button := Button.new()
	cancel_button.text = "VOLVER"
	cancel_button.custom_minimum_size = Vector2(170, 48)
	cancel_button.pressed.connect(func(): cancelled.emit(); queue_free())
	footer.add_child(cancel_button)
	var confirm_button := Button.new()
	confirm_button.text = "CONFIRMAR SELECCIÓN"
	confirm_button.custom_minimum_size = Vector2(280, 50)
	var confirm_style := StyleBoxFlat.new()
	confirm_style.bg_color = ACCENT
	confirm_style.set_corner_radius_all(4)
	confirm_button.add_theme_stylebox_override("normal", confirm_style)
	confirm_button.add_theme_color_override("font_color", Color.WHITE)
	confirm_button.pressed.connect(_confirm)
	footer.add_child(confirm_button)

func _build_team_column(parent: HBoxContainer, home: bool) -> void:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#1b2333") if home else Color("#171f2d")
	style.border_color = Color("#36425a")
	style.set_border_width_all(1)
	style.set_content_margin_all(12)
	card.add_theme_stylebox_override("panel", style)
	parent.add_child(card)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 7)
	card.add_child(column)

	var side_title := Label.new()
	side_title.text = "LOCAL  /  HOME" if home else "VISITANTE  /  AWAY"
	side_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	side_title.add_theme_font_size_override("font_size", 15)
	side_title.add_theme_color_override("font_color", Color("#c4cede"))
	column.add_child(side_title)

	var crest := Label.new()
	crest.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	crest.add_theme_font_size_override("font_size", 34)
	crest.add_theme_color_override("font_color", Color.WHITE)
	column.add_child(crest)
	if home:
		_home_crest = crest
	else:
		_away_crest = crest

	var team_name := Label.new()
	team_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	team_name.add_theme_font_size_override("font_size", 20)
	team_name.add_theme_color_override("font_color", Color.WHITE)
	column.add_child(team_name)
	if home:
		_home_name = team_name
	else:
		_away_name = team_name

	var team_controls := HBoxContainer.new()
	team_controls.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_child(team_controls)
	var previous_team := Button.new()
	previous_team.text = "‹"
	previous_team.custom_minimum_size = Vector2(48, 40)
	previous_team.pressed.connect(_cycle_team.bind(home, -1))
	team_controls.add_child(previous_team)
	var change_team := Button.new()
	change_team.text = "CAMBIAR EQUIPO"
	change_team.custom_minimum_size = Vector2(160, 40)
	change_team.pressed.connect(_cycle_team.bind(home, 1))
	team_controls.add_child(change_team)
	var next_team := Button.new()
	next_team.text = "›"
	next_team.custom_minimum_size = Vector2(48, 40)
	next_team.pressed.connect(_cycle_team.bind(home, 1))
	team_controls.add_child(next_team)

	var preview := SubViewport.new()
	preview.size = Vector2i(420, 390)
	preview.own_world_3d = true
	preview.transparent_bg = false
	preview.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	var preview_container := SubViewportContainer.new()
	preview_container.custom_minimum_size = Vector2(280, 270)
	preview_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	preview_container.stretch = true
	preview_container.add_child(preview)
	column.add_child(preview_container)
	if home:
		_home_preview = preview
	else:
		_away_preview = preview

	var kit_title := Label.new()
	kit_title.text = "EQUIPACIÓN"
	kit_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	kit_title.add_theme_font_size_override("font_size", 12)
	kit_title.add_theme_color_override("font_color", Color("#9ca8bc"))
	column.add_child(kit_title)

	var kit_controls := HBoxContainer.new()
	kit_controls.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_child(kit_controls)
	var previous_kit := Button.new()
	previous_kit.text = "‹"
	previous_kit.custom_minimum_size = Vector2(48, 42)
	previous_kit.pressed.connect(_cycle_kit.bind(home, -1))
	kit_controls.add_child(previous_kit)
	var kit_name := Label.new()
	kit_name.custom_minimum_size.x = 150
	kit_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	kit_name.add_theme_font_size_override("font_size", 16)
	kit_name.add_theme_color_override("font_color", Color.WHITE)
	kit_controls.add_child(kit_name)
	if home:
		_home_kit_name = kit_name
	else:
		_away_kit_name = kit_name
	var next_kit := Button.new()
	next_kit.text = "›"
	next_kit.custom_minimum_size = Vector2(48, 42)
	next_kit.pressed.connect(_cycle_kit.bind(home, 1))
	kit_controls.add_child(next_kit)

func _team(team_id: String) -> Dictionary:
	for team in teams:
		if str(team.get("id", "")) == team_id:
			return team
	return {}

func _cycle_team(home: bool, direction: int) -> void:
	if team_ids.size() < 2:
		return
	var current_id := home_team_id if home else away_team_id
	var index := team_ids.find(current_id)
	for attempt in range(team_ids.size()):
		index = posmod(index + direction, team_ids.size())
		var candidate := team_ids[index]
		if (home and candidate != away_team_id) or (not home and candidate != home_team_id):
			if home:
				home_team_id = candidate
			else:
				away_team_id = candidate
			_refresh_all()
			return

func _cycle_kit(home: bool, direction: int) -> void:
	if home:
		home_kit_index = posmod(home_kit_index + direction, KIT_LABELS.size())
	else:
		away_kit_index = posmod(away_kit_index + direction, KIT_LABELS.size())
	_refresh_all()

func _team_base_color(team_id: String) -> Color:
	var index := posmod(abs(team_id.hash()), PALETTE.size())
	return PALETTE[index]

func _kit_colors(team_id: String, kit_index: int) -> Dictionary:
	var base := _team_base_color(team_id)
	match kit_index:
		0:
			return {"shirt": base, "shorts": base.darkened(0.25), "socks": base}
		1:
			return {"shirt": Color("#f0f1f4"), "shorts": Color("#202737"), "socks": Color("#f0f1f4")}
		2:
			return {"shirt": Color("#e6b52d"), "shorts": Color("#222a38"), "socks": Color("#e6b52d")}
	return {"shirt": base, "shorts": base.darkened(0.25), "socks": base}

func _refresh_all() -> void:
	var home := _team(home_team_id)
	var away := _team(away_team_id)
	if home.is_empty() or away.is_empty():
		return
	_home_name.text = str(home.get("display_name", home.get("name", home_team_id)))
	_away_name.text = str(away.get("display_name", away.get("name", away_team_id)))
	_home_crest.text = str(_home_name.text.substr(0, 1)).to_upper()
	_away_crest.text = str(_away_name.text.substr(0, 1)).to_upper()
	_home_kit_name.text = KIT_LABELS[home_kit_index]
	_away_kit_name.text = KIT_LABELS[away_kit_index]
	_build_player_preview(_home_preview, _kit_colors(home_team_id, home_kit_index))
	_build_player_preview(_away_preview, _kit_colors(away_team_id, away_kit_index))

func _build_player_preview(viewport: SubViewport, colors: Dictionary) -> void:
	for child in viewport.get_children():
		child.queue_free()
	var world := Node3D.new()
	viewport.add_child(world)
	var environment_node := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("#20283a")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("#d8e1f0")
	environment.ambient_light_energy = 0.8
	environment_node.environment = environment
	world.add_child(environment_node)
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-28, -25, 0)
	light.light_energy = 1.5
	world.add_child(light)
	var fill := OmniLight3D.new()
	fill.position = Vector3(-2, 2, 3)
	fill.light_energy = 0.7
	world.add_child(fill)

	var mannequin := Node3D.new()
	mannequin.position.y = -0.8
	world.add_child(mannequin)
	_add_capsule(mannequin, Vector3(0, 1.55, 0), 0.22, 0.42, Color("#c99a78"))
	_add_capsule(mannequin, Vector3(0, 0.93, 0), 0.36, 0.9, colors.shirt)
	_add_capsule(mannequin, Vector3(-0.49, 0.92, 0), 0.12, 0.65, colors.shirt, Vector3(0, 0, -18))
	_add_capsule(mannequin, Vector3(0.49, 0.92, 0), 0.12, 0.65, colors.shirt, Vector3(0, 0, 18))
	_add_capsule(mannequin, Vector3(-0.18, 0.22, 0), 0.16, 0.58, colors.shorts)
	_add_capsule(mannequin, Vector3(0.18, 0.22, 0), 0.16, 0.58, colors.shorts)
	_add_capsule(mannequin, Vector3(-0.18, -0.3, 0), 0.105, 0.58, colors.socks)
	_add_capsule(mannequin, Vector3(0.18, -0.3, 0), 0.105, 0.58, colors.socks)
	var camera := Camera3D.new()
	camera.position = Vector3(0, 0.9, 4.8)
	camera.look_at(Vector3(0, 0.65, 0), Vector3.UP)
	camera.current = true
	world.add_child(camera)

func _add_capsule(parent: Node3D, position: Vector3, radius: float, height: float, color: Color, rotation_degrees: Vector3 = Vector3.ZERO) -> void:
	var instance := MeshInstance3D.new()
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	instance.mesh = mesh
	instance.position = position
	instance.rotation_degrees = rotation_degrees
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.78
	instance.material_override = material
	parent.add_child(instance)

func _confirm() -> void:
	if home_team_id.is_empty() or away_team_id.is_empty() or home_team_id == away_team_id:
		return
	confirmed.emit({
		"home_team_id": home_team_id,
		"away_team_id": away_team_id,
		"home_kit_id": KIT_LABELS[home_kit_index].to_lower(),
		"away_kit_id": KIT_LABELS[away_kit_index].to_lower()
	})
	queue_free()
