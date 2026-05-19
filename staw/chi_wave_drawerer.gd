@tool
extends Line2D
class_name Heartbeat

@export var set_spacing := 1.0
@export var set_speed := 5.0
@export var set_amp := 1.0


@export var spacing = 1.0
@export var speed = 1.0
@export var amp = 1.0
@export var change_speed = 1.0

@onready var r_amp = amp

var time = 0.0
func _ready() -> void:
	speed = set_speed
	amp = set_amp
	spacing = set_spacing
func _physics_process(delta):
	time += delta
	print(change_speed)
	r_amp = move_toward(r_amp, amp, change_speed * delta)
	for i in points.size():
		var sin_time = time * speed + i
		var t_amp = r_amp + cos(sin_time / 10) * 1.2 + sin(sin_time / 25) * 2
		points[i].y = sin(sin_time) * r_amp / 2 + cos(sin_time / 2) * t_amp
		points[i].x = i * spacing
		if i == points.size() - 1:
			sin_time -= 1
			points[i].y = sin(sin_time) * r_amp / 2 + cos(sin_time / 2) * r_amp
			points[i].x = (i - 0.999) * spacing
		if i == 0:
			sin_time = time * speed + 1
			points[i].y = sin(sin_time) * r_amp / 2 + cos(sin_time / 2 + 1) * r_amp
			points[i].x = 0.999 * spacing
func set_params(new_spacing = spacing, new_speed = speed, new_amp = amp):
	set_spacing = new_spacing
	set_speed = new_speed
	set_amp = new_amp

func realize(value : float) -> float:
	return randfn(value, value/10)
