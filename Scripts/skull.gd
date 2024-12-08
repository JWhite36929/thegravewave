extends CharacterBody2D

@export var movement_speed = 18
@export var hp = 15
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO

@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var shoot_timer = $ShootTimer
var projectile = preload("res://Scenes/projectile.tscn") 
var coin = preload("res://Scenes/xp_coin.tscn")

# pathing vars
var circle_radius = 150  # distance from player
var angular_speed = 2  # rotation speed
var current_angle = 0

signal remove_from_array(object)

func _ready() -> void:
	# initialize shoot timer
	shoot_timer.start()
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	# set initial position relative to player
	current_angle = global_position.angle_to_point(player.global_position)

func _physics_process(delta):
	# handle knockback
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	
	# calculate desired position on circle around player
	current_angle += angular_speed * delta
	var desired_position = player.global_position + Vector2(
		cos(current_angle) * circle_radius,
		sin(current_angle) * circle_radius
	)
	
	# move towards the desired position
	var direction = global_position.direction_to(desired_position)
	velocity = direction * movement_speed
	velocity += knockback
	
	# update sprite direction
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	move_and_slide()

func _on_shoot_timer_timeout():
	var new_projectile = projectile.instantiate()
	new_projectile.position = position 
	new_projectile.direction = global_position.direction_to(player.global_position)
	get_parent().add_child(new_projectile)

func death():
	emit_signal("remove_from_array", self)
	var coin_instance = coin.instantiate()
	coin_instance.global_position = global_position
	get_parent().call_deferred("add_child", coin_instance)
	queue_free()


func _on_hurt_box_hurt(damage: float, angle: Vector2, knockback_amount: float):
	print("Skull took damage: ", damage) # Add this line
	hp -= damage 
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
