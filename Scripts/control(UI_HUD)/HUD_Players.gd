extends Control


@onready var health_bar : ProgressBar = $CanvasLayer/health_bar

@export var health_bar_colors : Dictionary = {
	"full" : Color.GREEN,
	"mid" : Color.GREEN_YELLOW,
	"low" : Color.RED
}




func _on_health_component_took_damage(cur):
	health_bar.value = cur
	
