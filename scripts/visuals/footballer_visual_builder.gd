extends RefCounted
class_name NovaFootballerVisualBuilder

## Builds a lightweight, fully 3D humanoid footballer for mobile match actors.
## The mesh is an original procedural placeholder, not a licensed real-player model.

static func create_visual(player_data: Dictionary, home_team: bool) -> Node3D:
	var root := Node3D.new()
	root.name = "FootballerVisual"
	root.set_meta("procedural_footballer", true)

	var shirt_color := Color("#D92E3A") if home_team else Color("#E7E9EF")
	var shorts_color := Color("#18202B") if home_team else Color("#253A68")
	var trim_color := Color("#F2F4F8") if home_team else Color("#24384E")
	var skin_color := Color("#805039")
	var boot_color := Color("#17191F")
	var shirt := _material(shirt_color, 0.78)
	var shorts := _material(shorts_color, 0.86)
	var trim := _material(trim_color, 0.72)
	var skin := _material(skin_color, 0.9)
	var boots := _material(boot_color, 0.65)
	var role := str(player_data.get("role", ""))
	var is_goalkeeper := role == "GK"
	if is_goalkeeper:
		shirt = _material(Color("#E9B83F") if home_team else Color("#55B9A7"), 0.72)

	_add_capsule(root, "Torso", 0.255, 0.82, Vector3(0.0, 1.13, 0.0), shirt)
	_add_box(root, "JerseyChestBand", Vector3(0.43, 0.075, 0.035), Vector3(0.0, 1.22, -0.244), trim)
	_add_box(root, "Shorts", Vector3(0.45, 0.25, 0.31), Vector3(0.0, 0.63, 0.0), shorts)
	_add_capsule(root, "Neck", 0.075, 0.18, Vector3(0.0, 1.61, 0.0), skin)
	_add_sphere(root, "Head", 0.145, Vector3(0.0, 1.79, 0.0), skin)
	_add_sphere(root, "Hair", 0.148, Vector3(0.0, 1.87, 0.012), _material(Color("#211B19"), 0.95))

	for side in [-1.0, 1.0]:
		var arm_pivot := Node3D.new()
		arm_pivot.name = "LeftArmPivot" if side < 0.0 else "RightArmPivot"
		arm_pivot.position = Vector3(side * 0.29, 1.43, 0.0)
		root.add_child(arm_pivot)
		_add_capsule(arm_pivot, "Arm", 0.082, 0.52, Vector3(0.0, -0.245, 0.0), shirt)
		_add_sphere(arm_pivot, "Hand", 0.075, Vector3(0.0, -0.51, 0.0), skin)

		var leg_pivot := Node3D.new()
		leg_pivot.name = "LeftLegPivot" if side < 0.0 else "RightLegPivot"
		leg_pivot.position = Vector3(side * 0.13, 0.57, 0.0)
		root.add_child(leg_pivot)
		_add_capsule(leg_pivot, "Leg", 0.095, 0.62, Vector3(0.0, -0.29, 0.0), shorts)
		_add_box(leg_pivot, "Boot", Vector3(0.17, 0.11, 0.29), Vector3(0.0, -0.59, -0.065), boots)
		_add_box(leg_pivot, "BootSole", Vector3(0.175, 0.035, 0.29), Vector3(0.0, -0.645, -0.065), _material(Color("#050608"), 0.58))

	if is_goalkeeper:
		for side in [-1.0, 1.0]:
			_add_sphere(root, "LeftGoalkeeperGlove" if side < 0.0 else "RightGoalkeeperGlove", 0.09, Vector3(side * 0.34, 0.91, -0.02), _material(Color("#F4D34E"), 0.7))

	root.set_meta("player_id", str(player_data.get("player_id", "")))
	root.set_meta("shirt_number", int(player_data.get("shirt_number", 0)))
	return root

static func _material(color: Color, roughness: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	return material

static func _add_capsule(parent: Node3D, node_name: String, radius: float, height: float, at: Vector3, material: Material) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	mesh_instance.mesh = mesh
	mesh_instance.position = at
	mesh_instance.material_override = material
	parent.add_child(mesh_instance)

static func _add_sphere(parent: Node3D, node_name: String, radius: float, at: Vector3, material: Material) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh_instance.mesh = mesh
	mesh_instance.position = at
	mesh_instance.material_override = material
	parent.add_child(mesh_instance)

static func _add_box(parent: Node3D, node_name: String, dimensions: Vector3, at: Vector3, material: Material) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	mesh_instance.mesh = mesh
	mesh_instance.position = at
	mesh_instance.material_override = material
	parent.add_child(mesh_instance)
