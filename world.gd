extends Node2D
@onready var boxes_nodes = get_tree().get_nodes_in_group("boxes")
@onready var label = $Label
var numbers = []
var steps = []
var current_step = 1
var used_numbers : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	for i in range(boxes_nodes.size()):
		var unique_number = generate_unique_random()
		numbers.append(unique_number)
		boxes_nodes[i].label.set_text(str(unique_number))
	
	print(numbers)
	bubble_sort(numbers)

func _process(_delta):
	label.set_text("step: " + str(current_step) + " - " + str(steps[current_step]))

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
								# registrar cada passo
				for x in range(n):
					temp_arr.append(numbers[x])
				steps.append(temp_arr)
				
				var temp = arr[i - 1]
				arr[i - 1] = arr[i]
				arr[i] = temp
				swapped = true
				
				temp_arr = []
				
				print(numbers)
		#n -= 1
	print(steps)

func generate_unique_random():
	var random_number = -1
	while true:
		random_number = randi_range(1, 5)
		if used_numbers.find(random_number) == -1:
			used_numbers.append(random_number)
			break
	return random_number

func analyse_step():
	return true

func next_step():
	if current_step < steps.size():
		current_step += 1
