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
	var c35_home := KIT_PALETTE.shirt_color("CUB-S1-017", "home")
	var c35_away := KIT_PALETTE.shirt_color("CUB-S1-017", "away")
	var c35_keeper := KIT_PALETTE.shirt_color("CUB-S1-017", "home", true)
	assert(c35_home == Color("#14213d"), "Nova C35 debe usar azul medianoche.")
	assert(c35_away == Color("#f2f5fa"), "La segunda equipación de Nova C35 debe usar blanco hielo.")
	assert(c35_keeper == Color("#f4c95d"), "El portero de Nova C35 debe usar dorado.")
	print("FUTBOL_NOVA_TEAM_KIT_PALETTE_TESTS: PASS")
	quit(0)
