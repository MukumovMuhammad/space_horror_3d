extends Area3D


# Change this code later so as a 

@onready var coll = $CollisionShape3D

func _on_player_set_movement_state(state : movement_state):
	coll.shape.radius = state.noise_radius





func _on_player_set_direction(dir):
	if dir:
		make_noise()



func make_noise():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("noise_listener"):
			body.detect_sound(get_parent().global_position)
