extends StaticBody3D
@export var anim: AnimationPlayer
@onready var text: Label3D = $part1/text
@onready var btn: MeshInstance3D = $part1/btn
@onready var text_2: Label3D = $part1/text2

var close_color : Color = Color(0.744, 0.296, 0.226)
var open_color : Color = Color(0, 0.522, 0.361)
@onready var i_name = "door"

func _ready() -> void:
	btn.material_override = StandardMaterial3D.new()
	btn.material_override.albedo_color = open_color
	close_door()

func open_door():
	btn.material_override.albedo_color = open_color
	text.text = "open"
	text_2.text = "open"
	anim.play("open")
	await get_tree().create_timer(2).timeout
	close_door()


func close_door():
	anim.play_backwards("open")
	await get_tree().create_timer(0.6).timeout
	btn.material_override.albedo_color = close_color
	text.text = "close"
	text_2.text = "close"
	
