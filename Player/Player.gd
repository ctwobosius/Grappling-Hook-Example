class_name Player
extends KinematicBody

onready var cam_helper := $CamHelper
export var MOUSE_SENSITIVITY := .001
export var speed := 4.0
export var friction := .25 # Higher -> more friction
export var jump_strength := 32.0
var velocity := Vector3()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	move(delta)

func move(delta: float) -> void:
	# if on ground
	if is_on_floor():
		# Get player input (forwards/back/side)
		var input := get_forward_acceleration()
		input += get_side_acceleration()
		
		# Use player input
		velocity += input * speed
		
		# Apply friction on ground
		velocity.x *= 1 - friction
		velocity.z *= 1 - friction
	
		# Check jumping
		if Input.is_action_just_pressed("jump"):
			velocity += Vector3.UP * jump_strength
	
	# Gravity
	velocity += Vector3.DOWN
	
	# Move player
	velocity = move_and_slide(velocity, Vector3.UP)

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
		
		var camera_rot = cam_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -90, 90)
		cam_helper.rotation_degrees = camera_rot

# Handles toggling mouse capture
func handle_mouse_capture() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
