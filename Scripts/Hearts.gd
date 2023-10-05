extends Node2D

@onready var hearts = get_tree().get_nodes_in_group("hearts")

func _on_player_lose_life(_current_life, previous_life):
	var heartIndex = roundi(previous_life / 2.0) - 1 
	var isHalfHeart:bool = previous_life % 2 == 1
	
	if (isHalfHeart):
		hearts[heartIndex].play("full_loss")
	else:
		hearts[heartIndex].play("mid_loss")

func _on_player_renew_hearts():
	for heart in hearts:
		heart.play("reset")
