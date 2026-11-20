extends SceneTree

const GAME_HUB = preload("res://scripts/ui/game_hub.gd")

func _initialize() -> void:
	assert(not GAME_HUB.should_show_controller_hints({"enabled": false, "connected_count": 0}), "No gamepad hints should appear when the module is disabled.")
	assert(not GAME_HUB.should_show_controller_hints({"enabled": true, "connected_count": 0}), "No gamepad hints should appear when no controller is connected.")
	assert(not GAME_HUB.should_show_controller_hints({"enabled": false, "connected_count": 1}), "A connected device must not show prompts while the optional module is disabled.")
	assert(GAME_HUB.should_show_controller_hints({"enabled": true, "connected_count": 1}), "Gamepad hints should appear when the module is active and a controller is connected.")
	assert(GAME_HUB.should_show_controller_hints({"enabled": true, "connected_count": 2}), "Gamepad hints should remain visible when multiple controllers are connected.")
	assert(not GAME_HUB.should_show_controller_hints({}), "Missing controller state must remain hidden by default.")
	assert(not GAME_HUB.should_show_controller_hints({"enabled": true, "connected_count": -1}), "Invalid negative controller counts must not show hints.")
	print("FUTBOL_NOVA_CONTROLLER_HINT_VISIBILITY_TEST: PASS")
	quit(0)
