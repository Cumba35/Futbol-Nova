extends RefCounted
class_name NovaStadiumBuilder

const STADIUMS := [
	{
		"id": "nova_central",
		"name": "Estadio Nova Central",
		"capacity": 42000,
		"seating": "#164e3a",
		"accent": "#b9ec62",
		"roof": "#142638"
	},
	{
		"id": "bahia_arena",
		"name": "Arena Bahía",
		"capacity": 28500,
		"seating": "#1c526c",
		"accent": "#f0c66a",
		"roof": "#172d3d"
	},
	{
		"id": "aurora_park",
		"name": "Parque Aurora",
		"capacity": 19000,
		"seating": "#514071",
		"accent": "#c5ef70",
		"roof": "#24243a"
	},
	{
		"id": "nova_c35",
		"name": "Estadio del Fénix",
		"capacity": 105000,
		"club_id": "FN-NOVA-C35",
		"seating": "#101B35",
		"accent": "#00CFE8",
		"roof": "#0A1022",
		"secondary_accent": "#BFC9D8"
	},
	{
		"id": "rio_de_argenti",
		"name": "Estadio Río de Argenti",
		"capacity": 105000,
		"club_id": "FN-NOVA-RDA",
		"seating": "#176A91",
		"accent": "#C7D3DE",
		"roof": "#142A3B",
		"secondary_accent": "#FFFFFF",
		"palette_status": "provisional_pending_visual_check_of_dropbox_home_reference"
	},
	{
		"id": "nova_genesis",
		"name": "Arena Nova Génesis",
		"capacity": 105000,
		"club_id": "FN-NOVA-GEN",
		"seating": "#14213D",
		"accent": "#F5F7FA",
		"roof": "#101A30",
		"secondary_accent": "#D72638",
		"tertiary_accent": "#218C52"
	},
	{
		"id": "sangre_galactica",
		"name": "Estadio Sangre de Estrellas",
		"capacity": 105000,
		"club_id": "FN-NOVA-SAG",
		"seating": "#4A155D",
		"accent": "#D7193F",
		"roof": "#260B36",
		"secondary_accent": "#F4C542",
		"tertiary_accent": "#FFFFFF"
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
	var seating := StandardMaterial3D.new()
	seating.albedo_color = Color(str(config.seating))
	seating.roughness = 0.92
	var accent := StandardMaterial3D.new()
	accent.albedo_color = Color(str(config.accent))
	accent.roughness = 0.8
	var roof := StandardMaterial3D.new()
	roof.albedo_color = Color(str(config.roof))
	roof.metallic = 0.25
	roof.roughness = 0.72
	var secondary_accent := StandardMaterial3D.new()
	secondary_accent.albedo_color = Color(str(config.get("secondary_accent", config.accent)))
	secondary_accent.roughness = 0.8
	var tertiary_accent := StandardMaterial3D.new()
	tertiary_accent.albedo_color = Color(str(config.get("tertiary_accent", config.get("secondary_accent", config.accent))))
	tertiary_accent.roughness = 0.8

	for side in [-1.0, 1.0]:
		for tier in range(4):
			var height := 1.6 + float(tier) * 2.1
			var offset := 37.5 + float(tier) * 1.1
			var tier_material: Material = seating if tier % 2 == 0 else accent
			if tier == 2:
				tier_material = secondary_accent
			elif tier == 3:
				tier_material = tertiary_accent
			_add_box(root, "Stand_Long_%d_%d" % [int(side), tier], Vector3(3.4, 1.9, 110.0), Vector3(side * offset, height, 0.0), tier_material)
			var end_offset := 58.5 + float(tier) * 1.1
			_add_box(root, "Stand_End_%d_%d" % [int(side), tier], Vector3(76.0, 1.9, 3.4), Vector3(0.0, height, side * end_offset), tier_material)

		_add_box(root, "Roof_Long_%d" % int(side), Vector3(8.5, 0.8, 114.0), Vector3(side * 41.0, 10.8, 0.0), roof)
		_add_box(root, "Roof_End_%d" % int(side), Vector3(84.0, 0.8, 8.5), Vector3(0.0, 10.8, side * 63.0), roof)

	for x_side in [-1.0, 1.0]:
		for z_side in [-1.0, 1.0]:
			var pole := MeshInstance3D.new()
			pole.name = "FloodlightPole"
			var pole_mesh := CylinderMesh.new()
			pole_mesh.top_radius = 0.16
			pole_mesh.bottom_radius = 0.24
			pole_mesh.height = 15.0
			pole.mesh = pole_mesh
			pole.position = Vector3(x_side * 43.0, 7.5, z_side * 65.0)
			pole.material_override = roof
			root.add_child(pole)
			var lamp := MeshInstance3D.new()
			lamp.name = "Floodlight"
			var lamp_mesh := BoxMesh.new()
			lamp_mesh.size = Vector3(2.4, 0.5, 1.2)
			lamp.mesh = lamp_mesh
			lamp.position = Vector3(x_side * 43.0, 15.2, z_side * 65.0)
			lamp.material_override = accent
			root.add_child(lamp)

	_add_box(root, "Scoreboard", Vector3(14.0, 4.0, 0.8), Vector3(0.0, 12.5, -70.0), roof)
	var sign := Label3D.new()
	sign.name = "StadiumName"
	sign.text = str(config.name).to_upper()
	sign.font_size = 64
	sign.position = Vector3(0.0, 12.3, -69.45)
	sign.pixel_size = 0.008
	sign.modulate = Color(str(config.accent))
	sign.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(sign)
	return root

static func _add_box(parent: Node3D, node_name: String, dimensions: Vector3, at: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	instance.mesh = mesh
	instance.position = at
	instance.material_override = material
	parent.add_child(instance)
