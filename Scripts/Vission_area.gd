extends Node3D
var see : bool = false

signal bodies_count(bodies : int)
@export var parent : CharacterBody3D
@onready var ray : RayCast3D = $RayCast3D
var Player
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	print_debug("parent rot " , parent.global_rotation_degrees)
	print_debug("raycast rot ", ray.global_rotation_degrees)

"""
func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	bodies_count.emit(bodies.size())
	#if bodies.size() > 0:
	for body in bodies:
		ray.look_at(body.global_position)
		if body.is_in_group("Player") and is_in_range():
			if ray.is_colliding() and ray.get_collider().is_in_group("Player"):
				see = true
				#print_debug("Just saw a Player")
			else:
				see = false
				#print_debug("Didn't see a Player")
		elif see:
			see = false
	#else:
	#	see = false
	parent.see = see

"""


func _process(delta):
	ray.look_at(parent.player.global_position)
	if is_in_range():
		if ray.is_colliding() and ray.get_collider().is_in_group("Player"):
			see = true
			#print_debug("Just saw a Player")
		else:
			see = false
			#print_debug("Didn't see a Player")
	elif see:
		see = false
	
	parent.see = see

func is_in_range():
	var ray_rot = ray.global_rotation
	var parent_rot = parent.global_rotation
	if ray_rot.y < parent_rot.y + deg_to_rad(100) and ray_rot.y > parent_rot.y - deg_to_rad(100):
		return true
	return false
