extends CharacterBody2D
class_name Player

signal died

var use_accelerometer: bool = false

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var chsape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var accelerometer_speed: float = 130.0
var speed: float = 300.0
var gravity: float = 15.0
var max_fall_velocity: float = 1000.0
var jump_velocity: float = -800.0
var viewport_size: Vector2
var dead: bool = false
var fall_anim_name: String = "fall"
var jump_anim_name: String = "jump"

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	
	var os_name: String = OS.get_name()
	if os_name == "Android" || os_name == "iOS":
		use_accelerometer = true

func _process(_delta: float) -> void:
	if velocity.y > 0:
		if animator.current_animation != fall_anim_name:
			animator.play(fall_anim_name)
	elif velocity.y < 0:
		if animator.current_animation != jump_anim_name:
			animator.play(jump_anim_name)

func _physics_process(_delta: float) -> void:
	# apply gravity
	velocity.y += gravity
	if velocity.y > max_fall_velocity:
		velocity.y = max_fall_velocity
	
	# move player
	if !dead:
		if use_accelerometer:
			var mobile_input = Input.get_accelerometer()
			velocity.x = mobile_input.x * accelerometer_speed
		else:
			# keyboard inputs
			var direction: float = Input.get_axis("ui_left", "ui_right")
			if direction:
				velocity.x = direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed * 0.2)
	
	move_and_slide()
	
	# muda de lado quando chega na margem
	var margin: int = 20
	if global_position.x > viewport_size.x + margin:
		global_position.x = -margin
	if global_position.x < -margin:
		global_position.x = viewport_size.x + margin

func jump():
	velocity.y = jump_velocity
	SoundFx.play("Jump")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()

func die():
	if !dead:
		dead = true
		chsape.set_deferred("disabled", true)
		SoundFx.play("Fail")
		died.emit()

func use_new_skin() -> void:
	fall_anim_name = "fall_red"
	jump_anim_name = "jump_red"
	
	if sprite:
		sprite.texture = preload("res://assets/textures/character/Skin2Idle.png")
