extends SceneTree

const MATCH_11V11 = preload("res://scripts/gameplay/match_11v11_controller.gd")

func _initialize() -> void:
	call_deferred("_run_tests")

func _run_tests() -> void:
	var failures := PackedStringArray()
	var home_position := Vector3(0.0, 0.35, -40.0)
	var away_position := Vector3(0.0, 0.35, 40.0)
	var home_swapped_position := Vector3(0.0, 0.35, 40.0)

	if not MATCH_11V11.should_ai_shoot(home_position, true, false):
		failures.append("La IA local no reconoce una ocasión clara de tiro hacia -Z.")
	if not MATCH_11V11.should_ai_shoot(away_position, false, false):
		failures.append("La IA visitante no reconoce una ocasión clara de tiro hacia +Z.")
	if not MATCH_11V11.should_ai_shoot(home_swapped_position, true, true):
		failures.append("La IA local no reconoce la ocasión después del cambio de lado.")
	if MATCH_11V11.should_ai_shoot(Vector3(0.0, 0.35, -20.0), true, false):
		failures.append("La IA intenta rematar desde demasiado lejos.")
	if MATCH_11V11.should_ai_shoot(Vector3(0.0, 3.0, -40.0), true, false):
		failures.append("La IA intenta rematar un balón demasiado alto.")
	if MATCH_11V11.should_ai_shoot(Vector3(34.0, 0.35, -40.0), true, false):
		failures.append("La IA acepta una posición de balón fuera del límite lateral de juego.")

	var home_direction: Vector3 = MATCH_11V11.ai_shot_direction(home_position, true, false)
	var away_direction: Vector3 = MATCH_11V11.ai_shot_direction(away_position, false, false)
	var swapped_direction: Vector3 = MATCH_11V11.ai_shot_direction(home_swapped_position, true, true)
	if home_direction.z >= 0.0 or home_direction.y <= 0.0:
		failures.append("El tiro local no se dirige hacia la portería rival con elevación.")
	if away_direction.z <= 0.0 or away_direction.y <= 0.0:
		failures.append("El tiro visitante no se dirige hacia la portería rival con elevación.")
	if swapped_direction.z <= 0.0:
		failures.append("El tiro local no invierte su dirección tras cambiar de lado.")

	# Integration check: an AI striker with possession must release a real
	# physics ball toward goal instead of endlessly passing/clearing it.
	var controller = MATCH_11V11.new()
	root.add_child(controller)
	var actor := Node3D.new()
	actor.position = home_position
	controller.add_child(actor)
	var ball := RigidBody3D.new()
	ball.mass = 0.43
	ball.position = home_position
	var collision := CollisionShape3D.new()
	var sphere := SphereShape3D.new()
	sphere.radius = 0.22
	collision.shape = sphere
	ball.add_child(collision)
	root.add_child(ball)
	await physics_frame

	controller._ball = ball
	controller._possession_owner = actor
	controller._active = true
	var actor_data := {
		"node": actor,
		"player_id": "friendly_ai_shooter_test",
		"team_id": "home_test",
		"home_team": true,
		"role": "ST",
		"kick_cooldown": 0.0,
		"tackle_cooldown": 0.0,
		"player_data": {"attributes": {"shot": 90, "fin": 90}}
	}
	controller._actors.append(actor_data)
	controller.call("_try_ai_ball_action", 0, actor_data)
	await physics_frame
	if ball.linear_velocity.length() < 1.0:
		failures.append("La IA con posesión en zona de remate no aplicó un impulso real al balón.")
	if controller._possession_owner != null:
		failures.append("La IA conservó la posesión después de ejecutar el tiro.")

	controller.queue_free()
	ball.queue_free()
	if not failures.is_empty():
		for failure in failures:
			push_error("FÚTBOL NOVA AI SHOOTING: " + failure)
		quit(1)
		return
	print("FÚTBOL NOVA AI SHOOTING: selección de tiro, orientación por lado y lanzamiento físico superados.")
	quit(0)
