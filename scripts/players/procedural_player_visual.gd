extends Node3D
class_name NovaProceduralPlayerVisual

var _body_root: Node3D
var _left_arm: Node3D
var _right_arm: Node3D
var _left_leg: Node3D
var _right_leg: Node3D
var _head: Node3D
var _last_parent_position := Vector3.ZERO
var _has_previous_position := false
var _phase := 0.0
var _stride := 0.0
var _idle_breath := 0.0

func configure(kit_color: Color, shorts_color: Color, skin_color: Color, is_goalkeeper: bool = false, appearance_seed: int = 0) -> void:
	for child in get_children():
		child.queue_free()
	_body_root = Node3D.new()
	_body_root.name = "BodyRoot"
	add_child(_body_root)

	var shirt := _make_material(kit_color, 0.78)
	var shorts := _make_material(shorts_color, 0.88)
	var skin := _make_material(skin_color, 0.92)
	var hair := _make_material(_hair_color(appearance_seed), 0.94)
	var boots := _make_material(Color("#111722"), 0.62)
	var glove_color := Color("#e9edf4") if is_goalkeeper else Color("#111722")
	var gloves := _make_material(glove_color, 0.7)

	_add_capsule(_body_root, "Torso", 0.235, 0.76, Vector3(0.0, 1.12, 0.0), shirt)
	_add_capsule(_body_root, "Neck", 0.085, 0.16, Vector3(0.0, 1.57, 0.0), skin)
	_head = Node3D.new()
	_head.name = "HeadPivot"
	_head.position = Vector3(0.0, 1.76, -0.005)
	_body_root.add_child(_head)
	_add_sphere(_head, "Head", 0.145, Vector3.ZERO, skin)
	_add_sphere(_head, "HairCap", 0.149, Vector3(0.0, 0.075, 0.018), hair, Vector3(1.0, 0.55, 1.0))
	_add_sphere(_head, "LeftEye", 0.018, Vector3(-0.052, 0.012, -0.128), boots)
	_add_sphere(_head, "RightEye", 0.018, Vector3(0.052, 0.012, -0.128), boots)

	var hips := MeshInstance3D.new()
	hips.name = "Shorts"
	var shorts_mesh := BoxMesh.new()
	shorts_mesh.size = Vector3(0.43, 0.26, 0.30)
	hips.mesh = shorts_mesh
	hips.position = Vector3(0.0, 0.72, 0.0)
	hips.material_override = shorts
	_body_root.add_child(hips)

	_left_arm = _build_limb("LeftArm", Vector3(-0.265, 1.38, 0.0), shirt, skin, gloves, is_goalkeeper, true)
	_right_arm = _build_limb("RightArm", Vector3(0.265, 1.38, 0.0), shirt, skin, gloves, is_goalkeeper, false)
	_body_root.add_child(_left_arm)
	_body_root.add_child(_right_arm)
	_left_leg = _build_leg("LeftLeg", Vector3(-0.125, 0.62, 0.0), shorts, skin, boots)
	_right_leg = _build_leg("RightLeg", Vector3(0.125, 0.62, 0.0), shorts, skin, boots)
	_body_root.add_child(_left_leg)
	_body_root.add_child(_right_leg)

func _process(delta: float) -> void:
	if _body_root == null:
		return
	var parent_node := get_parent()
	var current_position: Vector3 = parent_node.global_position if parent_node is Node3D else global_position
	var speed := 0.0
	if _has_previous_position:
		speed = current_position.distance_to(_last_parent_position) / maxf(delta, 0.0001)
	_last_parent_position = current_position
	_has_previous_position = true
	_stride = move_toward(_stride, clampf(speed / 4.5, 0.0, 1.0), delta * 3.2)
	_phase += delta * (2.8 + _stride * 8.5)
	_idle_breath += delta
	var swing := sin(_phase) * 0.62 * _stride
	_left_leg.rotation.x = swing
	_right_leg.rotation.x = -swing
	_left_arm.rotation.x = -swing * 0.72
	_right_arm.rotation.x = swing * 0.72
	_body_root.position.y = absf(sin(_phase * 2.0)) * 0.045 * _stride + sin(_idle_breath * 1.8) * 0.008
	_head.rotation.x = sin(_phase * 0.5) * 0.025 * _stride

func _build_limb(node_name: String, at: Vector3, shirt: Material, skin: Material, gloves: Material, is_goalkeeper: bool, left: bool) -> Node3D:
	var pivot := Node3D.new()
	pivot.name = node_name
	pivot.position = at
	_add_capsule(pivot, "UpperArm", 0.085, 0.38, Vector3(0.0, -0.16, 0.0), shirt, Vector3(1.0, 1.0, 1.0))
	_add_capsule(pivot, "Forearm", 0.07, 0.34, Vector3(0.0, -0.48, -0.005), skin)
	_add_sphere(pivot, "Hand", 0.075, Vector3(0.0, -0.66, -0.01), gloves if is_goalkeeper else skin)
	return pivot

func _build_leg(node_name: String, at: Vector3, shorts: Material, skin: Material, boots: Material) -> Node3D:
	var pivot := Node3D.new()
	pivot.name = node_name
	pivot.position = at
	_add_capsule(pivot, "Shin", 0.09, 0.55, Vector3(0.0, -0.26, 0.0), skin)
	_add_capsule(pivot, "Sock", 0.095, 0.31, Vector3(0.0, -0.31, -0.005), _make_material(Color("#f2f5fa"), 0.9))
	var boot := MeshInstance3D.new()
	boot.name = "Boot"
	var boot_mesh := BoxMesh.new()
	boot_mesh.size = Vector3(0.18, 0.12, 0.32)
	boot.mesh = boot_mesh
	boot.position = Vector3(0.0, -0.55, -0.09)
	boot.material_override = boots
	pivot.add_child(boot)
	return pivot

func _add_capsule(parent: Node3D, node_name: String, radius: float, height: float, at: Vector3, material: Material, scale_value: Vector3 = Vector3.ONE) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = node_name
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	node.mesh = mesh
	node.position = at
	node.scale = scale_value
	node.material_override = material
	parent.add_child(node)
	return node

func _add_sphere(parent: Node3D, node_name: String, radius: float, at: Vector3, material: Material, scale_value: Vector3 = Vector3.ONE) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = node_name
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	node.mesh = mesh
	node.position = at
	node.scale = scale_value
	node.material_override = material
	parent.add_child(node)
	return node

func _make_material(color: Color, roughness: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	return material

func _hair_color(seed_value: int) -> Color:
	var colors := [Color("#171717"), Color("#38271f"), Color("#6a452d"), Color("#a77a45"), Color("#d1b18a")]
	return colors[posmod(abs(seed_value), colors.size())]
