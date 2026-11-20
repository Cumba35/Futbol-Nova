extends SceneTree

const STADIUM_BUILDER = preload("res://scripts/stadiums/stadium_builder.gd")

func _initialize() -> void:
	var failures := PackedStringArray()
	var catalog: Array = STADIUM_BUILDER.get_catalog()
	if catalog.size() != 1:
		failures.append("El juego base debe incluir exactamente un estadio.")
	if catalog.is_empty():
		push_error("No existe estadio base.")
		quit(1)
		return
	var stadium: Dictionary = catalog[0]
	var stadium_id := str(stadium.get("id", ""))
	if stadium_id != "estadio_del_fenix":
		failures.append("El único estadio base debe ser Estadio del Fénix.")
	if str(stadium.get("name", "")) != "Estadio del Fénix":
		failures.append("El nombre visible del estadio debe ser Estadio del Fénix.")
	if str(stadium.get("club", "")) != "Nova C35":
		failures.append("El estadio debe identificar a Nova C35 como club local.")
	if not bool(stadium.get("base_game", false)):
		failures.append("Estadio del Fénix debe marcarse como contenido base.")
	if int(stadium.get("capacity", 0)) != 105000:
		failures.append("Estadio del Fénix debe tener capacidad de diseño de 105 000 espectadores.")
	if str(stadium.get("version", "")).is_empty():
		failures.append("Versión del estadio no disponible.")

	var instance: Node3D = STADIUM_BUILDER.build_stadium(stadium_id)
	if instance == null:
		failures.append("No se pudo construir Estadio del Fénix.")
	else:
		root.add_child(instance)
		if instance.get_child_count() < 80:
			failures.append("La arquitectura del estadio está incompleta.")
		var bodies := instance.get_node_or_null("CrowdBodies") as MultiMeshInstance3D
		var heads := instance.get_node_or_null("CrowdHeads") as MultiMeshInstance3D
		if bodies == null or heads == null:
			failures.append("Faltan las multitudes instanciadas.")
		else:
			if bodies.multimesh == null or bodies.multimesh.instance_count < 2500:
				failures.append("La grada debe incluir una multitud de alta densidad.")
			if heads.multimesh == null or heads.multimesh.instance_count != bodies.multimesh.instance_count:
				failures.append("La multitud debe tener cuerpos y cabezas sincronizados.")
		if instance.find_children("LED_AdvertisingBoard", "MeshInstance3D", true, false).size() < 20:
			failures.append("Faltan paneles LED perimetrales.")
		if instance.find_children("FloodlightPanel", "MeshInstance3D", true, false).size() != 4:
			failures.append("Se esperan cuatro torres de iluminación.")
		instance.queue_free()

	var fallback: Dictionary = STADIUM_BUILDER.get_stadium_config("unknown")
	if str(fallback.get("id", "")) != "estadio_del_fenix":
		failures.append("Los estadios no disponibles deben recurrir al estadio base.")

	if failures.is_empty():
		print("FUTBOL_NOVA_STADIUM_BUILDER_TESTS: PASS")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)
