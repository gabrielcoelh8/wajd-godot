extends Area2D

@onready var player = get_node("../../Player")
@onready var area2d = get_node(".")
@onready var boxBody = get_node("RigidBody2D")

var drop_position
var picked = false
var dropping = false

func _physics_process(_delta):
	if picked:
		boxBody.position = player.marker.global_position
		boxBody.freeze = true
	if dropping:
		boxBody.position = drop_position
		dropping = false
		boxBody.freeze = false

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

func _on_body_entered(body):
	if body is Player:
		print("entrered by Player")

func _on_body_exited(body):
	if body is Player:
		print("exited by Player")
	
func _on_area_entered(area):
		#get drop_pos by marker of platform
	drop_position = area.drop_position
	print(drop_position)
	if picked == false:
		area.ocupada = true


