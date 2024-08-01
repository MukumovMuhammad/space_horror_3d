extends Node
var lerp_speed := 3.0
@export var Player : CharacterBody3D

@onready var state : movement_state = movement_state.new()
@onready var dir : Vector3 = Vector3.ZERO
@onready var Player_vel = Vector3.ZERO
@export var can_move : bool = true
var is_spying : bool = false
var can_get_dir : bool = true # this var is used for not getting new dir from player. So as it could still move only from it's previous dir. Like in spying

#for spying
var spy_pos : Vector3
var spy_cam_rot : Vector3
#fov
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Camera vars
@onready var head : Node3D = $"../head"
@onready var neck : Node3D = $"../head/neck"
@onready var Camera : Camera3D = $"../head/neck/Camera3D"


var sensvity = 0.25

enum states {
	STAND,
	CROUCH,
	WALK,
	RUN
}


func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg_to_rad(-event.relative.x * sensvity))
		neck.rotate_x(deg_to_rad(-event.relative.y * sensvity))
		neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-80), deg_to_rad(80))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state.id == states.STAND:
		if Input.is_action_pressed("right_look"):
			neck.position.x = lerp(neck.position.x, 1.0, lerp_speed * delta)
			neck.rotation.z = lerp_angle(neck.rotation.z, deg_to_rad(-30), lerp_speed * delta)
		elif Input.is_action_pressed("left_look"):
			neck.position.x = lerp(neck.position.x, -1.0, lerp_speed * delta)
			neck.rotation.z = lerp_angle(neck.rotation.z, deg_to_rad(30), lerp_speed * delta)
		else:
			neck.position.x = lerp(neck.position.x, 0.0, lerp_speed * delta)
			neck.rotation.z = lerp_angle(neck.rotation.z, deg_to_rad(0), lerp_speed * delta)
	else:
		neck.position.x = lerp(neck.position.x, 0.0, lerp_speed * delta)
		neck.rotation.z = lerp_angle(neck.rotation.z, deg_to_rad(0), lerp_speed * delta)
			

	Player_vel.x = lerp(dir.x, dir.x * state.speed, lerp_speed * delta)
	Player_vel.z = lerp(dir.z, dir.z * state.speed, lerp_speed * delta)
	
	
	#camera FOV
	var velocity_clambed = clamp(Player.velocity.length(), 0.5, state.speed * 4)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clambed
	Camera.fov = lerp(Camera.fov, target_fov, lerp_speed * delta)
	
	if is_spying:
		spying(delta)
	else:
		#Camera.position.y = 0
		pass
	
	if !can_move:
		Player_vel = Vector3.ZERO
	
	Player.velocity = Player_vel
	Player.move_and_slide()


# Recieving the player's states 
func _on_player_set_movement_state(player_state : movement_state):
	state = player_state
	#print("Player states is ", state.id)


# Recieving the player's direction 
func _on_player_set_direction(direction):
	if can_get_dir:
		dir = direction
	#print("The direction is ", dir)


func spying(_delta):
	if Player.global_position.distance_to(spy_pos) < 1.0:
		print("We hit the place")
		Player_vel = Vector3.ZERO
		head.global_rotation.y = spy_cam_rot.y
		head.global_rotation.z = spy_cam_rot.z
		neck.position.x = rad_to_deg(spy_cam_rot.x)
	else:
		neck.look_at(spy_pos)
		neck.rotation.x = 0
		Player_vel.x = lerp(dir.x, dir.x * Player.states["walk"].speed, lerp_speed * _delta)
		Player_vel.z = lerp(dir.z, dir.z * Player.states["walk"].speed, lerp_speed * _delta)

func start_spy(_spy_pos : Vector3, _cam_rot : Vector3):
	spy_pos = _spy_pos
	spy_cam_rot = _cam_rot
	can_get_dir = false
	is_spying = true
	
