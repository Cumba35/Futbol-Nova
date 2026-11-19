extends SceneTree

const REQUIRED_ACTIONS := [
	"move_left", "move_right", "move_forward", "move_back",
	"pass_ball", "shoot_ball", "skill_action", "pressure_action"
]

func _initialize() -> void:
	var failures := PackedStringArray()
	for action in REQUIRED_ACTIONS:
		if not InputMap.has_action(action):
			failures.append("Falta la acción de entrada: " + action)
			continue
		Input.action_press(action)
		if not Input.is_action_pressed(action):
			failures.append("No se pudo activar la acción: " + action)
		Input.action_release(action)
		if Input.is_action_pressed(action):
			failures.append("No se liberó la acción: " + action)
	if failures.is_empty():
		print("FUTBOL_NOVA_INPUT_ACTIONS_TEST: PASS")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)
