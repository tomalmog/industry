extends Control

# define needed variables
var inventory: Dictionary
var item_list: Node
var sort_option_button: Node
var search_bar: Node

# initialize constants
const SORT_BY_NAME = 0
const SORT_BY_QUANTITY = 1

# Pre: none
# Post: none
# Description: load and populate inventory
func _ready():
	# load inventory and get references to needed nodes
	inventory = InventoryManager.get_inventory()
	item_list = $"Panel/ItemList"  
	sort_option_button = $"Panel/SortOptionButton" 
	search_bar = $"Panel/SearchBar"
	
	# clear the item list to avoid duplicate entries
	item_list.clear()
	
	# connect the dropdown signal
	sort_option_button.item_selected.connect(on_sort_option_selected)
	search_bar.text_changed.connect(on_search_text_changed)
	
	# populate the item list
	on_sort_option_selected(SORT_BY_NAME)

# Pre: new_text is the current input in the search bar
# Post: none
# Description: filter items when search bar text changes
func on_search_text_changed(new_text):
	# populate inventory fully if searchbar is empty. if not, populate it with searched items
	if new_text == "":
		populate_item_list(inventory, inventory.keys())
	
	else:
		# initialize an array to store filtered keys
		var filtered_keys = []

		# loop through the inventory and filter keys by matching the search query
		for key in inventory:
			var item_name = ItemManager.item_instances[key].instantiate().name
			# checks if the searched term can be found in the item name, if yes, add it to valid keys
			if item_name.to_lower().find(new_text.to_lower()) != -1: 
				filtered_keys.append(key)

		# populate the item list with the filtered keys
		populate_item_list(inventory, filtered_keys)

# Pre: sorted_keys is a list of keys to be populated in the item list
# Post: none
# Description: populate the item list with given keys and corresponding inventory data, inventory stores a reference to inventory
func populate_item_list(inventory, sorted_keys):
	item_list.clear()
	
	var counter = 0
	for key in sorted_keys:
		var item_scene = ItemManager.item_instances[key].instantiate()
		item_list.add_item(str(item_scene.name + " X " + str(inventory[key])), item_scene.texture)
		counter += 1

# Pre: index is the selected sort option (SORT_BY_NAME or SORT_BY_QUANTITY)
# Post: none
# Description: sorts inventory based on selected sort option and updates the item list
func on_sort_option_selected(index):
	# load fresh inventory data
	inventory = InventoryManager.get_inventory()
	search_bar.text = ""
	
	# sort by name if option is selected
	if index == SORT_BY_NAME:  
		var sorted_keys = inventory.keys()
		
		# merge sort the keys alphabetically
		sorted_keys = merge_sort(sorted_keys, compare_by_name)

		# repopulate the item list with the sorted inventory
		populate_item_list(inventory, sorted_keys)
	
	# sort by quantity if option is selected
	elif index == SORT_BY_QUANTITY:  
		var sorted_keys = inventory.keys()

		# merge sort the keys based on the quantity in the dictionary
		sorted_keys = merge_sort(sorted_keys, compare_by_quantity)

		# repopulate the item list with the sorted inventory
		populate_item_list(inventory, sorted_keys)
	
	# play button clicked sound effect
	AudioManager.play_button_click_sound()

# Pre: arr is the array to be sorted, compare_func is the comparison function
# Post: returns a sorted array
# Description: recursively sorts the array using the merge sort algorithm
func merge_sort(arr, compare_func):
	# base case, if arr length is one return arr
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

# Pre: left and right are sorted arrays, compare_func is the comparison function
# Post: returns a merged sorted array
# Description: merges two sorted arrays into one sorted array based on a comparison function
func merge(left, right, compare_func):
	var result = []
	var i = 0
	var j = 0
	
	# merge the arrays while comparing elements using compare_func
	while i < left.size() and j < right.size():
		# use .call here because godot has weird behaviors when passing functions 
		if compare_func.call(left[i], right[j]): 
			result.append(left[i])
			i += 1
		else:
			result.append(right[j])
			j += 1
	
	# append any remaining elements
	result.append_array(left.slice(i, left.size()))
	result.append_array(right.slice(j, right.size()))
	
	return result
	
# Pre: left and right are item keys from the inventory
# Post: returns true if left has greater quantity than right
# Description: comparison function for sorting by quantity
func compare_by_quantity(left: int, right: int):
	return inventory[left] > inventory[right]

# Pre: left and right are item keys from the inventory
# Post: returns true if left item name is alphabetically before right
# Description: comparison function for sorting by name
func compare_by_name(left: int, right: int):
	var left_name = ItemManager.item_instances[left].instantiate().name.to_lower()
	var right_name = ItemManager.item_instances[right].instantiate().name.to_lower()
	
	# compare the names in alphabetical order
	return left_name < right_name
