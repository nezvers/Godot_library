extends PopupMenu
class_name MenuPopupMenu

var callbacks:Dictionary = {}

## Call super._ready() if inheriting
func _ready()->void:
	initialize()

func initialize()->void:
	if !index_pressed.is_connected(on_index_pressed):
		index_pressed.connect(on_index_pressed)
	if !index_pressed.is_connected(on_about_to_pop):
		about_to_popup.connect(on_about_to_pop)

func on_index_pressed(i:int)->void:
	callbacks[i].call()

func submenu_popup(submenu:PopupMenu)->void:
	add_submenu_item(submenu.name, submenu.name)

func callback_button(item_name:String, callback:Callable, tooltip:String = "")->void:
	var i: = item_count
	add_item(item_name)
	callbacks[i] = callback
	if !tooltip.is_empty():
		set_item_tooltip(i, tooltip)

func on_about_to_pop()->void:
	var parent: = get_parent()
	if !(parent is PopupMenu):
		return
	position.x = parent.position.x + parent.size.x
