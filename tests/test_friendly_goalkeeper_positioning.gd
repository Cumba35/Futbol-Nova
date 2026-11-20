extends SceneTree

const MATCH_11V11 = preload("res://scripts/gameplay/match_11v11_controller.gd")

func _initialize() -> void:
	call_deferred("_run_tests")

func _run_tests() -> void:
	var failures := PackedStringArray()
	var home_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(0.0, 0.35, 40.0), true, false)
	var away_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(0.0, 0.35, -40.0), false, false)
	var swapped_home_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(0.0, 0.35, -40.0), true, true)
	var midfield_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(2.0, 0.35, 0.0), true, false)
	var extreme_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(40.0, 0.35, 40.0), true, false)

	if home_keeper.z >= 49.0 or home_keeper.z < 43.0:
		failures.append("El portero local no adelanta su posición de forma gradual ante peligro en su área.")
	if away_keeper.z <= -49.0 or away_keeper.z > -43.0:
		failures.append("El portero visitante no adelanta su posición en su propia área.")
	if swapped_home_keeper.z >= -43.0:
		failures.append("El portero local no cambia correctamente de portería tras el descanso.")
	if absf(midfield_keeper.z - 49.0) > 0.01:
		failures.append("El portero abandona su línea cuando el balón está en el medio campo.")
	if absf(midfield_keeper.x - 0.84) > 0.01:
		failures.append("El portero no ajusta lateralmente su posición a la trayectoria del balón.")
	if absf(extreme_keeper.x) > 3.1:
		failures.append("El portero puede salir del espacio protegido por los postes.")
	var anticipating_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(0.0, 0.35, 40.0), true, false, Vector3(4.0, 0.0, 6.0))
	var retreating_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(0.0, 0.35, 40.0), true, false, Vector3(4.0, 0.0, -6.0))
	var away_anticipating_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(0.0, 0.35, -40.0), false, false, Vector3(4.0, 0.0, -6.0))
	if anticipating_keeper.x <= 1.5:
		failures.append("El portero local no anticipa el cruce lateral del balón que se acerca a su portería.")
	if absf(retreating_keeper.x) > 0.01:
		failures.append("El portero se desplaza hacia una trayectoria que se aleja de su portería.")
	if away_anticipating_keeper.x <= 1.5:
		failures.append("El portero visitante no anticipa la trayectoria del balón hacia su portería.")
	if not home_keeper.is_finite() or not away_keeper.is_finite() or not swapped_home_keeper.is_finite():
		failures.append("El cálculo de posición del portero produjo coordenadas no finitas.")

	# Verify the live tactical target path uses the tested goalkeeper helper.
	var controller = MATCH_11V11.new()
	root.add_child(controller)
	var ball = RigidBody3D.new()
	ball.position = Vector3(0.0, 0.35, 40.0)
	ball.linear_velocity = Vector3(4.0, 0.0, 6.0)
	root.add_child(ball)
	controller._ball = ball
	var keeper_actor := Node3D.new()
	var keeper_data := {
		"node": keeper_actor,
		"role": "GK",
		"home_team": true,
		"home_position": Vector3(0.0, 0.0, 49.0)
	}
	var live_target: Vector3 = controller.call("_choose_target", 0, keeper_data)
	var expected_target: Vector3 = MATCH_11V11.goalkeeper_home_position(ball.position, true, false, ball.linear_velocity)
	if live_target.distance_to(expected_target) > 0.001:
		failures.append("El controlador de partido no usa el posicionamiento probado para el portero.")
	controller.queue_free()
	ball.queue_free()
	keeper_actor.free()

	# Integration check: a real rigid-body shot must collide with the
	# goalkeeper capsule and rebound instead of passing through the model.
	var keeper_controller = MATCH_11V11.new()
	root.add_child(keeper_controller)
	keeper_controller.call("_create_ai_actor", {
		"player_id": "keeper_physics_test",
		"team_id": "home_test",
		"role": "GK",
		"home_team": true,
		"position": Vector3.ZERO,
		"player_data": {}
	})
	var keeper_node: Node3D = keeper_controller.get_node("keeper_physics_test")
	var keeper_collision = keeper_node.get_node_or_null("GoalkeeperCollision")
	if not (keeper_collision is AnimatableBody3D):
		failures.append("El portero no tiene un cuerpo físico animable sincronizado con su movimiento.")
	else:
		var keeper_shape_node = keeper_collision.get_node_or_null("CollisionShape3D")
		if not (keeper_shape_node is CollisionShape3D) or not (keeper_shape_node.shape is CapsuleShape3D):
			failures.append("La colisión física del portero no utiliza una cápsula válida.")
	# Moving the tactical actor must move its physics body as well.
	keeper_node.global_position = Vector3(1.25, 0.0, 0.0)
	if keeper_collision is AnimatableBody3D and absf(keeper_collision.global_position.x - 1.25) > 0.01:
		failures.append("La colisión del portero no acompaña el movimiento táctico del actor.")
	keeper_node.global_position = Vector3.ZERO
	var shot_ball := RigidBody3D.new()
	shot_ball.mass = 0.43
	shot_ball.gravity_scale = 0.0
	shot_ball.position = Vector3(0.0, 0.92, 1.35)
	shot_ball.linear_velocity = Vector3(0.0, 0.0, -12.0)
	var shot_collision := CollisionShape3D.new()
	var shot_sphere := SphereShape3D.new()
	shot_sphere.radius = 0.22
	shot_collision.shape = shot_sphere
	shot_ball.add_child(shot_collision)
	root.add_child(shot_ball)
	for frame_index in range(18):
		await physics_frame
	if shot_ball.linear_velocity.z <= 0.5:
		failures.append("El disparo atravesó al portero o no rebotó tras el contacto físico.")
	keeper_controller.queue_free()
	shot_ball.queue_free()

	if not failures.is_empty():
		for failure in failures:
			push_error("FÚTBOL NOVA GOALKEEPER POSITIONING: " + failure)
		quit(1)
		return
	print("FÚTBOL NOVA GOALKEEPER: posicionamiento, colisión móvil y bloqueo físico superados.")
	quit(0)
