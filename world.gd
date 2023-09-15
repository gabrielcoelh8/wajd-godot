extends Node2D
@onready var Box1Label = get_node("Box1/Label")
@onready var boxes_nodes = get_tree().get_nodes_in_group("boxes")
@onready var numbers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	for i in range(boxes_nodes.size()):
		var unique_number = generate_unique_random()
		numbers.append(unique_number)
		boxes_nodes[i].label.set_text(str(unique_number))
	
	print(numbers)

func bubblesort(a, b):
	if a[0] < b[0]:
		return true
	return false
	
	
func bubble_sort(arr):
	var n = arr.size()
	var swapped = false
	
	for i in range(n-1):
		swapped = false
		for j in range(n-1-i):
			if arr[j] > arr[j+1]:
				arr.swap(j, j+1)
				swapped = true
		if not swapped:
			break

var used_numbers : Array = []
func generate_unique_random():
	var random_number = -1
	while true:
		random_number = randi_range(1, 5)
		if used_numbers.find(random_number) == -1:
			used_numbers.append(random_number)
			break
	return random_number
