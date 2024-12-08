extends Area2D

var level = 1
var damage = 5
var knockback_amount = 100
var attack_size = 1.0
var side = "left"  
var offset_distance = 50
var lifetime = 0.5  

@onready var player = get_tree().get_first_node_in_group("player")

func set_side(new_side: String) -> void:
	side = new_side

func _ready():
	add_to_group("attack")
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	
	match level:
		1:
			damage = 5
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			damage = 7
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			damage = 7
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			damage = 10
			attack_size = 1.0 * (1 + player.spell_size)

func _process(_delta: float) -> void:
	var offset = Vector2(offset_distance if side == "right" else -offset_distance, 0)
	global_position = player.global_position + offset

func _on_timer_timeout() -> void:
	queue_free() 
