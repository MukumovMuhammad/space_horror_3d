extends Area3D

@export var parent : Node
@export var i_name := "petrol";
@export var the_key := "F";


func equiped():
	self.monitorable = false
	set_collision_layer_value(2, false)
func dropped():
	self.monitorable = true
	set_collision_layer_value(2, true)
