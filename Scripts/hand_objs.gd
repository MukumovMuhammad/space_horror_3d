extends Node3D

##--------- for carying objects ---------##
@export var current_obj : Node = null
@onready var obj_place: Marker3D = $"../obj_place"

@onready var cur_hand_obj
enum obj {
	CAMERA_TAB,
	FLESHLIGHT,
	PISTOL
}



#-- Player's vars --#
@onready var movement: Node = $"../../../movement"
@onready var player: CharacterBody3D = $"../../.."


func _ready() -> void:
	get_child(obj.CAMERA_TAB).hide()
	get_child(obj.FLESHLIGHT).hide()


func _process(delta: float) -> void:
	
	#-- Flesh light --#
	if Input.is_action_just_pressed("1"):
		
		take_obj(obj.FLESHLIGHT)
		#if cur_hand_obj == obj.FLESHLIGHT:
			#get_child(cur_hand_obj).take_away()
			#cur_hand_obj = null
		#else:
			#if cur_hand_obj != null:
				#get_child(cur_hand_obj).take_away()
				#movement.can_move = true
			#cur_hand_obj = obj.FLESHLIGHT
			#get_child(cur_hand_obj).get_obj()
	
	#-- Pistol --#
	if Input.is_action_just_pressed("2"):
		take_obj(obj.PISTOL)
	
	##-- Camera Tab --#
	#if Input.is_action_just_pressed("the_camera_tab"):
		#if cur_hand_obj == obj.CAMERA_TAB:
			#cur_hand_obj = null
			#movement.can_move = true
			#get_child(obj.CAMERA_TAB).take_away()
		#else:
			#if cur_hand_obj != null:
				#get_child(cur_hand_obj).take_away()
			#cur_hand_obj = obj.CAMERA_TAB
			#movement.can_move = false
			#get_child(cur_hand_obj).get_obj()
		#


	
	if Input.is_action_just_pressed("left_click"):
		if cur_hand_obj == null:
			return
		get_child(cur_hand_obj).press_btn()
	
	carrying_obj()


func take_obj(this_obj : obj):
	if cur_hand_obj == this_obj:
		get_child(cur_hand_obj).take_away()
		cur_hand_obj = null
	else:
		if cur_hand_obj != null:
			get_child(cur_hand_obj).take_away()
			movement.can_move = true
		cur_hand_obj = this_obj
		get_child(cur_hand_obj).get_obj()



func carrying_obj():
	if current_obj == null:
		return 
	
	current_obj.global_transform = obj_place.global_transform


func change_obj(obj):
	#if cur_hand_obj != null:
		#get_child(cur_hand_obj).take_away()
	if current_obj != null:
		var obj_pos = obj.global_transform
		obj.global_transform = current_obj.global_transform
		current_obj.drop()
		current_obj.global_transform = obj_pos
	current_obj = obj
	current_obj.took()


func have_petrol():
	if current_obj == null:
		return false
	if current_obj.obj_name == "petrol":
		return true
	return false
	


func empty_petrol_can():
	if current_obj.obj_name != "petrol":
		return
		
	var petrol_v = current_obj.petrol_volue
	current_obj.queue_free()
	current_obj = null
	return petrol_v
	
	
