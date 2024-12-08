extends Node

const PNG_PATH = "res://Assets/Upgrades/"

const UPGRADES = {
   "axe1": {
	   "icon": PNG_PATH + "axe.png", 
	   "displayname": "Axe",
	   "details": "Throws an axe at enemies",
	   "level": "Level: 1",
	   "prerequisite": [],
	   "type": "weapon"
   },
   "axe2": {
	   "icon": PNG_PATH + "axe.png",
	   "displayname": "Axe", 
	   "details": "Damage increased by 2",
	   "level": "Level: 2", 
	   "prerequisite": ["axe1"],
	   "type": "weapon"
   },
   "axe3": {
	   "icon": PNG_PATH + "axe.png",
	   "displayname": "Axe",
	   "details": "Throws an additional axe",
	   "level": "Level: 3",
	   "prerequisite": ["axe2"],
	   "type": "weapon"
   },
   "axe4": {
	   "icon": PNG_PATH + "axe.png", 
	   "displayname": "Axe",
	   "details": "Damage increased by 3",
	   "level": "Level: 4",
	   "prerequisite": ["axe3"],
	   "type": "weapon"
   },
   "shield1": {
	   "icon": PNG_PATH + "shield.png",
	   "displayname": "Shield",
	   "details": "A shield that bounces off walls",
	   "level": "Level: 1",
	   "prerequisite": [],
	   "type": "weapon"  
   },
   "shield2": {
	   "icon": PNG_PATH + "shield.png",
	   "displayname": "Shield",
	   "details": "Shield damage increased by 2",
	   "level": "Level: 2",
	   "prerequisite": ["shield1"],
	   "type": "weapon"
   },
   "shield3": {
	   "icon": PNG_PATH + "shield.png", 
	   "displayname": "Shield",
	   "details": "Additional shield appears",
	   "level": "Level: 3",
	   "prerequisite": ["shield2"],
	   "type": "weapon"
   },
   "shield4": {
	   "icon": PNG_PATH + "shield.png",
	   "displayname": "Shield", 
	   "details": "Shield damage increased by 3",
	   "level": "Level: 4",
	   "prerequisite": ["shield3"],
	   "type": "weapon"
   },
   "sword1": {
	   "icon": PNG_PATH + "sword.png",
	   "displayname": "Sword",
	   "details": "A sword swings at enemies",
	   "level": "Level: 1",
	   "prerequisite": [],
	   "type": "weapon"
   },
   "sword2": {
	   "icon": PNG_PATH + "sword.png",
	   "displayname": "Sword",
	   "details": "Sword damage increased by 2",
	   "level": "Level: 2", 
	   "prerequisite": ["sword1"],
	   "type": "weapon"
   },
   "sword3": {
	   "icon": PNG_PATH + "sword.png",
	   "displayname": "Sword",
	   "details": "Additional sword swing",
	   "level": "Level: 3",
	   "prerequisite": ["sword2"],
	   "type": "weapon"
   },
   "sword4": {
	   "icon": PNG_PATH + "sword.png",
	   "displayname": "Sword",
	   "details": "Sword damage increased by 3",
	   "level": "Level: 4",
	   "prerequisite": ["sword3"],
	   "type": "weapon"
   },
   "ring1": {
	   "icon": PNG_PATH + "ring.png",
	   "displayname": "Ring",
	   "details": "Increases area of effect by 10%",
	   "level": "Level: 1",
	   "prerequisite": [],
	   "type": "upgrade"
   },
   "ring2": {
	   "icon": PNG_PATH + "ring.png",
	   "displayname": "Ring",
	   "details": "Increases area of effect by additional 15%",
	   "level": "Level: 2",
	   "prerequisite": ["ring1"],
	   "type": "upgrade"
   },
   "ring3": {
	   "icon": PNG_PATH + "ring.png", 
	   "displayname": "Ring",
	   "details": "Increases area of effect by additional 20%",
	   "level": "Level: 3",
	   "prerequisite": ["ring2"],
	   "type": "upgrade"
   },
   "ring4": {
	   "icon": PNG_PATH + "ring.png",
	   "displayname": "Ring",
	   "details": "Increases area of effect by additional 25%",
	   "level": "Level: 4",
	   "prerequisite": ["ring3"],
	   "type": "upgrade"
   },
   "mirror1": {
	   "icon": PNG_PATH + "mirror.png",
	   "displayname": "Mirror",
	   "details": "Increases projectiles by 1",
	   "level": "Level: 1", 
	   "prerequisite": [],
	   "type": "upgrade"
   },
   "mirror2": {
	   "icon": PNG_PATH + "mirror.png",
	   "displayname": "Mirror",
	   "details": "Increases projectiles by 1",
	   "level": "Level: 2",
	   "prerequisite": ["mirror1"],
	   "type": "upgrade"
   },
   "mirror3": {
	   "icon": PNG_PATH + "mirror.png",
	   "displayname": "Mirror", 
	   "details": "Increases projectiles by 1",
	   "level": "Level: 3",
	   "prerequisite": ["mirror2"],
	   "type": "upgrade"
   },
   "mirror4": {
	   "icon": PNG_PATH + "mirror.png",
	   "displayname": "Mirror",
	   "details": "Increases projectiles by 1",
	   "level": "Level: 4",
	   "prerequisite": ["mirror3"],
	   "type": "upgrade"
   },
   "potion1": {
	   "icon": PNG_PATH + "potion.png",
	   "displayname": "Potion",
	   "details": "Increases max health by 10",
	   "level": "Level: 1",
	   "prerequisite": [],
	   "type": "upgrade"
   },
   "potion2": {
	   "icon": PNG_PATH + "potion.png",
	   "displayname": "Potion",
	   "details": "Increases max health by additional 15",
	   "level": "Level: 2",
	   "prerequisite": ["potion1"],
	   "type": "upgrade"
   },
   "potion3": {
	   "icon": PNG_PATH + "potion.png",
	   "displayname": "Potion",
	   "details": "Increases max health by additional 20",
	   "level": "Level: 3",
	   "prerequisite": ["potion2"],
	   "type": "upgrade"
   },
   "potion4": {
	   "icon": PNG_PATH + "potion.png",
	   "displayname": "Potion",
	   "details": "Increases max health by additional 25",
	   "level": "Level: 4",
	   "prerequisite": ["potion3"],
	   "type": "upgrade"
   },
	"food": {
		"icon": PNG_PATH + "food.png",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}
