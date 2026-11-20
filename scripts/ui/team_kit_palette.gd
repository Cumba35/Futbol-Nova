extends RefCounted
class_name NovaTeamKitPalette

const CLUB_COLORS := [
	Color("#173c91"), Color("#b51f32"), Color("#08784c"), Color("#5b318b"),
	Color("#168d9d"), Color("#f06b24"), Color("#6c283e"), Color("#b58a1a"),
	Color("#174b72"), Color("#8b315c")
]
const AWAY_COLOR := Color("#f0f1f4")
const GOALKEEPER_COLOR := Color("#e6b52d")

static func primary_color(team_id: String) -> Color:
	return CLUB_COLORS[posmod(abs(team_id.hash()), CLUB_COLORS.size())]

static func shirt_color(team_id: String, kit_id: String, goalkeeper: bool = false) -> Color:
	if goalkeeper:
		return GOALKEEPER_COLOR
	if kit_id == "away":
		return AWAY_COLOR
	return primary_color(team_id)

static func shorts_color(team_id: String, kit_id: String, goalkeeper: bool = false) -> Color:
	if goalkeeper:
		return Color("#202737")
	if kit_id == "away":
		return Color("#202737")
	return primary_color(team_id).darkened(0.25)
