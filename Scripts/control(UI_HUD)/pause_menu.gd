extends Control

#lets think again that here is written something
var pause : bool = false

@onready var pause_panel = $CanvasLayer/pause_panel


func _ready():
	pause_panel.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta):
	if Input.is_action_just_pressed("ESC"):
		pause = !pause
		get_tree().paused = pause
		if pause:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
			pause_panel.show()
		else:
			pause_panel.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _on_continue_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_panel.hide()
	get_tree().paused = false


func _on_exit_pressed(): #exit to menu
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
