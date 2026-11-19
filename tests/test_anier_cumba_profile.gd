extends SceneTree

const ANIER_SCENE: PackedScene = preload("res://scenes/players/anier_cumba.tscn")
const LegendService = preload("res://scripts/legend/legend_career_service.gd")

var _check_index := 0


func _check(condition: bool, message: String = "Anier profile assertion failed") -> bool:
	_check_index += 1
	if not condition:
		push_error("%s (check %d)" % [message, _check_index])
		quit(1)
		return false
	return true

func _initialize() -> void:
	call_deferred("_run")
	call_deferred("_test_watchdog")


func _test_watchdog() -> void:
	await create_timer(60.0).timeout
	push_error("ANIER PROFILE TEST: la prueba superó 60 segundos.")
	quit(1)


func _run() -> void:
	var file := FileAccess.open("res://data/custom_players.json", FileAccess.READ)
	if not _check(file != null, "custom_players.json must exist"): return
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	if not _check(data.has("players") and data.players.size() > 0): return
	var player: Dictionary = data.players[0]
	if not _check(player.id == "NOVA-PLAYER-0035"): return
	if not _check(player.name == "Anier Cumbá"): return
	if not _check(player.full_name == "Anier Alejandro Cumbá Ibar"): return
	if not _check(player.display_name == "Anier Cumbá"): return
	if not _check(player.date_of_birth == "2001-04-14"): return
	if not _check(player.birth_country == "CUB"): return
	if not _check(player.preferred_national_team == "BRA"): return
	if not _check(player.favorite_club == "Real Madrid"): return
	if not _check(player.height_cm == 171): return
	if not _check(player.weight_kg == 65): return
	if not _check(player.nationality == "CUB"): return
	if not _check(player.shirt_name == "CUMBÁ"): return
	if not _check(player.shirt_number == 35): return
	if not _check(player.team_role == "captain"): return
	if not _check(player.preferred_foot == "right"): return
	if not _check(player.club_name == "Real Madrid", "Anier's owner-confirmed current club is Real Madrid"): return
	if not _check(player.club_id == "FN-ESP-REAL-MADRID", "Anier must retain the canonical Real Madrid club ID"): return
	if not _check(player.favorite_club == "Real Madrid", "The representative club keeps its real-world reference separate"): return
	if not _check(player.overall == 92, "Anier's confirmed overall must be 92"): return
	if not _check(player.potential == 97, "Anier potential must be 97"): return
	if not _check(player.confirmed_attributes.acc == 90, "Anier base acceleration must be 90"): return
	if not _check(player.confirmed_attributes.spd == 90, "Anier base top speed must be 90"): return
	if not _check(player.confirmed_attributes.fin == 87, "Anier finishing must be 87"): return
	if not _check(player.confirmed_attributes.shot == 90, "Anier shot power must be 90"): return
	if not _check(player.confirmed_attributes == player.base_attributes, "All assigned base attributes are owner-confirmed"): return
	if not _check(player.base_attributes.acc == 90 and player.base_attributes.spd == 90): return
	if not _check(player.attributes.acc == 98 and player.attributes.spd == 98): return
	if not _check(player.attributes.agi == 92): return
	if not _check(player.attribute_calculation.bonuses_included == true): return
	var rating_service = LegendService.new()
	if not _check(rating_service.calculate_overall(player.attributes, "MCO") == 92, "Anier MCO overall must calculate to 92"): return
	rating_service.free()
	if not _check(player.preferred_national_team == "BRA"): return
	if not _check(player.visual.representation == "3D_ONLY"): return
	if not _check(player.visual.accessories.boots.base_color == "#C62828"): return
	if not _check(player.visual.accessories.boots.design_colors == ["#D4AF37", "#171923"]): return
	if not _check(player.visual.accessories.socks.kit_dependent == true): return
	if not _check(player.visual.accessories.socks.length == "long"): return
	if not _check(player.visual.accessories.socks.description == "Medias largas por encima de las rodillas, adaptadas a los colores y al diseño de la equipación que lleve puesta."): return
	if not _check(player.visual.kit.shirt_tucked == false): return
	if not _check(player.visual.kit.shirt_fit == "untucked_over_shorts"): return
	if not _check(data.equipment_rules.shin_guards.required_for_all_players == true): return
	if not _check(player.visual.accessories.shin_guards.required == true): return
	if not _check(player.visual.accessories.wristbands.worn == false): return
	if not _check(player.visual.accessories.hairband.worn == false): return
	if not _check(player.visual.accessories.captain_armband.worn == true): return
	if not _check(player.visual.accessories.captain_armband.kit_dependent == true): return
	if not _check(player.visual.accessories.captain_armband.design_source == "current_team"): return
	if not _check(player.visual.accessories.gloves.worn == true): return
	if not _check(player.visual.accessories.gloves.base_color == "#171923"): return
	if not _check(player.visual.accessories.gloves.design_colors == ["#C62828", "#D4AF37"]): return
	if not _check(player.visual.accessories.earrings.worn == false): return
	if not _check(player.visual.accessories.inner_shirt.worn == true): return
	if not _check(player.visual.accessories.inner_shirt.always_worn == true): return
	if not _check(player.visual.accessories.inner_shirt.wear_policy == "all_matches_and_kits"): return
	if not _check(player.visual.accessories.inner_shirt.sleeve_length == "long"): return
	if not _check(player.visual.accessories.inner_shirt.fit == "compression"): return
	if not _check(player.visual.accessories.inner_shirt.fit_type == "snug"): return
	if not _check(player.visual.accessories.inner_shirt.kit_dependent == true): return
	if not _check(player.visual.accessories.inner_shirt.style_reference == "EA SPORTS FIFA 23"): return
	if not _check(player.visual.accessories.inner_shirt.neckline_visible == true): return
	if not _check(player.visual.accessories.inner_shirt.neckline_style == "around_neck"): return
	if not _check(player.position == "MCO"): return
	if not _check(player.secondary_positions.has("MC")): return

	var anier := ANIER_SCENE.instantiate()
	if not _check(anier != null, "Anier's 3D scene must instantiate"): return
	# This acceptance test inspects the procedural visual, not live movement.
	# Disable inherited input/physics before add_child() invokes _ready().
	anier.set_physics_process(false)
	root.add_child(anier)
	await process_frame
	if not _check(anier.get_script().resource_path.ends_with("anier_cumba.gd")): return
	if not _check(anier.find_child("AnierVisual3D", true, false) != null): return
	if not _check(anier.find_child("torso", true, false) != null): return
	if not _check(anier.find_child("shirt_untucked_hem", true, false) != null): return
	if not _check(anier.find_child("long_sock_1.0", true, false) != null): return
	if not _check(anier.find_child("boot_1.0", true, false) != null): return
	if not _check(anier.find_child("boot_sole_1.0", true, false) != null): return
	if not _check(anier.find_child("boot_gold_design_1.0", true, false) != null): return
	if not _check(anier.find_child("boot_black_design_1.0", true, false) != null): return
	if not _check(anier.find_child("shin_guard_1.0", true, false) != null): return
	if not _check(anier.find_child("glove_1.0", true, false) != null): return
	if not _check(anier.find_child("inner_shirt_sleeve_1.0", true, false) != null): return
	if not _check(anier.find_child("inner_shirt_neckline", true, false) != null): return
	if not _check(anier.find_child("glove_red_detail_1.0", true, false) != null): return
	if not _check(anier.find_child("glove_gold_detail_1.0", true, false) != null): return
	if not _check(anier.find_child("captain_armband", true, false) != null): return
	if not _check(anier.find_child("CollisionShape3D", true, false) != null): return
	if not _check(is_equal_approx(float(anier.get("player_height_m")), 1.71)): return

	var main_file := FileAccess.open("res://scripts/main.gd", FileAccess.READ)
	if not _check(main_file != null): return
	var main_source := main_file.get_as_text()
	if not _check(main_source.contains('preload("res://scenes/players/anier_cumba.tscn")')): return
	if not _check(main_source.contains("ANIER_PLAYER_SCENE.instantiate()")): return

	anier.queue_free()
	print("Anier Cumba profile and scene integration: PASS")
	quit(0)
