extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

#export allows the variable to be edited in the inspector gui
@export var speed = 80
var hp = 100
var maxhp = 100
var movement_direction = Vector2.ZERO
var experience = 0
var exp_level = 1
var collected_exp = 0
var time = 0

#attacks
var axe = preload("res://Scenes/weapons/axe.tscn")
var shield = preload("res://Scenes/weapons/shield.tscn")
var sword = preload("res://Scenes/weapons/sword.tscn")

#axew
var axe_ammo = 0
var axe_base_ammo = 0
var axe_attack_speed = 1.5
var axe_level = 0

#shield
var shield_ammo = 0
var shield_base_ammo = 0
var shield_attack_speed = 2.0
var shield_level = 0
var shield_duration = 10

#sword
var sword_ammo = 0
var sword_base_ammo = 0
var sword_attack_speed = 1.0
var sword_level = 0

#ring
var ring_level = 0

#mirror
var mirror_level = 0

#potion
var potion_level = 0

#UPGRADES
var collected_upgrades = []
var available_upgrades = []
var spell_size = 0 
var additional_attacks = 0


@onready var axe_timer = %AxeTimer
@onready var axe_attack_timer = %AxeAttackTimer
@onready var shield_timer = $Attack/ShieldTimer
@onready var shield_attack_timer = $Attack/ShieldTimer/ShieldAttackTimer
@onready var sword_timer = $Attack/SwordTimer
@onready var sword_attack_timer = $Attack/SwordTimer/SwordAttackTimer

#HUD
@onready var exp_bar = $HUDLayer/HUD/ExpBar
@onready var level_label = $HUDLayer/HUD/ExpBar/LevelLabel
@onready var level_panel = $HUDLayer/HUD/LevelUp
@onready var upgrade_options = %UpgradeOptions
@onready var item_options = preload("res://Scenes/item_option.tscn")
@onready var health_bar = %HealthBar
@onready var clock_label = %ClockLabel
@onready var current_weapons = %CollectedWeapons
@onready var current_upgrades = %CollectedUpgrades
@onready var item_container = preload("res://Utility/item_container.tscn")

#enemy locater
var enemy_close = []

func _process(delta: float) -> void:
	if hp <= 0:
		death()

func _ready() -> void:
	var starting_weapon = GameStateManager.get_starting_weapon()
	if starting_weapon != "":
		upgrade_character(starting_weapon)
		GameStateManager.clear_starting_weapon()
	attack()
	level_panel.visible = false
	set_exp_bar(experience, calculate_exp_cap())
	_on_hurt_box_hurt(0,0,0) #to initalize heatlh bar on spawn


func _physics_process(delta):
	movement()

func movement():
	var x_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_direction = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var move = Vector2(x_direction,y_direction)
	velocity = move.normalized() * speed
	
	if move.x < 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("default")
	elif move.x > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("default")
	move_and_slide()

func attack():
	if axe_level > 0:
		axe_timer.wait_time = axe_attack_speed
		if axe_timer.is_stopped():
			axe_timer.start()
			
	if shield_level > 0:
		if shield_timer.is_stopped():
			shield_timer.start()
			
	if sword_level > 0:
		if sword_timer.is_stopped():
			sword_timer.start()

func death():
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

# shield logic
func _on_shield_timer_timeout() -> void:
	shield_ammo += shield_base_ammo + additional_attacks
	shield_attack_timer.start()

func _on_shield_attack_timer_timeout() -> void:
	if shield_ammo > 0:
		var total_shields = 1 + additional_attacks  # additional_attacks comes from mirror upgrades
		
		# spawn the shields
		for i in total_shields:
			var shield_attack = shield.instantiate()
			shield_attack.position = position
			shield_attack.level = shield_level
			add_child(shield_attack)
			
		shield_ammo -= 1
		if shield_ammo > 0:
			shield_attack_timer.start()
		else:
			shield_attack_timer.stop()


# sword logic
func _on_sword_timer_timeout() -> void:
	sword_ammo += sword_base_ammo + additional_attacks
	sword_attack_timer.start()

func _on_sword_attack_timer_timeout() -> void:
	if sword_ammo > 0:
		var positions = ["left", "right"]
		for pos in positions:
			var sword_attack = sword.instantiate()
			sword_attack.position = position
			sword_attack.level = sword_level
			sword_attack.set_side(pos) 
			add_child(sword_attack)
		sword_ammo -= 1
		if sword_ammo > 0:
			sword_attack_timer.start()
		else:
			sword_attack_timer.stop()


# axe logic
func _on_axe_timer_timeout() -> void:
	axe_ammo += axe_base_ammo + additional_attacks
	axe_attack_timer.start()

func _on_axe_attack_timer_timeout() -> void:
	if axe_ammo > 0:
		var axe_attack = axe.instantiate()
		axe_attack.position = position
		axe_attack.target = get_random_target()
		axe_attack.level = axe_level
		add_child(axe_attack)
		axe_ammo -= 1
		if axe_ammo > 0:
			axe_attack_timer.start()
		else:
			axe_attack_timer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_hurt_box_hurt(damage: Variant, angle: Variant, knockback: Variant) -> void:
	hp -= damage
	print(hp)
	health_bar.max_value = maxhp
	health_bar.value = hp

func _on_enemy_detector_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detector_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)

func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self #self being player

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var coin_exp = area.collect()
		calculate_exp(coin_exp)
 
func calculate_exp(coin_exp):
	var exp_required = calculate_exp_cap()
	collected_exp += coin_exp
	if experience + collected_exp >= exp_required:
		collected_exp -= exp_required
		exp_level += 1
		level_label.text = str("Level: ", exp_level)
		experience = 0
		exp_required = calculate_exp_cap()
		level_up()
		calculate_exp(0)
	else:
		experience += collected_exp
		collected_exp = 0
	set_exp_bar(experience, exp_required)

func calculate_exp_cap():
	var exp_cap = exp_level 
	if exp_level < 20:
		exp_cap = exp_level * 5
	elif exp_level < 40:
		exp_cap + 95 * (exp_level-19) * 8
	else:
		exp_cap = 255 + (exp_level - 39) * 12
	return exp_cap
		
func set_exp_bar(set_value = 1, set_max_value = 100):
	exp_bar.value = set_value
	exp_bar.max_value = set_max_value

func level_up():
	level_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	upgrade_options.process_mode = Node.PROCESS_MODE_ALWAYS
	level_label.text = str("Level: ", exp_level)
	level_panel.visible = true
	var options = 0
	var options_max = 3
	while options < options_max:
		var option_choice = item_options.instantiate()
		option_choice.item = get_random_item()
		upgrade_options.add_child(option_choice)
		options += 1
	get_tree().paused = true 

func upgrade_character(upgrade):
	match upgrade:
		# axe upgrades - focus on number of axes and attack speed
		"axe1":
			axe_level = 1
			axe_base_ammo += 1    # start with one axe
		"axe2":
			axe_level = 2
			axe_attack_speed -= 0.3  # faster throwing
		"axe3":
			axe_level = 3
			axe_base_ammo += 1    # additional axe
		"axe4":
			axe_level = 4
			axe_base_ammo += 1    # one more axe

		# shield upgrades
		"shield1":
			shield_level = 1
			shield_base_ammo += 1  # initial shield
		"shield2":
			shield_level = 2
			shield_duration += 1.0  # shield lasts longer
		"shield3":
			shield_level = 3
			shield_base_ammo += 1  # additional shield
		"shield4":
			shield_level = 4
			shield_base_ammo += 1  # one more shield

		# sword upgrades
		"sword1":
			sword_level = 1
			sword_base_ammo += 1   # initial sword swing
		"sword2":
			sword_level = 2
			sword_attack_speed -= 0.2  # faster attacks
		"sword3":
			sword_level = 3
			sword_base_ammo += 1   # additional attack
		"sword4":
			sword_level = 4
			sword_base_ammo += 1   # additional attack

		# ring upgrades
		"ring1":
			ring_level = 1
			spell_size += 0.10    # 10% increase
		"ring2":
			ring_level = 2
			spell_size += 0.15    # additional 15%
		"ring3":
			ring_level = 3
			spell_size += 0.20    # additional 20%
		"ring4":
			ring_level = 4
			spell_size += 0.25    # additional 25%

		# mirror upgrades
		"mirror1":
			mirror_level = 1
			additional_attacks += 1  
		"mirror2":
			mirror_level = 2
			additional_attacks += 1  
		"mirror3":
			mirror_level = 3
			additional_attacks += 1  
		"mirror4":
			mirror_level = 4
			additional_attacks += 1  

		# potion upgrades - Max Health
		"potion1":
			potion_level = 1
			maxhp += 10            # +10 max health
		"potion2":
			potion_level = 2
			maxhp += 15            # additional +15
		"potion3":
			potion_level = 3
			maxhp += 20            # additional +20
		"potion4":
			potion_level = 4
			maxhp += 25            # additional +25
		
	# keep track of updated max hp
	if upgrade.begins_with("potion"):
		hp = clamp(hp, 0, maxhp)
	update_HUD(upgrade)
	attack()
	var options_children = upgrade_options.get_children()
	for i in options_children:
		i.queue_free()
	available_upgrades.clear()
	collected_upgrades.append(upgrade)
	level_panel.visible = false
	get_tree().paused = false
	calculate_exp(0)
	
func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #find already collected upgrades
			pass
		elif i in available_upgrades: #if the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #check for PreRequisites
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		available_upgrades.append(randomitem)
		return randomitem
	else:
		return null

func change_time(argtime = 0):
	time = argtime
	var get_minutes = int(time/60)
	var get_seconds = time % 60
	if get_minutes < 10:
		get_minutes = str(0, get_minutes)
	if get_seconds < 10:
		get_seconds = str(0, get_seconds)
	clock_label.text = str(get_minutes,":",get_seconds)

func update_HUD(upgrade):
	var get_upgraded_display_name = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item": #food
		var get_collected_display_names = []
		for i in collected_upgrades:
			get_collected_display_names.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_display_name in get_collected_display_names:
			var new_item = item_container.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					current_weapons.add_child(new_item)
				"upgrade":
					current_upgrades.add_child(new_item) 
