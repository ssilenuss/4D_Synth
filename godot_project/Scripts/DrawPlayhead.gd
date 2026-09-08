extends Control

@onready var playback_visualizer : PlaybackVisualizer = get_parent()

func _ready() -> void:
	playback_visualizer.redraw_playhead.connect(queue_redraw)


func _draw() -> void:
	var playhead_x :float = lerpf(0.0, size.x, playback_visualizer.playback_position/playback_visualizer.end_position)
	var playhead_points : PackedVector2Array = [Vector2(playhead_x, 0.0), Vector2(playhead_x, size.y)]
	draw_polyline(playhead_points, playback_visualizer.playhead_color, 3.0)
