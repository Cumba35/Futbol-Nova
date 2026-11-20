extends SceneTree

const PLAYER_PROFILE = preload("res://scripts/data/player_profile.gd")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var file := FileAccess.open("res://data/original_club_players_2026.json", FileAccess.READ)
	assert(file != null, "Debe existir el catálogo de plantillas originales")
	var catalog = JSON.parse_string(file.get_as_text())
	file.close()
	assert(catalog is Dictionary, "El catálogo debe ser JSON válido")
	var players_by_id := {}
	for player in catalog.get("players", []):
		assert(player is Dictionary, "Cada jugador debe ser un objeto")
		var player_id := str(player.get("id", ""))
		assert(not player_id.is_empty() and not players_by_id.has(player_id), "Los IDs deben ser únicos")
		assert(PLAYER_PROFILE.is_valid(player), "Perfil inválido: " + player_id + " -> " + str(PLAYER_PROFILE.validate(player)))
		players_by_id[player_id] = player
	assert(players_by_id.size() == 40, "Deben existir 40 fichas generadas: 20 por club, además de los dos perfiles ya existentes")

	var all_ids := {}
	for team in catalog.get("teams", []):
		var ids: Array = team.get("player_ids", [])
		assert(ids.size() == 22, "Cada club amistoso debe tener 22 jugadores")
		for player_id in ids:
			assert(not all_ids.has(str(player_id)), "Un jugador no puede pertenecer a ambos clubes")
			all_ids[str(player_id)] = true
			if not ["NOVA-PLAYER-0035", "NOVA-PLAYER-0036"].has(str(player_id)):
				assert(players_by_id.has(str(player_id)), "Falta ficha para " + str(player_id))
	assert(all_ids.size() == 44, "Las dos plantillas deben sumar 44 plazas sin duplicados")

	var raymond: Dictionary = players_by_id.get("NOVA-PLAYER-0037", {})
	assert(not raymond.is_empty(), "Raymond debe tener un nuevo ID interno")
	assert(str(raymond.get("display_name", "")) == "Raymond Valdez", "Nombre de Raymond incorrecto")
	assert(str(raymond.get("club_id", "")) == "FN-NOVA-RDA", "Raymond debe pertenecer a FC Río de Argenti")
	assert(int(raymond.get("shirt_number", 0)) == 5, "Raymond debe conservar el dorsal 5")
	assert(int(raymond.get("overall", 0)) == 91 and int(raymond.get("potential", 0)) == 96, "Media y potencial deben coincidir con su ficha")
	assert(int(raymond.get("height_cm", 0)) == 171 and int(raymond.get("weight_kg", 0)) == 63, "Medidas de Raymond incorrectas")
	assert(raymond.get("skill_moves", []) is Array and raymond.skill_moves.size() >= 8, "Raymond debe incluir su repertorio técnico")
	assert(str(raymond.get("goal_celebration", {}).get("id", "")) == "raymond_messi_inspired_skyward_point", "Debe existir la celebración especial de Raymond")
	assert(int(raymond.get("statistics", {}).get("career", {}).get("appearances", -1)) == 0, "Las estadísticas de carrera deben empezar en cero")
	print("FUTBOL_NOVA_ORIGINAL_CLUB_ROSTERS_TESTS: PASS")
	quit(0)
