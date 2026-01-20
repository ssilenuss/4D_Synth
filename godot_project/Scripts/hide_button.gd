extends CheckBox

@export var control_node : Control

func _ready() -> void:
	control_node.visibility_changed.connect(on_node_visibility_changed)
	self.pressed.connect(_on_self_pressed)
	control_node.visible = button_pressed

func on_node_visibility_changed()->void:
	button_pressed = control_node.visible

func _on_self_pressed()->void:
	control_node.visible = button_pressed
