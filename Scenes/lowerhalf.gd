extends VBoxContainer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("4"):
		visible = !visible
