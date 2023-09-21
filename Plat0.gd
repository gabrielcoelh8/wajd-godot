extends Area2D

@onready var dropzone = get_node("DropZone")
@onready var label = get_node("Label")
var box_number
var drop_position
var cont_overlaps = 0

func _ready():
	drop_position = dropzone.global_position
	label.set_text(str(box_number))

func _on_area_entered(area):
	#trackear quantas caixas estão na plataforma
	if not area.is_in_group("boxArea") or cont_overlaps>1:
		return
	
	cont_overlaps += 1

func _on_area_exited(area):
	if not area.is_in_group("boxArea") or cont_overlaps>1:
		return
	
	cont_overlaps -= 1
