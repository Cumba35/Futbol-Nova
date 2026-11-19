extends SceneTree

const PREFERENCES_SCRIPT := preload("res://scripts/data/nova_preferences_service.gd")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var original_bus := AudioServer.get_bus_index("Master")
	var original_volume := AudioServer.get_bus_volume_linear(original_bus) if original_bus >= 0 else 1.0
	var original_muted := AudioServer.is_bus_mute(original_bus) if original_bus >= 0 else false
	var first := PREFERENCES_SCRIPT.new()
	root.add_child(first)
	var initial: Dictionary = first.get_audio_preferences()
	var initial_ui: Dictionary = first.get_ui_preferences()
	_check(first.set_master_volume(0.37), "El volumen debe guardarse")
	_check(first.set_master_muted(true), "El silencio debe guardarse")
	_check(first.set_ui_scale(2.0), "La escala superior debe aceptarse y limitarse")
	_check(is_equal_approx(float(first.get_ui_preferences().get("ui_scale", -1.0)), 1.3), "La escala no debe superar el 130%")
	_check(first.set_ui_scale(0.1), "La escala inferior debe aceptarse y limitarse")
	_check(is_equal_approx(float(first.get_ui_preferences().get("ui_scale", -1.0)), 0.8), "La escala no debe bajar del 80%")
	_check(first.set_ui_scale(1.25), "El tamaño de texto debe guardarse")
	var second := PREFERENCES_SCRIPT.new()
	root.add_child(second)
	var restored: Dictionary = second.get_audio_preferences()
	_check(is_equal_approx(float(restored.get("master_volume", -1.0)), 0.37), "El volumen debe persistir al crear otra instancia")
	_check(bool(restored.get("master_muted", false)), "El silencio debe persistir al crear otra instancia")
	var restored_ui: Dictionary = second.get_ui_preferences()
	_check(is_equal_approx(float(restored_ui.get("ui_scale", -1.0)), 1.25), "El tamaño de texto debe persistir al crear otra instancia")
	second.set_master_volume(float(initial.get("master_volume", 0.8)))
	second.set_master_muted(bool(initial.get("master_muted", false)))
	second.set_ui_scale(float(initial_ui.get("ui_scale", 1.0)))
	if original_bus >= 0:
		AudioServer.set_bus_volume_db(original_bus, linear_to_db(maxf(original_volume, 0.0001)))
		AudioServer.set_bus_mute(original_bus, original_muted)
	quit(0)

func _check(condition: bool, message: String) -> void:
	if not condition:
		push_error(message)
		quit(1)
