extends CharacterBody2D

@export var SPEED = 200.0
@export var JUMP_VELOCITY = -400.0
@export var JUMP_RELEASE_FORCE = -200
@export var ACCELERATION = 10
@export var FRICTION = 10
@export var ADD_FALL_GRAVITY = 4

# Get the gravity from the project settings to be synced with RigidBody nodes.
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	apply_gravity(delta)
	$AnimatedSprite2D.play()
		
	var input = Vector2.ZERO
	input.x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left') 
	#negative when moved from left
	
	if input.x == 0:
		apply_friction()
		$AnimatedSprite2D.animation = "idle"
	else:
		apply_acceleration(input.x)
		$AnimatedSprite2D.animation = "run"
		if(input.x < 0):
			$AnimatedSprite2D.flip_h = true
		elif(input.x > 0):
			$AnimatedSprite2D.flip_h = false
	
	# Handle Jump.
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
			#aplicar força de salto
	else:
		$AnimatedSprite2D.animation = "jump"
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE: 
			#final do salto logo após parar de saltar
			velocity.y = JUMP_RELEASE_FORCE
		if velocity.y > 0:
			velocity.y += ADD_FALL_GRAVITY 
			#gravidade adicional ao começar queda livre

	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, SPEED * amount, ACCELERATION)
