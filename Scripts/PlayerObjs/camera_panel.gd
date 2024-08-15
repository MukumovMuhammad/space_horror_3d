extends CanvasLayer

@onready var password_edit: TextEdit = $password_edit
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var camera_tab: TextureRect = $CameraTab

@export var player: CharacterBody3D
var password_is_unlocked : bool


var cur_camera : int = 0 # for indicating curent camera


func _ready() -> void:
	camera_tab.visible = false
	var cur_camera = 1
	password_is_unlocked = false
	camera_tab.texture.viewport_path = "../../" + str(player.Camera_Subs[cur_camera])

func open_computer():
	self.visible = true
	anim.play("opening")
	camera_tab.texture.viewport_path =   "../../" + str(player.Camera_Subs[cur_camera])



func next_cam():
	cur_camera += 1
	if cur_camera > player.Camera_Subs.size() - 1:
		cur_camera = 0
	camera_tab.texture.viewport_path =  "../../" + str(player.Camera_Subs[cur_camera])

func prev_cam():
	cur_camera -= 1
	if cur_camera < 0:
		cur_camera = player.Camera_Subs.size() - 1
	camera_tab.texture.viewport_path =  "../../" + str(player.Camera_Subs[cur_camera])



func _on_submit_pressed() -> void:
	if password_edit.text == "PassWord":
		password_is_unlocked = true
		$submit/Label.add_theme_color_override("font_color",Color.GREEN)
		$submit/Label.text = "Correct!"
		await get_tree().create_timer(0.5).timeout
		$submit/Label.text = ""
		anim.play_backwards("opening")
		await get_tree().create_timer(0.6).timeout
		anim.play("unlocked")
		#camera_tab.texture.viewport_path = player.Camera_Subs[cur_camera]
	else:
		$submit/Label.add_theme_color_override("font_color",Color.RED)
		password_edit.text = ""
		$submit/Label.text = "Incorrect password"



func _on_exit_pressed() -> void:
	if password_is_unlocked:
		anim.play_backwards("unlocked")
	else:
		anim.play_backwards("opening")
	
	player.default_movement()
	self.hide()
	#await get_tree().create_timer(0.6).timeout
	#get_tree().quit()





func _on_password_edit_text_changed() -> void:
	$submit/Label.text = ""


func _on_next_btn_pressed():
	next_cam()


func _on_prev_btn_pressed():
	prev_cam()
