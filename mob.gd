extends CharacterBody3D

## Minimum speed of the mob [m/s]
@export var min_speed = 10
## Maximum speed of the mob [m/s]
@export var max_speed = 18

signal squashed

func _physics_process(delta):
	move_and_slide()

## to call from the Main scene
func initialize(start_position, player_position):
	# position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player
	look_at_from_position(start_position, player_position, Vector3.UP)
	
	# rotate randomly between -90 and 90 degrees
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# calculate random speed
	var random_speed = randi_range(min_speed, max_speed)
	# calculate a forward velocity that represents the speed
	velocity = Vector3.FORWARD * random_speed
	# rotate velocity vector to align with Mob's look direction
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	# animation speed
	$AnimationPlayer.speed_scale = random_speed / min_speed


func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func squash():
	squashed.emit()
	queue_free()
