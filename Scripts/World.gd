extends Node2D
@onready var player = $Player
@onready var boxes_nodes = get_tree().get_nodes_in_group("boxes")
@onready var platforms_nodes = get_tree().get_nodes_in_group("Platform")
@onready var label = $Help
@onready var timerLabel = $TimerLabel

var numbers = []
var steps = []
var current_step = 0
var used_numbers : Array = []
var time = 0.0
var final_time

func _ready():
	randomize()
	get_tree().paused = false
	
	for i in range(boxes_nodes.size()):
		var unique_number = generate_unique_random()
		numbers.append(unique_number)
		boxes_nodes[i].number = unique_number
	
	#signal
	player.no_lifes.connect(analyse_step)
	
	#debug
	#selection_sort, bubble_sort, shaker_sort
	shaker_sort(numbers)
	next_step()
	
	label.set_text("help: " + str(current_step) + " -> " + str(steps[current_step]))

func _process(delta):
	time += delta
	timerLabel.set_text(str(snapped(time, 0.01)))

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_help"):
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"), "start")
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = not get_tree().paused
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()

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
	print("original: ", temp_arr)
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

func shaker_sort(arr):
	var temp_arr = []
	var n = arr.size()
	var temp
	var swap: bool
	
	register_step(arr, temp_arr)
	print("original: ", temp_arr)
	temp_arr = []
	
	swap = true
	while(swap):
		swap = false
		#left-right
		for i in range(n-1):
			if arr[i] > arr[i+1]:
				temp = arr[i]
				arr[i] = arr[i + 1]
				arr[i + 1] = temp
				swap = true
				
				register_step(arr, temp_arr)
				temp_arr = []
		if not swap:
			break
		swap = false
		#right-left
		for i in range(n-2, 0, -1):
			if arr[i] > arr[i+1]:
				temp = arr[i]
				arr[i] = arr[i+1]
				arr[i+1] = temp
				swap = true
				
				register_step(arr, temp_arr)
				temp_arr = []
		
		print("steps: ", steps)

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
			return
	next_step()

func gameover():
	Globals.last_final_time = time
	label.set_text("Game over!")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/Gameover.tscn")

func next_step():
	if current_step < steps.size()-1:
		current_step += 1
		player.renew_life()
		label.set_text("help: " + str(current_step) + " -> " + str(steps[current_step]))
		return
	label.set_text("Win!")

func _on_player_no_lifes():
	gameover()
