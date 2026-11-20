extends SceneTree

const TEAM_KIT_SELECTION = preload("res://scripts/ui/team_kit_selection.gd")

func _initialize() -> void:
	var ids: Array[String] = ["HOME", "AWAY", "THIRD"]
	assert(TEAM_KIT_SELECTION.next_available_team_id(ids, "HOME", "AWAY", 1) == "THIRD", "El selector debe saltar al rival al avanzar.")
	assert(TEAM_KIT_SELECTION.next_available_team_id(ids, "HOME", "AWAY", -1) == "THIRD", "El selector debe saltar al rival al retroceder.")
	assert(TEAM_KIT_SELECTION.next_available_team_id(ids, "THIRD", "AWAY", 1) == "HOME", "El selector debe recorrer el catálogo circularmente.")
	assert(TEAM_KIT_SELECTION.next_available_team_id(ids, "HOME", "HOME", 1) != "HOME", "El selector nunca debe devolver el mismo equipo del rival.")
	assert(TEAM_KIT_SELECTION.next_available_team_id(["ONLY"], "ONLY", "", 1).is_empty(), "No debe ofrecer cambios si solo hay un equipo.")
	print("FUTBOL_NOVA_TEAM_KIT_SELECTION_TESTS: PASS")
	quit(0)
