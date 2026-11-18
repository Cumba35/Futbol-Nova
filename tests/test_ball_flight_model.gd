extends SceneTree

const BallFlightModel = preload("res://scripts/ball_flight_model.gd")

func _initialize() -> void:
	var failures := PackedStringArray()
	var velocity := Vector3(20.0, 2.0, 0.0)
	var drag := BallFlightModel.aerodynamic_force(velocity, Vector3.ZERO)
	_expect(drag.dot(velocity) < 0.0, "Aerodynamic drag must oppose the direction of travel", failures)

	var magnus := BallFlightModel.aerodynamic_force(Vector3(0.0, 0.0, -20.0), Vector3.UP * 30.0)
	_expect(absf(magnus.x) > 0.1, "Spin must create a lateral Magnus force", failures)
	_expect(magnus.is_finite(), "Magnus force must remain finite", failures)

	var decayed := BallFlightModel.decay_spin(Vector3.UP * 30.0, 0.5)
	_expect(decayed.length() < 30.0 and decayed.length() > 0.0, "Spin must decay without disappearing instantly", failures)

	var integrated := BallFlightModel.integrate_step(Vector3.ZERO, Vector3(10.0, 4.0, 0.0), Vector3.UP * 20.0, 0.016)
	var integrated_position: Vector3 = integrated.get("position", Vector3.ZERO)
	var integrated_velocity: Vector3 = integrated.get("velocity", Vector3.ZERO)
	var integrated_spin: Vector3 = integrated.get("spin", Vector3.ZERO)
	_expect(integrated_position.is_finite(), "Integrated position must be finite", failures)
	_expect(integrated_velocity.is_finite(), "Integrated velocity must be finite", failures)
	_expect(integrated_spin.is_finite(), "Integrated spin must be finite", failures)

	var negative_delta := BallFlightModel.integrate_step(Vector3.ZERO, Vector3.FORWARD, Vector3.UP, -1.0)
	var negative_position: Vector3 = negative_delta.get("position", Vector3.ZERO)
	var negative_velocity: Vector3 = negative_delta.get("velocity", Vector3.ZERO)
	_expect(negative_position.is_finite() and negative_velocity.is_finite(), "Negative delta must not destabilize integration", failures)
	_expect(negative_position.is_zero_approx(), "Negative delta must not move the ball backwards in time", failures)

	var path := PackedVector2Array([Vector2(0.45, 0.72), Vector2(0.58, 0.52), Vector2(0.78, 0.30)])
	var launch := BallFlightModel.swipe_to_launch(path, 0.65, Vector3(0.0, 0.0, -1.0))
	_expect(bool(launch.get("valid", false)), "A valid swipe must produce a launch", failures)
	var launch_velocity: Vector3 = launch.get("velocity", Vector3.ZERO)
	var launch_spin: Vector3 = launch.get("spin", Vector3.ZERO)
	_expect(launch_velocity.is_finite(), "Swipe launch velocity must be finite", failures)
	_expect(launch_spin.is_finite(), "Swipe launch spin must be finite", failures)

	var invalid_path := PackedVector2Array([Vector2(0.5, 0.5), Vector2(0.5, 0.5)])
	var invalid_launch := BallFlightModel.swipe_to_launch(invalid_path, 0.5, Vector3.FORWARD)
	_expect(not bool(invalid_launch.get("valid", false)), "A zero-length swipe must be rejected", failures)

	if failures.is_empty():
		print("BALL FLIGHT MODEL TESTS: PASS")
		quit(0)
	else:
		for failure in failures:
			push_error("BALL FLIGHT MODEL: " + failure)
		quit(1)

func _expect(condition: bool, message: String, failures: PackedStringArray) -> void:
	if not condition:
		failures.append(message)
