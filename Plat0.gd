extends Area2D

@onready var dropzone = get_node("DropZone")
@onready var label = get_node("Label")
var drop_position
var is_occupied = false

func _ready():
	drop_position = dropzone.global_position
	label.set_text(str(is_occupied))

func _on_area_entered(area):
	if area.is_in_group("boxArea"):
		is_occupied = true
		label.set_text(str(is_occupied))

func _on_area_exited(area):
	if area.is_in_group("boxArea"):
		is_occupied = false
		label.set_text(str(is_occupied))
