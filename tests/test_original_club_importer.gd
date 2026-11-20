extends SceneTree

const REGISTRY_SCRIPT = preload("res://scripts/data/football_data_registry.gd")
const ORIGINAL_CLUB_IMPORTER = preload("res://scripts/data/original_club_importer.gd")
const PRE_MATCH_SETUP = preload("res://scripts/ui/pre_match_setup.gd")
const RAYMOND_SCENE = preload("res://scenes/players/raymond_valdez.tscn")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var registry = REGISTRY_SCRIPT.new()
	var result: Dictionary = ORIGINAL_CLUB_IMPORTER.import_into_registry(registry)
	assert(bool(result.get("ok", false)), "El importador debe completar los dos clubes: %s" % str(result.get("errors", [])))
	assert(registry.teams_by_id.size() == 2, "Deben registrarse exactamente los dos clubes originales del amistoso.")
	assert(registry.players_by_id.size() == 44, "Deben registrarse 44 perfiles: 41 ficticios y 3 perfiles confirmados.")
	for team_id in ["FN-NOVA-C35", "FN-NOVA-RDA"]:
		assert(registry.teams_by_id.has(team_id), "Falta el club " + team_id)
		var roster: Array = registry.get_team_roster(team_id)
		assert(roster.size() == 22, "La plantilla debe contener 22 jugadores: " + team_id)
		var ids := {}
		for player in roster:
			var player_id := str(player.get("id", ""))
			assert(not player_id.is_empty() and not ids.has(player_id), "La plantilla contiene IDs vacíos o duplicados.")
			ids[player_id] = true
		assert(PRE_MATCH_SETUP.build_starting_eleven(roster).size() == 11, "El club debe generar un once válido: " + team_id)
	assert(registry.teams_by_id["FN-NOVA-C35"].player_ids.has("NOVA-PLAYER-0035"))
	assert(registry.teams_by_id["FN-NOVA-C35"].player_ids.has("NOVA-PLAYER-0036"))
	assert(registry.teams_by_id["FN-NOVA-RDA"].player_ids.has("NOVA-PLAYER-0037"))
	var raymond: Dictionary = registry.players_by_id["NOVA-PLAYER-0037"]
	assert(raymond.get("display_name") == "Raymond Valdez")
	assert(raymond.get("primary_position") == "DC")
	assert(raymond.get("secondary_positions", []) == ["MCO"])
	assert(int(raymond.get("shirt_number", 0)) == 5)
	assert(int(raymond.get("height_cm", 0)) == 171 and int(raymond.get("weight_kg", 0)) == 63)
	assert(int(raymond.get("estimated_overall", 0)) == 91 and int(raymond.get("potential", 0)) == 96)
	assert(int(raymond.get("statistics", {}).get("career", {}).get("appearances", -1)) == 0)
	for player in registry.players_by_id.values():
		if bool(player.get("fictional", false)):
			assert(int(player.get("statistics", {}).get("career", {}).get("appearances", -1)) == 0, "Los jugadores ficticios deben iniciar sin estadísticas históricas.")
	assert(registry.competitions_by_id.is_empty(), "Los clubes amistosos no deben añadirse a una competición de liga.")
	var raymond_avatar := RAYMOND_SCENE.instantiate() as CharacterBody3D
	assert(raymond_avatar != null, "Debe instanciarse el avatar controlable de Raymond.")
	root.add_child(raymond_avatar)
	await process_frame
	assert(raymond_avatar.get_node_or_null("CollisionShape3D") is CollisionShape3D, "Raymond necesita colisión física.")
	assert(raymond_avatar.get_node_or_null("RaymondProceduralPlaceholder") is Node3D, "Debe existir un modelo visual procedural provisional.")
	assert(raymond_avatar.has_method("play_skill_animation") and raymond_avatar.has_method("play_goal_celebration"), "Raymond debe exponer las animaciones originales de habilidad y celebración.")
	raymond_avatar.call("play_skill_animation")
	raymond_avatar.call("play_goal_celebration")
	raymond_avatar.queue_free()
	await process_frame
	print("FUTBOL_NOVA_ORIGINAL_CLUB_IMPORTER_TEST: PASS")
	quit(0)
