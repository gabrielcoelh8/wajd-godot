extends CharacterBody2D
class_name Player

@export_category('SCRIPT')
signal no_lifes
signal lose_life(current_life, previous_life)
signal renew_hearts

@export var SPEED = 200.0
@export var JUMP_VELOCITY = -500.0
@onready var JUMP_RELEASE_FORCE = -200
@onready var ACCELERATION = 10
@onready var FRICTION = 30
@onready var ADD_FALL_GRAVITY = 4

@onready var canPick = true
@onready var isDrowning = false
@onready var lifes = 6

@onready var text = $RichTextLabel
@onready var marker = $Marker2D
@onready var animatedSprite = $AnimatedSprite2D
@onready var boxEquipSound = $BoxEquip
@onready var boxEquipDrop = $BoxDrop
@onready var footstepSound = $Footstep

#onready - só declara após o node estar carregado

# Get the gravity from the project settings to be synced with RigidBody nodes.
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animatedSprite.sprite_frames = load("res://sprites/animation/playerBeige.tres")
	#setar spriteframes (permite mudar os frames do objeto)

func _process(_delta):
	if lifes == 0:
		emit_signal("no_lifes")
	
	if isDrowning:
		velocity.x = 1
		velocity.y = 1
		
	text.text = "[shake rate=5 level=10]lifes: "+ str(lifes) +"[/shake]"

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
		footstepSound.stream_paused = true
	else:
		apply_acceleration(input.x)
		animatedSprite.animation = "run"
		
		if is_on_floor() and not isDrowning:
			footstepSound.stream_paused = false
		
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

func loss_life_handle():
	if lifes == 0:
		return
	
	lifes -= 1
	var previous_life = lifes+1 
	emit_signal("lose_life", lifes, previous_life)

func renew_life():
	emit_signal("renew_hearts")
	lifes = 6

func onPick():
	canPick = false
	boxEquipSound.play()

func onDrop():
	canPick = true
	boxEquipDrop.play()

func apply_gravity(delta):
	if not is_on_floor() and not isDrowning:
		velocity.y += GRAVITY * delta

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, SPEED * amount, ACCELERATION)

func drowing():
	isDrowning = true
	print("drowing in ma dreams")
