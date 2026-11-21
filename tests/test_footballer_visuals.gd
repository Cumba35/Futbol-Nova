extends SceneTree

const VISUAL_BUILDER := preload("res://scripts/visuals/footballer_visual_builder.gd")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var failures := PackedStringArray()
	var home := VISUAL_BUILDER.create_visual({"player_id": "NOVA-TEST-HOME", "role": "CM", "shirt_number": 35}, true)
	var away := VISUAL_BUILDER.create_visual({"player_id": "NOVA-TEST-AWAY", "role": "ST", "shirt_number": 9}, false)
	var goalkeeper := VISUAL_BUILDER.create_visual({"player_id": "NOVA-TEST-GK", "role": "GK", "shirt_number": 1}, true)

	for visual in [home, away, goalkeeper]:
		for required_node in ["Torso", "Head", "Hair", "Shorts", "LeftArmPivot", "RightArmPivot", "LeftLegPivot", "RightLegPivot"]:
			if visual.get_node_or_null(required_node) == null:
				failures.append("Falta el componente 3D %s en %s." % [required_node, visual.name])
		if not bool(visual.get_meta("procedural_footballer", false)):
			failures.append("El actor no está identificado como modelo 3D procedural.")

	if home.get_node_or_null("Torso") == null or away.get_node_or_null("Torso") == null:
		failures.append("Los equipos no generaron torso 3D.")
	else:
		var home_material := (home.get_node("Torso") as MeshInstance3D).material_override as StandardMaterial3D
		var away_material := (away.get_node("Torso") as MeshInstance3D).material_override as StandardMaterial3D
		if home_material == null or away_material == null or home_material.albedo_color == away_material.albedo_color:
			failures.append("Los uniformes local y visitante no tienen colores diferenciados.")

	var glove_count := 0
	for child in goalkeeper.get_children():
		if str(child.name).ends_with("GoalkeeperGlove"):
			glove_count += 1
	if glove_count != 2:
		failures.append("El portero no recibió sus dos guantes 3D.")

	for visual in [home, away, goalkeeper]:
		visual.free()

	if failures.is_empty():
		print("FOOTBALLER_VISUAL_TEST: PASS — 3D humanoide, extremidades articuladas y equipaciones.")
		quit(0)
	else:
		for failure in failures:
			push_error("FOOTBALLER_VISUAL_TEST: " + failure)
		quit(1)
