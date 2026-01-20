extends Node

# Keep the number of samples per second to mix low, as GDScript is not super fast.
@export var sample_hz := 22050.0
@export var pulse_hz := 440.0
@export_range(0.0,1.0,0.0001) var freq : float = 1.0
var phase := 0.0

# Actual playback stream, assigned in _ready().
var playback: AudioStreamPlayback

@export var fast_noise : FastNoiseLite

func _fill_buffer() -> void:
	var increment := pulse_hz / sample_hz

	var to_fill: int = playback.get_frames_available()
	while to_fill > 0:
		#original
		#playback.push_frame(Vector2.ONE * sin(phase * TAU)) # Audio frames are stereo.
		#phase = fmod(phase + increment, 1.0)
		
		#whitenoise
		#playback.push_frame(Vector2.ONE * randf())
		
		#fast_noise
		var noise : float = fast_noise.get_noise_1d(0)
		noise = (noise + 1.0)/2.0
		fast_noise.offset.x+=freq
		playback.push_frame(Vector2.ONE * noise)
		
		
		to_fill -= 1


func _process(_delta: float) -> void:
	_fill_buffer()



func _ready() -> void:
	# Setting mix rate is only possible before play().
	$Player.stream.mix_rate = sample_hz
	$Player.play()
	playback = $Player.get_stream_playback()
	# `_fill_buffer` must be called *after* setting `playback`,
	# as `fill_buffer` uses the `playback` member variable.
	_fill_buffer()
	
	
	
	
