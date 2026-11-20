extends RefCounted
class_name NovaStadiumBuilder

# The base Android game ships with one original home ground.
# Additional venues belong to optional stadium packs, never to the base APK.
const BASE_STADIUM_ID := "estadio_del_fenix"
const CROWD_SHADER := """
shader_type spatial;
render_mode diffuse_burley, specular_disabled;
varying vec3 instance_tint;
void vertex() {
	instance_tint = COLOR.rgb;
	VERTEX.y += sin(TIME * 2.1 + UV.x * 9.0 + UV.y * 4.0) * 0.012;
}
void fragment() {
	ALBEDO = instance_tint;
	ROUGHNESS = 0.96;
}
"""

const STADIUMS := [
	{
		"id": BASE_STADIUM_ID,
		"name": "Estadio del Fénix",
		"capacity": 35000,
		"version": "Base 1.0",
		"seating": "#14213d",
		"accent": "#27c9e8",
		"roof": "#101a2d",
		"club": "Nova C35",
		"club_short": "C35",
		"city": "Cuba",
		"base_game": true
	}
]

static func get_catalog() -> Array:
	return STADIUMS.duplicate(true)

static func get_stadium_config(stadium_id: String) -> Dictionary:
	for stadium in STADIUMS:
		if str(stadium.get("id", "")) == stadium_id:
			return stadium.duplicate(true)
	return STADIUMS[0].duplicate(true)

static func build_stadium(stadium_id: String) -> Node3D:
	var config := get_stadium_config(stadium_id)
	var root := Node3D.new()
	root.name = "Stadium_" + str(config.id)
	root.set_meta("stadium_id", str(config.id))
	root.set_meta("base_game_venue", true)

	var seating := _material(Color(str(config.seating)), 0.94)
	var accent := _material(Color(str(config.accent)), 0.78, 0.12)
	var roof := _material(Color(str(config.roof)), 0.7, 0.28)
	var concrete := _material(Color("#687386"), 0.9)
	var dark_trim := _material(Color("#09111f"), 0.86)
	var phoenix_gold := _material(Color("#f4c95d"), 0.65, 0.18)

	# Four-sided, four-tier bowl with open sightlines toward the pitch.
	for side in [-1.0, 1.0]:
		for tier in range(4):
			var height := 1.8 + float(tier) * 2.05
			var offset := 36.2 + float(tier) * 1.9
			_add_box(root, "Stand_Long_%d_%d" % [int(side), tier], Vector3(3.8, 1.75, 108.0), Vector3(side * offset, height, 0.0), seating if tier % 2 == 0 else dark_trim)
			var end_offset := 55.2 + float(tier) * 1.9
			_add_box(root, "Stand_End_%d_%d" % [int(side), tier], Vector3(74.0, 1.75, 3.8), Vector3(0.0, height, side * end_offset), seating if tier % 2 == 0 else dark_trim)
			_add_box(root, "Concourse_Long_%d_%d" % [int(side), tier], Vector3(4.5, 0.34, 109.0), Vector3(side * (offset + 2.1), height + 1.0, 0.0), concrete)
			_add_box(root, "Concourse_End_%d_%d" % [int(side), tier], Vector3(75.0, 0.34, 4.5), Vector3(0.0, height + 1.0, side * (end_offset + 2.1)), concrete)

		_add_box(root, "Roof_Long_%d" % int(side), Vector3(10.0, 0.9, 116.0), Vector3(side * 43.0, 11.7, 0.0), roof)
		_add_box(root, "Roof_End_%d" % int(side), Vector3(86.0, 0.9, 10.0), Vector3(0.0, 11.7, side * 63.0), roof)
		_add_box(root, "Roof_Fascia_Long_%d" % int(side), Vector3(1.1, 1.3, 116.0), Vector3(side * 48.0, 11.2, 0.0), accent)
		_add_box(root, "Roof_Fascia_End_%d" % int(side), Vector3(86.0, 1.3, 1.1), Vector3(0.0, 11.2, side * 68.0), accent)

	# Roof trusses and support columns add depth to the silhouette.
	for z in range(-48, 49, 16):
		_add_box(root, "Roof_Support", Vector3(0.75, 8.5, 0.75), Vector3(-43.0, 6.1, float(z)), concrete)
		_add_box(root, "Roof_Support", Vector3(0.75, 8.5, 0.75), Vector3(43.0, 6.1, float(z)), concrete)
		_add_box(root, "Roof_Truss", Vector3(88.0, 0.42, 0.42), Vector3(0.0, 15.0, float(z)), dark_trim)

	_add_crowd(root, config)
	_add_led_boards(root, accent, dark_trim)
	_add_scoreboard_and_crest(root, config, roof, accent, phoenix_gold)
	_add_tunnel_and_benches(root, concrete, dark_trim, accent)

	# Four floodlight towers and emissive lamp panels.
	for x_side in [-1.0, 1.0]:
		for z_side in [-1.0, 1.0]:
			var pole := MeshInstance3D.new()
			pole.name = "FloodlightPole"
			var pole_mesh := CylinderMesh.new()
			pole_mesh.top_radius = 0.13
			pole_mesh.bottom_radius = 0.24
			pole_mesh.height = 15.0
			pole.mesh = pole_mesh
			pole.position = Vector3(x_side * 51.0, 7.5, z_side * 66.0)
			pole.material_override = roof
			root.add_child(pole)
			_add_box(root, "FloodlightPanel", Vector3(3.8, 0.7, 1.2), Vector3(x_side * 51.0, 15.1, z_side * 66.0), phoenix_gold)

	return root

static func _material(color: Color, roughness: float, metallic: float = 0.0) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	return material

static func _add_crowd(root: Node3D, config: Dictionary) -> void:
	var body_mesh := CapsuleMesh.new()
	body_mesh.radius = 0.16
	body_mesh.height = 0.78
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.14
	head_mesh.height = 0.28
	var crowd_material := ShaderMaterial.new()
	var shader := Shader.new()
	shader.code = CROWD_SHADER
	crowd_material.shader = shader

	var body_multi := MultiMesh.new()
	body_multi.transform_format = MultiMesh.TRANSFORM_3D
	body_multi.use_colors = true
	body_multi.mesh = body_mesh
	var head_multi := MultiMesh.new()
	head_multi.transform_format = MultiMesh.TRANSFORM_3D
	head_multi.use_colors = true
	head_multi.mesh = head_mesh

	var placements: Array[Transform3D] = []
	var rng := RandomNumberGenerator.new()
	rng.seed = 350026
	var tier_colors := [
		Color("#e9edf4"), Color("#27c9e8"), Color("#e14b5a"),
		Color("#f4c95d"), Color("#263b62"), Color("#f5f5f0"),
		Color("#3d9a75"), Color("#a9b5c7")
	]
	for side in [-1.0, 1.0]:
		for tier in range(4):
			var stand_y := 2.8 + float(tier) * 2.05
			var stand_x := side * (34.4 + float(tier) * 1.9)
			for row in range(4):
				var y := stand_y + float(row) * 0.34
				for seat in range(54):
					var z := -51.0 + float(seat) * 1.92 + rng.randf_range(-0.12, 0.12)
					placements.append(Transform3D(Basis.IDENTITY, Vector3(stand_x, y, z)))
	for end_side in [-1.0, 1.0]:
		for tier in range(4):
			var stand_y := 2.8 + float(tier) * 2.05
			var stand_z := end_side * (53.4 + float(tier) * 1.9)
			for row in range(4):
				var y := stand_y + float(row) * 0.34
				for seat in range(38):
					var x := -34.0 + float(seat) * 1.84 + rng.randf_range(-0.12, 0.12)
					placements.append(Transform3D(Basis.IDENTITY, Vector3(x, y, stand_z)))

	body_multi.instance_count = placements.size()
	head_multi.instance_count = placements.size()
	for index in range(placements.size()):
		var base := placements[index]
		var shirt := tier_colors[rng.randi_range(0, tier_colors.size() - 1)]
		var body_transform := base
		body_transform.origin.y += 0.28
		body_multi.set_instance_transform(index, body_transform)
		body_multi.set_instance_color(index, shirt)
		var head_transform := base
		head_transform.origin.y += 0.78
		head_multi.set_instance_transform(index, head_transform)
		head_multi.set_instance_color(index, Color("#d6ad8b") if rng.randf() > 0.28 else Color("#f0d4b5"))

	var bodies := MultiMeshInstance3D.new()
	bodies.name = "CrowdBodies"
	bodies.multimesh = body_multi
	bodies.material_override = crowd_material
	root.add_child(bodies)
	var heads := MultiMeshInstance3D.new()
	heads.name = "CrowdHeads"
	heads.multimesh = head_multi
	heads.material_override = crowd_material
	root.add_child(heads)
	root.set_meta("crowd_instance_count", placements.size())

static func _add_led_boards(root: Node3D, accent: Material, dark: Material) -> void:
	for side in [-1.0, 1.0]:
		for segment in range(8):
			var z := -49.0 + float(segment) * 14.0
			_add_box(root, "LED_AdvertisingBoard", Vector3(0.65, 1.05, 13.2), Vector3(side * 34.2, 0.72, z), accent if segment % 2 == 0 else dark)
	for end_side in [-1.0, 1.0]:
		for segment in range(6):
			var x := -30.0 + float(segment) * 12.0
			_add_box(root, "LED_AdvertisingBoard", Vector3(11.4, 1.05, 0.65), Vector3(x, 0.72, end_side * 52.6), accent if segment % 2 == 0 else dark)

static func _add_scoreboard_and_crest(root: Node3D, config: Dictionary, roof: Material, accent: Material, gold: Material) -> void:
	_add_box(root, "MainScoreboard", Vector3(18.0, 5.0, 0.9), Vector3(0.0, 14.1, -69.0), roof)
	var sign := Label3D.new()
	sign.name = "StadiumName"
	sign.text = "ESTADIO DEL FÉNIX"
	sign.font_size = 66
	sign.position = Vector3(0.0, 14.0, -68.48)
	sign.pixel_size = 0.008
	sign.modulate = Color("#27c9e8")
	sign.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(sign)
	var club_mark := Label3D.new()
	club_mark.name = "NovaC35Mark"
	club_mark.text = "NOVA C35  •  C35"
	club_mark.font_size = 38
	club_mark.position = Vector3(0.0, 10.2, -68.3)
	club_mark.pixel_size = 0.009
	club_mark.modulate = Color("#f4c95d")
	club_mark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(club_mark)
	_add_box(root, "PhoenixCrestPlate", Vector3(4.0, 4.0, 0.55), Vector3(0.0, 17.2, -68.8), gold)
	_add_box(root, "PhoenixCrestCore", Vector3(1.4, 2.6, 0.7), Vector3(0.0, 17.2, -68.35), accent)

static func _add_tunnel_and_benches(root: Node3D, concrete: Material, dark: Material, accent: Material) -> void:
	_add_box(root, "PlayersTunnel", Vector3(9.0, 4.0, 7.0), Vector3(0.0, 1.9, 59.0), dark)
	_add_box(root, "TunnelRoof", Vector3(10.0, 0.55, 7.8), Vector3(0.0, 4.1, 59.0), concrete)
	for side in [-1.0, 1.0]:
		_add_box(root, "TechnicalAreaBench", Vector3(8.0, 1.4, 2.0), Vector3(side * 15.0, 0.85, 58.0), dark)
		_add_box(root, "TechnicalAreaCanopy", Vector3(8.5, 0.3, 2.5), Vector3(side * 15.0, 2.1, 58.0), accent)

static func _add_box(parent: Node3D, node_name: String, dimensions: Vector3, at: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	instance.mesh = mesh
	instance.position = at
	instance.material_override = material
	parent.add_child(instance)
