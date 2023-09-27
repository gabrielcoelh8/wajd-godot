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
	#print(numbers)
	insertion_sort(numbers)
	
	#signal
	player.no_lifes.connect(analyse_step)
	next_step()

func _process(_delta):
	pass

func bubble_sort(arr):
	var n = arr.size()
	var swapped
	var temp_arr = []
	
	register_step(arr, temp_arr)
	temp_arr = []
	
	while swapped != false:
		swapped = false
		for i in range(1, n):
			if arr[i-1] > arr[i]:
				#debug
				print("swap: ", arr[i - 1]," -> ", arr[i])
				
				var temp = arr[i - 1]
				arr[i - 1] = arr[i]
				arr[i] = temp
				swapped = true
				
				# registrar cada passo
				register_step(arr, temp_arr)
				
				temp_arr = []
		#n -= 1 -----otimização

func selection_sort(arr):
	var temp_arr = []
	var n = arr.size()
	var pos_greatest
	var temp
	
	register_step(arr, temp_arr)
	temp_arr = []
	
	for i in range(n-1, 1, -1):
		pos_greatest = 0
		
		for j in range(i):
			if arr[j] > arr[pos_greatest]:
				pos_greatest = j
		temp = arr[i]
		arr[i] = arr[pos_greatest]
		arr[pos_greatest] = temp
		
		# registrar cada passo
		register_step(arr, temp_arr)
		temp_arr = []
		
	print(steps)

func insertion_sort(arr):
	#var temp_arr = []
	var n = arr.size()
	var temp
	var i
	
	#register_step(arr, temp_arr)
	#temp_arr = []
	
	for j in range(1, n):
		temp = arr[j]
		i = j - 1
		while i>=0 and arr[i]>temp:
			arr[i+1] = arr[i]
			i -= 1
			print("process: ", j, " - ", arr)
		arr[i+1] = temp
		print("process: ", j, " - ", arr)

func register_step(arr, temp_arr):
	for item in arr:
		temp_arr.append(item)
	steps.append(temp_arr)

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
	next_step()

func gameover():
	label.set_text("Game over!")
	pass

func next_step():
	if current_step < steps.size()-1:
		current_step += 1
		player.renew_life()
		label.set_text("help: " + str(current_step) + " -> " + str(steps[current_step]))
		return
	label.set_text("Win!")
