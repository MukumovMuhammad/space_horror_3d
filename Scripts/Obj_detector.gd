extends RayCast3D

@onready var info: Label = $"../../../../HUD/CanvasLayer/equipment_mini_info"
@onready var obj_place: Marker3D = $"../../obj_place"
@onready var petrol_progress: ProgressBar = $"../../../../HUD/CanvasLayer/petrol_progress"
@onready var player: CharacterBody3D = $"../../../.."
@onready var movement: Node = $"../../../../movement"


@export var current_obj : Node = null
@onready var camera_tab: Node3D = $"../../Camera_Tab"
@onready var camera_view: TextureRect = $"../../../../HUD/CanvasLayer/CameraTab"

@onready var hand_objs: Node3D = $"../../hand_objs"

var took_camera : bool = false
var cur_camera: int = 0


#func _ready() -> void:
	#camera_view.texture.viewport_path = player.Camera_Subs[cur_camera]
	#camera_view.hide()
	#camera_tab.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		var obj = get_collider()
		
		if obj.is_in_group("has_info"):
			info.text = obj.i_name
		else:
			info.text = ""
		
		
		##--------equipments--------##
		if obj.is_in_group("equipment"):
			
			
			
			if Input.is_action_just_pressed("action"):
				hand_objs.change_obj(obj.parent)
		
		##--------equipments (pterol) --------##
		#elif obj.is_in_group("petrol_container") and current_obj != null:
			#if current_obj.obj_name == "petrol":
				#petrol_progress.value = obj.Fill_container(current_obj.petrol_volue)
				#current_obj.queue_free()
				#current_obj = null
		elif obj.is_in_group("e_door"):
			info.text = "open"
			if Input.is_action_just_pressed("action"):
				obj.open_door()
		elif obj.is_in_group("spying_spot"):
			if Input.is_action_just_pressed("space"):
				obj.spy(player)
	else:
		info.text = ""


