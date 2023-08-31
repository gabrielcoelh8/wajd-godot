extends RigidBody2D

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_body_entered(body):
	if body is Player:
		print(body.name)
