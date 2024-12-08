extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO
var fall_speed = 400
var velocity = Vector2.ZERO
var inital_velocity = -250 #up is negative y

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	add_to_group("attack")
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	velocity = Vector2(angle.x * speed, inital_velocity)
	match level:
		1:
			hp = 1
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size) 
		2:
			hp = 1
			speed = 100
			damage = 7
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 2
			speed = 100
			damage = 7
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size) 
		4:
			hp = 2
			speed = 100
			damage = 10
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size) 


func _physics_process(delta):
	velocity.y += fall_speed * delta
	position += velocity * delta
	rotation = velocity.angle() + deg_to_rad(135)

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()


func _on_timer_timeout():
	queue_free()
