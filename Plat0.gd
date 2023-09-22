extends Area2D
@onready var player = get_node("../../Player")
@onready var dropzone = get_node("DropZone")
@onready var label = get_node("Label")
var drop_position

var current_number
var is_occupied = false

func _ready():
	drop_position = dropzone.global_position

func _process(_delta):
	label.set_text(str(current_number))
