extends CharacterBody3D

signal set_movement_state(state : movement_state)
signal set_direction(dir : Vector3)
signal player_died
@export var movement : Node


@export var death_ui : PackedScene

@export_category("camera bob")
@export var amp  := 0.08
@export var freq := 4
var t_bob = 0.0
var can_bob : int  = 1


@export_category("movement_states")
@export var states : Dictionary


#const SPEED = 5.0
const JUMP_VELOCITY = 4.5
# lerp vars
var lerp_speed := 5.0

@onready var cur_state := "stand"
# Camera vars
@onready var head : Node3D = $head
@onready var Camera : Camera3D = $head/neck/Camera3D




# Charasteristic vars
var pre_cur
var pre_dir : Vector3
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pre_cur = cur_state
	pre_dir = Vector3.ZERO
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	emit_signal("set_movement_state", states["stand"])




func _physics_process(delta):
	cur_state = "stand"
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif !can_bob:
		can_bob = 1
	# Handle jump.
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	
	
	
	var direction = (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		cur_state = "walk"
		emit_signal("set_direction", direction)
		if Input.is_action_pressed("shift"):
			cur_state = "run"
		if Input.is_action_pressed("crouch"):
			cur_state = "crouch"
	
	
	#emiting signals
	if cur_state != pre_cur: # conditions for emitting signal of movement once
		pre_cur = cur_state
	#	print_debug("set movement state to " , cur_state)
		emit_signal("set_movement_state", states[cur_state])
	
	if pre_dir != direction: # conditions for emitting signal of direction once
		pre_dir = direction
		#print_debug("set new direct to " , direction)
		emit_signal("set_direction", direction)
	
	
	#head bobing
	t_bob += delta * velocity.length() * can_bob
	Camera.transform.origin = head_bob(t_bob)
	move_and_slide()


func head_bob(time) -> Vector3:
	var pos : Vector3 = Vector3.ZERO
	
	pos.y = sin(time * freq) * amp
	pos.x = cos(time * freq / 2) * amp
	return pos
	


func take_damage(point : int):
	$health_component.take_damage(point)


func death():
	print_debug("Player Died")
	add_child(death_ui.instantiate())
	player_died.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	get_tree().paused = true
