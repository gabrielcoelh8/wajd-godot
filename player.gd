extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var input = Vector2.ZERO
	input.x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
	#negative when moved from left
	
	if input.x == 0:
		apply_friction()
	else:
		apply_acceleration(input.x)

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var direction = Input.get_axis("ui_left", "ui_right")
	# if direction:
	#	velocity.x = direction * SPEED
	# else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, 10)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, 50 * amount, SPEED)
	
	
