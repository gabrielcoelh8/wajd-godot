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
	bubble_sort(numbers)

var steps = []
func bubble_sort(arr):
	var n = arr.size()
	var swapped
	var temp_arr = []
	while swapped != false:
		swapped = false
		
		for i in range(1, n):
			if arr[i-1] > arr[i]:
				#debug
				print("swap: ",arr[i - 1]," -> ", arr[i])
				
				var temp = arr[i - 1]
				arr[i - 1] = arr[i]
				arr[i] = temp
				swapped = true
				
				# registrar cada passo
				for x in range(n):
					temp_arr.append(numbers[x])
				steps.append(temp_arr)
				temp_arr = []
				
				print(numbers)
		#n -= 1
	print(steps)

var used_numbers : Array = []
func generate_unique_random():
	var random_number = -1
	while true:
		random_number = randi_range(1, 5)
		if used_numbers.find(random_number) == -1:
			used_numbers.append(random_number)
			break
	return random_number
