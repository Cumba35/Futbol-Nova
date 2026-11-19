extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var touch_script = load("res://scripts/input/touch_controls.gd")
	assert(touch_script != null, "Touch controls script must load")
	var controls = touch_script.new()
	root.add_child(controls)
	await process_frame

	# Simulate two fingers holding movement and a match action when a menu opens.
	Input.action_press("move_left")
	Input.action_press("shoot_ball")
	controls.joystick_touch_id = 7
	controls.joystick_vector = Vector2.LEFT
	controls.action_touch_ids[8] = "shoot_ball"
	controls.pressed_actions["shoot_ball"] = true
	controls.visible = false
	await process_frame

	assert(not Input.is_action_pressed("move_left"), "Hiding touch controls must release movement")
	assert(not Input.is_action_pressed("shoot_ball"), "Hiding touch controls must release match actions")
	assert(controls.joystick_touch_id == -1, "Hiding touch controls must reset joystick ownership")
	assert(controls.action_touch_ids.is_empty(), "Hiding touch controls must clear active touch ownership")
	assert(controls.pressed_actions.is_empty(), "Hiding touch controls must clear pressed visual states")

	# Two fingers may hold the same action. Releasing one finger must not
	# cancel the action while the other finger is still pressing it.
	controls.size = Vector2(1000.0, 700.0)
	var pass_center: Vector2 = controls._button_layout()["pass_ball"].center
	controls._begin_touch(11, pass_center)
	controls._begin_touch(12, pass_center)
	assert(Input.is_action_pressed("pass_ball"), "A touch button must press its mapped action")
	controls._end_touch(11)
	assert(Input.is_action_pressed("pass_ball"), "Releasing one of two fingers must keep the shared action pressed")
	controls._end_touch(12)
	assert(not Input.is_action_pressed("pass_ball"), "The shared action must release after the final finger lifts")

	# The virtual joystick must translate a touch displacement into movement input.
	var joystick_center: Vector2 = controls._joystick_center()
	controls._begin_touch(13, joystick_center)
	controls._update_joystick(joystick_center + Vector2(70.0, 0.0))
	assert(Input.is_action_pressed("move_right"), "Dragging the joystick right must produce rightward movement input")
	controls._end_touch(13)
	assert(not Input.is_action_pressed("move_right"), "Releasing the joystick must clear movement input")

	print("FUTBOL_NOVA_TOUCH_CONTROLS_TEST: PASS")
	controls.queue_free()
	quit(0)
