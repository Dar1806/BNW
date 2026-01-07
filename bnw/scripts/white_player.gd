extends CharacterBody2D

@export var speed: float = 250.0
@export var accel_smooth: float = 8.0
@export var friction_smooth: float = 25.0
@export var jump_velocity: float = -320.0

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

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

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
	else:
		if velocity.y < -80.0:
			animated_sprite.play("jumpup")
		elif velocity.y > -80.0 && velocity.y < 80.0 :
			animated_sprite.play("jumpmid")
		elif velocity.y > 80.0 :
			animated_sprite.play("jumpdown")
