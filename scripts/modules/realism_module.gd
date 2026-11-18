extends RefCounted
class_name NovaRealismModule

## Optional, data-driven realism package. The base game remains playable without it.

const PACKAGE_ID := "futbol_nova_realism"
const CONFIG_FILE := "realism_profile.json"
const INSTALL_ROOT := "user://futbol_nova/packages/"

static func _get_content_package_service() -> Node:
	var main_loop: MainLoop = Engine.get_main_loop()
	if not (main_loop is SceneTree):
		return null
	var scene_tree := main_loop as SceneTree
	return scene_tree.root.get_node_or_null("ContentPackages")


static func _read_profile_number(profile: Dictionary, key: String, fallback: float) -> float:
	var value: Variant = profile.get(key, null)
	if value is int or value is float:
		return float(value)
	if value is String:
		var text_value := str(value).strip_edges()
		if text_value.is_valid_float():
			return float(text_value)
	return fallback


static func load_profile() -> Dictionary:
	var inactive := {"enabled": false, "profile_id": "base_game"}
	var package_service := _get_content_package_service()
	if package_service == null:
		return inactive
	if not package_service.has_method("is_package_installed") or not package_service.has_method("get_installed_packages"):
		return inactive
	if not bool(package_service.call("is_package_installed", PACKAGE_ID)):
		return inactive
	var installed_packages: Variant = package_service.call("get_installed_packages")
	if not (installed_packages is Dictionary):
		return inactive
	var installed: Dictionary = installed_packages.get(PACKAGE_ID, {})
	var root := str(installed.get("installed_path", ""))
	if not root.begins_with(INSTALL_ROOT) or root.contains(".."):
		return inactive
	var config_path := root.path_join(CONFIG_FILE)
	if not FileAccess.file_exists(config_path):
		return inactive
	var file := FileAccess.open(config_path, FileAccess.READ)
	if file == null:
		return inactive
	var parsed = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		return inactive
	var schema_value: Variant = parsed.get("schema_version", null)
	if not (schema_value is int or schema_value is float) or int(schema_value) != 1:
		return inactive
	if str(parsed.get("module_id", "")) != PACKAGE_ID:
		return inactive
	var profile_value: Variant = parsed.get("profile", {})
	if not (profile_value is Dictionary):
		return inactive
	var profile: Dictionary = profile_value
	if not validate_profile(profile):
		return inactive
	var result := profile.duplicate(true)
	result["enabled"] = true
	return result


static func validate_profile(profile: Dictionary) -> bool:
	if str(profile.get("profile_id", "")) != "realism_balanced":
		return false
	var drain := _read_profile_number(profile, "movement_fatigue_per_second", -1.0)
	var recovery := _read_profile_number(profile, "recovery_per_second", -1.0)
	var minimum_speed := _read_profile_number(profile, "minimum_speed_multiplier", -1.0)
	if drain < 0.0 or drain > 3.0:
		return false
	if recovery < 0.0 or recovery > 3.0:
		return false
	if minimum_speed < 0.5 or minimum_speed > 1.0:
		return false
	return true


static func movement_speed_multiplier(stamina: float, profile: Dictionary) -> float:
	if not bool(profile.get("enabled", false)) or not bool(profile.get("fatigue_enabled", false)):
		return 1.0
	var minimum_speed := clampf(_read_profile_number(profile, "minimum_speed_multiplier", 0.78), 0.5, 1.0)
	return lerpf(minimum_speed, 1.0, clampf(stamina / 100.0, 0.0, 1.0))


static func update_stamina(stamina: float, is_moving: bool, delta: float, profile: Dictionary) -> float:
	if not bool(profile.get("enabled", false)) or not bool(profile.get("fatigue_enabled", false)):
		return clampf(stamina, 0.0, 100.0)
	var drain := _read_profile_number(profile, "movement_fatigue_per_second", 0.10)
	var recovery := _read_profile_number(profile, "recovery_per_second", 0.16)
	var rate := drain if is_moving else -recovery
	var safe_delta := maxf(0.0, delta) if is_finite(delta) else 0.0
	return clampf(stamina - rate * safe_delta, 0.0, 100.0)


static func get_status() -> Dictionary:
	var profile := load_profile()
	return {"enabled": bool(profile.get("enabled", false)), "profile_id": str(profile.get("profile_id", "base_game")), "package_id": PACKAGE_ID}
