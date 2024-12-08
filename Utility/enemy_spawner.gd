extends Node2D

#utilizing a feature from godot 4 to put custom classes into an array
@export var spawns: Array[Spawn_info] = []
@export var time = 0

@onready var player = get_tree().get_first_node_in_group("player")

signal changetime(time)

func _ready() -> void:
	changetime.connect(player.change_time) 


func _on_timer_timeout() -> void:
	time += 1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1 #spawn an enemy once every 2 seconds 
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn)
					counter += 1
	emit_signal("changetime", time)


func get_random_position():
	var floor_tile = $"../Floor"  
	var floor_rect = floor_tile.get_used_rect()
	var tile_size = floor_tile.tile_set.tile_size
	
	var x_spawn = randf_range(
		floor_rect.position.x * tile_size.x,
		(floor_rect.position.x + floor_rect.size.x) * tile_size.x
	)
	var y_spawn = randf_range(
		floor_rect.position.y * tile_size.y,
		(floor_rect.position.y + floor_rect.size.y) * tile_size.y
	)
	
	return Vector2(x_spawn, y_spawn)
	
	
