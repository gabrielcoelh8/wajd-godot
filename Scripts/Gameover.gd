extends Node2D
@onready var result = $Result
@onready var coinLabel = $CoinControl/StepLabel

func _ready():
	#var time = snapped(Globals.last_final_time, 0.01)
	var result_text : String
	var coins = Globals.last_coins
	
	coinLabel.set_text(str(coins))
	
	if Globals.win_verify:
		result_text = "[center]Vitória[/center]" 
	else: 
		result_text = "[center]Derrota[/center]"
		
	result.set_text("[shake rate=5 level=10]" + result_text +"[/shake]")

func _on_continuar_pressed():
	get_tree().change_scene_to_file("res://scenes/World.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
