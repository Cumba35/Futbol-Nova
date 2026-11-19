extends Node
class_name NovaPreferencesService

signal master_volume_changed(value: float)
signal master_mute_changed(muted: bool)

const SETTINGS_PATH := "user://futbol_nova_settings.cfg"
const SECTION_AUDIO := "audio"
const DEFAULT_MASTER_VOLUME := 0.8

var master_volume: float = DEFAULT_MASTER_VOLUME
var master_muted: bool = false

func _ready() -> void:
	load_preferences()

func load_preferences() -> void:
	var config := ConfigFile.new()
	var error := config.load(SETTINGS_PATH)
	if error == OK:
		master_volume = clampf(float(config.get_value(SECTION_AUDIO, "master_volume", DEFAULT_MASTER_VOLUME)), 0.0, 1.0)
		master_muted = bool(config.get_value(SECTION_AUDIO, "master_muted", false))
	_apply_audio()
	master_volume_changed.emit(master_volume)
	master_mute_changed.emit(master_muted)

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

func get_audio_preferences() -> Dictionary:
	return {"master_volume": master_volume, "master_muted": master_muted}

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
	return config.save(SETTINGS_PATH) == OK
