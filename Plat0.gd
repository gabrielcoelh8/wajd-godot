extends Area2D

@onready var dropzone = get_node("DropZone")
var drop_position

func _ready():
	drop_position = dropzone.global_position
