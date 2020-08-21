extends KinematicBody2D

signal attack;

var x = 1;
var y = 1;

var timer;
var health = 100;

var seconds_per_beat = 0.5;
var beat_timer = seconds_per_beat / 2;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	beat_timer += delta;
	if beat_timer > seconds_per_beat:

		beat_timer -= seconds_per_beat;
		
		var moved = false;
		while not moved:
			var directions = ["UP", "DOWN", "LEFT", "RIGHT", "ATTACK"];
			var dir = directions[randi() % directions.size()];
			if dir == "DOWN" and y < 2:
				position.y += 32;
				position.x -= 3;
				y+=1;
				moved = true;
			if dir == "UP" and y > 0:
				position.y -= 32;
				position.x += 3;
				y-=1;
				moved = true;
			if dir == "LEFT" and x > 0:
				position.x -= 29;
				x-=1;
				moved = true;
			if dir == "RIGHT" and x < 2:
				position.x += 29;
				x+=1;
				moved = true;
			if dir == "ATTACK":
				moved = true;
				
				var attacks = ["ROW", "COLUMN"];
				var attack = attacks[randi() % attacks.size()];
				emit_signal('attack', attack, x, y);
