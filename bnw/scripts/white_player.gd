extends CharacterBody2D

@export var speed: float = 250.0
@export var accel_smooth: float = 8.0
@export var friction_smooth: float = 25.0
@export var jump_velocity: float = -320.0
@export var wall_pushback: float = 300.0
@export var wall_gravity: float = 100.0
var is_wall_sliding = false

@onready var animated_sprite: AnimatedSprite2D = $Animations

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction: float = Input.get_axis("left", "right")
	var target_x: float = direction * speed

	if direction != 0.0:
		velocity.x = lerpf(velocity.x, target_x, accel_smooth * delta)
	else:
		velocity.x = lerpf(velocity.x, 0.0, friction_smooth * delta)
	jump()
	wall_slide(delta)
	move_and_slide()

	if direction > 0.0:
		animated_sprite.flip_h = false
	elif direction < 0.0:
		animated_sprite.flip_h = true
	if is_on_floor():
		if abs(velocity.x) < 10.0:
			animated_sprite.play("stand")
		else:
			animated_sprite.play("run")
	else :
		if velocity.y < -80.0:
			animated_sprite.play("jumpup")
		elif velocity.y > -80.0 && velocity.y < 80.0 :
			animated_sprite.play("jumpmid")
		elif velocity.y > 80.0 :
			animated_sprite.play("jumpdown")

func wall_slide(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	if is_wall_sliding:
		velocity.y += (wall_gravity * delta)
		velocity.y = min(velocity.y, wall_gravity)

func jump():
	var direction: float = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
		elif is_on_wall():
			if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				velocity.y = jump_velocity
				velocity.x = -direction * wall_pushback
				
