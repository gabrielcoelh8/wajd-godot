extends RigidBody2D

@onready var player = get_node("../../Player")
@onready var label = get_node("Label")
var number : int

var on_air = false
var dropping = false

var player_is_inside = false
#var drop_position : Vector2
var current_area

func _ready():
	pass

func _process(_delta):
	label.set_text(str(number))

func _physics_process(_delta):
	if on_air:
		self.position = player.marker.global_position
		self.freeze = true
	if dropping:
		self.position = current_area.drop_position
		self.freeze = false
		dropping = false

func _input(_event):
	#restrições
	if not current_area:
		return
	#input listeners
	if Input.is_action_just_pressed("ui_pick") and player.canPick and player_is_inside:
		pick_handle()
		player.onPick()
	
	if Input.is_action_just_pressed("ui_drop") and on_air == true and current_area.is_occupied == false:
		drop_handle()
		player.onDrop()

func pick_handle():
	current_area.current_number = null
	current_area.is_occupied = false
	player.loss_life_handle()
	on_air = true

func drop_handle():
	current_area.is_occupied = true
	current_area.current_number = number
	player.loss_life_handle()
	on_air = false
	dropping = true

func _on_player_entered(body):
	if body is Player:
		#body.toggle_canPick()
		player_is_inside = true

func _on_player_exited(body):
	if body is Player:
		#body.toggle_canPick()
		player_is_inside = false

func _on_inside_platform(area):
	#print(area.is_occupied)
	if not area.is_in_group("Platform") or area.is_occupied:
		return
	#get current area
	current_area = area
	#on create
	if player_is_inside == false:
		current_area.current_number = number
		current_area.is_occupied = true

func _on_exit_platform(area):
	if not area.is_in_group("Platform") or area.is_occupied:
		#print("ocupada")
		return
	#get area by marker of platform/area2D
	current_area = null
