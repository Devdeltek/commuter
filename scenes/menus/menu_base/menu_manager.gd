extends Node
@onready var canvas = get_tree().root.get_node("menu_base/MarginContainer")

enum MENU_LEVEL {
	NONE,
	MAIN,
	CREATE,
	CREDITS
}

var menus = {
	MENU_LEVEL.MAIN:preload("res://scenes/menus/main_menu/main_menu.tscn").instantiate(),
	MENU_LEVEL.CREATE:preload("res://scenes/menus/create_level/create_level.tscn").instantiate(),
	MENU_LEVEL.CREDITS:preload("res://scenes/menus/credits/credits.tscn").instantiate()
}
var current_menu : Node = null
var container:Node = null

func load_menu(menu_level):
	call_deferred("_deferred_load_menu", menu_level)

func _deferred_load_menu(menu_level):
	current_menu = menus[menu_level]
	
	for location in canvas.get_children():
		canvas.remove_child(location)

	canvas.add_child(current_menu)

# Called when the node enters the scene tree for the first time.
func _ready():
	load_menu(MENU_LEVEL.MAIN)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
