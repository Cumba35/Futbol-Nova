extends SceneTree

const CLUB_PATH := "res://data/nova_c35_club.json"

func _initialize() -> void:
	var file := FileAccess.open(CLUB_PATH, FileAccess.READ)
	assert(file != null, "Debe existir el perfil de Nova C35.")
	var parsed = JSON.parse_string(file.get_as_text())
	assert(parsed is Dictionary, "El perfil de Nova C35 debe ser JSON válido.")
	assert(str(parsed.get("id", "")) == "CUB-S1-017", "Nova C35 debe tener un ID estable.")
	assert(str(parsed.get("name", "")) == "Nova C35", "Nombre de club incorrecto.")
	assert(str(parsed.get("competition_id", "")) == "cuba_primera_division_nova", "Nova C35 debe apuntar a Primera División de Cuba.")
	assert(int(parsed.get("league_target", {}).get("team_count", 0)) == 20, "El objetivo de Primera División debe ser 20 equipos.")
	assert(str(parsed.get("home_stadium_id", "")) == "estadio_del_fenix", "Nova C35 debe jugar en el Estadio del Fénix.")
	assert(bool(parsed.get("fictional", false)) and not bool(parsed.get("official", true)), "La identidad debe marcarse como original y ficticia.")
	print("FUTBOL_NOVA_C35_IDENTITY_TESTS: PASS")
	quit(0)
