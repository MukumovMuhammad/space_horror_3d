extends Node3D
@onready var the_light : SpotLight3D = $MeshInstance3D/SpotLight3D

var on : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer





func press_btn():
	on = !on
	if on:
		the_light.show()
	else:
		the_light.hide()


func get_obj():
	animation_player.play("get_obj")
	the_light.hide()


func take_away():
	animation_player.play_backwards("get_obj")
	the_light.hide()
