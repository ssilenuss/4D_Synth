extends Label

var title : String
@export var slider: Slider
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if slider:
		text = title+": "+str(slider.value)
