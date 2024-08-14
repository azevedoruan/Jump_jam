extends Control
class_name Hud

signal pause_game

@onready var topbar: Control = $TopBar
@onready var topbar_bg: ColorRect = $TopBarBG
@onready var score_label: Label = $TopBar/ScoreLabel

func _ready() -> void:
	var os_name: String = OS.get_name()
	if os_name == "Android" || os_name == "iOS":
		var safe_area: Rect2i = DisplayServer.get_display_safe_area()
		var safe_area_top: int = safe_area.position.y
		
		if os_name == "iOS":
			var screen_scale: float = DisplayServer.screen_get_scale()
			safe_area_top = (safe_area_top / screen_scale)
			MyUtility.add_log_message("screen scale: " + str(screen_scale))
		
		topbar.position.y += safe_area_top
		var margin: int = 10
		topbar_bg.size.y += safe_area_top + margin
		
		MyUtility.add_log_message("window size: " + str(DisplayServer.window_get_size()))
		MyUtility.add_log_message("safe area: " + str(safe_area))
		MyUtility.add_log_message("safe area top: " + str(safe_area_top))
		MyUtility.add_log_message("topbar position: " + str(topbar.position))

func set_score(score: int) -> void:
	score_label.text = str(score)

func _on_pause_button_pressed() -> void:
	SoundFx.play("Click")
	pause_game.emit()
