extends Node3D

@onready var anim = $AnimationPlayer

@onready var bullet = load("res://Scenes/Player_Obj/bullet.tscn")
@onready var bullet_pos = $bullet_pos

@export var Parent : Node

func press_btn():
	if not anim.is_playing():
		anim.play("fire")
		var instance_bullet = bullet.instantiate()
		#instance_bullet.transform = bullet_pos.global_transform
		instance_bullet.rotation = bullet_pos.global_rotation
		instance_bullet.position = bullet_pos.global_position
		
		Parent.get_parent().add_child(instance_bullet)
		#instance_bullet.set_velocity(bullet_pos)


func take_away():
	anim.play_backwards("get_weapon")

func get_obj():
	anim.play("get_weapon")
