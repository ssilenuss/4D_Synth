extends Control

@export var background_color : Color
@export var gynth : AudioOsc2D
@export var delay_bus_idx : int
var effect : AudioEffectDelay



func _ready() -> void:
	effect = AudioServer.get_bus_effect(gynth.bus_idx,delay_bus_idx)
	visible = false
	
func _on_delay_settings_close_button_pressed() -> void:
	visible = false

func _on_dry_slider_value_changed(value: float) -> void:
	effect.set_dry(value)


func _draw()->void:
	draw_rect(Rect2(Vector2.ZERO, size), background_color)


func _on_resized() -> void:
	queue_redraw()


func _on_delay_checkbox_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_effect_enabled(gynth.bus_idx, delay_bus_idx, toggled_on)


func _on_tap_1_delay_slider_value_changed(value: float) -> void:
	effect.set_tap1_delay_ms(value)


func _on_tap_1_level_slider_value_changed(value: float) -> void:
	effect.set_tap1_level_db(value)


func _on_tap_1_pan_slider_value_changed(value: float) -> void:
	effect.set_tap1_pan(value)


func _on_tap_2_delay_slider_value_changed(value: float) -> void:
	effect.set_tap2_delay_ms(value)

func _on_tap_2_level_slider_value_changed(value: float) -> void:
	effect.set_tap2_level_db(value)


func _on_tap_2_pan_slider_value_changed(value: float) -> void:
	effect.set_tap2_pan(value)


func _on_feedback_level_slider_value_changed(value: float) -> void:
	effect.set_feedback_level_db(value)


func _on_feedback_delay_slider_value_changed(value: float) -> void:
	effect.set_feedback_delay_ms(value)


func _on_feedback_low_pass_slider_value_changed(value: float) -> void:
	effect.set_feedback_lowpass(value)


func _on_feedback_check_box_toggled(toggled_on: bool) -> void:
	effect.set_feedback_active(toggled_on)


func _on_tap_1_check_box_toggled(toggled_on: bool) -> void:
	effect.set_tap1_active(toggled_on)


func _on_tap_2_check_box_toggled(toggled_on: bool) -> void:
	effect.set_tap2_active(toggled_on)


func _on_delay_settings_pressed() -> void:
	visible = true


func _on_settings_close_button_pressed() -> void:
	visible = false
