extends Node
signal took_damage(cur : int)
var current_health : int = 0
@export var max_health : int = 100
@onready var hud_anim = $"../HUD_anim"

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health
	emit_signal("took_damage", current_health)


func take_damage(points : int):
	current_health -= points
	hud_anim.play("took_damage")
	if current_health <= 0:
		current_health = 0
		player_death()
	
	emit_signal("took_damage", current_health)


func player_death():
	get_parent().death()
