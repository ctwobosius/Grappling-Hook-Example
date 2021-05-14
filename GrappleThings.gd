extends Spatial

func _ready():
	for box in get_children():
		box.rotation = Vector3(3, 3, 3) * randf()
