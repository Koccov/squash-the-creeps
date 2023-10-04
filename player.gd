extends CharacterBody3D

## How fast the player moves [m/s]
@export var speed = 14
## Downward acceleration when in the air [m/s^2]
@export var fall_acceleration = 75
## vertical impulse when jumping [m/s]
@export var jump_impulse = 20

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	# create a local variable to store the input direction
	var direction = Vector3.ZERO
	
	# check for each move input and update the direction
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
	
	# ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# vertical velocity
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# jumping
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# move the character
	velocity = target_velocity
	move_and_slide()
