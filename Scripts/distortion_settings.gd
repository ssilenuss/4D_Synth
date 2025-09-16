extends Control

@export var background_color : Color
@export var gynth : AudioOsc2D
@export var effect_bus_idx : int
@export var mode_menu: MenuButton
var mode_popup:PopupMenu
var effect : AudioEffectDistortion



func _ready() -> void:
	effect = AudioServer.get_bus_effect(gynth.bus_idx,effect_bus_idx)
	mode_popup = mode_menu.get_popup()
	mode_popup.id_pressed.connect(_on_popup_selected)
	_on_popup_selected(0)
	_on_drive_slider_value_changed(0.5)
	visible = false
	

func _draw()->void:
	draw_rect(Rect2(Vector2.ZERO, size), background_color)


func _on_resized() -> void:
	queue_redraw()


func _on_settings_close_button_pressed() -> void:
	visible = false

func _on_popup_selected(id: int)->void:
	mode_menu.text = mode_popup.get_item_text(id)
	effect.set_mode(id)
	



func _on_distortion_settings_pressed() -> void:
	visible = true


func _on_distortion_checkbox_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_effect_enabled(gynth.bus_idx, effect_bus_idx, toggled_on)


func _on_reset_button_pressed() -> void:
	var id : int = 0
	mode_menu.text = mode_popup.get_item_text(id)
	effect.set_mode(id)


func _on_drive_slider_value_changed(value: float) -> void:
	effect.set_drive(value)


func _on_keep_h_fhz_slider_value_changed(value: float) -> void:
	effect.set_keep_hf_hz(value)


func _on_pre_gain_slider_value_changed(value: float) -> void:
	effect.set_pre_gain(value)


func _on_post_gain_slider_value_changed(value: float) -> void:
	effect.set_post_gain(value)
