extends Node2D

signal player_died(score, highscore)
signal pause_game

@onready var level_generator: LevelGenerator = $LevelGenerator
@onready var ground_sprite: Sprite2D = $GroundSprite
@onready var parallax1: ParallaxLayer = $ParallaxBackground/ParallaxLayer
@onready var parallax2: ParallaxLayer = $ParallaxBackground/ParallaxLayer2
@onready var parallax3: ParallaxLayer = $ParallaxBackground/ParallaxLayer3
@onready var hud: Hud = $UILayer/HUD

var viewport_size: Vector2
var camera_scene: PackedScene = preload("res://scenes/game_camera.tscn")
var camera: Camera2D = null

var player_scene: PackedScene = preload("res://scenes/player.tscn")
var player: Player = null
var player_spawn_position: Vector2

var score: int = 0
var highscore: int = 0
var save_file_path: String = "user://highscore.save"

var new_skin_unlocked: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_size = get_viewport_rect().size
	player_spawn_position.x = viewport_size.x / 2
	player_spawn_position.y = viewport_size.y - 135
	
	ground_sprite.global_position.x = viewport_size.x / 2
	ground_sprite.global_position.y = viewport_size.y
	
	set_parallax_layer(parallax1)
	set_parallax_layer(parallax2)
	set_parallax_layer(parallax3)
	
	hud.visible = false
	hud.set_score(0)
	ground_sprite.visible = false
	
	hud.pause_game.connect(on_hud_pause_game)
	load_score()

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	# calcula o score
	if player:
		var score_calculation: int = (viewport_size.y - player.global_position.y) * 0.05
		if score < score_calculation:
			score = score_calculation
			hud.set_score(score)

func new_game():
	reset_game()
	score = 0
	
	player = player_scene.instantiate()
	player.global_position = player_spawn_position
	player.died.connect(_on_player_died)
	add_child(player)
	
	if new_skin_unlocked == true:
		player.use_new_skin()
	
	camera = camera_scene.instantiate()
	camera.setup_camera(player)
	add_child(camera)
	
	if player != null:
		level_generator.set_player(player)
		level_generator.start_generation()
	
	hud.visible = true
	ground_sprite.visible = true

func get_parallax_sprite_scale(parallax_sprite: Sprite2D) -> Vector2:
	var parallax_texture: Texture2D = parallax_sprite.get_texture()
	var parallax_texture_width: float = float(parallax_texture.get_width())
	var scale: float = viewport_size.x / parallax_texture_width
	var result: Vector2 = Vector2(scale, scale)
	return result

func set_parallax_layer(parallax_layer: ParallaxLayer) -> void:
	var parallax_sprite: Sprite2D = parallax_layer.find_child("Sprite2D")
	if parallax_sprite != null:
		parallax_sprite.scale = get_parallax_sprite_scale(parallax_sprite)
		var motion_y: float = parallax_sprite.scale.y * parallax_sprite.get_texture().get_height()
		parallax_layer.motion_mirroring.y = motion_y

func _on_player_died():
	hud.visible = false
	
	if score > highscore:
		highscore = score
		save_score()
	
	player_died.emit(score, highscore)

func reset_game() -> void:
	ground_sprite.visible = false
	hud.visible = false
	level_generator.reset_level()
	if player != null:
		player.queue_free()
		player = null
		level_generator.player = null
	if camera != null:
		camera.queue_free()
		camera = null

func save_score() -> void:
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	file.store_var(highscore)
	file.close()
	print("Save highscore")

func load_score() -> void:
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path, FileAccess.READ)
		highscore = file.get_var()
		file.close()
		print("load highscore")
	else:
		highscore = 0

func on_hud_pause_game() -> void:
	pause_game.emit()
