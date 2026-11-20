extends Node
class_name Nova3DAnimation

## Shared, reusable animation-state contract for every 3D footballer.
## Clip playback binds to an AnimationTree when a rigged model is installed.
signal state_changed(state_name: String)
signal skill_requested(skill_id: String)
signal celebration_requested(celebration_id: String, sequence: Array)

const STATES := ["idle","walk","run","sprint","turn_left","turn_right","dribble","pass_short","pass_long","shot","tackle","intercept","jump","header","fall","get_up","celebration"]
var active_state := "idle"
var animation_tree: AnimationTree
var active_animation_profile: Dictionary = {}

func bind_tree(tree: AnimationTree) -> void:
	animation_tree = tree

func play_state(state_name: String) -> void:
	if not STATES.has(state_name):
		push_warning("Unknown NOVA animation state: " + state_name)
		return
	if active_state == state_name:
		return
	active_state = state_name
	if animation_tree and animation_tree.active:
		animation_tree.set("parameters/conditions/" + state_name, true)
	state_changed.emit(state_name)


## Loads per-player animation metadata without requiring proprietary player clips.
## A rig-specific controller can subscribe to the request signals and play original clips.
func set_player_animation_profile(profile: Dictionary) -> void:
	active_animation_profile = profile.duplicate(true)

func play_player_skill(skill_id: String) -> bool:
	var skill_mapping: Dictionary = active_animation_profile.get("skill_event_mapping", {})
	if not skill_mapping.has(skill_id):
		return false
	var state_name := str(skill_mapping[skill_id])
	if not STATES.has(state_name):
		return false
	skill_requested.emit(skill_id)
	play_state(state_name)
	return true

func play_goal_celebration(celebration: Dictionary) -> bool:
	var celebration_id := str(celebration.get("id", ""))
	var sequence: Array = celebration.get("sequence", [])
	if celebration_id.is_empty() or sequence.is_empty():
		return false
	celebration_requested.emit(celebration_id, sequence.duplicate())
	play_state("celebration")
	return true

func get_player_animation_profile() -> Dictionary:
	return active_animation_profile.duplicate(true)

func supported_states() -> PackedStringArray:
	return PackedStringArray(STATES)
