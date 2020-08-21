extends KinematicBody2D

signal attack;

var x = 0;
var y = 0;

var seconds_per_beat = 0.5;
var beat_timer =seconds_per_beat / 2;

var error_cutoff = 0.1;

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	beat_timer += delta;
	if beat_timer > seconds_per_beat:
		print("BEAT");
		beat_timer -= seconds_per_beat;
		
	var error = min(beat_timer, seconds_per_beat - beat_timer);
	
	if (error > error_cutoff):
		return;
	if Input.is_action_just_pressed("down") and y < 2:
		position.y += 32;
		position.x -= 3;
		y+=1;
	if Input.is_action_just_pressed("up") and y > 0:
		position.y -= 32;
		position.x += 3;
		y-=1;
	if Input.is_action_just_pressed("left") and x > 0:
		position.x -= 29;
		x-=1;
	if Input.is_action_just_pressed("right") and x < 2:
		position.x += 29;
		x+=1;
	if Input.is_action_just_pressed("attack"):
		print(beat_timer);
		emit_signal("attack", x, y);
