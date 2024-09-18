extends Node


var stereo := true
var mix_rate := 48000
var format := 1
var file : AudioStreamWAV
var last_file: AudioStreamWAV

@onready var record_effect : AudioEffectRecord = AudioServer.get_bus_effect(0,0)
@onready var record_button : Button = $RecordButton
@onready var play_button : Button = $PlayButton
@onready var save_button : Button = $SaveButton
@onready var playback : AudioStreamPlayer = $Playback
@onready var file_dialog : FileDialog = $FileDialog
@onready var loop_button : CheckBox = $LoopButton
@onready var status : Label = $Status

var recording : bool : set = set_recording
func set_recording(v: bool)->void:
	recording = v

var playing : bool : set = set_playing
func set_playing(v: bool)->void:
	playing = v

func _ready() -> void:
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.root_subfolder = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	file_dialog.filters = ["*.wav ; WAV File"]
	file_dialog.file_selected.connect(on_file_dialog_file_selected)





func _on_save_button_pressed() -> void:
	if file:
		file_dialog.popup_centered_ratio(0.6)
		
	else:
		status.text = "No file to save.  Record first."

func on_file_dialog_file_selected(path:String) -> void:
	file.save_to_wav(path)
	status.text = "Saved: " + path


func _on_play_button_pressed() -> void:
	if not playback.is_playing():
		if not file:
			status.text = "There is no recording to play."
		else:
			playback.stream = file
			play_button.modulate = Color(0.0,1.0,0.0,1.0)
			playback.play()
			status.text = "Playing last recording"
	else:
		playback.stop()
		play_button.modulate = Color(1.0,1.0,1.0,1.0)
		status.text = ""


func _on_record_button_pressed() -> void:
	if record_effect.is_recording_active():
		if playback.is_playing():
			playback.stop()
			playback.stream = null
			play_button.modulate = Color(1.0,1.0,1.0,1.0)
			status.text = ""
		file = record_effect.get_recording()
		play_button.disabled = false
		save_button.disabled = false
		record_effect.set_recording_active(false)
		file.set_mix_rate(mix_rate)
		file.set_format(format)
		file.set_stereo(stereo)
		record_button.modulate = Color(1.0,1.0,1.0,1.0)
		status.text = "File recorded."
	else:
		#play_button.disabled = true
		save_button.disabled = true
		record_effect.set_recording_active(true)
		record_button.modulate = Color(1.0,0.0,0.0,1.0)
		status.text = "Recording"
	pass # Replace with function body.


func _on_playback_finished() -> void:
	if loop_button.button_pressed:
		playback.play()
	else:
		play_button.modulate = Color(1.0,1.0,1.0,1.0)
		status.text = ""
