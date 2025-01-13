extends Control

var inventory
var item_list
var sort_option_button
var search_bar  # The LineEdit for searching

func _ready():
	# get references to the itemlist and sortoptionbutton nodes
	inventory = InventoryManager.get_inventory()
	item_list = $"Panel/ItemList"  
	sort_option_button = $"Panel/SortOptionButton" 
	search_bar = $"Panel/SearchBar"
	
	# Clear the item list to avoid duplicate entries
	item_list.clear()
	
	# Connect the dropdown signal
	sort_option_button.item_selected.connect(_on_sort_option_selected)
	
	search_bar.text_changed.connect(_on_search_text_changed)
	
	# Populate the item list
	populate_item_list(inventory, inventory.keys())


func _on_search_text_changed(new_text):
	if new_text == "":
		populate_item_list(inventory, inventory.keys())
	
	else:
		var filtered_keys = []

		# Loop through the inventory and filter keys by matching the search query
		for key in inventory.keys():
			var item_name = ItemManager.item_instances[key].instantiate().name
			if item_name.to_lower().find(new_text.to_lower()) != -1:  # Case-insensitive search
				filtered_keys.append(key)

		# Populate the item list with the filtered keys
		populate_item_list(inventory, filtered_keys)


func populate_item_list(inventory, sorted_keys):
	item_list.clear()
	
	var counter = 0
	for key in sorted_keys:
		var item_scene = ItemManager.item_instances[key].instantiate()
		item_list.add_item(str(item_scene.name + " X " + str(inventory[key])), item_scene.texture)
		counter += 1

func _on_sort_option_selected(index):
	inventory = InventoryManager.get_inventory()
	
	if index == 0:  # sort by name
		var sorted_keys = inventory.keys()
		# merge sort the keys alphabetically
		sorted_keys = merge_sort(sorted_keys, compare_by_name)

		# repopulate the item list with the sorted inventory (by key)
		populate_item_list(inventory, sorted_keys)
	
	elif index == 1:  # Sort by quantity
		var sorted_keys = inventory.keys()

		# rerge sort the keys based on the value (quantity) in the dictionary
		sorted_keys = merge_sort(sorted_keys, compare_by_quantity)

		# repopulate the item list with the sorted inventory (by quantity)
		populate_item_list(inventory, sorted_keys)

# merge sort function
func merge_sort(arr, compare_func):
	if arr.size() <= 1:
		return arr
	
	# split the array in half
	var mid = arr.size() / 2
	var left = arr.slice(0, mid)
	var right = arr.slice(mid, arr.size())
	
	# recursively sort both halves
	left = merge_sort(left, compare_func)
	right = merge_sort(right, compare_func)
	
	# merge the sorted halves
	return merge(left, right, compare_func)

# merge function to merge two sorted arrays
func merge(left, right, compare_func):
	var result = []
	var i = 0
	var j = 0
	
	# merge the arrays while comparing elements using compare_func
	while i < left.size() and j < right.size():
		if compare_func.call(left[i], right[j]):  # use .call here because godot has weird behaviors when passing functions 
			result.append(left[i])
			i += 1
		else:
			result.append(right[j])
			j += 1
	
	# append any remaining elements
	result.append_array(left.slice(i, left.size()))
	result.append_array(right.slice(j, right.size()))
	
	return result
	
# comparison function for sorting by quantity 
func compare_by_quantity(left: int, right: int):
	return inventory[left] > inventory[right]

func compare_by_name(left: int, right: int):
	var left_name = ItemManager.item_instances[left].instantiate().name.to_lower()
	var right_name = ItemManager.item_instances[right].instantiate().name.to_lower()
	
	# compare the names in alphabetical order
	return left_name < right_name 
