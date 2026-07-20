extends Control

const UI := preload("res://game/ui/ui.gd")
const ZOO_SCENE := preload("res://game/scenes/zoo/zoo.tscn")


func _ready() -> void:
	_build()


func _build() -> void:
	if has_node("Background"):
		return

	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP

	var background := ColorRect.new()
	background.name = "Background"
	background.color = Color(0.054902, 0.0745098, 0.109804, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var center := CenterContainer.new()
	center.name = "CenterContainer"
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var menu_column := VBoxContainer.new()
	menu_column.name = "MenuColumn"
	menu_column.add_theme_constant_override("separation", 16)
	center.add_child(menu_column)

	var title := Label.new()
	title.name = "Title"
	title.text = "Iron Bastion"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 36)
	menu_column.add_child(title)

	var zoo_button := _create_menu_button("ZooButton", "zoo")
	zoo_button.pressed.connect(_on_zoo_pressed)
	menu_column.add_child(zoo_button)

	var quit_button := _create_menu_button("QuitButton", "quit", GameUiTheme.ButtonVariant.OUTLINE)
	quit_button.pressed.connect(_on_quit_pressed)
	menu_column.add_child(quit_button)


func _create_menu_button(
	button_name: String,
	label_text: String,
	variant: GameUiTheme.ButtonVariant = GameUiTheme.ButtonVariant.DEFAULT
) -> Button:
	var button := UI.Components.create_button(variant) as Button
	button.name = button_name
	button.text = label_text
	button.custom_minimum_size = Vector2(220, button.custom_minimum_size.y)
	return button


func _on_zoo_pressed() -> void:
	var result := get_tree().change_scene_to_packed(ZOO_SCENE)
	if result != OK:
		push_error("Failed to load zoo scene: %s" % error_string(result))


func _on_quit_pressed() -> void:
	get_tree().quit()
