extends Control

const UI := preload("res://game/ui/ui.gd")
const UI_THEME := preload("res://game/ui/ui_theme.gd")
const ZOO_SCENE := preload("res://game/scenes/zoo/zoo.tscn")


func _ready() -> void:
	_build()


func _build() -> void:
	if has_node("MainMenuRoot"):
		return

	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var title = UI.Builder.label("Iron Bastion").named("Title").center_text()
	title.font_size(36).font_color(UI_THEME.FOREGROUND)

	var zoo_button = UI.Builder.button_default(
		"zoo",
		GameUiTheme.ButtonSize.DEFAULT,
		_on_zoo_pressed
	).named("ZooButton")
	zoo_button.min_width(220)

	var quit_button = UI.Builder.button_default(
		"quit",
		GameUiTheme.ButtonSize.DEFAULT,
		_on_quit_pressed
	).named("QuitButton")
	quit_button.min_width(220)

	var menu_column = UI.Builder.column(16).named("MenuColumn")
	menu_column.children([title, zoo_button, quit_button])

	var menu_card = UI.Builder.card(28).named("MenuCard")
	menu_card.child(menu_column)

	var center_container = UI.Builder.center().named("CenterContainer")
	center_container.child(menu_card)

	var main_menu_root = UI.Builder.control().named("MainMenuRoot").full_rect()
	main_menu_root.mouse_filter_mode(Control.MOUSE_FILTER_STOP)
	main_menu_root.children([
		UI.Builder.background(UI_THEME.BACKGROUND),
		center_container,
	])
	main_menu_root.mount(self)


func _on_zoo_pressed() -> void:
	var result := get_tree().change_scene_to_packed(ZOO_SCENE)
	if result != OK:
		push_error("Failed to load zoo scene: %s" % error_string(result))


func _on_quit_pressed() -> void:
	get_tree().quit()
