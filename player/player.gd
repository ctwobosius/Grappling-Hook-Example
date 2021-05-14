class_name Player
extends KinematicBody

# Convenience Nodes
onready var cam_helper := $CamHelper

# Player Controller
export var MOUSE_SENSITIVITY := .001
export var speed := 4.0
export var air_speed := .25
export var friction := .25  # Higher -> more friction
export var jump_strength := 32.0
var velocity := Vector3()

func _ready() -> void:
	# Capture mouse at start
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	move(delta)
	collide_with_rigidbodies()
	if Input.is_action_pressed("slowmo"):
		Engine.time_scale = .1
	else:
		Engine.time_scale = 1

# CHARACTER CONTROLLER -------------------------------------------------

func move(delta: float) -> void:
	# Get player input (forwards/back/side)
	var input := get_forward_acceleration() + get_side_acceleration()
	
	# if on ground
	if is_on_floor():
		# Use player input
		velocity += input * speed
		
		# Apply friction on ground
		velocity.x *= 1 - friction
		velocity.z *= 1 - friction
	
		# Check jumping
		if Input.is_action_just_pressed("jump"):
			velocity += Vector3.UP * jump_strength
	
	# Else we are in the air
	else:
		velocity += input * air_speed
	
	# Gravity
	velocity += Vector3.DOWN
	
	# Move player using velocity, we want to have the UP vector as our up,
	# the false at the end allows us to have better collisions
	# with Rigidbodies, the rest are default arguments
	velocity = move_and_slide(velocity, Vector3.UP, false, 4, .8, false)

# Since we want better collisions, we have to do a lil work
func collide_with_rigidbodies() -> void:
	for index in get_slide_count():
		var collision := get_slide_collision(index)
		if collision.collider is RigidBody:
			collision.collider.apply_central_impulse(
				-collision.normal * .05 * velocity.length()
			)

func get_side_acceleration() -> Vector3:
	return global_transform.basis.x * (
		Input.get_action_strength("right") - Input.get_action_strength("left")
	)

func get_forward_acceleration() -> Vector3:
	return global_transform.basis.z * (
		Input.get_action_strength("backward") - Input.get_action_strength("forward")
	)

func _input(event: InputEvent) -> void:
	# So we can quit the game by pressing escape
	if event.is_action_pressed("ui_cancel"):
		handle_mouse_capture()
	# Fullscreen
	elif event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	# Move camera
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		cam_helper.rotate_x(event.relative.y * -MOUSE_SENSITIVITY)
		rotate_y(event.relative.x * -MOUSE_SENSITIVITY)
		
		cam_helper.rotation_degrees.x = clamp(
			cam_helper.rotation_degrees.x, 
			-90, 
			90
		)

# Handles toggling mouse capture
func handle_mouse_capture() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
