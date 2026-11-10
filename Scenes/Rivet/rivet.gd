extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const TILE_W: int = 16
const TILE_H: int = 16

# tiles per second
@export var maximum_speed: float = 5
# tiles per second per second
@export var positive_acceleration: float = 30
# tiles per second per second
@export var negative_acceleration: float = 30



# tiles
@export var maximum_jump_height : float = 2
# tiles per second per second
@export var rising_acceleration : float = 35
# tiles per second per second
@export var falling_acceleration: float = 70

@export var maximum_jumps: int = 1
@export var current_jumps: int = 0


var vx = 0
var vy = 0

func _ready():
	pass
	
func _physics_process(dt: float) -> void:
	var dx = Input.get_axis(
		"move_left",
		"move_right"
	)
	
	if dx != 0:
		vx = clamp(
			vx + TILE_W * positive_acceleration * dx * dt,
			-maximum_speed * TILE_W,
			 maximum_speed * TILE_W
		)
	elif vx != 0:
		var direction = sign(vx)
		vx -= TILE_W * direction * negative_acceleration * dt
		if direction != sign(vx):
			vx = 0
	
	var vx_collision = move_and_collide(Vector2(vx, 0) * dt)
	if vx_collision:
		pass
		
	if Input.is_action_pressed("jump") and vy < 0:
		vy += TILE_H * rising_acceleration  * dt
	else:
		vy += TILE_H * falling_acceleration * dt
	
	if Input.is_action_just_pressed("jump") and current_jumps < maximum_jumps:
		vy = -sqrt(2 * TILE_H * TILE_H * rising_acceleration * maximum_jump_height)
		current_jumps += 1
		
	var vy_collision = move_and_collide(Vector2(0, vy) * dt)
	if vy_collision:
		if vy > 0:
			current_jumps = 0
		vy = 0

	
	if dx != 0:
		sprite.scale.x = dx
		
	if   !is_on_floor() and vy < 0:
		sprite.animation = "jump"
	elif !is_on_floor() and vy > 0:
		sprite.animation = "fall"
	elif vx != 0:
		sprite.animation = "walk"
	else:
		sprite.animation = "idle"
	
	move_and_slide()
	
