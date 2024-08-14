extends CanvasLayer

signal start_game
signal delete_level
signal purchase_skin

@onready var console: Control = $Debug/ConsoleLog
@onready var title_screen: BaseScreen = $TitleScreen
@onready var pause_screen: BaseScreen = $PauseScreen
@onready var gameover_screen: BaseScreen = $GameOverScreen
@onready var gameover_score_label: Label = $GameOverScreen/Box/ScoreLabel
@onready var gameover_highscore_label: Label = $GameOverScreen/Box/BestLabel
@onready var shop_screen: BaseScreen = $ShopScreen

var current_screen: BaseScreen = null


func _ready() -> void:
	console.visible = false
	register_buttons()
	change_screen(title_screen)

func register_buttons() -> void:
	var buttons = get_tree().get_nodes_in_group("buttons")
	if buttons.size() > 0:
		for button in buttons:
			if button is ScreenButton:
				button.clicked.connect(_on_button_pressed)

func _on_button_pressed(button) -> void:
	SoundFx.play("Click")
	match button.name:
		"TitlePlay":
			change_screen(null)
			await(get_tree().create_timer(0.5).timeout)
			start_game.emit()
		"TitleShop":
			change_screen(shop_screen)
		"PauseRetryButton":
			change_screen(null)
			await(get_tree().create_timer(0.75).timeout)
			get_tree().paused = false
			start_game.emit()
		"PauseMenuButton":
			change_screen(title_screen)
			get_tree().paused = false
			delete_level.emit()
		"PauseCloseButton":
			change_screen(null)
			await(get_tree().create_timer(0.75).timeout)
			get_tree().paused = false
		"GameOverRetryButton":
			change_screen(null)
			await(get_tree().create_timer(0.5).timeout)
			start_game.emit()
		"GameOverMenuButton":
			change_screen(title_screen)
			delete_level.emit()
		"ShopBack":
			change_screen(title_screen)
		"ShopPurchaseSkin":
			purchase_skin.emit()

func _on_toggle_console_pressed() -> void:
	console.visible = !console.visible

func change_screen(new_screen: BaseScreen) -> void:
	if current_screen != null:
		var disappear_tween: Tween = current_screen.disappear()
		await(disappear_tween.finished)
		current_screen.visible = false
	current_screen = new_screen
	if current_screen != null:
		var appear_tween: Tween = current_screen.appear()
		await(appear_tween.finished)
		get_tree().call_group("buttons", "set_disable", false)

func game_over(score, highscore) -> void:
	gameover_score_label.text = "Score: " + str(score)
	gameover_highscore_label.text = "Best: " + str(highscore)
	change_screen(gameover_screen)

func pause_game() -> void:
	change_screen(pause_screen)
