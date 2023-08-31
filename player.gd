extends CharacterBody2D
class_name Player

@export_category('SCRIPT')
@export var SPEED = 200.0
@export var JUMP_VELOCITY = -500.0
@export var JUMP_RELEASE_FORCE = -200
@export var ACCELERATION = 10
@export var FRICTION = 10
@export var ADD_FALL_GRAVITY = 4

# Get the gravity from the project settings to be synced with RigidBody nodes.
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animatedSprite = $AnimatedSprite2D #só declara após o node estar carregado

func _ready():
	animatedSprite.sprite_frames = load("res://playerBeige.tres") 
	#setar spriteframes (permite mudar os frames do objeto)

func _physics_process(delta):
	# aplica gravidade por delta
	apply_gravity(delta)
	
	var input = Vector2.ZERO
	input.x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left') 
	#negativo ao mover para esquerda
	
	if input.x == 0:
		apply_friction()
		#resistência física
		animatedSprite.animation = "idle"
	else:
		apply_acceleration(input.x)
		animatedSprite.animation = "run"
		if(input.x < 0):
			animatedSprite.flip_h = true
		elif(input.x > 0):
			animatedSprite.flip_h = false
	
	# Handle Jump.
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
			#aplicar força de salto
	else:
		animatedSprite.animation = "jump"
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE: 
			velocity.y = JUMP_RELEASE_FORCE
			#final do salto mais lento logo após salto primario
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
