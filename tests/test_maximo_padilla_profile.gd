extends SceneTree

const PROFILE_PATH := "res://data/custom_players.json"
const PLAYER_SCENE: PackedScene = preload("res://scenes/players/maximo_padilla.tscn")
const PLAYER_SCRIPT = preload("res://scripts/players/maximo_padilla.gd")

func _initialize() -> void:
	# --script runs in an isolated SceneTree; register gameplay actions for the
	# player controller so its physics callback cannot flood headless test logs.
	# The dedicated input-actions test validates the actual project settings.
	for action in ["move_left", "move_right", "move_forward", "move_back", "pass_ball", "shoot_ball", "skill_action", "pressure_action"]:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
	call_deferred("_run")
	call_deferred("_test_watchdog")

func _test_watchdog() -> void:
	await create_timer(45.0).timeout
	push_error("MAXIMO PADILLA PROFILE TEST: superó el límite interno de 45 segundos.")
	quit(1)

func _run() -> void:
	print("MAXIMO_PROFILE_TEST: starting")
	var file := FileAccess.open(PROFILE_PATH, FileAccess.READ)
	assert(file != null, "Debe existir el catálogo de jugadores personalizados")
	var catalog: Dictionary = JSON.parse_string(file.get_as_text())
	var found: Dictionary = {}
	for player in catalog.get("players", []):
		if str(player.get("id", "")) == "NOVA-PLAYER-0036":
			found = player
			break
	assert(not found.is_empty(), "Máximo Padilla debe estar en el catálogo")
	print("MAXIMO_PROFILE_TEST: catalog entry loaded")
	assert(found.get("full_name") == "Máximo Padilla Robert")
	assert(found.get("display_name") == "Máximo Padilla")
	assert(found.get("shirt_name") == "PADILLA")
	assert(found.get("position") == "MCD")
	assert(found.get("secondary_positions", []) == ["MC"])
	assert(found.get("preferred_national_team") == "CUB")
	assert(found.get("favorite_national_team") == "ARG")
	assert(int(found.get("overall", 0)) == 94, "La media general confirmada debe seguir en 94")
	assert(int(found.get("potential", 0)) == 97, "La proyección confirmada debe seguir en 97")
	var base: Dictionary = found.get("base_attributes", {})
	assert(base == found.get("attributes", {}), "Los atributos de juego deben coincidir con los atributos base")
	assert(int(base.get("int", 0)) >= 95 and int(base.get("aware", 0)) >= 95, "Máximo debe destacar en intercepciones y lectura defensiva")
	assert(int(base.get("tack", 0)) >= 95 and int(base.get("str", 0)) >= 95, "Máximo debe destacar en entradas y fuerza")
	assert(int(base.get("longp", 0)) >= 90 and int(base.get("short", 0)) >= 85, "Debe combinar pase seguro y cambio largo")
	assert(found.get("playing_style", {}).get("archetype") == "single_pivot_ball_winner", "Debe tener el perfil de pivote recuperador")
	assert(found.get("visual", {}).get("scene") == "res://scenes/players/maximo_padilla.tscn")
	assert(found.get("visual", {}).get("script") == "res://scripts/players/maximo_padilla.gd")
	var legend_errors := preload("res://scripts/legend/legend_career_service.gd").new().validate_catalog_player({
		"id": "NOVA-PLAYER-0036", "display_name": "Máximo Padilla", "age": 29,
		"nationality_id": "CUB", "primary_position": "MCD", "secondary_positions": ["MC"],
		"height_cm": 180, "weight_kg": 75, "attributes": found.get("attributes", {})
	})
	assert(legend_errors.is_empty(), "Máximo debe superar la validación del catálogo de Modo Leyenda: %s" % str(legend_errors))
	assert(str(found.get("club_id", "")) == "FN-NOVA-C35", "El club actual confirmado de Máximo debe ser Nova C35")
	var club_file := FileAccess.open("res://data/spain_clubs_2026_27.json", FileAccess.READ)
	assert(club_file != null)
	var clubs: Dictionary = JSON.parse_string(club_file.get_as_text())
	var barcelona_has_player := false
	for club in clubs.get("clubs", []):
		if str(club.get("id", "")) == "FN-ESP-BARCELONA":
			barcelona_has_player = club.get("player_ids", []).has("NOVA-PLAYER-0036")
	assert(not barcelona_has_player, "Máximo ya no debe permanecer en Litoral Barcelona después del traspaso confirmado")
	var original_rosters_file := FileAccess.open("res://data/players/nova_original_club_rosters_2026.json", FileAccess.READ)
	assert(original_rosters_file != null)
	var original_rosters: Dictionary = JSON.parse_string(original_rosters_file.get_as_text())
	var c35_roster: Dictionary = {}
	for club in original_rosters.get("clubs", []):
		if str(club.get("id", "")) == "FN-NOVA-C35":
			c35_roster = club
			break
	assert(c35_roster.get("player_ids", []).has("NOVA-PLAYER-0036"), "Máximo debe figurar en la plantilla actual de Nova C35")
	var instance := PLAYER_SCENE.instantiate()
	assert(instance is CharacterBody3D, "La escena debe instanciar un CharacterBody3D")
	assert(instance.get_script() == PLAYER_SCRIPT, "La escena debe usar el controlador de Máximo")
	assert(is_equal_approx(instance.tackle_reach_bonus, 0.18), "El estilo de Máximo debe aplicar un alcance de entrada mejorado")
	assert(is_equal_approx(instance.tackle_angle_bonus, 0.08), "La lectura defensiva debe mejorar el ángulo de entrada")
	var collision := instance.get_node_or_null("CollisionShape3D") as CollisionShape3D
	assert(collision != null and collision.shape is CapsuleShape3D, "El jugador necesita una cápsula de colisión")
	assert(is_equal_approx((collision.shape as CapsuleShape3D).height, 1.8), "La colisión debe corresponder a 180 cm")
	# Disable inherited gameplay physics BEFORE entering the SceneTree.
	# add_child() runs _ready() synchronously; disabling afterwards can allow
	# one or more physics callbacks to query missing actions in isolated --script
	# runs before the test reaches the next line.
	instance.set_physics_process(false)
	root.add_child(instance)
	await process_frame
	var visual := instance.get_node_or_null("MaximoPadillaVisual3D") as Node3D
	assert(visual != null, "El controlador debe construir el modelo visual 3D")
	assert(visual.get_node_or_null("shirt_name_padilla") is Label3D, "La camiseta debe mostrar PADILLA como texto 3D")
	assert(visual.get_node_or_null("shirt_number_30") is Label3D, "La camiseta debe mostrar el dorsal 30 como texto 3D")
	assert(visual.get_node_or_null("inner_shirt_sleeve_right") != null, "Debe existir la manga interior de compresión")
	print("MAXIMO_PROFILE_TEST: 3D scene validated")
	instance.queue_free()
	await process_frame
	var career_service = preload("res://scripts/legend/legend_career_service.gd").new()
	career_service.sync_to_database = false
	var career_test_path := "user://test_maximo_padilla_legend_career.json"
	career_service.persistence_path = career_test_path
	var career_result: Dictionary = career_service.start_career_from_catalog(found)
	assert(career_result.get("ok", false), "Máximo debe poder iniciar una carrera desde el catálogo: %s" % str(career_result.get("error", career_result.get("errors", []))))
	var career_player: Dictionary = career_result.get("career", {}).get("player", {})
	assert(int(career_player.get("age", 0)) == 29, "La edad declarada debe conservarse")
	assert(str(career_player.get("birth_date", "")) == "", "No debe inventarse una fecha de nacimiento")
	assert(str(career_player.get("shirt_name", "")) == "PADILLA", "El nombre de uniforme debe conservarse")
	assert(str(career_result.get("career", {}).get("club_id", "")) == "FN-NOVA-C35", "Debe conservarse el club actual confirmado de Máximo")
	assert(str(career_result.get("career", {}).get("club_name", "")) == "Nova C35", "Debe conservarse el nombre del club actual")
	print("MAXIMO_PROFILE_TEST: career validated")
	career_service.free()
	for cleanup_path in [career_test_path, career_test_path + ".tmp", career_test_path + ".bak"]:
		if FileAccess.file_exists(cleanup_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(cleanup_path))
	print("FUTBOL_NOVA_MAXIMO_PADILLA_PROFILE_TEST: PASS")
	quit(0)
