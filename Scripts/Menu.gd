extends Node2D

func _on_normal_pressed():
	get_tree().change_scene_to_file("res://scenes/World.tscn")

func _on_sair_pressed():
	get_tree().quit()
