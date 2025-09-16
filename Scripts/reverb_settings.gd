extends Control

@export var background_color : Color
@export var gynth : AudioOsc2D
@export var reverb_bus_idx : int
var effect : AudioEffectReverb



func _ready() -> void:
	effect = AudioServer.get_bus_effect(gynth.bus_idx,reverb_bus_idx)
	visible = false
	
func _on_reverb_settings_close_button_pressed() -> void:
	visible = false


func _on_room_size_slider_value_changed(value: float) -> void:
	effect.set_room_size(value)


func _on_damping_slider_value_changed(value: float) -> void:
	effect.set_damping(value)


func _on_spread_slider_value_changed(value: float) -> void:
	effect.set_spread(value)

func _on_hi_pass_slider_value_changed(value: float) -> void:
	effect.set_hpf(value)


func _on_dry_slider_value_changed(value: float) -> void:
	effect.set_dry(value)


func _on_wet_slider_value_changed(value: float) -> void:
	effect.set_wet(value)


func _on_predelay_msec_slider_value_changed(value: float) -> void:
	effect.set_predelay_msec(value)


func _on_predelay_feedback_slider_value_changed(value: float) -> void:
	effect.set_predelay_feedback(value)


func _on_reverb_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_effect_enabled(gynth.bus_idx, reverb_bus_idx, toggled_on)


func _on_reverb_settings_pressed() -> void:
	visible = true

func _draw()->void:
	draw_rect(Rect2(Vector2.ZERO, size), background_color)


func _on_resized() -> void:
	queue_redraw()
