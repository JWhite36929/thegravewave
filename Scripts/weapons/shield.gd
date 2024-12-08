extends Area2D

var level = 1
var speed = 150
var damage = 5
var angle = Vector2.ZERO
var velocity = Vector2.ZERO
var attack_size = 1.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var ray = $RayCast2D  # Reference the RayCast2D as a child node

func _ready() -> void:
	add_to_group("attack")
	
	match level:
		1:
			speed = 150
			damage = 5
			attack_size = 1.0 * (1 + player.spell_size) 
		2:
			speed = 175
			damage = 7
			attack_size = 1.0 * (1 + player.spell_size) 
		3:
			speed = 200
			damage = 10
			attack_size = 1.0 * (1 + player.spell_size) 
		4:
			speed = 225
			damage = 10
			attack_size = 1.0 * (1 + player.spell_size) 
	
	
	# random initial angle
	var random_angle = randf_range(0, 2 * PI)
	angle = Vector2(cos(random_angle), sin(random_angle))
	velocity = angle * speed

func _physics_process(delta: float) -> void:
	# update raycast direction to match movement
	ray.target_position = velocity.normalized() * 10
	ray.force_raycast_update()
	
	# check for wall collision
	if ray.is_colliding():
		var collision_normal = ray.get_collision_normal()
		velocity = velocity.bounce(collision_normal)
		ray.target_position = velocity.normalized() * 10
	
	position += velocity * delta
	rotation += 10.0 * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurt_box"):
		if area.has_method("hurt"):
			area.hurt(damage, global_position.direction_to(area.global_position), 0)

func _on_timer_timeout() -> void:
	queue_free()
