extends Node3D
@onready var mesh = $MeshInstance3D
@onready var particles = $GPUParticles3D
var velocity = Vector3.ZERO
@onready var ray = $RayCast3D
const SPEED = 40.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(get_transform().basis.z.normalized() * delta * SPEED)
	if ray.is_colliding():
		mesh.visible = false
		particles.emitting = true
		if ray.get_collider().is_in_group("enemy"):
			ray.get_collider().hit()
		await  get_tree().create_timer(1.0).timeout
		queue_free()


func set_velocity(target):
	look_at(target)
	velocity = position.direction_to(target) * SPEED

func _on_timer_timeout():
	queue_free()
