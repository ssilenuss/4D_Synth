@tool
extends TextureRect

class_name OpticalSoundtrackSynth

enum SoundtrackMode {VARIABLE_DENSITY,VARIABLE_AREA}

@export var play : bool = false:
	set(value):
		play = value
		if play and player:
			player.play()
			playback = player.get_stream_playback()
			playhead.visible = true
		else:
			player.stop()
			playhead.visible = false
			

@export var soundtrack_mode : SoundtrackMode = SoundtrackMode.VARIABLE_DENSITY
@export var scan_speed : float = 120.0
@export var slit_width : int = 5
@export var master_volume : float = 0.8
@export var flutter_amount : float = 0.002
@export var flutter_rate : float = 4.0
@export var grain_amount : float = 0.01
@export var refresh_image_each_frame : bool = false
@export var lowpass_strength : float = 0.2

var image : Image
var stream : AudioStreamGenerator
var playback : AudioStreamGeneratorPlayback
@onready var player : AudioStreamPlayer = $AudioStreamPlayer
@onready var playhead : ColorRect = $Playhead

var sample_rate : float = 44100.0
var scan_position : float = 0.0
var flutter_phase : float = 0.0
var previous_output : float = 0.0

var image_width : int
var image_height : int



func _ready() -> void:
	if texture == null:
		push_error("TextureRect has no texture.")
		return

	_update_image()
	player.play()
	playback = player.get_stream_playback()
	player.stop()

func _update_image() -> void:
	if texture == null:	return

	image = texture.get_image()
	image_width = image.get_width()
	image_height = image.get_height()

func _process(_delta: float) -> void:
	if playback == null:

		print("playback is null, returning")
		return

	if refresh_image_each_frame:
		_update_image()

	var available := playback.get_frames_available()

	for i in range(available):
		var sample := _generate_sample()
		playback.push_frame(Vector2(sample, sample))
		
	if play:
		playhead.position.x = (scan_position / image_width) * size.x
		playhead.size.x =(slit_width / float(image_width)) * size.x
		playhead.size.y = size.y

func _generate_sample() -> float:
	if image == null:
		return 0.0

	var flutter := sin(flutter_phase) * flutter_amount
	flutter_phase += (TAU * flutter_rate / sample_rate)

	scan_position += (scan_speed * (1.0 + flutter)) / sample_rate

	while scan_position >= image_width:
		scan_position -= image_width

	var raw_sample : float

	match soundtrack_mode:
		SoundtrackMode.VARIABLE_DENSITY:
			raw_sample = _sample_variable_density()
		SoundtrackMode.VARIABLE_AREA:
			raw_sample = _sample_variable_area()
		_:
			raw_sample = 0.0

	raw_sample += randf_range(-grain_amount, grain_amount)

	var filtered :float= lerp(raw_sample, previous_output, lowpass_strength)
	previous_output = filtered

	filtered *= master_volume
	return clampf(filtered, -1.0, 1.0)

func _sample_variable_density() -> float:
	var x := int(scan_position)
	var total := 0.0

	for y in range(image_height):
		var brightness := _read_slit_brightness(x, y)
		total += brightness

	total /= float(image_height)
	return total * 2.0 - 1.0

func _sample_variable_area() -> float:
	var x := int(scan_position)
	var bright_pixels := 0.0

	for y in range(image_height):
		var brightness := _read_slit_brightness(x, y)
		if brightness > 0.5:
			bright_pixels += 1.0

	var area := bright_pixels / float(image_height)
	return area * 2.0 - 1.0

func _read_slit_brightness(x: int, y: int) -> float:
	var total := 0.0
	var count := 0
	var half := slit_width / 2

	for sx in range(x - half, x + half + 1):
		var wrapped_x := posmod(sx, image_width)
		var pixel := image.get_pixel(wrapped_x, y)

		var luminance := (
			pixel.r * 0.2126 +
			pixel.g * 0.7152 +
			pixel.b * 0.0722
		)

		total += luminance
		count += 1

	if count == 0:
		return 0.0

	return total / float(count)

func restart_scan() -> void:
	scan_position = 0.0

func set_speed(new_speed: float) -> void:
	scan_speed = max(new_speed, 0.001)

func set_volume(new_volume: float) -> void:
	master_volume = clamp(new_volume, 0.0, 1.0)
	
