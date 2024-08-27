extends StaticBody3D

@onready var is_on : bool = true
@onready var i_name : String = "switch electricity"


func switch_ebox():
	if is_on:
		is_on = false
	else:
		is_on = true
	set_electricity(is_on)
		


func set_electricity(on: bool):
	for i in get_children():
		if i.is_in_group("electrical"):
			#var the_path =  electronics.get_child(i).get_path()
			#the_path = str(the_path) + "/e_component"
			#print("The path of electrical component is \n ", the_path, "\n\n")
			i.get_node("e_component").emit_signal("set_electricity", on)
