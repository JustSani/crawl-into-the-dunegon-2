extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 6.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.5
		%Camera3D.rotation_degrees.x -= event.relative.y * 0.2
		%Camera3D.rotation_degrees.x = clamp(
			%Camera3D.rotation_degrees.x, -60.0, 60.0
		)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	# 1. GESTIONE GRAVITÀ
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y -= gravity * 2.0 * delta 
		else:
			velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y *= 0.5 

	var input_direction_2D = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_back"
	) 
	
	var input_direction_3D = Vector3(
		input_direction_2D.x, 0.0, input_direction_2D.y
	).normalized()
	
	var direction = transform.basis * input_direction_3D
	
	if direction != Vector3.ZERO:
		velocity.x = lerp(velocity.x, direction.x * SPEED, 15.0 * delta)
		velocity.z = lerp(velocity.z, direction.z * SPEED, 15.0 * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, 15.0 * delta)
		velocity.z = lerp(velocity.z, 0.0, 15.0 * delta)

	move_and_slide()
