extends Camera2D

@onready var destroyer: Area2D = $Destroyer
@onready var destroyer_shape: CollisionShape2D = $Destroyer/CollisionShape2D

var player: Player = null
var limit_distance: int = 420
var viewport_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# define a posição da camera previamente
	if player != null:
		global_position.y = player.global_position.y
	
	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2
	
	limit_bottom = int(viewport_size.y)
	limit_left = 0
	limit_right = int(viewport_size.x)
	
	destroyer.position.y = viewport_size.y
	var rect_shape: RectangleShape2D = RectangleShape2D.new()
	var rect_shape_size: Vector2 = Vector2(viewport_size.x, 200)
	rect_shape.set_size(rect_shape_size)
	destroyer_shape.shape = rect_shape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player != null:
		if limit_bottom > player.global_position.y + limit_distance:
			limit_bottom = int(player.global_position.y + limit_distance)
	
	var overlapping_areas = destroyer.get_overlapping_areas()
	if overlapping_areas.size() > 0:
		for area in overlapping_areas:
			if area is Platform:
				area.queue_free()


func setup_camera(_player: Player) -> void:
	if _player != null:
		player = _player


func _physics_process(_delta: float) -> void:
	if player != null:
		global_position.y = player.global_position.y
