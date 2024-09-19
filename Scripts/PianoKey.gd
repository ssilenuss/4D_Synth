
extends ColorRect
class_name Piano_Key

var label = Label
signal piano_key_pitch(pitch_cv: float)
signal piano_key_gate(pitch_cv: float)


@export var flat : Piano_Key
@export var key_color : Color
@export var pressed_color : Color



var notes : Dictionary = {
	"A" : 0/12.0,
	"B_FLAT" : 1.0/12.0, 
	"B" : 2.0/12.0, 
	"C" : 3.0/12.0, 
	"D_FLAT" : 4.0/12.0, 
	"D" : 5.0/12.0, 
	"E_FLAT" : 6.0/12.0, 
	"E" : 7.0/12.0, 
	"F" : 8.0/12.0, 
	"G_FLAT" : 9.0/12.0, 
	"G" : 10.0/12.0, 
	"A1_FLAT" : 11.0/12.0, 
	"A1" : 12.0/12.0, 
	"B1_FLAT" : 13.0/12.0, 
	"B1" : 14.0/12.0, 
	"C1" : 15.0/12.0
}
func _ready()->void:
	add_to_group("piano_key")
	color = key_color
	var key_input: Array=  InputMap.action_get_events(get_name())
	label = $Label
	if key_input.size()>0:
		if key_input[0] is InputEventKey:
			var keycode :Key= DisplayServer.keyboard_get_keycode_from_physical(key_input[0].physical_keycode)
			var string :String = OS.get_keycode_string(keycode)
			#print(string)
			if string == "Comma":
				string = ","
			elif string == "Apostrophe":
				string = "'"
			label.text = string
	else:
		label.text = "!"

	if flat != null:
		reset_flat_pos()
	
	resized.connect(_on_resized)
	gui_input.connect(_on_gui_input)
	
func reset_flat_pos()->void:
	flat.set_position(Vector2.ZERO)
	flat.set_size(size/3.0)
	flat._set_position(Vector2(-flat.size.x/2,0))
	
	
func _on_resized()->void:
	if flat:
		reset_flat_pos()

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		cv_out(get_name())
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		release_key()
		
func cv_out(_note: String)->void:
	color = pressed_color
	var v : float = notes[_note]
	#piano_key_pitch.emit(v)
	#piano_key_gate.emit(1.0)
	for g in get_tree().get_nodes_in_group("gynth_consoles"):
		var g_c : Gynth_Controller = g
		if g_c.keyboard_controlled:
			#var new_pitch : float = pow(2,notes[get_name()])
			g_c._on_keyboard_pressed(notes[get_name()])
			g_c._on_check_box_bang_button_down()

func release_key()->void:
	#piano_key_pitch.emit(0.0)
	piano_key_gate.emit(0.0)
	color = key_color

func _process(delta: float) -> void:

	if Input.is_action_just_pressed(get_name()):
		cv_out(get_name())
		
	elif Input.is_action_just_released(get_name()):
		release_key()
