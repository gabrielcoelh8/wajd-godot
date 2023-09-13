extends Node2D
@onready var Box1Label = get_node("Box1/Label")
@onready var numbers = [1, 2, 3, 4, 5]
@onready var lastnumber

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var boxes_numbers = []
	var boxes_nodes = get_tree().get_nodes_in_group("boxes")
	
	for i in range(boxes_nodes.size()):
		boxes_numbers.append(get_random_number())
		boxes_nodes[i].label.set_text(str(boxes_numbers[i]))
		
	#boxes_numbers.sort_custom(bubblesort)
	print(boxes_numbers)
	#Box1Label.set_text(str(boxes_numbers[0]))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func bubblesort(a, b):
	if a[0] < b[0]:
		return true
	return false
	
func get_random_number():
	var random_number = numbers[randi() % numbers.size()]
	while random_number == lastnumber:
		# The last fruit was picked, try again until we get a different fruit.
		random_number = numbers[randi() % numbers.size()]

	# Note: if the random element to pick is passed by reference,
	# such as an array or dictionary,
	# use `_last_fruit = random_fruit.duplicate()` instead.
	lastnumber = random_number

	# Returns "apple", "orange", "pear", or "banana" every time the code runs.
	# The function will never return the same fruit more than once in a row.
	return random_number
