extends Node2D
@onready var label = $Label

func _ready():
	var time = snapped(Globals.last_final_time, 0.01)
	label.set_text("Tempo: "+ str(time) + " sec.")

func _on_continuar_pressed():
	get_tree().change_scene_to_file("res://scenes/World.tscn")

func _on_tutorial_pressed():
	pass # Replace with function body.

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
