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
	print("FUTBOL_NOVA_TOUCH_CONTROLS_TEST: PASS")
	controls.queue_free()
	quit(0)
