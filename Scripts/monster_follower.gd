extends CharacterBody3D


signal enemies_data(data : String)
@onready var attack_cooldown_timer : Timer = $attack_cool_down
@export var attack_demage : int = 10
var noise_pos : Vector3
@export var speed = 5.0
var see  : bool = false
var heard_sth : bool = false
var fallowing : bool = false
var attack : bool = false
@export var main_pos : Vector3 = global_position
@export var player : CharacterBody3D
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
var current_target : Vector3
var dest : Vector3

#This var is just for seeing how much that is mosnter printing sth or no
var just_for_counting : = 0
func _ready():
	dest = Vector3.ZERO
	current_target = main_pos

	


func detect_sound(noise_point : Vector3):
	if see:
		return
	nav_agent.set_target_position(noise_point)
	current_target = noise_point
	heard_sth = true
	$MeshInstance3D.material_override.albedo_color = Color.RED
	await get_tree().create_timer(0.2).timeout
	$MeshInstance3D.material_override.albedo_color = Color.WHITE
	
	
	
func _process(delta):
	enemies_data.emit(
		"see : " + str(see) + 
		"\n hear : " + str(heard_sth) + "\n fallow : " + str(fallowing) + 
		"\ndestination : " + str(snapped(global_position.distance_to(dest), 0.01)) +
		"\n fallow : " + str(fallowing) + 
		"\n attacking : " + str(attack) 
	)
	#"Got to destination ", "see : " , see, " | heard : " , heard_sth, " | fallowing : " , fallowing , " | ", just_for_counting"
	
	if see:
		heard_sth = false
		fallowing = true
		nav_agent.set_target_position(player.global_position)
		current_target = player.global_position
	
	dest = nav_agent.get_next_path_position()
	var dir = (dest - global_position).normalized()
	look_at(dest)
	rotation = Vector3(0,rotation.y, 0)
	
	if fallowing:
		if global_position.distance_to(player.global_position) < 2.0:
			print_debug("Couch_player")
			if !attack:
				attack_cooldown_timer.start()
				attack = true
		else:
			print_debug("didn't catch a player")
			fallowing = false
	if global_position.distance_to(current_target) <= 1:
		if heard_sth:
			heard_sth = false
		nav_agent.set_target_position(main_pos)
		current_target = main_pos
		
		
	if attack:
		velocity = Vector3.ZERO
	else:
		velocity = dir * speed
	move_and_slide()


func _on_vission_area_bodies_count(bodies):
	$Label3D.text = "Bodies detect vision : \n " + str(bodies)


func _on_attack_cool_down_timeout():
	if global_position.distance_to(player.global_position) < 2.0:
		player.take_damage(attack_demage)
	attack = false
