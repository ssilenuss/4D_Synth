extends CheckBox

@export var effect_idx : int 
@export var bus_idx : int = 2

var effect : AudioEffect

func _ready() -> void:
	self.toggled.connect(_on_self_toggled)
	


func _on_self_toggled(toggled_on:bool)->void:
	self.button_pressed= toggled_on
	AudioServer.set_bus_effect_enabled(bus_idx, effect_idx, toggled_on)
