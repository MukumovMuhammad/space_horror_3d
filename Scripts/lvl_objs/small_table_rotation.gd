extends StaticBody3D


@export var obj_to_rotate : MeshInstance3D
@export var rot_speed : float = 2.0
var time : float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	obj_to_rotate.rotate_y(delta * rot_speed)
	time += delta * rot_speed
	obj_to_rotate.position.y = sin(time * 1.0) * 0.1 + 0.2
