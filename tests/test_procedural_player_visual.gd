extends SceneTree

const PLAYER_VISUAL = preload("res://scripts/players/procedural_player_visual.gd")

func _initialize() -> void:
	var actor := Node3D.new()
	var visual := PLAYER_VISUAL.new()
	visual.configure(Color("#14213d"), Color("#0b1428"), Color("#b9825e"), true, 35)
	actor.add_child(visual)
	root.add_child(actor)
	assert(visual.get_node_or_null("BodyRoot/Torso") != null, "El futbolista debe tener torso con camiseta.")
	assert(visual.get_node_or_null("BodyRoot/HeadPivot/Head") != null, "El futbolista debe tener cabeza.")
	assert(visual.get_node_or_null("BodyRoot/LeftArm/UpperArm") != null, "Debe existir el brazo izquierdo articulado.")
	assert(visual.get_node_or_null("BodyRoot/RightArm/Forearm") != null, "Debe existir el antebrazo derecho.")
	assert(visual.get_node_or_null("BodyRoot/LeftLeg/Boot") != null, "Debe existir la bota izquierda.")
	assert(visual.get_node_or_null("BodyRoot/RightLeg/Sock") != null, "Debe existir la media derecha.")
	assert(visual.get_node_or_null("BodyRoot/LeftArm/Hand") != null, "El guardameta debe tener guantes/manos visibles.")
	visual._process(0.016)
	actor.queue_free()
	print("FUTBOL_NOVA_PROCEDURAL_PLAYER_VISUAL_TESTS: PASS")
	quit(0)
