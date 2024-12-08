extends CharacterBody2D

@export var movement_speed = 22
@export var hp = 10
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO

@onready var player = get_tree().get_nodes_in_group("player")[0] # Get first player node

var coin = preload("res://Scenes/xp_coin.tscn")

signal remove_from_array(object)

func _ready() -> void:
	$wallCollision.disabled = true

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	velocity += knockback
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("default")
	elif direction.x > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("default")
	move_and_slide()

func death():
	emit_signal("remove_from_array", self)
	var coin_instance = coin.instantiate()
	coin_instance.global_position = global_position
	get_parent().call_deferred("add_child", coin_instance)
	queue_free()


func _on_hurt_box_hurt(damage: Variant, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()


func _on_timer_timeout() -> void:
	$wallCollision.disabled = false
