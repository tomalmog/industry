extends Node

var IM = ItemManager
#var inventory = {IM.GOLD_ORE: 5, IM.IRON_ORE: 300, IM.IRON_CUT: 23, IM.BRONZE_INGOT: 301, IM. GOLD_INGOT: 120, IM.GOLD_NUGGET: 2, IM.GOLD_CUT: 3, IM.BRONZE_CUT: 4, IM.BRONZE_ORE: 300}
var inventory = {}

var quests = [[IM.GOLD_ORE, 10], [IM.IRON_ORE, 15], [IM.BRONZE_NUGGET, 20], [IM.GOLD_INGOT, 30], [IM.IRON_INGOT, 30]]
var quests_completed: int = 0
var curr_quest = quests[quests_completed]

var item_label: Label
var item_texture: TextureRect

var is_first = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
