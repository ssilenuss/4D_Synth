extends Control

@export var filter_controls : Control
var effect_name : StringName
@export var gynth: AudioOsc2D
@export var effect_enable_button: CheckBox
@export var lfo_checkbox: CheckBox
@export var cutoff_hz_input: LineEdit
@export var cutoff_hz_slider: HSlider
@export var resonance_menu: MenuButton
@export var lfo_depth_menu: MenuButton
@export var db_menu: MenuButton
@export var lfo: LFO_Controller
var db_popup: PopupMenu

var effect : AudioEffect
var bus_idx: int
var effect_idx: int = 0
var lfo_enabled: bool
var lfo_depth : float = 0.25



func _ready() -> void:
	effect_name = self.get_name()
	effect_enable_button.text = effect_name
	bus_idx = AudioServer.get_bus_index(gynth.bus)
	find_audio_effect()
	
	effect_enable_button.toggled.connect(_on_effect_enable_checkbox_toggled)
	lfo_checkbox.toggled.connect(_on_lfo_toggled)
	cutoff_hz_slider.value_changed.connect(_on_cutoff_slider_value_changed)
	cutoff_hz_input.text_submitted.connect(_on_cutoff_input_text_submitted)
	init_resonance_slider()
	init_lfo_depth_slider()
	db_popup = db_menu.get_popup()
	db_popup.id_pressed.connect(_on_db_popup_selected)
	

	
	_on_cutoff_slider_value_changed(2000.0)
	_on_resonance_slider_value_changed(0.5)
	_on_db_popup_selected(0)
	
func _process(delta: float) -> void:
	if lfo_enabled:
		var cutoff_fq: float = cutoff_hz_slider.value
		var new_value : float = cutoff_fq + (lfo.value*lfo_depth*cutoff_fq)
		effect.set_cutoff(new_value)
		print(new_value)

func _on_lfo_toggled(toggled_on:bool)->void:
	lfo_enabled = toggled_on
	
	if toggled_on and not lfo.enable_checkbox.button_pressed:
		lfo.enable_checkbox.button_pressed = toggled_on
	
	if toggled_on and not effect_enable_button.button_pressed:
		effect_enable_button.button_pressed = toggled_on
	
	
func _on_db_popup_selected(id: int)->void:
	print(id)
	match id:
		0:
			db_menu.text = "6 dB"
		1:
			db_menu.text = "12 dB"
		2:
			db_menu.text = "18 dB"
		3:
			db_menu.text = "24 dB"
	#mode_menu.text = mode_popup.get_item_text(id)
	effect.set_db(id)
	print(effect.get_db())
	
func find_audio_effect()->void:
	var temp_effect = AudioServer.get_bus_effect(bus_idx, effect_idx)
	if temp_effect.get_class() == "AudioEffect"+effect_name:
		effect = temp_effect
		print("effect found!: ", effect)
	else:
		effect_idx +=1
		#print(temp_effect.get_class(), " is not ", "AudioEffect"+effect_name)
		find_audio_effect()

		
func _on_effect_enable_checkbox_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_effect_enabled(bus_idx, effect_idx, toggled_on)
	filter_controls.visible = toggled_on
	


func _on_cutoff_input_text_submitted(new_text: String) -> void:
	var _old_text = cutoff_hz_input.text
	if new_text.is_valid_float():
		_old_text = new_text
		cutoff_hz_input.text = new_text
		effect.set_cutoff(float(new_text))
		
	else:
		cutoff_hz_input.text = str(effect.get_cutoff())

func _on_cutoff_slider_value_changed(value:float)->void:
	effect.cutoff_hz = value
	cutoff_hz_input.text = str(value)

#func _on_resonance_input_text_submitted(new_text: String) -> void:
	#var _old_text = cutoff_hz_input.text
	#if new_text.is_valid_float():
		#_old_text = new_text
		#resonance_menu.text = new_text
		#effect.set_resonance(float(new_text))
		#
	#else:
		#cutoff_hz_input.text = str(effect.get_cutoff())

func init_resonance_slider() -> void:
	var popup:PopupMenu = resonance_menu.get_popup()
	var v_slider = VSlider.new()
	v_slider.set_anchors_preset(Control.PRESET_FULL_RECT)
	v_slider.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v_slider.value = effect.get_resonance()
	v_slider.max_value = 1.0
	v_slider.min_value = 0.0
	v_slider.step = 0.001
	v_slider.value_changed.connect(_on_resonance_slider_value_changed)
	var min_size : float = 100
	popup.min_size.y = min_size
	v_slider.custom_minimum_size.y = min_size
	popup.add_child(v_slider)

func init_lfo_depth_slider() -> void:
	var popup:PopupMenu = lfo_depth_menu.get_popup()
	var v_slider = VSlider.new()
	v_slider.set_anchors_preset(Control.PRESET_FULL_RECT)
	v_slider.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v_slider.value = effect.get_resonance()
	v_slider.max_value = 1.0
	v_slider.min_value = 0.0
	v_slider.step = 0.001
	v_slider.value_changed.connect(_on_lfo_depth_slider_value_changed)
	var min_size : float = 100
	popup.min_size.y = min_size
	v_slider.custom_minimum_size.y = min_size
	popup.add_child(v_slider)
	
func _on_resonance_slider_value_changed(value:float)->void:
	effect.set_resonance(value)
	resonance_menu.text = str(value)

func _on_lfo_depth_slider_value_changed(value:float)->void:
	lfo_depth = value
	lfo_depth_menu.text = str(value)
