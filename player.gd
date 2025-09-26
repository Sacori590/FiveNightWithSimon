extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_force: float = 6.0
@export var gravity: float = 12.0
@export var mouse_sensitivity: float = 0.003

@onready var cam: Camera3D = $Camera3D

var y_velocity: float = 0.0
var rotation_y: float = 0.0
var cam_x_rot: float = 0.0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		cam_x_rot -= event.relative.y * mouse_sensitivity
		cam_x_rot = clamp(cam_x_rot, deg_to_rad(-80), deg_to_rad(80))
		
		rotation.y = rotation_y
		cam.rotation.x = cam_x_rot


func _physics_process(delta: float):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	direction = direction.normalized()

	# Gravité et saut
	if not is_on_floor():
		y_velocity -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			y_velocity = jump_force
		else:
			y_velocity = 0.0

	# Assigner la velocity intégrée du CharacterBody3D
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y = y_velocity

	move_and_slide()
