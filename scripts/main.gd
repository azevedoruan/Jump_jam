extends Node

@onready var game: Node2D = $Game
@onready var screens: CanvasLayer = $Screens
@onready var iap_manager: IAPManager = $IAPManager

var game_in_progress: bool = false

func _ready() -> void:
	DisplayServer.window_set_window_event_callback(_on_window_event)
	
	screens.start_game.connect(_on_screen_start_game)
	screens.delete_level.connect(_on_screen_delete_level)
	
	game.player_died.connect(_on_game_player_died)
	game.pause_game.connect(_on_game_pause_game)
	
	# IAP signals
	iap_manager.unlock_new_skin.connect(_on_iap_manager_unlock_new_skin)
	screens.purchase_skin.connect(_on_screens_puchase_skin)

func _on_window_event(event) -> void:
	match event:
		DisplayServer.WINDOW_EVENT_FOCUS_IN:
			print("Focus in")
			MyUtility.add_log_message("Focus in")
		DisplayServer.WINDOW_EVENT_FOCUS_OUT:
			print("Focus out")
			MyUtility.add_log_message("Focus out")
			if game_in_progress == true && !get_tree().paused:
				_on_game_pause_game()

func _on_screen_start_game() -> void:
	game_in_progress = true
	game.new_game()

func _on_screen_delete_level() -> void:
	game.reset_game()

func _on_game_player_died(score, highscore) -> void:
	game_in_progress = false
	await(get_tree().create_timer(0.75).timeout)
	screens.game_over(score, highscore)

func _on_game_pause_game() -> void:
	get_tree().paused = true
	screens.pause_game()

func _on_screens_puchase_skin() -> void:
	iap_manager.purchase_skin()

func _on_iap_manager_unlock_new_skin() -> void:
	if game.new_skin_unlocked == false:
		game.new_skin_unlocked = true
