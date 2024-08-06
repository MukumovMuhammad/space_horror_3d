extends CharacterBody3D


signal enemies_data(data : String) # it's just for displaying
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var rot_point: Marker3D = $rot_point

@onready var attack_cooldown_timer : Timer = $attack_cool_down
@export var attack_demage : int = 10
@export var Wondering_poses : Array
var noise_pos : Vector3
@export var walking_speed := 2.0
@export var running_speed := 5.0
var cur_speed : float

@export var main_pos : Vector3 = global_position
@export var player : CharacterBody3D
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
var current_target : Vector3
var dest : Vector3

#Enemy states vars
var see  : bool = false
var heard_sth : bool = false
var fallowing : bool = false
var attack : bool = false
var lost : bool = false
var going_back_home : bool = false
var got_to_home : bool = true
var dead : bool = false
var revival : bool = false

#--------anim--------#
var current_anim

enum states {
	IDLE,
	HEARD,
	FOLLOWING,
	LOST,
	MAD,
	ATTACK,
	DEATH,
	REVIVAL
}

#----------- LIFE var -----------#
@export var max_health : int = 100;
var cur_health : int



#This var is just for seeing how much that is mosnter printing sth or no
var just_for_counting : = 0

func _ready():
	anim_tree.active = true
	dest = Vector3.ZERO
	current_target = Wondering_poses.pick_random()
	nav_agent.set_target_position(current_target)
	going_back_home = true
	got_to_home = false
	cur_health = max_health


func detect_sound(noise_point : Vector3):
	if see:
		return
	nav_agent.set_target_position(noise_point)
	current_target = noise_point
	going_back_home = false
	got_to_home = false
	heard_sth = true
	lost = false
	
	
	
func _process(delta):
	current_anim = anim_tree.get("parameters/playback").get_current_node()
	enemies_data.emit(
		"see : " + str(see) + 
		"\n hear : " + str(heard_sth) + "\n fallow : " + str(fallowing) + 
		"\ndestination : " + str(snapped(global_position.distance_to(dest), 0.01)) +
		"\n attacking : " + str(attack)  + 
		"\n lost : " + str(lost) + 
		"\n gooing back home : " + str(going_back_home)+
		"\n got home " + str(got_to_home) + 
		"\n current_anim " + str(current_anim) + 
		"\n curent target dest : " + str(snapped(global_position.distance_to(nav_agent.get_final_position()), 0.01))+
		"\n curent health : " + str(cur_health)
	)
	
	if see:
		got_to_home = false
		going_back_home = false
		heard_sth = false
		fallowing = true
		lost = false
		nav_agent.set_target_position(player.global_position)
		current_target = player.global_position
	#elif fallowing:
		#if global_position.distance_to(player.global_position) < 2.0:
			#fallowing = false
			#current_target = Wondering_poses.pick_random()
			#nav_agent.set_target_position(current_target)
			#going_back_home = true
			#got_to_home = false
	
	dest = nav_agent.get_next_path_position()
	var dir = (dest - global_position).normalized()
	
	#for smooth rotation
	rot_point.look_at(Vector3(dest.x, self.global_position.y,dest.z))
	rotation.y = lerp_angle(rotation.y, rot_point.global_rotation.y, delta * 3)
	if current_anim == "mutant_walking":
		cur_speed = walking_speed
	elif current_anim == "running":
		cur_speed = running_speed
	else:
		cur_speed = 0.0
	
	velocity = dir * cur_speed
	
	
	if fallowing:
		if global_position.distance_to(player.global_position) < 2.0:
			#print_debug("Couch_player")
			if !attack:  
				#attack_cooldown_timer.start()
				attack = true
		#else:
			#print_debug("didn't catch a player")
			#fallowing = false
			
	if global_position.distance_to(nav_agent.get_final_position()) <= 2:
		if going_back_home or fallowing:
			got_to_home = true
			going_back_home = false
			fallowing = false
		else:
			lost = true
			got_to_home = true
			
		if heard_sth:
			heard_sth = false
	
	#animation controll
	anim_tree.set("parameters/conditions/heard", heard_sth)
	anim_tree.set("parameters/conditions/see",see)
	anim_tree.set("parameters/conditions/see",see)
	anim_tree.set("parameters/conditions/lost",lost)
	anim_tree.set("parameters/conditions/attack",attack)
	anim_tree.set("parameters/conditions/got_home",got_to_home)
	anim_tree.set("parameters/conditions/going_to_pos", going_back_home)
	anim_tree.set("parameters/conditions/dead", dead)
	anim_tree.set("parameters/conditions/not_dead", revival)
	
	if revival:
		dead = false
		revival = false
		cur_health = max_health
		set_new_target(Wondering_poses.pick_random())
	move_and_slide()
		

func _on_vission_area_bodies_count(bodies):
	$Label3D.text = "Bodies detect vision : \n " + str(bodies)



func _attack():
	if global_position.distance_to(player.global_position) < 2.0:
		player.take_damage(attack_demage)
	attack = false





func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	#print_debug("anim name is : " + anim_name)
	if anim_name == "screaming":
		look_at(player.global_position)
	elif ["idle", "mutant_idle"].has(anim_name)  and got_to_home:
		set_new_target(Wondering_poses.pick_random())



func set_new_target(target : Vector3):
	lost = false
	current_target = target
	nav_agent.set_target_position(current_target)
	going_back_home = true
	got_to_home = false


func _anim_idle_finished():
	if lost:
		lost = false
		current_target = Wondering_poses.pick_random()
		nav_agent.set_target_position(current_target)
		going_back_home = true

func hit():
	cur_health -= 10;
	if cur_health <= 0:
		dead = true
		$death_timer.start()





func _on_death_timer_timeout():
	revival = true
	
