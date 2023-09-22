extends Node2D
@onready var player = $Player
@onready var boxes_nodes = get_tree().get_nodes_in_group("boxes")
@onready var platforms_nodes = get_tree().get_nodes_in_group("Platform")
@onready var label = $Label

var numbers = []
var steps = []
var current_step = 0
var used_numbers : Array = []

func _ready():
	randomize()
	for i in range(boxes_nodes.size()):
		var unique_number = generate_unique_random()
		numbers.append(unique_number)
		boxes_nodes[i].number = unique_number
	#debug
	print(numbers)
	bubble_sort(numbers)
	
	#signal
	player.no_lifes.connect(analyse_step)
	next_step()

func _process(_delta):
	label.set_text("next step: " + str(current_step) + " - " + str(steps[current_step]))

func bubble_sort(arr):
	var n = arr.size()
	var swapped
	var temp_arr = []
	
	for item in arr:
		temp_arr.append(item)
	steps.append(temp_arr)
	temp_arr = []
	
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
		#n -= 1 -----otimização
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
	for n in range(1, platforms_nodes.size()):
		if not platforms_nodes[n].current_number == steps[current_step][n-1]:
			gameover()
			return
	print("Win!")
	next_step()

func gameover():
	print("Game over!")
	pass

func next_step():
	player.renew_life()
	if current_step < steps.size():
		current_step += 1
