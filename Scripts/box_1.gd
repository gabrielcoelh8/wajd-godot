extends RigidBody2D

@onready var player = get_node("../../Player")
@onready var label = get_node("Label")
var number : int
var picking = false
var dropping = false
var player_is_inside = false
var drop_position : Vector2
var current_area

func _process(_delta):
	label.set_text(str(number))

func _physics_process(_delta):
	if picking:
		self.position = player.marker.global_position
		self.freeze = true
	if dropping:
		self.position = current_area.drop_position
		self.freeze = false
		dropping = false

func _input(_event):
	#restrições
	if current_area == null or not player_is_inside or current_area.cont_overlaps > 1:
		return
	
	#input listeners
	if Input.is_action_just_pressed("ui_pick") and player.canPick == true:
		player.lifes -= 1
		picking = true
		player.canPick = false
	
	if Input.is_action_just_pressed("ui_drop") and picking == true:
		player.lifes -= 1
		picking = false
		dropping = true
		player.canPick = true

#platform/area2D signals
func _on_area_2d_area_entered(area):
	if not area.is_in_group("Platform"):
		return
	#get drop_pos by marker of platform/area2D
	current_area = area
	area.box_number = self.number

func _on_area_2d_area_exited(area):
	if not area.is_in_group("Platform"):
		return
	area.box_number = 0
	current_area = null

#player/area2D signals
func _on_area_2d_body_entered(body):
	if body is Player:
		player_is_inside = true

func _on_area_2d_body_exited(body):
	if body is Player:
		player_is_inside = false



