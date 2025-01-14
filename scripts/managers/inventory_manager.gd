extends Node

var IM = ItemManager
var inventory: Dictionary

var quests = [
	[IM.GOLD_ORE, 50], 
	[IM.IRON_ORE, 150], 
	[IM.GOLD_NUGGET, 50], 
	[IM.BRONZE_NUGGET, 100], 
	[IM.BRONZE_INGOT, 150],
	[IM.IRON_INGOT, 200],
	[IM.BRONZE_INGOT, 150],
	[IM.BRONZE_INGOT, 150]]
	
var quests_completed: int
var curr_quest: Array

var item_label: Label
var item_texture: TextureRect

var is_first: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory = {}
	quests_completed = 0
	curr_quest = quests[quests_completed]
	
	is_first = true
	
	reload()
	pass # Replace with function body.

func reload():
	item_label = get_node("/root/World/Hub/ItemLabel")
	item_texture = get_node("/root/World/Hub/ItemTexture")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var item = get_quest_item()
	var required = get_quest_requirement()
	
	if inventory.has(item) && inventory[item] >= required:
		quests_completed += 1
		
		if !item_label:
			reload()
		
		item_label.update_quest_item()
		item_texture.update_quest_item()
	


func get_quest_item():
	return quests[quests_completed][0]
	
func get_quest_requirement():
	return quests[quests_completed][1]

func get_quests_completed():
	return quests_completed
	
func set_quests_completed(completed: int):
	quests_completed = completed

func set_inventory_count(type: int, count: int):
	inventory[type] = count

func get_inventory_count(type: int):
	if inventory.has(type):
		return inventory[type]
	else:
		return 0

func get_inventory():
	return inventory
	
func clear_inventory():
	inventory = {}

	
func add_to_inventory(item: Item):
	var type = item.get_type()
	if inventory.has(type):
		inventory[type] += 1
	else:
		inventory[type] = 1
		
func delete_from_inventory(item: Item, amount: int) -> bool:
	var type = item.get_type()
	if inventory.has(type) && inventory[type] >= amount:
		inventory[type] -= amount
		return true
		
	return false
	
