class_name BallFlightModel
extends RefCounted

## Original, reusable football flight model inspired by published aerodynamics
## and the MIT-licensed FreeKick reference. It is not copied from that project.
const DEFAULT_GRAVITY := 9.81
const DEFAULT_DRAG := 0.0013
const DEFAULT_MAGNUS := 0.0018
const DEFAULT_SPIN_DECAY := 0.22
const MAX_SPIN := 110.0

static func aerodynamic_force(
	velocity: Vector3,
	spin: Vector3,
	drag_coefficient: float = DEFAULT_DRAG,
	magnus_coefficient: float = DEFAULT_MAGNUS,
	max_force: float = 4.8
) -> Vector3:
	if not velocity.is_finite() or not spin.is_finite():
		return Vector3.ZERO
	var safe_drag := clampf(drag_coefficient, 0.0, 0.05) if is_finite(drag_coefficient) else DEFAULT_DRAG
	var safe_magnus := clampf(magnus_coefficient, 0.0, 0.05) if is_finite(magnus_coefficient) else DEFAULT_MAGNUS
	var safe_max_force := clampf(max_force, 0.0, 50.0) if is_finite(max_force) else 4.8
	var drag := -velocity * velocity.length() * safe_drag
	var magnus := spin.cross(velocity) * safe_magnus
	var total := drag + magnus.limit_length(safe_max_force)
	return total if total.is_finite() else Vector3.ZERO

static func decay_spin(spin: Vector3, delta: float, decay: float = DEFAULT_SPIN_DECAY) -> Vector3:
	if not spin.is_finite():
		return Vector3.ZERO
	var safe_delta := maxf(0.0, delta) if is_finite(delta) else 0.0
	var safe_decay := clampf(decay, 0.0, 10.0) if is_finite(decay) else DEFAULT_SPIN_DECAY
	return spin / (1.0 + safe_decay * safe_delta)

static func integrate_step(
	position: Vector3,
	velocity: Vector3,
	spin: Vector3,
	delta: float,
	mass: float = 0.43,
	gravity: float = DEFAULT_GRAVITY,
	drag_coefficient: float = DEFAULT_DRAG,
	magnus_coefficient: float = DEFAULT_MAGNUS,
	spin_decay: float = DEFAULT_SPIN_DECAY
) -> Dictionary:
	if not position.is_finite() or not velocity.is_finite() or not spin.is_finite():
		return {"position": Vector3.ZERO, "velocity": Vector3.ZERO, "spin": Vector3.ZERO}
	var safe_mass := clampf(mass, 0.01, 100.0) if is_finite(mass) else 0.43
	var safe_delta := clampf(delta, 0.0, 0.25) if is_finite(delta) else 0.0
	var safe_gravity := clampf(gravity, 0.0, 50.0) if is_finite(gravity) else DEFAULT_GRAVITY
	var force := aerodynamic_force(velocity, spin, drag_coefficient, magnus_coefficient)
	var next_velocity := velocity + (force / safe_mass + Vector3.DOWN * safe_gravity) * safe_delta
	var next_spin := decay_spin(spin.limit_length(MAX_SPIN), safe_delta, spin_decay)
	var next_position := position + (velocity + next_velocity) * 0.5 * safe_delta
	return {
		"position": next_position,
		"velocity": next_velocity,
		"spin": next_spin
	}

## A normalized gesture is interpreted in a local aim plane. The first point
## is the contact/start point and later points bend the requested path. The
## caller maps this plane into the restart's world-space coordinate frame.
static func normalize_swipe_path(path: PackedVector2Array) -> PackedVector2Array:
	var result := PackedVector2Array()
	if path.is_empty():
		return result
	var origin := path[0]
	var direction := (path[path.size() - 1] - origin).normalized()
	if direction.length_squared() < 0.0001:
		return result
	# Keep the screen-plane trajectory intact: vertical strokes must still
	# control loft, lateral strokes aim across the field, and bends remain
	# available to the curve estimator.
	for point in path:
		result.append(point - origin)
	return result

static func swipe_to_launch(
	path: PackedVector2Array,
	power: float,
	forward: Vector3,
	base_speed: float = 13.0,
	max_speed: float = 32.0,
	curve_scale: float = 7.0,
	loft_scale: float = 0.42
) -> Dictionary:
	var normalized := normalize_swipe_path(path)
	if normalized.size() < 2 or not forward.is_finite():
		return {"valid": false, "velocity": Vector3.ZERO, "spin": Vector3.ZERO}
	var end_point := normalized[normalized.size() - 1]
	var planar_forward := Vector3(forward.x, 0.0, forward.z).normalized()
	if planar_forward.length_squared() < 0.001:
		planar_forward = Vector3.FORWARD
	var right := planar_forward.cross(Vector3.UP).normalized()
	var aim_x := clampf(end_point.x, -1.0, 1.0)
	var aim_y := clampf(end_point.y, -1.0, 1.0)
	var direction := (planar_forward + right * aim_x * 0.85).normalized()
	var strength := clampf(power, 0.0, 1.0)
	var speed := lerpf(base_speed, max_speed, strength)
	var chord := end_point
	var chord_length := maxf(0.001, chord.length())
	var signed_bend := 0.0
	for point in normalized:
		var cross_value := (chord.x * point.y - chord.y * point.x) / chord_length
		if absf(cross_value) > absf(signed_bend):
			signed_bend = cross_value
	var curve := clampf(signed_bend * curve_scale, -MAX_SPIN, MAX_SPIN)
	var loft := clampf(-aim_y * loft_scale, -0.12, 0.55)
	var velocity := direction * speed + Vector3.UP * speed * loft
	var spin := Vector3.UP * curve
	return {
		"valid": true,
		"velocity": velocity,
		"spin": spin.limit_length(MAX_SPIN),
		"power": strength,
		"curve": curve,
		"loft": loft
	}
