extends SceneTree

const PreMatchSetup = preload("res://scripts/ui/pre_match_setup.gd")
const MatchClockRules = preload("res://scripts/gameplay/match_clock_rules.gd")
const MatchClockStateMachine = preload("res://scripts/gameplay/match_clock_state_machine.gd")
const StadiumBuilder = preload("res://scripts/stadiums/stadium_builder.gd")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var failures := PackedStringArray()
	var defaults := PreMatchSetup.get_default_friendly_match_settings()

	_check(str(defaults.get("match_type", "")) == "friendly", "El modo predeterminado debe ser amistoso.", failures)
	_check(str(defaults.get("home_team_id", "")) == "FN-NOVA-C35", "Nova C35 debe ser el local predeterminado.", failures)
	_check(str(defaults.get("away_team_id", "")) == "FN-NOVA-RDA", "FC Río de Argenti debe ser el visitante predeterminado.", failures)
	_check(str(defaults.get("stadium_id", "")) == "nova_central", "El estadio predeterminado debe coincidir con el catálogo.", failures)
	_check(int(defaults.get("half_length_minutes", 0)) == 5, "La duración predeterminada debe ser de cinco minutos por tiempo.", failures)
	_check(str(defaults.get("clock_mode", "")) == "continuous", "El reloj predeterminado debe ser continuo.", failures)
	_check(not bool(defaults.get("extra_time_enabled", true)), "La prórroga debe comenzar desactivada.", failures)
	_check(not bool(defaults.get("penalties_enabled", true)), "Los penaltis deben comenzar desactivados mientras no exista su motor.", failures)
	_check(str(defaults.get("formation_id", "")) == "4-3-3", "La formación predeterminada debe ser 4-3-3.", failures)
	_check(int(defaults.get("minimum_roster_size", 0)) == 22, "Cada club debe disponer de 22 futbolistas.", failures)
	_check(int(defaults.get("starting_lineup_size", 0)) == 11, "El once inicial debe tener once futbolistas.", failures)

	var indices := PreMatchSetup.get_default_team_indices(["OTHER", "FN-NOVA-C35", "FN-NOVA-RDA"])
	_check(int(indices.get("home", -1)) == 1 and int(indices.get("away", -1)) == 2, "La selección predeterminada debe localizar C35 y RDA por ID estable.", failures)

	var c35_ids: Array[String] = ["NOVA-PLAYER-0035", "C35_02", "C35_03", "C35_04", "C35_05", "C35_06", "C35_07", "C35_08", "C35_09", "C35_10", "C35_11"]
	var rda_ids: Array[String] = ["NOVA-PLAYER-0037", "RDA_02", "RDA_03", "RDA_04", "RDA_05", "RDA_06", "RDA_07", "RDA_08", "RDA_09", "RDA_10", "RDA_11"]
	_check(PreMatchSetup.get_default_controlled_player_id("FN-NOVA-C35", c35_ids) == "NOVA-PLAYER-0035", "C35 local debe seleccionar a Anier.", failures)
	_check(PreMatchSetup.get_default_controlled_player_id("FN-NOVA-RDA", rda_ids) == "NOVA-PLAYER-0037", "RDA local debe seleccionar a Raymond.", failures)
	_check(PreMatchSetup.get_default_controlled_player_id("OTHER", rda_ids) == "RDA_10", "Los demás clubes deben conservar el jugador de fallback.", failures)

	var stadium_found := false
	for stadium in StadiumBuilder.get_catalog():
		if str(stadium.get("id", "")) == str(defaults.get("stadium_id", "")):
			stadium_found = true
	_check(stadium_found, "El estadio predeterminado debe existir en el catálogo offline.", failures)

	_check(MatchClockRules.HALF_LENGTHS_MINUTES == [3, 5, 6, 8, 10, 15, 20], "Las siete duraciones configuradas deben conservarse.", failures)
	var expected_extra := {3: 1, 5: 2, 6: 2, 8: 3, 10: 3, 15: 5, 20: 7}
	_check(MatchClockRules.EXTRA_TIME_BY_REGULAR_HALF == expected_extra, "La duración de prórroga debe seguir la tabla definida.", failures)
	var clock_state := MatchClockStateMachine.create_state()
	_check(int(clock_state.get("half_length_minutes", 0)) == 5, "El estado del reloj debe usar la duración predeterminada compartida.", failures)
	_check(str(clock_state.get("clock_mode", "")) == "continuous", "El estado del reloj debe usar el modo continuo predeterminado.", failures)

	var roster: Array[Dictionary] = []
	var positions: Array[String] = ["POR", "LI", "DFC", "DFC", "LD", "MCD", "MC", "MCO", "EI", "DC", "ED"]
	for index in range(22):
		var position: String = positions[index] if index < positions.size() else "MC"
		roster.append({"id": "TEST_PLAYER_%02d" % index, "primary_position": position, "overall": 60 + index})
	var lineup := PreMatchSetup.build_starting_eleven(roster)
	_check(lineup.size() == 11, "La selección de titulares debe devolver exactamente once IDs.", failures)
	var unique_ids := {}
	for player_id in lineup:
		unique_ids[player_id] = true
	_check(unique_ids.size() == 11, "El once inicial no debe repetir futbolistas.", failures)

	if failures.is_empty():
		print("FUTBOL_NOVA_CONFIGURATION_DEFAULTS: PASS")
		quit(0)
	else:
		for failure in failures:
			push_error("FUTBOL_NOVA_CONFIGURATION_DEFAULTS: " + failure)
		quit(1)

func _check(condition: bool, message: String, failures: PackedStringArray) -> void:
	if not condition:
		failures.append(message)
