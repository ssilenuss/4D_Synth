extends Control


@export var effect_name : StringName
@export var gynth: AudioOsc2D
@export var effect_enable_button: CheckBox
@export var cutoff_hz_input: LineEdit
@export var cutoff_hz_slider: HSlider
@export var resonance_input: LineEdit
@export var resonance_slider: HSlider
@export var db_menu: MenuButton

var effect : AudioEffectLowPassFilter
var bus_idx: int
var effect_idx: int = 0


func _ready() -> void:
	bus_idx = AudioServer.get_bus_index(gynth.bus)
	find_audio_effect()
	
	effect_enable_button.toggled.connect(_on_effect_enable_checkbox_toggled)
	cutoff_hz_slider.value_changed.connect(_on_cutoff_slider_value_changed)
	cutoff_hz_input.text_submitted.connect(_on_cutoff_input_text_submitted)
	resonance_slider.value_changed.connect(_on_resonance_slider_value_changed)
	resonance_input.text_submitted.connect(_on_resonance_input_text_submitted)
	
	
	_on_cutoff_slider_value_changed(2000.0)
	_on_resonance_slider_value_changed(0.5)
	

func find_audio_effect()->void:
	var temp_effect = AudioServer.get_bus_effect(bus_idx, effect_idx)
	if temp_effect.get_class() == "AudioEffect"+effect_name:
		effect = temp_effect
		#print("effect found!: ", effect)
	else:
		effect_idx +=1
		#print(temp_effect.get_class(), " is not ", "AudioEffect"+effect_name)
		find_audio_effect()
		
func _on_effect_enable_checkbox_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_effect_enabled(bus_idx, effect_idx, toggled_on)


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

func _on_resonance_input_text_submitted(new_text: String) -> void:
	var _old_text = cutoff_hz_input.text
	if new_text.is_valid_float():
		_old_text = new_text
		resonance_input.text = new_text
		effect.set_resonance(float(new_text))
		
	else:
		cutoff_hz_input.text = str(effect.get_cutoff())

func _on_resonance_slider_value_changed(value:float)->void:
	effect.set_resonance(value)
	resonance_input.text = str(value)
