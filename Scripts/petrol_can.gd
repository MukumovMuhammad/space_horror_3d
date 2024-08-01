extends Node3D

var full : bool = true
@onready var obj_equitble: Area3D = $obj_equitble
@onready var petrol_volue = 10.0
@onready var is_took : bool = false
@onready var obj_name := "petrol"

func took():
	is_took = true
	obj_equitble.equiped()
	#self.sleeping = false

func drop():
	is_took = false
	obj_equitble.dropped()
	#self.sleeping = true
