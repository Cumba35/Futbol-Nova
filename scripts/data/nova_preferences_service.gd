extends Node
class_name NovaPreferencesService

signal master_volume_changed(value: float)
signal master_mute_changed(muted: bool)
signal ui_scale_changed(value: float)

const SETTINGS_PATH := "user://futbol_nova_settings.cfg"
const SECTION_AUDIO := "audio"
const SECTION_INTERFACE := "interface"
const SECTION_GAMEPLAY := "gameplay"
const DEFAULT_MASTER_VOLUME := 0.8
const DEFAULT_UI_SCALE := 1.0

var master_volume: float = DEFAULT_MASTER_VOLUME
var master_muted: bool = false
var ui_scale: float = DEFAULT_UI_SCALE
var match_control_mode: String = "team"
var preferred_player_id: String = ""

func _ready() -> void:
	load_preferences()

func load_preferences() -> void:
	var config := ConfigFile.new()
	var error := config.load(SETTINGS_PATH)
	if error == OK:
		master_volume = clampf(float(config.get_value(SECTION_AUDIO, "master_volume", DEFAULT_MASTER_VOLUME)), 0.0, 1.0)
		master_muted = bool(config.get_value(SECTION_AUDIO, "master_muted", false))
		ui_scale = clampf(float(config.get_value(SECTION_INTERFACE, "ui_scale", DEFAULT_UI_SCALE)), 0.8, 1.3)
		match_control_mode = str(config.get_value(SECTION_GAMEPLAY, "match_control_mode", "team"))
		if not match_control_mode in ["team", "single"]:
			match_control_mode = "team"
		preferred_player_id = str(config.get_value(SECTION_GAMEPLAY, "preferred_player_id", ""))
	_apply_audio()
	master_volume_changed.emit(master_volume)
	master_mute_changed.emit(master_muted)
	ui_scale_changed.emit(ui_scale)

func set_master_volume(value: float) -> bool:
	master_volume = clampf(value, 0.0, 1.0)
	_apply_audio()
	master_volume_changed.emit(master_volume)
	return _save_preferences()

func set_master_muted(value: bool) -> bool:
	master_muted = value
	_apply_audio()
	master_mute_changed.emit(master_muted)
	return _save_preferences()

func set_match_control_preferences(mode: String, player_id: String = "") -> bool:
	if not mode in ["team", "single"]:
		return false
	match_control_mode = mode
	if not player_id.is_empty():
		preferred_player_id = player_id
	return _save_preferences()

func get_match_control_preferences() -> Dictionary:
	return {"mode": match_control_mode, "player_id": preferred_player_id}

func get_audio_preferences() -> Dictionary:
	return {"master_volume": master_volume, "master_muted": master_muted}

func set_ui_scale(value: float) -> bool:
	ui_scale = clampf(value, 0.8, 1.3)
	ui_scale_changed.emit(ui_scale)
	return _save_preferences()

func get_ui_preferences() -> Dictionary:
	return {"ui_scale": ui_scale}


func _apply_audio() -> void:
	var master_bus := AudioServer.get_bus_index("Master")
	if master_bus < 0:
		return
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(maxf(master_volume, 0.0001)))
	AudioServer.set_bus_mute(master_bus, master_muted)

func _save_preferences() -> bool:
	var config := ConfigFile.new()
	var error := config.load(SETTINGS_PATH)
	if error != OK and error != ERR_FILE_NOT_FOUND:
		return false
	config.set_value(SECTION_AUDIO, "master_volume", master_volume)
	config.set_value(SECTION_AUDIO, "master_muted", master_muted)
	config.set_value(SECTION_INTERFACE, "ui_scale", ui_scale)
	config.set_value(SECTION_GAMEPLAY, "match_control_mode", match_control_mode)
	config.set_value(SECTION_GAMEPLAY, "preferred_player_id", preferred_player_id)
	return config.save(SETTINGS_PATH) == OK
