extends Area3D


@export var spy_pos : Marker3D
@export var spy_cam_rot : Marker3D
@export var i_name : String = "spy from the corner"

@export_enum("corner", "key_hole") var spy_mode : int

enum spy_modes {
	CORNER,
	KEY_HOLE
}


func spy(player):
	if spy_mode == spy_modes.CORNER:
		player.spy_corner(spy_pos.global_position, spy_cam_rot.global_rotation) # first pos then rotation
	elif spy_mode == spy_modes.KEY_HOLE:
		pass
