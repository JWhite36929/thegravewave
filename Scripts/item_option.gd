extends ColorRect

# keeping track of mouse interaction state
var mouse_over = false
var item = null

# grabbing ui elements
@onready var label_name = $LabelName
@onready var label_desc = $LabelDescription
@onready var label_level = $LabelLevel
@onready var item_icon = $ColorRect/ItemIcon

# need player reference to send upgrades to
@onready var player = get_tree().get_first_node_in_group("player")

# signal to tell player when an upgrade is picked
signal selected_upgrade(upgrade)

func _ready() -> void:
	# default to food if nothing else set
	if item == null:
		item = "food"
	# connect signal to the player's upgrade function
	selected_upgrade.connect(player.upgrade_character)
	# populate the ui elements from our upgrade database
	label_name.text = UpgradeDb.UPGRADES[item]["displayname"]
	label_desc.text = UpgradeDb.UPGRADES[item]["details"]
	label_level.text = UpgradeDb.UPGRADES[item]["level"]
	item_icon.texture = load(UpgradeDb.UPGRADES[item]["icon"])


func _input(event):
	if event.is_action_pressed("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item)

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
