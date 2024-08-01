extends StaticBody3D

@export var display : StaticBody3D
var max_volume : float = 100.0
var current_volume : float = 0.0

func _ready() -> void:
	display.display_status(current_volume)


func Fill_container(volume : float):
	current_volume += volume
	display.display_status(current_volume)
	return current_volume
