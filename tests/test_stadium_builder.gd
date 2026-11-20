extends SceneTree

const STADIUM_BUILDER = preload("res://scripts/stadiums/stadium_builder.gd")

func _initialize() -> void:
	var failures := PackedStringArray()
	var catalog: Array = STADIUM_BUILDER.get_catalog()
	var seen_ids := {}
	if catalog.size() != 3:
		failures.append("StadiumBuilder: se esperaban tres estadios locales.")
	for stadium in catalog:
		var stadium_id := str(stadium.get("id", ""))
		if stadium_id.is_empty() or seen_ids.has(stadium_id):
			failures.append("StadiumBuilder: ID vacío o duplicado.")
		seen_ids[stadium_id] = true
		if str(stadium.get("version", "")).is_empty():
			failures.append("StadiumBuilder: versión no disponible para " + stadium_id)
		if int(stadium.get("capacity", 0)) <= 0:
			failures.append("StadiumBuilder: capacidad inválida para " + stadium_id)
		var instance: Node3D = STADIUM_BUILDER.build_stadium(stadium_id)
		if instance == null or instance.get_child_count() < 20:
			failures.append("StadiumBuilder: geometría incompleta para " + stadium_id)
		else:
			root.add_child(instance)
			instance.queue_free()
	var fallback: Dictionary = STADIUM_BUILDER.get_stadium_config("unknown")
	if str(fallback.get("id", "")) != "nova_central":
		failures.append("StadiumBuilder: el ID desconocido debe usar el estadio base.")
	if failures.is_empty():
		print("FUTBOL_NOVA_STADIUM_BUILDER_TESTS: PASS")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)
