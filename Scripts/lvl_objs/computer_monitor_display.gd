extends StaticBody3D
@onready var label_3d: Label3D = $Label3D


func display_status(value : int):
	label_3d.text = str(value) + "%"
