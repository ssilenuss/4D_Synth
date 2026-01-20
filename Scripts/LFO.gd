extends Control
class_name LFO_Controller

@export var enable_checkbox: CheckBox
@export var wav_vis: Control
@export var speed_slider: HSlider
@export var speed_label: Label
@export var wav_menu: MenuButton
@export var gynth : AudioOsc2D
@export var gynth_freq_slider : HSlider
@export var gynth_amp_slider : HSlider
var wav_menu_popup: PopupMenu
@export var fm_menu_popup : MenuButton
@export var am_menu_popup : MenuButton
@export var noise :FastNoiseLite= FastNoiseLite.new()
@export var lfo_controls : Control 

var wave_type: int 
var enabled: bool
var fm_enabled : bool
var am_enabled : bool
var speed : float
var value : float = 0.0
var phase : float = 0.0
var fm_depth: float = 0.0
var am_depth : float = 0.0

func _ready()->void:
	wav_menu_popup = wav_menu.get_popup()
	wav_menu_popup.id_pressed.connect(_on_wav_menu_popup_selected)
	
	_on_wav_menu_popup_selected(0)
	_on_check_box_lfo_enable_toggled(false)
	_on_speed_slider_value_changed(speed_slider.max_value/4.0)
	
	_on_fm_depth_value_changed(0.1)
	_on_am_depth_value_changed(0.1)
	
func _on_wav_menu_popup_selected(id: int)->void:
	wav_menu.text = "WAVE: " + wav_menu_popup.get_item_text(id)
	wave_type = id
	
func _process(delta: float) -> void:
	if enabled:
		var increment : float = delta*speed
		match wave_type:
			0: #sin
				value = sin(phase*TAU)
				phase = fmod(phase+increment, 1.0)
			1: #saw_buffer
				phase = fmod(phase+increment, 1.0)
				value = (phase*2.0)-1.0
			2:#pulse_buffer
				phase = fmod(phase+increment, 1.0)
				value = (phase*2.0)-1.0
				value *= -1
			3:
				phase = fmod(phase+increment, 1.0)
				if phase <0.5:
					value = -1.0
				else:
					value = 1.0
			4:
				value = noise.get_noise_1d(0.0)
				noise.offset.x += increment*10
		var c : float = (value +1.0) / 2.0
		speed_slider.modulate = Color(c, 0.0, c, 1.0)

		if fm_enabled:
			var freq : float = gynth_freq_slider.value
			var f : float = (value*fm_depth)+freq
			if f >0.001:
				gynth.pitch = f
		
		if am_enabled:
			var amp : float = gynth_amp_slider.value
			var a: float = (value*am_depth)*10+amp
			if a > 0.0 and a < 10.0:
				gynth.limiter = a
			
			


func _on_speed_slider_value_changed(speed_val: float) -> void:
	speed = speed_val


func _on_check_box_lfo_enable_toggled(toggled_on: bool) -> void:
	enabled = toggled_on
	
	for c in lfo_controls.get_children():
		c.visible = toggled_on
	

func _on_fm_depth_value_changed(v: float)->void:
	fm_menu_popup.text = "FM Depth: " + str(v)
	fm_depth = v

func _on_am_depth_value_changed(v: float)->void:
	am_menu_popup.text = "AM Depth: " + str(v)
	am_depth = v

func _on_fm_vslider_popup_menu_about_to_popup() -> void:
	var popup:PopupMenu = fm_menu_popup.get_popup()
	var v_slider = VSlider.new()
	v_slider.set_anchors_preset(Control.PRESET_FULL_RECT)
	v_slider.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v_slider.value = fm_depth
	v_slider.max_value = 1.0
	v_slider.min_value = 0.0
	v_slider.step = 0.001
	v_slider.value_changed.connect(_on_fm_depth_value_changed)
	var min_size : float = 100
	popup.min_size.y = int(min_size)
	v_slider.custom_minimum_size.y = min_size
	popup.add_child(v_slider)


func _on_check_box_fm_toggled(toggled_on: bool) -> void:
	fm_menu_popup.visible = toggled_on
	fm_enabled = toggled_on
	if not toggled_on:
		gynth.pitch = gynth_freq_slider.value


func _on_check_box_am_toggled(toggled_on: bool) -> void:
	am_menu_popup.visible = toggled_on
	am_enabled = toggled_on
	if not toggled_on:
		gynth.limiter = gynth_amp_slider.value

func _on_am_vslider_popup_menu_about_to_popup() -> void:
	var popup:PopupMenu = am_menu_popup.get_popup()
	var v_slider = VSlider.new()
	v_slider.set_anchors_preset(Control.PRESET_FULL_RECT)
	v_slider.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v_slider.value = am_depth
	v_slider.max_value = 1.0
	v_slider.min_value = 0.0
	v_slider.step = 0.001
	v_slider.value_changed.connect(_on_am_depth_value_changed)
	var min_size : float = 100
	popup.min_size.y = int(min_size)
	v_slider.custom_minimum_size.y = min_size
	popup.add_child(v_slider)
