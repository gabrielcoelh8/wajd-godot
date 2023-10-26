extends Node2D
signal time_end
signal lucky

@onready var player = $Player
@onready var boxes_nodes = get_tree().get_nodes_in_group("boxes")
@onready var platforms_nodes = get_tree().get_nodes_in_group("Platform")
@onready var helpLabel = $Help
@onready var timerLabel = $TimerLabel
@onready var timerSound = $TimerSound
@onready var drownSound = $DrownSound
@onready var coinSound = $CoinSound
@onready var sucessSound = $SucessAudio
@onready var coinLabel = $CoinControl/HBoxContainer/StepLabel
@onready var waterShader = $WaterShader
@onready var animPlayer = $AnimationPlayer

var numbers = []
#testes
var test_bestcase = [1, 2, 3, 4, 5]
var test_worsecase = [5, 4, 3, 2, 1]
#######
var steps = []
var current_step = 0
var used_numbers : Array = []
var default_time = 60
var time = default_time
var punished_time = 5.0
var coins = 0
var final_time
var sort_type

func _ready():
	randomize()
	get_tree().paused = true
	
	for i in range(boxes_nodes.size()):
		var unique_number = generate_unique_random()
		numbers.append(unique_number)
		boxes_nodes[i].number = unique_number
	
	#signal
	player.no_lifes.connect(no_lifes_handle)
	time_end.connect(end_time_handle)
	lucky.connect(lucky_handler)
	
	show_dialogue(load("res://dialogue/main.dialogue"), "choice")
	await DialogueManager.dialogue_ended
	sort_type = Globals.sort_type
	get_tree().paused = false
	
	#switch
	match sort_type:
		"bubble_sort":
			bubble_sort(numbers)
		"selection_sort":
			selection_sort(numbers)
		"shaker_sort":
			shaker_sort(numbers)
	
	if(steps.size() <= 2):
		lucky.emit()
	else:
		next_step()
		timerLabel.visible = true
		timerSound.play()
		helpLabel.set_text(str(steps[current_step]))

func _process(delta):
	if(not get_tree().paused) and time > 0:
		time -= delta
	
	if time <= 0.00:
		time = clamp(time, 0.00, 30.0)
		time_end.emit()
	
	coinLabel.set_text(str(coins))
	timerLabel.set_text(str(snapped(time, 0.01)))

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_help") and helpLabel.visible == false:
		time -= punished_time
		show_dialogue(load("res://dialogue/main.dialogue"), "help")
		helpLabel.visible = true
		await get_tree().create_timer(10.0).timeout
		helpLabel.visible = false
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
	var pivot
	var temp
	
	register_step(arr, temp_arr)
	print("original: ", temp_arr)
	temp_arr = []
	
	for i in range(n-1, 1, -1):
		pivot = 0
		
		for j in range(i):
			if arr[j] > arr[pivot]:
				pivot = j
		temp = arr[i]
		arr[i] = arr[pivot]
		arr[pivot] = temp
		
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

func no_lifes_handle():
	if analyse_step():
		coins += 1
		coinSound.play()
		next_step()
	else:
		gameover(false)

func end_time_handle():
	gameover(false)

func analyse_step():
	for n in range(1, platforms_nodes.size()):
		if not platforms_nodes[n].current_number == steps[current_step][n-1]:
			return false
	return true

func gameover(win_verify):
	Globals.win_verify = win_verify
	Globals.last_final_time = time
	Globals.last_coins = coins
	Globals.last_time = time
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/Gameover.tscn")

func next_step():
	if current_step < steps.size()-1:
		current_step += 1
		time = default_time
		player.renew_life()
		helpLabel.set_text(str(steps[current_step]))
	else:
		gameover(true)

func _on_drowing_area_body_entered(body: Player):
	#if body is Player:
	drownSound.play(3.0)
	animPlayer.play("death_anim")
	waterShader.visible = true
	body.drowing()
	await get_tree().create_timer(1.0).timeout
	gameover(false)

func _on_death_area_body_entered(_body: Player):
	gameover(false)

func lucky_handler():
	get_tree().paused = true
	sucessSound.play()
	show_dialogue(load("res://dialogue/main.dialogue"), "lucky")
	await DialogueManager.dialogue_ended
	coinSound.play()
	coins = 10
	Globals.win_verify = true
	Globals.last_final_time = 0.00
	Globals.last_coins = coins
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/Gameover.tscn")
	get_tree().paused = false

func show_dialogue(resource: DialogueResource, title: String = "0", extra_game_states: Array = []) -> void:
	var ExampleBalloonScene = load("res://dialogue/visual_novel_balloon/visual_novel_balloon.tscn")
	var balloon: Node = ExampleBalloonScene.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(resource, title, extra_game_states)
