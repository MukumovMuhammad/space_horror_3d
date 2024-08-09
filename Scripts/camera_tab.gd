extends Node3D
#@onready var anim: AnimationPlayer = $AnimationPlayer
#
#@onready var sprite_3d: Sprite3D = $screen/Sprite3D
#@onready var player: CharacterBody3D = $"../../../.."
#@onready var camera_view: TextureRect = $"../../../../HUD/CanvasLayer/CameraTab"
#
##-- camera tab's vars --#
#var took_camera : bool = false
#var cur_camera: int = 0
#
#func _ready() -> void:
	#camera_view.texture.viewport_path = player.Camera_Subs[cur_camera]
	#camera_view.hide()
#
#
#func press_btn():
	#cur_camera += 1
	#if cur_camera > player.Camera_Subs.size() - 1:
		#cur_camera = 0
	#camera_view.texture.viewport_path = player.Camera_Subs[cur_camera]
#
#func get_obj():
	#anim.play("getting")
	#await get_tree().create_timer(0.6).timeout
	#camera_view.show()
	#
#
#func take_away():
	#camera_view.hide()	
	#anim.play_backwards("getting")
