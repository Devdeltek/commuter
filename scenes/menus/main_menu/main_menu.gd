extends Control
@onready var button_box = $VBoxContainer/button_box


func _on_load_level_button_pressed() -> void:
	print("start")
	#load_levels.emit()
	#hide()

func _on_create_level_button_pressed() -> void:
	menu_manager.load_menu(menu_manager.MENU_LEVEL.CREATE)

func _on_options_button_pressed():
	print("options")


func _on_credits_button_pressed():
	menu_manager.load_menu(menu_manager.MENU_LEVEL.CREDITS)

func _on_quit_button_pressed():
	get_tree().quit()

func focus_button() -> void:
	if(button_box):
		var button:Button = button_box.get_child(0)
		if(button is Button):
			button.grab_focus()


# Called when the node enters the scene tree for the first time.
func _ready():
	focus_button()
	

func _on_visibility_changed() -> void:
	await get_tree().create_timer(.1).timeout
	focus_button()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
