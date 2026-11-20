extends SceneTree

const Match11v11 = preload("res://scripts/gameplay/match_11v11_controller.gd")

func _initialize() -> void:
	call_deferred("_run_tests")

func _run_tests() -> void:
	await process_frame
	var failures := PackedStringArray()
	var controller := Match11v11.new()
	root.add_child(controller)
	var player := CharacterBody3D.new()
	player.name = "FriendlyValidationControlledPlayer"
	root.add_child(player)
	var ball := RigidBody3D.new()
	ball.name = "FriendlyValidationBall"
	var ball_collision := CollisionShape3D.new()
	var ball_shape := SphereShape3D.new()
	ball_shape.radius = 0.22
	ball_collision.shape = ball_shape
	ball.add_child(ball_collision)
	root.add_child(ball)
	await physics_frame

	var home_ids: Array[String] = []
	var away_ids: Array[String] = []
	for index in range(11):
		home_ids.append("C35_%02d" % index)
		away_ids.append("RDA_%02d" % index)
	var valid_settings := {
		"home_team_id": "FN-NOVA-C35",
		"away_team_id": "FN-NOVA-RDA",
		"home_player_ids": home_ids,
		"away_player_ids": away_ids,
		"controlled_player_id": "C35_09",
		"half_length_minutes": 3,
		"clock_mode": "continuous"
	}
	var started: Dictionary = controller.start_match(player, ball, valid_settings)
	if not bool(started.get("ok", false)):
		failures.append("No se pudo iniciar el partido válido de referencia: " + str(started.get("error", "")))
	else:
		var initial_summary: Dictionary = controller.get_match_summary()
		if not bool(initial_summary.get("active", false)) or int(initial_summary.get("ai_players", 0)) != 21:
			failures.append("El partido de referencia no quedó activo con sus 21 actores de IA.")

		var invalid_same_team: Dictionary = controller.start_match(player, ball, {
			"home_team_id": "FN-NOVA-C35",
			"away_team_id": "FN-NOVA-C35"
		})
		if bool(invalid_same_team.get("ok", false)):
			failures.append("El motor aceptó el mismo club como local y visitante.")
		var after_same_team: Dictionary = controller.get_match_summary()
		if not controller.is_match_active() or str(after_same_team.get("home_team_id", "")) != "FN-NOVA-C35" or str(after_same_team.get("away_team_id", "")) != "FN-NOVA-RDA" or int(after_same_team.get("ai_players", 0)) != 21:
			failures.append("Una selección duplicada interrumpió o alteró el amistoso que ya estaba activo.")

		var incomplete_ids: Array[String] = home_ids.slice(0, 10)
		var invalid_lineup: Dictionary = controller.start_match(player, ball, {
			"home_team_id": "FN-NOVA-C35",
			"away_team_id": "FN-NOVA-RDA",
			"home_player_ids": incomplete_ids,
			"away_player_ids": away_ids
		})
		if bool(invalid_lineup.get("ok", false)):
			failures.append("El motor aceptó una alineación local con diez titulares.")
		if not controller.is_match_active() or int(controller.get_match_summary().get("ai_players", 0)) != 21:
			failures.append("Una alineación incompleta interrumpió el amistoso activo.")

		var invalid_controlled_player: Dictionary = controller.start_match(player, ball, {
			"home_team_id": "FN-NOVA-C35",
			"away_team_id": "FN-NOVA-RDA",
			"home_player_ids": home_ids,
			"away_player_ids": away_ids,
			"controlled_player_id": "PLAYER_NOT_IN_HOME_LINEUP"
		})
		if bool(invalid_controlled_player.get("ok", false)):
			failures.append("El motor aceptó un futbolista controlado que no pertenece al once local.")
		if not controller.is_match_active() or int(controller.get_match_summary().get("ai_players", 0)) != 21:
			failures.append("Un ID de jugador controlado inválido interrumpió el amistoso activo.")

		var restarted: Dictionary = controller.start_match(player, ball, valid_settings)
		if not bool(restarted.get("ok", false)):
			failures.append("No se pudo reiniciar un amistoso válido después de rechazar solicitudes inválidas.")
		else:
			var restarted_summary: Dictionary = controller.get_match_summary()
			if not controller.is_match_active() or int(restarted_summary.get("home_players", 0)) != 11 or int(restarted_summary.get("away_players", 0)) != 11 or int(restarted_summary.get("ai_players", 0)) != 21:
				failures.append("El reinicio válido no reemplazó la sesión anterior por exactamente 22 futbolistas.")

	controller.stop_match()
	controller.queue_free()
	player.queue_free()
	ball.queue_free()
	await process_frame
	if failures.is_empty():
		print("FUTBOL_NOVA_MATCH_START_ATOMIC_VALIDATION: PASS")
		quit(0)
	else:
		for failure in failures:
			push_error("FUTBOL_NOVA_MATCH_START_ATOMIC_VALIDATION: " + failure)
		quit(1)
