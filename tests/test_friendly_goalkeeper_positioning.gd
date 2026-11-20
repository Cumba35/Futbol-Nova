extends SceneTree

const MATCH_11V11 = preload("res://scripts/gameplay/match_11v11_controller.gd")

func _initialize() -> void:
	call_deferred("_run_tests")

func _run_tests() -> void:
	var failures := PackedStringArray()
	var home_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(0.0, 0.35, 40.0), true, false)
	var away_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(0.0, 0.35, -40.0), false, false)
	var swapped_home_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(0.0, 0.35, -40.0), true, true)
	var midfield_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(2.0, 0.35, 0.0), true, false)
	var extreme_keeper := MATCH_11V11.goalkeeper_home_position(Vector3(40.0, 0.35, 40.0), true, false)

	if home_keeper.z >= 49.0 or home_keeper.z < 43.0:
		failures.append("El portero local no adelanta su posición de forma gradual ante peligro en su área.")
	if away_keeper.z <= -49.0 or away_keeper.z > -43.0:
		failures.append("El portero visitante no adelanta su posición en su propia área.")
	if swapped_home_keeper.z >= -43.0:
		failures.append("El portero local no cambia correctamente de portería tras el descanso.")
	if absf(midfield_keeper.z - 49.0) > 0.01:
		failures.append("El portero abandona su línea cuando el balón está en el medio campo.")
	if absf(midfield_keeper.x - 0.84) > 0.01:
		failures.append("El portero no ajusta lateralmente su posición a la trayectoria del balón.")
	if absf(extreme_keeper.x) > 3.1:
		failures.append("El portero puede salir del espacio protegido por los postes.")
	if not home_keeper.is_finite() or not away_keeper.is_finite() or not swapped_home_keeper.is_finite():
		failures.append("El cálculo de posición del portero produjo coordenadas no finitas.")

	if not failures.is_empty():
		for failure in failures:
			push_error("FÚTBOL NOVA GOALKEEPER POSITIONING: " + failure)
		quit(1)
		return
	print("FÚTBOL NOVA GOALKEEPER POSITIONING: línea, seguimiento lateral, adelanto defensivo y cambio de lado superados.")
	quit(0)
