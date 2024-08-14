extends Node2D
class_name LevelGenerator

@onready var platform_parent: Node2D = $PlatformParent

var platform_scene: PackedScene = preload("res://scenes/platform.tscn")

var player: Player = null

var viewport_size: Vector2
var start_platform_y: float
var y_distance_between_platforms: float = 100.0
var level_Size: int = 10
var generated_platform_count: int = 0


func set_player(_player: Player) -> void:
	if _player:
		player = _player


func _ready() -> void:
	generated_platform_count = 0
	viewport_size = get_viewport_rect().size
	start_platform_y = viewport_size.y - y_distance_between_platforms * 2


func start_generation() -> void:
	generate_level(start_platform_y, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player != null:
		var py: float = player.global_position.y
		var end_of_level_pos: float = start_platform_y - (generated_platform_count * y_distance_between_platforms)
		var treshold: float = end_of_level_pos + (y_distance_between_platforms * 12)
		if py <= treshold:
			generate_level(end_of_level_pos, false)


func create_platform(location: Vector2) -> Node2D:
	var platform: Node2D = platform_scene.instantiate() as Node2D
	platform.global_position = location
	platform_parent.add_child(platform)
	return platform


func generate_level(start_y: float, generate_ground: bool) -> void:
	var platform_width: float = 136
	
	# generate the ground
	if generate_ground == true:
		var ground_layer_y_offset: float = 62
		var ground_layer_platform_count: int = int(viewport_size.x / platform_width) + 1
		for i in range(ground_layer_platform_count):
			var ground_location: Vector2 = Vector2(i * platform_width, viewport_size.y - ground_layer_y_offset)
			create_platform(ground_location)
	
	# generate the rest of the level
	var max_x_position: float = viewport_size.x - platform_width
	for i in range(level_Size):
		var random_x_position: float = randf_range(0, max_x_position)
		var location: Vector2 = Vector2.ZERO
		location.x = random_x_position
		location.y = start_y - (y_distance_between_platforms * i)
		create_platform(location)
		generated_platform_count += 1

func reset_level() -> void:
	generated_platform_count = 0
	for platform in platform_parent.get_children():
		platform.queue_free()
