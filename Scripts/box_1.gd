extends RigidBody2D

var picked = false
@onready var player = get_node("../Player")
@onready var label = get_node("Label")

func _physics_process(_delta):
	if picked:
		self.position = player.marker.global_position

func _input(_event):
	if Input.is_action_just_pressed("ui_pick"):
		var bodies = $Area2D.get_overlapping_bodies()
		for body in bodies:
			if body is Player and player.canPick == true:
				picked = true
				player.canPick = false
	if Input.is_action_just_pressed("ui_drop") and picked == true:
		picked = false
		print("droping...")
		print(player.sprite.flip_h)
		player.canPick = true
