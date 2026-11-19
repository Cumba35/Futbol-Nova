extends SceneTree

const RosterService = preload("res://scripts/data/custom_player_roster_service.gd")
const ATTRIBUTE_KEYS := ["acc", "spd", "attp", "fin", "shot", "long", "vol", "pen", "vis", "cross", "fk", "short", "longp", "curve", "agi", "bal", "react", "ctrl", "drib", "comp", "int", "head", "aware", "tack", "slide", "jump", "sta", "str", "agr", "dive", "hand", "kick", "ref", "gkspd", "gkpos"]

func _initialize() -> void:
	call_deferred("_run_tests")

func _run_tests() -> void:
	var service := RosterService.new()
	root.add_child(service)
	var attributes := {}
	for key in ATTRIBUTE_KEYS:
		attributes[key] = 60
	var player := {
		"id": "NOVA-USER-ROSTER-TEST",
		"origin": "user_created",
		"full_name": "Jugador Personalizado de Prueba",
		"display_name": "Jugador Personalizado de Prueba",
		"primary_position": "MCO",
		"nationality_id": "CUB",
		"overall": 60,
		"attributes": attributes
	}
	var added: Dictionary = service.add_created_player(player)
	assert(bool(added.get("ok", false)), "Debe guardar jugadores creados en el registro separado")
	assert(service.get_created_players().size() > 0, "El registro debe devolver jugadores personalizados")
	var assigned_home: Dictionary = service.assign_created_player_to_team("NOVA-USER-ROSTER-TEST", "FN-ESP-REAL-MADRID")
	assert(bool(assigned_home.get("ok", false)), "Debe incorporar el jugador personalizado a la plantilla local")
	assert(str(service.get_assigned_team_id("NOVA-USER-ROSTER-TEST")) == "FN-ESP-REAL-MADRID", "La asignación de club debe quedar guardada")
	assert(service.get_players_for_team("FN-ESP-REAL-MADRID").size() == 1, "La plantilla debe incluir al futbolista personalizado")
	var reassigned: Dictionary = service.assign_created_player_to_team("NOVA-USER-ROSTER-TEST", "FN-ESP-BARCELONA")
	assert(bool(reassigned.get("ok", false)), "Debe permitir cambiar al jugador a otro club")
	assert(service.get_players_for_team("FN-ESP-REAL-MADRID").is_empty(), "El jugador no debe permanecer duplicado en el club anterior")
	assert(service.get_players_for_team("FN-ESP-BARCELONA").size() == 1, "El nuevo club debe recibir al jugador")
	var removed: Dictionary = service.remove_created_player_from_team("NOVA-USER-ROSTER-TEST", "FN-ESP-BARCELONA")
	assert(bool(removed.get("ok", false)), "Debe permitir retirar al jugador de la plantilla")
	assert(service.get_assigned_team_id("NOVA-USER-ROSTER-TEST").is_empty(), "El jugador debe quedar sin club al retirarlo")
	var rejected: Dictionary = service.add_created_player({
		"id": "NOVA-CATALOG-TEST",
		"origin": "nova_catalog",
		"display_name": "Jugador Oficial Nova",
		"attributes": attributes
	})
	assert(not bool(rejected.get("ok", false)), "El registro personalizado no debe aceptar jugadores del catálogo Nova")
	var selected: Dictionary = service.select_for_online("NOVA-USER-ROSTER-TEST")
	assert(bool(selected.get("ok", false)), "Debe permitir elegir un jugador creado para Online")
	assert(str(service.get_online_selected_player().get("id", "")) == "NOVA-USER-ROSTER-TEST", "Online debe conservar el ID del jugador elegido")
	assert(not bool(service.select_for_online("NOVA-CATALOG-TEST").get("ok", false)), "No debe permitir seleccionar como propio un jugador fuera del registro personalizado")
	service.clear_online_selection()
	assert(service.get_online_selected_player().is_empty(), "Debe poder quitar la selección para Online")
	for index in range(service._players.size() - 1, -1, -1):
		if str(service._players[index].get("id", "")) == "NOVA-USER-ROSTER-TEST":
			service._players.remove_at(index)
	service._team_assignments.erase("FN-ESP-REAL-MADRID")
	service._team_assignments.erase("FN-ESP-BARCELONA")
	service._save_roster()
	print("FUTBOL_NOVA_CUSTOM_PLAYER_ROSTER_TESTS: PASS")
	quit(0)
