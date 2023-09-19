extends RigidBody2D

@onready var player = get_node("../../../Player")
@onready var area2d = get_node("../../Area2D")
@onready var label = get_node("Label")
var drop_position
var picked = false
var dropping = false

func _physics_process(_delta):
	if picked:
		self.position = player.marker.global_position
		self.freeze = true
	if dropping:
		self.position = drop_position
		dropping = false
		self.freeze = false

func _input(_event):
	var bodies = area2d.get_overlapping_bodies()
	
	if Input.is_action_just_pressed("ui_pick"):
		for body in bodies:
			if body is Player and player.canPick == true:
				picked = true
				player.canPick = false
	
	if Input.is_action_just_pressed("ui_drop") and picked == true:
		picked = false
		dropping = true
		player.canPick = true

func _on_area_2d_area_entered(area):
	#get drop_pos by marker of platform
	drop_position = area.drop_position
	
	if picked == false:
		area.ocupada = true
