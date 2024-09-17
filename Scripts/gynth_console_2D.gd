extends Control
class_name Gynth_Controller
var gynth : AudioOsc2D

@onready var controls_visible_box : CheckBox = $VBoxContainer/Controls/VBoxContainer/HFO/CheckBox_Controls_Visible
@onready var bang_box : CheckBox = $VBoxContainer/Controls/VBoxContainer/EnvelopeOptions/CheckBox_Bang
@onready var gen_box : CheckBox = $VBoxContainer/Controls/VBoxContainer/HFO/CheckBox_Generating
@onready var enable_envelope_box : CheckBox = $VBoxContainer/Controls/VBoxContainer/EnvelopeOptions/CheckBox_EnvelopeEnable
@onready var loop_envelope_box : CheckBox = $VBoxContainer/Controls/VBoxContainer/EnvelopeOptions/CheckBox_LoopEnvelope
@onready var wav_menu : MenuButton = $VBoxContainer/Controls/VBoxContainer/HFO/WaveType_Menu
@onready var wav_vis : ColorRect = $VBoxContainer/wav_vis
@onready var pitchlabel : Label = $VBoxContainer/Controls/VBoxContainer/PitchLabel
@onready var pitchslider : HSlider = $VBoxContainer/Controls/VBoxContainer/PitchSlider
@onready var limiter_slider : HSlider = $VBoxContainer/Controls/VBoxContainer/LimiterSlider
@onready var attack_slider : HSlider = $VBoxContainer/Controls/VBoxContainer/AttackSlider
@onready var decay_slider : HSlider = $VBoxContainer/Controls/VBoxContainer/DecaySlider
@onready var sustain_slider: HSlider = $VBoxContainer/Controls/VBoxContainer/SustainSlider
@onready var release_slider : HSlider = $VBoxContainer/Controls/VBoxContainer/ReleaseSlider
@onready var speed_slider : HSlider = $VBoxContainer/Controls/VBoxContainer/SpeedSlider


@export var playhead_color: Color = Color(0,0,1,1)
var playhead_position : float = 0.0

@export var env_color : Color

func _ready() -> void:
	#wav_menu.get_popup().id_pressed.connect(wavetype_selected)
	gynth = $AudioOsc2D
	wav_vis.gynth = gynth
	
	enable_envelope_box.button_pressed = gynth.env_enabled
	loop_envelope_box.button_pressed = gynth.env_enabled
	_on_check_box_envelope_enable_toggled(gynth.env_enabled)
	_on_check_box_loop_envelope_toggled(gynth.loop)
		

func _on_check_box_generating_toggled(toggled_on: bool) -> void:
	gynth.set_generating(toggled_on)


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
	pitchslider.value = gynth.pitch
	_on_pitch_slider_value_changed(gynth.pitch)
	limiter_slider.value = gynth.limiter
	attack_slider.value = gynth.attack
	decay_slider.value = gynth.decay
	sustain_slider.value = gynth.sustain
	release_slider.value = gynth.release
	speed_slider.value = gynth.speed
	

func _on_check_box_envelope_enable_toggled(toggled_on: bool) -> void:
	gynth.set_env_enabled(toggled_on)


func _on_check_box_loop_envelope_toggled(toggled_on: bool) -> void:
	gynth.loop = toggled_on


func wavetype_selected(idx: int)->void:
	wav_menu.text = wav_menu.get_popup().get_item_text(idx)
	gynth.set_generating(false)
	gynth.osc_type = idx
	gynth.set_generating(true)
	


func _on_pitch_slider_value_changed(value: float) -> void:
	gynth.pitch = value
	pitchlabel.text = "Pitch: " + str(gynth.frequency*gynth.pitch_scale)


func _on_limiter_slider_value_changed(value: float) -> void:
	gynth.limiter = value


func _on_attack_slider_value_changed(value: float) -> void:
	gynth.attack = value

func _on_decay_slider_value_changed(value: float) -> void:
	gynth.decay = value


func _on_sustain_slider_value_changed(value: float) -> void:
	gynth.sustain = value


func _on_release_slider_value_changed(value: float) -> void:
	gynth.release = value


func _on_speed_slider_value_changed(value: float) -> void:
	gynth.speed = value


func _on_controls_visible_box_toggled(toggled_on: bool) -> void:
	$Controls.visible = false
	
