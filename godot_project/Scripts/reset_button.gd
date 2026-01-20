extends Button

@export var settings : Array[Slider] 

var values : PackedFloat32Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for v in settings:
		values.append(v.value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	for v in settings.size():
		settings[v].value = values[v]
