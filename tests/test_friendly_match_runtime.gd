extends SceneTree

const MAIN_SCENE_PATH := "res://scenes/main.tscn"
const MATCH_CLOCK_STATE := preload("res://scripts/gameplay/match_clock_state_machine.gd")
const MATCH_11V11 := preload("res://scripts/gameplay/match_11v11_controller.gd")
const MOMENTS_SERVICE_SCRIPT := preload("res://scripts/moments/daily_moments_service.gd")

func _initialize() -> void:
	call_deferred("_run_acceptance_test")
	call_deferred("_test_watchdog")

func _test_watchdog() -> void:
	await create_timer(120.0).timeout
	push_error("FÚTBOL NOVA ACCEPTANCE: el test runtime superó 120 segundos.")
	quit(1)

func _run_acceptance_test() -> void:
	var failures := PackedStringArray()
	var moments_service: Node = root.get_node_or_null("MomentsService")
	var original_moments_state: Dictionary = {}
	var training_moments_progress := -1
	print("FRIENDLY_TEST: creating main scene")
	var main_scene := load(MAIN_SCENE_PATH) as PackedScene
	if main_scene == null:
		push_error("FRIENDLY_TEST: no se pudo cargar scenes/main.tscn después de inicializar autoloads.")
		quit(1)
		return
	var game = main_scene.instantiate()
	if game == null or game.get_script() == null:
		push_error("FRIENDLY_TEST: main.gd no se pudo cargar o compilar.")
		quit(1)
		return
	root.add_child(game)

	# The main scene builds its field, HUD, hub and match controller over several frames.
	for frame_index in range(40):
		await process_frame
		if game.game_hub != null and game.match_11v11_controller != null:
			break

	print("FRIENDLY_TEST: main scene initialized")
	if game.game_hub == null:
		failures.append("La escena principal no creó el menú de juego.")
	if game.match_11v11_controller == null:
		failures.append("La escena principal no creó el motor de partido 11 contra 11.")
	var stadium = game.get_node_or_null("NovaStadium")
	if stadium == null or stadium.get_child_count() < 50:
		failures.append("El estadio base procedural no se creó completo.")
	var football_data_service: Node = root.get_node_or_null("FootballData")
	var football_registry: Variant = football_data_service.get("registry") if football_data_service != null else null
	if football_registry == null:
		failures.append("El catálogo offline no creó el registro de clubes.")

	if game.game_hub != null:
		for page in ["home", "online", "modes", "settings"]:
			game.game_hub._open_main_page(page)
			await process_frame
			if game.game_hub.current_page != page:
				failures.append("No se pudo abrir la pantalla principal: " + page)
			if game.game_hub.content_box.get_child_count() == 0:
				failures.append("La pantalla principal está vacía: " + page)

		for category in ["Edición", "Módulos", "Música", "Juego", "Datos", "Controles", "Audio", "Gráficos", "Accesibilidad", "Administración", "Información"]:
			game.game_hub._open_settings_category(category)
			await process_frame
			if game.game_hub.current_subpage != category:
				failures.append("No se pudo abrir la categoría de configuración: " + category)
			if game.game_hub.content_box.get_child_count() == 0:
				failures.append("La categoría de configuración no muestra contenido: " + category)

		game.game_hub._show_home()
		await process_frame
		print("FRIENDLY_TEST: hub navigation complete")

	# A valid training goal must advance daily Moments, while a friendly-match goal must not.
	if moments_service == null:
		failures.append("El servicio de Momentos diarios no está disponible.")
	else:
		var daily_before: Dictionary = moments_service.call("get_daily_challenge")
		original_moments_state = moments_service.get("_state").duplicate(true)
		var clean_moments_state: Dictionary = MOMENTS_SERVICE_SCRIPT.create_daily_state(str(daily_before.get("date", "")), 0)
		moments_service.set("_state", clean_moments_state)
		game._on_training_mode_selected("free_practice")
		game.ball.global_position = Vector3(0.0, 0.35, 53.0)
		game._on_goal_body_entered(game.ball, "away")
		var daily_after_training: Dictionary = moments_service.call("get_daily_challenge")
		training_moments_progress = int(daily_after_training.get("progress", 0))
		if training_moments_progress != 1:
			failures.append("Un gol válido en práctica libre no avanzó el reto de Momentos diarios.")
		if str(game.current_training_mode_id) != "free_practice":
			failures.append("El juego no conservó el modo de entrenamiento activo para registrar el gol.")
		if game.ball.global_position.distance_to(Vector3(0.0, 0.35, 0.0)) > 0.01:
			failures.append("El balón no regresó al punto de inicio de práctica libre después del gol.")

	# Use the same pre-match screen and button path as a real player.
	if game.match_11v11_controller != null and football_registry != null:
		game._open_pre_match_setup()
		await process_frame
		print("FRIENDLY_TEST: pre-match setup opened")
		var setup = game.pre_match_setup
		if setup == null or not is_instance_valid(setup):
			failures.append("No se abrió la preparación del amistoso.")
		else:
			if setup._home_teams.item_count < 2 or setup._away_teams.item_count < 2:
				failures.append("La preparación no muestra al menos dos clubes elegibles.")
			if setup._start_button.disabled:
				failures.append("El botón Iniciar amistoso está bloqueado pese a existir dos clubes válidos.")
			var selected_home_id: String = str(setup._selected_team_id(setup._home_teams))
			var selected_away_id: String = str(setup._selected_team_id(setup._away_teams))
			if selected_home_id != "FN-ESP-REAL-MADRID":
				failures.append("El amistoso no seleccionó Real Madrid como equipo local a la izquierda.")
			if selected_away_id != "FN-ESP-BARCELONA":
				failures.append("El amistoso no seleccionó Barcelona como visitante a la derecha.")
			if setup._home_badge == null or not setup._home_badge.text.contains("REAL MADRID"):
				failures.append("La tarjeta local no identifica al representante de Real Madrid.")
			if setup._away_badge == null or not setup._away_badge.text.contains("FC BARCELONA"):
				failures.append("La tarjeta visitante no identifica al representante de Barcelona.")
			if football_registry.get_team_roster(selected_home_id).size() != 22:
				failures.append("La plantilla base de Real Madrid no contiene 22 perfiles Nova.")
			if football_registry.get_team_roster(selected_away_id).size() != 22:
				failures.append("La plantilla base de Barcelona no contiene 22 perfiles Nova.")
			if setup._home_lineup_preview == null or setup._home_lineup_preview.text.split("\n").size() != 12:
				failures.append("La pantalla no muestra los once titulares del equipo local.")
			if setup._away_lineup_preview == null or setup._away_lineup_preview.text.split("\n").size() != 12:
				failures.append("La pantalla no muestra los once titulares del equipo visitante.")
			if setup._stadium_option == null or setup._stadium_option.item_count < 1:
				failures.append("La pantalla previa no ofrece un estadio base jugable.")
			var expected_home_name: String = setup._team_match_display_name(selected_home_id, football_registry.teams_by_id.get(selected_home_id, {}))
			var expected_away_name: String = setup._team_match_display_name(selected_away_id, football_registry.teams_by_id.get(selected_away_id, {}))
			if selected_home_id.is_empty() or selected_away_id.is_empty() or selected_home_id == selected_away_id:
				failures.append("La selección inicial no contiene dos clubes distintos.")
			else:
				setup._start_match()
				await process_frame
				print("FRIENDLY_TEST: friendly match started")
				var summary: Dictionary = game.match_11v11_controller.get_match_summary()
				var applied_roster_profiles := 0
				for actor_data in game.match_11v11_controller._actors:
					var actor_attributes: Dictionary = actor_data.get("attributes", {})
					if str(actor_data.get("display_name", "")).is_empty() or actor_attributes.is_empty() or int(actor_data.get("overall", 0)) <= 0:
						failures.append("Un futbolista de IA no recibió su perfil, atributos y valoración desde la plantilla.")
					if float(actor_data.get("speed", 0.0)) <= 0.0:
						failures.append("Un futbolista de IA no recibió velocidad derivada de sus atributos.")
					applied_roster_profiles += 1
				if applied_roster_profiles != 21:
					failures.append("El partido no aplicó perfiles individuales a los 21 futbolistas de IA.")
				var controlled_profile: Dictionary = game.player.get_meta("nova_player_profile", {})
				if controlled_profile.is_empty() or controlled_profile.get("attributes", {}).is_empty():
					failures.append("El futbolista controlado no conservó su perfil de la plantilla local.")
				var controlled_attributes: Dictionary = controlled_profile.get("attributes", {})
				var expected_move_speed := lerpf(6.4, 8.2, clampf(float(controlled_attributes.get("spd", 70.0)) / 99.0, 0.0, 1.0))
				var expected_pass_force := lerpf(4.8, 7.0, clampf(float(controlled_attributes.get("short", 70.0)) / 99.0, 0.0, 1.0))
				var expected_shot_force := lerpf(9.5, 13.0, clampf(float(controlled_attributes.get("shot", 70.0)) / 99.0, 0.0, 1.0))
				if not is_equal_approx(float(game.player.get("move_speed")), expected_move_speed):
					failures.append("La velocidad del jugador controlado no coincide con sus atributos.")
				if not is_equal_approx(float(game.player.get("pass_force")), expected_pass_force):
					failures.append("La fuerza de pase no se calculó desde la plantilla del jugador.")
				if not is_equal_approx(float(game.player.get("shot_force")), expected_shot_force):
					failures.append("La fuerza de tiro no se calculó desde la plantilla del jugador.")
				var sample_kit_colors: Dictionary = game.match_11v11_controller.get("_team_colors")
				if not sample_kit_colors.get("home", Color.BLACK).is_equal_approx(Color("#E7E2D5")):
					failures.append("El representante local de Real Madrid no aplicó su equipación Nova original.")
				if not sample_kit_colors.get("away", Color.BLACK).is_equal_approx(Color("#A04A57")):
					failures.append("El representante visitante de Barcelona no aplicó su equipación Nova original.")
				if game.current_stadium_id != "nova_stadium_main":
					failures.append("El partido no conservó el estadio base seleccionado.")
				if not bool(summary.get("active", false)):
					failures.append("El motor rechazó el amistoso iniciado desde la pantalla de preparación.")
				if int(summary.get("home_players", 0)) != 11:
					failures.append("El equipo local no quedó con once jugadores en el campo.")
				if int(summary.get("away_players", 0)) != 11:
					failures.append("El equipo visitante no quedó con once jugadores en el campo.")
				if int(summary.get("ai_players", 0)) != 21:
					failures.append("El partido no creó los 21 futbolistas de IA además del jugador controlado.")
				if game.player == null or not is_instance_valid(game.player):
					failures.append("El jugador controlado dejó de existir al iniciar el amistoso.")
				elif game.match_11v11_controller._player != game.player:
					failures.append("El motor conserva una referencia antigua en vez del futbolista controlado actual.")
				game.match_11v11_controller.set_match_paused(true)
				if game.player.is_physics_processing():
					failures.append("El jugador siguió moviéndose durante la pausa del partido.")
				game.match_11v11_controller.set_match_paused(false)
				if not game.player.is_physics_processing():
					failures.append("El jugador no recuperó sus controles al reanudar el partido.")
				game.match_11v11_controller._transfer_possession(game.player, true, "controlled_player")
				if not game.ball.freeze:
					failures.append("La prueba no pudo establecer la posesión previa al reinicio.")
				var spin_release_ok: bool = bool(game.match_11v11_controller.release_controlled_ball(Vector3.FORWARD, 7.0, Vector3.UP * 18.0))
				if not spin_release_ok:
					failures.append("El controlador no liberó el balón con spin válido desde la posesión controlada.")
				if game.match_11v11_controller.has_controlled_possession():
					failures.append("El balón conservó la posesión controlada después del lanzamiento.")
				var applied_flight_spin: Vector3 = game.match_11v11_controller.get("_ball_flight_spin")
				if applied_flight_spin.length() < 1.0:
					failures.append("El spin de vuelo no llegó al modelo aerodinámico.")
				game.ball.sleeping = false
				game.match_11v11_controller._apply_ball_aerodynamics(0.1)
				var decayed_flight_spin: Vector3 = game.match_11v11_controller.get("_ball_flight_spin")
				if decayed_flight_spin.length() >= applied_flight_spin.length():
					failures.append("El controlador no aplicó el decaimiento del spin durante el vuelo.")
				game.match_11v11_controller._transfer_possession(game.player, true, "controlled_player")
				game.ball.freeze = false
				game.ball.sleeping = true
				if not game.ball.sleeping:
					failures.append("La prueba no pudo simular un balón dormido antes del reinicio.")
				game._reset_ball()
				if game.match_11v11_controller.has_controlled_possession():
					failures.append("El reinicio tras un gol conservó la posesión anterior.")
				if game.ball.freeze:
					failures.append("El balón quedó congelado después del reinicio.")
				if game.ball.sleeping:
					failures.append("El balón siguió dormido después del reinicio.")
				if game.ball.global_position.distance_to(Vector3(0.0, 0.35, 0.0)) > 0.01:
					failures.append("El balón no regresó al centro después del reinicio.")
				if str(summary.get("home_team_id", "")) != selected_home_id:
					failures.append("El motor no conservó el ID del club local seleccionado.")
				if str(summary.get("away_team_id", "")) != selected_away_id:
					failures.append("El motor no conservó el ID del club visitante seleccionado.")
				if str(game.home_team_display_name) != expected_home_name:
					failures.append("El HUD no muestra el nombre correcto del equipo local.")
				if str(game.away_team_display_name) != expected_away_name:
					failures.append("El HUD no muestra el nombre correcto del equipo visitante.")
				if game.match_clock_label == null or not game.match_clock_label.text.contains("PRIMER TIEMPO"):
					failures.append("El reloj del amistoso no muestra el primer tiempo.")

				# Goal areas must not change the score in training or after full time.
				var score_before_inactive_goal: int = int(game.score_home)
				game.match_11v11_controller.stop_match()
				game.ball.global_position = Vector3(0.0, 1.0, -53.0)
				game._on_goal_body_entered(game.ball, "home")
				if game.score_home != score_before_inactive_goal:
					failures.append("Una entrada en portería fuera de un amistoso activo modificó el marcador.")
				var restarted_match: Dictionary = game.match_11v11_controller.start_match(game.player, game.ball, {
					"home_team_id": selected_home_id,
					"away_team_id": selected_away_id,
					"half_length_minutes": 3,
					"clock_mode": "continuous"
				})
				if not bool(restarted_match.get("ok", false)):
					failures.append("No se pudo reiniciar el amistoso para comprobar los goles.")
				else:
					game._on_goal_body_entered(game.ball, "home")
					if game.score_home != 1 or game.score_away != 0:
						failures.append("El gol válido en la portería visitante no actualizó el marcador local.")
					if game.ball.global_position.distance_to(Vector3(0.0, 0.35, 0.0)) > 0.01:
						failures.append("El balón no se reinició en el centro tras el gol local.")
					game.ball.global_position = Vector3(0.0, 1.0, 53.0)
					game._on_goal_body_entered(game.ball, "away")
					if game.score_home != 1 or game.score_away != 1:
						failures.append("El gol válido en la portería local no actualizó el marcador visitante.")
					if game.ball.global_position.distance_to(Vector3(0.0, 0.35, 0.0)) > 0.01:
						failures.append("El balón no se reinició en el centro tras el gol visitante.")
					if moments_service != null and training_moments_progress >= 0:
						var daily_after_match_goals: Dictionary = moments_service.call("get_daily_challenge")
						if int(daily_after_match_goals.get("progress", 0)) != training_moments_progress:
							failures.append("Los goles de un amistoso no deben contar como goles de entrenamiento.")

				# Exercise the live controller through both regulation periods, not only kickoff.
				game.match_11v11_controller._match_clock_state = MATCH_CLOCK_STATE.create_state({
					"half_length_minutes": 3,
					"clock_mode": "continuous"
				})
				var home_z_before_half_time: float = float(game.player.global_position.z)
				var away_goalkeeper: Node3D
				for actor_data in game.match_11v11_controller._actors:
					if not bool(actor_data.get("home_team", true)) and str(actor_data.get("role", "")) == "GK":
						away_goalkeeper = actor_data.get("node")
						break
				var away_goalkeeper_z_before := away_goalkeeper.global_position.z if is_instance_valid(away_goalkeeper) else 0.0
				game.player.velocity = Vector3(2.0, 0.0, 3.0)
				game.match_11v11_controller._update_match_clock(240.0)
				if str(game.match_11v11_controller.get_clock_summary().get("phase", "")) != "half_time":
					failures.append("El motor en vivo no alcanzó el descanso después del primer tiempo y añadido.")
				if not game.match_11v11_controller.continue_after_period_break():
					failures.append("El motor en vivo no permitió continuar después del descanso.")
				if not is_equal_approx(game.player.global_position.z, -home_z_before_half_time):
					failures.append("El futbolista controlado no cambió de lado al comenzar el segundo tiempo.")
				if not game.player.velocity.is_zero_approx():
					failures.append("El futbolista conservó la velocidad anterior al cambiar de lado.")
				if is_instance_valid(away_goalkeeper) and not is_equal_approx(away_goalkeeper.global_position.z, -away_goalkeeper_z_before):
					failures.append("El portero visitante no cambió de lado al comenzar el segundo tiempo.")
				# Goal scoring follows the teams' swapped ends, not fixed goal-area labels.
				var home_score_before_swapped_goal: int = int(game.score_home)
				var away_score_before_swapped_goal: int = int(game.score_away)
				game.ball.global_position = Vector3(0.0, 1.0, 53.0)
				game._on_goal_body_entered(game.ball, "away")
				if game.score_home != home_score_before_swapped_goal + 1 or game.score_away != away_score_before_swapped_goal:
					failures.append("El gol local hacia +Z no se contabilizó después del cambio de lado.")
				game.ball.global_position = Vector3(0.0, 1.0, -53.0)
				game._on_goal_body_entered(game.ball, "home")
				if game.score_away != away_score_before_swapped_goal + 1:
					failures.append("El gol visitante hacia -Z no se contabilizó después del cambio de lado.")
				if MATCH_11V11.goalkeeper_clear_direction(true, 0.0, true).z <= 0.0 or MATCH_11V11.goalkeeper_clear_direction(false, 0.0, true).z >= 0.0:
					failures.append("Los despejes de los porteros no se orientaron hacia el campo rival después del cambio de lado.")
				game.match_11v11_controller._update_match_clock(240.0)
				var finished_clock: Dictionary = game.match_11v11_controller.get_clock_summary()
				if str(finished_clock.get("phase", "")) != "full_time":
					failures.append("El motor en vivo no finalizó el amistoso después del segundo tiempo y añadido.")
				if game.match_11v11_controller.is_match_active():
					failures.append("El controlador mantuvo activo el partido después del pitido final.")

				# Extra time has its own halftime; teams must swap ends again there.
				var extra_match: Dictionary = game.match_11v11_controller.start_match(game.player, game.ball, {
					"home_team_id": selected_home_id,
					"away_team_id": selected_away_id,
					"half_length_minutes": 3,
					"clock_mode": "continuous",
					"extra_time_enabled": true,
					"competition_allows_extra_time": true,
					"penalties_enabled": true,
					"competition_allows_penalties": true
				})
				if not bool(extra_match.get("ok", false)):
					failures.append("No se pudo iniciar el escenario de prueba de prórroga.")
				else:
					game.match_11v11_controller._update_match_clock(240.0)
					game.match_11v11_controller.continue_after_period_break()
					if game.player.global_position.z <= 0.0:
						failures.append("El segundo tiempo no dejó al equipo local en el lado opuesto.")
					game.match_11v11_controller._update_match_clock(240.0)
					if str(game.match_11v11_controller.get_clock_summary().get("phase", "")) != "extra_time_first_half":
						failures.append("El empate no inició la primera parte de la prórroga.")
					game.match_11v11_controller._update_match_clock(120.0)
					if str(game.match_11v11_controller.get_clock_summary().get("phase", "")) != "extra_time_half_time":
						failures.append("La prórroga no alcanzó su descanso.")
					game.match_11v11_controller.continue_after_period_break()
					if game.player.global_position.z >= 0.0:
						failures.append("Los equipos no volvieron a cambiar de lado en el descanso de la prórroga.")

	print("FRIENDLY_TEST: assertions completed")
	if game.match_11v11_controller != null:
		game.match_11v11_controller.stop_match()
	if moments_service != null and not original_moments_state.is_empty():
		moments_service.set("_state", original_moments_state)
		moments_service.call("_save")
	game.queue_free()

	if not failures.is_empty():
		for failure in failures:
			push_error("FÚTBOL NOVA ACCEPTANCE: " + failure)
		quit(1)
		return
	print("FÚTBOL NOVA ACCEPTANCE: cuatro pantallas, once categorías y amistoso 11v11 hasta el pitido final superados.")
	quit(0)
