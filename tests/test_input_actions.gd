extends SceneTree

const REQUIRED_ACTIONS := [
	"move_left", "move_right", "move_forward", "move_back",
	"pass_ball", "shoot_ball", "skill_action", "pressure_action"
]

const REQUIRED_KEYS := {
	"move_left": KEY_A,
	"move_right": KEY_D,
	"move_forward": KEY_W,
	"move_back": KEY_S,
	"pass_ball": KEY_F,
	"shoot_ball": KEY_SPACE,
	"skill_action": KEY_E,
	"pressure_action": KEY_G
}

func _initialize() -> void:
	var failures := PackedStringArray()
	for action in REQUIRED_ACTIONS:
		if not InputMap.has_action(action):
			failures.append("Falta la acción de entrada: " + action)
			continue
		var has_expected_key := false
		for event in InputMap.action_get_events(action):
			if event is InputEventKey and event.physical_keycode == REQUIRED_KEYS[action]:
				has_expected_key = true
		if not has_expected_key:
			failures.append("La acción no tiene su tecla predeterminada: " + action)
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
