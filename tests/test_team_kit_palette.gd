extends SceneTree

const KIT_PALETTE = preload("res://scripts/ui/team_kit_palette.gd")

func _initialize() -> void:
	var home_id := "FN-NOVA-HOME-TEST"
	var away_id := "FN-NOVA-AWAY-TEST"
	var home_first := KIT_PALETTE.shirt_color(home_id, "home")
	var home_second := KIT_PALETTE.shirt_color(home_id, "away")
	var away_first := KIT_PALETTE.shirt_color(away_id, "home")
	var keeper := KIT_PALETTE.shirt_color(home_id, "home", true)
	assert(home_first != home_second, "La primera y segunda equipación deben distinguirse.")
	assert(home_first == KIT_PALETTE.shirt_color(home_id, "home"), "El color de club debe ser determinista.")
	assert(away_first == KIT_PALETTE.primary_color(away_id), "La equipación local del visitante debe usar su paleta propia.")
	assert(keeper == KIT_PALETTE.GOALKEEPER_COLOR, "El portero debe usar el color reservado para su equipación.")
	assert(KIT_PALETTE.shorts_color(home_id, "away") != KIT_PALETTE.shorts_color(home_id, "home"), "El pantalón debe cambiar con la equipación.")
	print("FUTBOL_NOVA_TEAM_KIT_PALETTE_TESTS: PASS")
	quit(0)
