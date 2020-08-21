extends Node2D

onready var tilemap = $TileMap;
onready var player = $Player;
onready var enemy = $Enemy;
onready var stream = $AudioStreamPlayer2D;
onready var hp = $ProgressBar;

var last_attack_x = -1;
var last_attack_y = -1;

var danger_tiles = [];
var danger_timeout = 1;
var max_danger_timeout = 1;

var beat_timer = 0;
var seconds_per_beat = 0.5;

var enemy_hp = 100;

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("attack", self, "_on_attack");
	enemy.connect("attack", self, "_on_enemy_attack");
	randomize();
	_random_attack_tile();
	hp.value = enemy_hp;

func _random_attack_tile():
	var x = last_attack_x;
	var y = last_attack_y;
	tilemap.set_cell(x, y, 0);
	while x == last_attack_x:
		x = floor(rand_range(2, 5))
	while y == last_attack_y:
		y = floor(rand_range(1, 4))
	tilemap.set_cell(x, y, 1);
	last_attack_x = x;
	last_attack_y = y;

func _on_attack(x, y):
	x += 2;
	y += 1;
	if (last_attack_x == x and last_attack_y == y):
		print("ATTACK");
		_random_attack_tile(); 
		enemy_hp -= 10;
		hp.value = enemy_hp;
		
func _on_enemy_attack(attack, x, y):
	if danger_timeout > 0:
		return;
	danger_timeout = max_danger_timeout;
	if attack == "ROW":
		danger_tiles = [Vector2(0, y),Vector2(1, y),Vector2(2, y)];
	elif attack == "COLUMN":
		danger_tiles = [Vector2(x, 0),Vector2(x, 1),Vector2(x, 2)];
		
func _process(delta):
	danger_timeout -= delta;
	beat_timer += delta;
	if beat_timer > seconds_per_beat:
		if not stream.playing:
			stream.play();
		if danger_timeout < 0:
			for tile in danger_tiles:
				if tilemap.get_cell(tile.x + 2, tile.y + 1) != 0:
					if player.x == tile.x and player.y == tile.y:
						print("DED");
						player.queue_free();
				tilemap.set_cell(tile.x + 2, tile.y + 1, 0);
			tilemap.set_cell(last_attack_x, last_attack_y, 1);
		else:
			for tile in danger_tiles:
				tilemap.set_cell(tile.x + 2, tile.y + 1, 2);
			tilemap.set_cell(last_attack_x, last_attack_y, 1);
