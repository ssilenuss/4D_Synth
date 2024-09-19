extends Control
class_name Gynth_Controller
var gynth : AudioOsc2D

#@export var controls_visible_box : CheckBox 
@export var bang_box : CheckBox 
@export var gen_box : CheckBox 
@export var enable_envelope_box : CheckBox 
@export var loop_envelope_box : CheckBox 
@export var wav_menu : MenuButton 
@export var wav_vis : ColorRect 
@export var frequency_label : LineEdit 
@export var frequency_slider : HSlider 
@export var limiter_label : LineEdit
@export var limiter_slider : HSlider 
@export var attack_slider : HSlider 
@export var decay_slider : HSlider 
@export var sustain_slider: HSlider 
@export var release_slider : HSlider 
@export var speed_slider : HSlider 
@export var keyboard_box: CheckBox 
@export var wav_controls : VBoxContainer
@export var env_title : VBoxContainer
@export var env_controls : VBoxContainer
@export var speed_label : LineEdit
@export var attack_label : LineEdit
@export var decay_label : LineEdit
@export var release_label : LineEdit
@export var sustain_label : LineEdit

@export var playhead_color: Color = Color(0,0,1,1)


@export var env_color : Color

var keyboard_controlled := false
var playhead_position : float = 0.0
var wav_menu_popup : PopupMenu
var base_frequency : float
	

func _ready() -> void:
	#wav_menu.get_popup().id_pressed.connect(wavetype_selected)
	gynth = $AudioOsc2D
	wav_vis.gynth = gynth
	base_frequency = gynth.frequency
	
	wav_menu_popup = wav_menu.get_popup()
	wav_menu_popup.id_pressed.connect(_on_wav_menu_popup_selected)
	_on_wav_menu_popup_selected(0)

	_on_frequency_text_submitted("440.0")
	
	_on_limiter_text_submitted("0.0")
	
	_on_check_box_envelope_enable_toggled(false)	
	
	_on_check_box_loop_envelope_toggled(false)

	_on_check_box_generating_toggled(false)
	
	_on_keyboard_controlle_toggled(true)

	_on_speed_text_submitted("1.0")
	
	_on_attack_line_submitted("0.5")
	
	_on_decay_text_submitted("0.5")
	
	_on_sustain_text_submitted("5.0")
	
	_on_release_text_submitted("1.0")



	
		
func _on_check_box_generating_toggled(toggled_on: bool) -> void:
	gynth.set_generating(toggled_on)
	wav_controls.visible = toggled_on
	gen_box.button_pressed = toggled_on
	#env_title.visible = toggled_on
	#wav_vis.visible = toggled_on
	


func _on_check_box_bang_button_down() -> void:
	gynth.receive_bang(true)
	await get_tree().create_timer(.1).timeout
	bang_box.button_pressed = false
	
func init_menu()->void:
	gen_box.button_pressed = gynth.generating
	enable_envelope_box.button_pressed = gynth.env_enabled
	loop_envelope_box.button_pressed = gynth.loop
	wav_menu.text = wav_menu.get_popup().get_item_text(gynth.osc_type)
	wav_vis.gynth = gynth
	frequency_slider.value = gynth.pitch
	_on_pitch_slider_value_changed(gynth.pitch)
	limiter_slider.value = gynth.limiter
	attack_slider.value = gynth.attack
	decay_slider.value = gynth.decay
	sustain_slider.value = gynth.sustain
	release_slider.value = gynth.release
	speed_slider.value = gynth.speed
	

func _on_check_box_envelope_enable_toggled(toggled_on: bool) -> void:
	gynth.set_env_enabled(toggled_on)
	env_controls.visible = toggled_on
	enable_envelope_box.button_pressed = toggled_on
	_on_check_box_generating_toggled(false)
	_on_check_box_generating_toggled(true)


func _on_check_box_loop_envelope_toggled(toggled_on: bool) -> void:
	gynth.loop = toggled_on
	loop_envelope_box.button_pressed = toggled_on


#func wavetype_selected(idx: int)->void:
	#wav_menu.text = wav_menu.get_popup().get_item_text(idx)
	#gynth.set_generating(false)
	#gynth.osc_type = idx
	#gynth.set_generating(true)
	#


func _on_pitch_slider_value_changed(value: float) -> void:
	#gynth.set_effective_frequency(value)
	gynth.pitch = value-0.01
	
	base_frequency = gynth.get_effective_frequency()
	frequency_label.text = str(base_frequency)

func _on_keyboard_pressed(pitch_mod: float) -> void:
	if keyboard_controlled:
		var new_frequency : float = base_frequency * pow(2, pitch_mod)
		gynth.set_effective_frequency(new_frequency)
		#gynth.pitch = base_pitch+new_pitch
		frequency_label.text = str(gynth.get_effective_frequency())
		
func _on_limiter_slider_value_changed(value: float) -> void:
	gynth.limiter = value
	limiter_label.text = str(value)


func _on_attack_slider_value_changed(value: float) -> void:
	gynth.attack = value
	attack_label.text = str(value)

func _on_decay_slider_value_changed(value: float) -> void:
	gynth.decay = value
	decay_label.text = str(value)


func _on_sustain_slider_value_changed(value: float) -> void:
	gynth.sustain = value
	sustain_label.text = str(value)


func _on_release_slider_value_changed(value: float) -> void:
	gynth.release = value
	release_label.text = str(value)


func _on_speed_slider_value_changed(value: float) -> void:
	gynth.speed = value
	speed_label.text = str(value) + "(s)"

#
#func _on_controls_visible_box_toggled(toggled_on: bool) -> void:
	#$Controls.visible = false
	
func _on_wav_menu_popup_selected(id)->void:
	wav_menu.text = "WAVE: " + wav_menu_popup.get_item_text(id)
	gynth.osc_type = id
	_on_check_box_generating_toggled(false)
	_on_check_box_generating_toggled(true)

func _on_keyboard_controlle_toggled(toggled_on: bool) -> void:
	keyboard_controlled = toggled_on


func _on_frequency_text_submitted(new_text: String) -> void:
	var old_text = frequency_label.text
	if new_text.is_valid_float():
		old_text = new_text
		frequency_label.text = new_text
		gynth.set_effective_frequency(float(new_text))
		frequency_slider.value = gynth.pitch_scale
	else:
		frequency_label.text = str(gynth.get_effective_frequency())
	


func _on_limiter_text_submitted(new_text: String) -> void:
	var old_text = limiter_label.text
	if new_text.is_valid_float():
		old_text = new_text
		limiter_label.text = new_text
		limiter_slider.value = float(new_text)
		
	else:
		limiter_label.text = str(limiter_slider.value)
		
	


func _on_speed_text_submitted(new_text: String) -> void:
	var old_text = speed_label.text
	if new_text.is_valid_float():
		old_text = new_text
		speed_label.text = new_text
		speed_slider.value = float(new_text)
		
	else:
		speed_label.text = str(speed_slider.value)


func _on_attack_line_submitted(new_text: String) -> void:
	var old_text = attack_label.text
	if new_text.is_valid_float():
		old_text = new_text
		attack_label.text = new_text
		attack_slider.value = float(new_text)
		
	else:
		attack_label.text = str(attack_slider.value)


func _on_decay_text_submitted(new_text: String) -> void:
	var old_text = decay_label.text
	if new_text.is_valid_float():
		old_text = new_text
		decay_label.text = new_text
		decay_slider.value = float(new_text)
		
	else:
		decay_label.text = str(decay_slider.value)


func _on_release_text_submitted(new_text: String) -> void:
	var old_text = release_label.text
	if new_text.is_valid_float():
		old_text = new_text
		release_label.text = new_text
		release_slider.value = float(new_text)
		
	else:
		release_label.text = str(release_slider.value)


func _on_sustain_text_submitted(new_text: String) -> void:
	var old_text = sustain_label.text
	if new_text.is_valid_float():
		old_text = new_text
		sustain_label.text = new_text
		sustain_slider.value = float(new_text)
		
	else:
		sustain_label.text = str(sustain_slider.value) + "(s)"
