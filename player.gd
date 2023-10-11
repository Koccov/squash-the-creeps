extends CharacterBody3D

## How fast the player moves [m/s]
@export var speed = 14
## Downward acceleration when in the air [m/s^2]
@export var fall_acceleration = 75
## vertical impulse when jumping [m/s]
@export var jump_impulse = 20
## vertical impulse on bounce over a mob [m/s]
@export var bounce_impulse = 16

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
	
	# iterate through all collision this frame
	for index in range(get_slide_collision_count()):
		# get one of the collisions
		var collision = get_slide_collision(index)
		
		# if collision with ground
		if (collision.get_collider() == null):
			continue
		
		# if collision with mob
		if (collision.get_collider().is_in_group("mob")):
			var mob = collision.get_collider()
			# check if hit from above
			if Vector3.UP.dot(collision.get_normal()) > 0.5:
				# squash and bounce
				mob.squash()
				target_velocity.y = bounce_impulse
	
	# move the character
	velocity = target_velocity
	move_and_slide()
