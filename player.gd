extends CharacterBody2D

@onready var animated_sprite = $Sprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -450.0
const GRAVITY = 1200.0
var coyote_timer = 0.0
const COYOTE_TIME = 0.12
var jumps_left = 2

func _physics_process(delta):
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jumps_left = 1
		elif coyote_timer > 0:
			velocity.y = JUMP_VELOCITY
			coyote_timer = 0
			jumps_left = 1
		elif jumps_left > 0:
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1

	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		animated_sprite.flip_h = direction < 0
	
	if not is_on_floor():
		animated_sprite.play("jump")
	elif direction != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
