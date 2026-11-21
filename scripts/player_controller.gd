extends CharacterBody3D

var _procedural_walk_phase := 0.0

signal skill_action_requested
signal pressure_action_requested

@export var move_speed := 7.5
@export var acceleration := 22.0
@export var gravity := 24.0
@export var pass_force := 5.5
@export var shot_force := 10.5
@export var tackle_reach_bonus := 0.0
@export var tackle_angle_bonus := 0.0

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := Vector3(input_vector.x, 0.0, input_vector.y)
	if direction.length_squared() > 1.0:
		direction = direction.normalized()

	velocity.x = move_toward(velocity.x, direction.x * move_speed, acceleration * delta)
	velocity.z = move_toward(velocity.z, direction.z * move_speed, acceleration * delta)
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	if direction.length_squared() > 0.01:
		rotation.y = atan2(-direction.x, -direction.z)

	move_and_slide()
	_update_procedural_walk(delta)

	if Input.is_action_just_pressed("pass_ball"):
		_kick_ball(pass_force)
	if Input.is_action_just_pressed("shoot_ball"):
		_kick_ball(shot_force)
	if Input.is_action_just_pressed("skill_action"):
		skill_action_requested.emit()
	if Input.is_action_just_pressed("pressure_action"):
		pressure_action_requested.emit()

func _update_procedural_walk(delta: float) -> void:
	var visual := get_node_or_null("FootballerVisual") as Node3D
	if visual == null:
		return
	_procedural_walk_phase += delta * (4.5 + velocity.length() * 0.45)
	var intensity := clampf(Vector2(velocity.x, velocity.z).length() / maxf(move_speed, 0.1), 0.0, 1.0)
	var swing := sin(_procedural_walk_phase) * 0.62 * intensity
	var left_leg := visual.get_node_or_null("LeftLegPivot") as Node3D
	var right_leg := visual.get_node_or_null("RightLegPivot") as Node3D
	var left_arm := visual.get_node_or_null("LeftArmPivot") as Node3D
	var right_arm := visual.get_node_or_null("RightArmPivot") as Node3D
	if left_leg != null:
		left_leg.rotation.x = swing
	if right_leg != null:
		right_leg.rotation.x = -swing
	if left_arm != null:
		left_arm.rotation.x = -swing * 0.72
	if right_arm != null:
		right_arm.rotation.x = swing * 0.72

func _kick_ball(force: float) -> void:
	var ball := get_tree().get_first_node_in_group("match_ball") as RigidBody3D
	if ball == null or global_position.distance_to(ball.global_position) > 2.4:
		return
	var forward := -global_transform.basis.z
	var direction := (forward * 0.7 + Vector3.UP * 0.08).normalized()
	var match_controller := get_tree().get_first_node_in_group("match_controller")
	if match_controller != null and match_controller.has_method("has_controlled_possession") and bool(match_controller.has_controlled_possession()):
		# Lateral body movement adds a small, bounded side-spin to the kick.
		var lateral_speed := velocity.dot(global_transform.basis.x)
		var flight_spin := Vector3.UP * clampf(lateral_speed * 2.0, -24.0, 24.0)
		if match_controller.release_controlled_ball(direction, force, flight_spin):
			return
	if match_controller != null and match_controller.has_method("notify_ball_kicked"):
		match_controller.notify_ball_kicked(0.18, str(get_meta("player_id", "")))
	ball.apply_central_impulse(direction * force)
