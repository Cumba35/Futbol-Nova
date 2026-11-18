extends SceneTree

const MAIN_SCENE := preload("res://scenes/main.tscn")
const GOAL_PREFIXES := ["Home", "Away"]
const GOAL_PARTS := [
	"GoalPostLeftCollision",
	"GoalPostRightCollision",
	"GoalCrossbarCollision",
	"GoalNetBackCollision",
	"GoalNetLeftCollision",
	"GoalNetRightCollision",
	"GoalNetRoofCollision"
]

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var failures := PackedStringArray()
	var game = MAIN_SCENE.instantiate()
	root.add_child(game)
	for _frame in range(60):
		await process_frame
		if game.ball != null:
			break

	if game.ball == null or not is_instance_valid(game.ball):
		push_error("GOAL FRAME PHYSICS: no se creó el balón.")
		game.queue_free()
		quit(1)
		return

	for prefix in GOAL_PREFIXES:
		for part in GOAL_PARTS:
			var node := game.get_node_or_null(NodePath(prefix + part))
			if not (node is StaticBody3D):
				failures.append("Falta colisión física: " + prefix + part)
				continue
			var has_shape := false
			for child in node.get_children():
				if child is CollisionShape3D and child.shape != null:
					has_shape = true
			if not has_shape:
				failures.append("La colisión no tiene CollisionShape3D: " + prefix + part)

	var ball: RigidBody3D = game.ball
	ball.freeze = false
	ball.sleeping = false
	ball.global_position = Vector3(-4.5, 1.265, 52.5)
	ball.linear_velocity = Vector3(12.0, 0.0, 0.0)
	ball.angular_velocity = Vector3.ZERO
	for _step in range(18):
		await physics_frame
	if ball.global_position.x > -3.90:
		failures.append("El balón atravesó el poste izquierdo de la portería visitante.")
	if ball.linear_velocity.x > 1.0:
		failures.append("El poste no frenó el movimiento lateral del balón.")

	ball.global_position = Vector3(0.0, 2.95, 52.5)
	ball.linear_velocity = Vector3(0.0, -12.0, 0.0)
	ball.angular_velocity = Vector3.ZERO
	ball.sleeping = false
	for _step in range(18):
		await physics_frame
	if ball.global_position.y < 2.55:
		failures.append("El balón atravesó el larguero.")

	var score_before := int(game.score_away)
	ball.global_position = Vector3(0.0, 1.0, 55.5)
	ball.linear_velocity = Vector3(0.0, 0.0, -12.0)
	ball.angular_velocity = Vector3.ZERO
	ball.sleeping = false
	for _step in range(18):
		await physics_frame
	if ball.global_position.z < 54.5:
		failures.append("La red trasera no contuvo el balón.")
	if int(game.score_away) != score_before:
		failures.append("Un balón que entró desde detrás de la portería concedió un gol falso.")

	game.queue_free()
	await process_frame
	if not failures.is_empty():
		for failure in failures:
			push_error("GOAL FRAME PHYSICS: " + failure)
		quit(1)
		return
	print("GOAL FRAME PHYSICS: marcos, largueros, redes y entradas por detrás comprobados.")
	quit(0)
