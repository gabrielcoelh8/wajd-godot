extends RigidBody2D

var picked = false
@onready var player = get_node("../Player")
@onready var label = get_node("Label")
var drop_position

func _physics_process(_delta):
	if picked:
		self.position = player.marker.global_position
		
	if Input.is_action_just_pressed("ui_drop") and picked == true:
		picked = false
		player.canPick = true
		self.global_position = lerp(self.global_position, drop_position, 10 * _delta)
		self.rotation = lerp_angle(rotation, 0, 10 * _delta)

func _input(_event):
	var bodies = $Area2D.get_overlapping_bodies()
	if Input.is_action_just_pressed("ui_pick"):
		for body in bodies:
			if body is Player and player.canPick == true:
				picked = true
				player.canPick = false
	
		#picked = false
		#print(player.sprite.flip_h)
		#player.canPick = true

func _on_area_2d_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	print(body)

func _on_area_2d_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	#get postion of dropzone on overlap
	print(area.is_in_group("Platform"))
	drop_position = area.get_node("DropZone").global_position
	print(drop_position)
