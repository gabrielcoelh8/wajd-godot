extends RigidBody2D

@onready var player = get_node("../../Player")
@onready var label = get_node("Label")

var picked = false
var dropping = false
var on_ground = true
var player_is_inside = false
var drop_position : Vector2

func _physics_process(_delta):
	if picked:
		self.position = player.marker.global_position
		self.freeze = true
	if dropping:
		self.position = drop_position
		self.freeze = false
		dropping = false

func _input(_event):
	if Input.is_action_just_pressed("ui_pick") and player_is_inside and player.canPick == true:
		on_ground = false
		picked = true
		player.canPick = false
	
	if Input.is_action_just_pressed("ui_drop") and player_is_inside and picked == true:
		on_ground = true
		picked = false
		dropping = true
		player.canPick = true

func _on_area_2d_area_entered(area):
	#get drop_pos by marker of platform
	drop_position = area.drop_position

func _on_area_2d_body_entered(body):
	if body is Player:
		player_is_inside = true

func _on_area_2d_body_exited(body):
	if body is Player:
		player_is_inside = false
