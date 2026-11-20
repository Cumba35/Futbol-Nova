extends "res://scripts/player_controller.gd"
class_name NovaRaymondValdezController

## Procedural placeholder avatar for the owner-confirmed Raymond game profile.
## The final high-fidelity likeness remains dependent on review of the supplied portrait.

func _ready() -> void:
	_build_collision()
	_build_visual()

func _build_collision() -> void:
	var collision := CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.34
	capsule.height = 1.82
	collision.shape = capsule
	collision.position.y = 0.91
	add_child(collision)

func _build_visual() -> void:
	var visual := Node3D.new()
	visual.name = "RaymondProceduralPlaceholder"
	add_child(visual)
	var navy := _material(Color("#142A3B"))
	var river_blue := _material(Color("#176A91"))
	var silver := _material(Color("#C7D3DE"))
	var skin := _material(Color("#B98262"))
	var shorts := _material(Color("#142A3B"))
	var boots := _material(Color("#20242B"))
	_add_capsule(visual, "Torso", Vector3(0.0, 1.25, 0.0), 0.27, 0.72, river_blue)
	_add_capsule(visual, "Shorts", Vector3(0.0, 0.77, 0.0), 0.25, 0.36, shorts)
	_add_sphere(visual, "Head", Vector3(0.0, 1.82, 0.0), 0.19, skin)
	_add_capsule(visual, "LeftArm", Vector3(-0.34, 1.24, 0.0), 0.075, 0.52, silver)
	_add_capsule(visual, "RightArm", Vector3(0.34, 1.24, 0.0), 0.075, 0.52, silver)
	_add_capsule(visual, "LeftLeg", Vector3(-0.13, 0.34, 0.0), 0.09, 0.55, navy)
	_add_capsule(visual, "RightLeg", Vector3(0.13, 0.34, 0.0), 0.09, 0.55, navy)
	_add_box(visual, "LeftBoot", Vector3(-0.13, 0.07, -0.07), Vector3(0.16, 0.12, 0.30), boots)
	_add_box(visual, "RightBoot", Vector3(0.13, 0.07, -0.07), Vector3(0.16, 0.12, 0.30), boots)
	_add_box(visual, "ShirtNumberFive", Vector3(0.0, 1.28, -0.275), Vector3(0.13, 0.18, 0.015), silver)

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.82
	return material

func _add_capsule(parent: Node3D, node_name: String, at: Vector3, radius: float, height: float, material: Material) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	mesh_instance.mesh = mesh
	mesh_instance.position = at
	mesh_instance.material_override = material
	parent.add_child(mesh_instance)

func _add_sphere(parent: Node3D, node_name: String, at: Vector3, radius: float, material: Material) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh_instance.mesh = mesh
	mesh_instance.position = at
	mesh_instance.material_override = material
	parent.add_child(mesh_instance)

func _add_box(parent: Node3D, node_name: String, at: Vector3, dimensions: Vector3, material: Material) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	mesh_instance.mesh = mesh
	mesh_instance.position = at
	mesh_instance.material_override = material
	parent.add_child(mesh_instance)
