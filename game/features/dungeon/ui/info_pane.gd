extends Control

enum InfoTab { INVENTORY, DECK, JOURNAL }

const UI_THEME := preload("res://game/ui/theme/ui_theme.gd")
const TAB_NAMES: Array[String] = ["INVENTORY", "DECK", "JOURNAL"]

var _selected_tab := InfoTab.INVENTORY
var _tab_group := ButtonGroup.new()
var _tab_buttons: Array[Button] = []
var _tab_pages: Array[Control] = []


func _ready() -> void:
	_build_ui()
	_select_tab(_selected_tab)


func _build_ui() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

	var shell := PanelContainer.new()
	shell.name = "Shell"
	shell.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shell.add_theme_stylebox_override(
		"panel", _panel_style(UI_THEME.VOID, UI_THEME.STONE_MID, 2)
	)
	add_child(shell)

	var shell_margin := MarginContainer.new()
	_set_margins(shell_margin, 10)
	shell.add_child(shell_margin)

	var column := VBoxContainer.new()
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_theme_constant_override("separation", 8)
	shell_margin.add_child(column)

	column.add_child(_build_character_stats_reserve())
	column.add_child(_build_tab_bar())
	column.add_child(_build_tab_content())


func _build_character_stats_reserve() -> Control:
	var panel := PanelContainer.new()
	panel.name = "CharacterStatsReserve"
	panel.custom_minimum_size.y = 158.0
	panel.add_theme_stylebox_override(
		"panel", _panel_style(UI_THEME.CHARCOAL, UI_THEME.STONE_MID, 1)
	)

	var margin := MarginContainer.new()
	_set_margins(margin, 14)
	panel.add_child(margin)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	margin.add_child(column)

	var heading := Label.new()
	heading.text = "CHARACTER"
	heading.add_theme_font_size_override("font_size", 19)
	heading.add_theme_color_override("font_color", UI_THEME.CANDLE_GLOW)
	column.add_child(heading)

	column.add_child(_divider())

	var reserve_row := HBoxContainer.new()
	reserve_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	reserve_row.add_theme_constant_override("separation", 14)
	column.add_child(reserve_row)

	var portrait := PanelContainer.new()
	portrait.name = "PortraitReserve"
	portrait.custom_minimum_size = Vector2(92.0, 88.0)
	portrait.add_theme_stylebox_override(
		"panel", _panel_style(UI_THEME.VOID, UI_THEME.STONE_MID, 1)
	)
	var portrait_center := CenterContainer.new()
	portrait.add_child(portrait_center)
	portrait_center.add_child(_muted_label("PORTRAIT", 12))
	reserve_row.add_child(portrait)

	reserve_row.add_child(_build_stat_reserve("IDENTITY", ["NAME / LEVEL", "LOADOUT"]))
	reserve_row.add_child(_vertical_divider())
	reserve_row.add_child(_build_stat_reserve("CHARACTER STATS", ["HEALTH", "DEFENSE"]))
	reserve_row.add_child(_vertical_divider())
	reserve_row.add_child(_build_stat_reserve("RUN SUMMARY", ["DECK", "RELICS"]))

	return panel


func _build_stat_reserve(title: String, rows: Array[String]) -> Control:
	var column := VBoxContainer.new()
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.add_theme_constant_override("separation", 7)

	var title_label := Label.new()
	title_label.text = title
	title_label.add_theme_font_size_override("font_size", 13)
	title_label.add_theme_color_override("font_color", UI_THEME.PARCHMENT)
	column.add_child(title_label)

	for row_name in rows:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		var label := _muted_label(row_name, 12)
		label.custom_minimum_size.x = 82.0
		row.add_child(label)

		var line := ColorRect.new()
		line.color = UI_THEME.STONE_SHADOW
		line.custom_minimum_size.y = 2.0
		line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(line)
		column.add_child(row)

	return column


func _build_tab_bar() -> Control:
	var tab_bar := HBoxContainer.new()
	tab_bar.name = "TabBar"
	tab_bar.custom_minimum_size.y = 50.0
	tab_bar.add_theme_constant_override("separation", 5)

	for tab_index in TAB_NAMES.size():
		var button := Button.new()
		button.name = "%sTab" % TAB_NAMES[tab_index].capitalize()
		button.text = TAB_NAMES[tab_index]
		button.toggle_mode = true
		button.button_group = _tab_group
		button.focus_mode = Control.FOCUS_ALL
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.add_theme_font_size_override("font_size", 16)
		button.add_theme_color_override("font_color", UI_THEME.PARCHMENT)
		button.add_theme_color_override("font_hover_color", UI_THEME.CANDLE_GLOW)
		button.add_theme_color_override("font_pressed_color", UI_THEME.CANDLE_GLOW)
		button.add_theme_color_override("font_focus_color", UI_THEME.CANDLE_GLOW)
		button.add_theme_stylebox_override(
			"normal", _tab_style(UI_THEME.CHARCOAL, UI_THEME.STONE_MID)
		)
		button.add_theme_stylebox_override(
			"hover", _tab_style(UI_THEME.STONE_SHADOW, UI_THEME.WARM_TAUPE)
		)
		button.add_theme_stylebox_override(
			"pressed", _tab_style(UI_THEME.BLOOD_SHADOW, UI_THEME.PARCHMENT, 2)
		)
		button.add_theme_stylebox_override(
			"focus", _tab_style(UI_THEME.CHARCOAL, UI_THEME.RITUAL_RED, 2)
		)
		button.pressed.connect(_select_tab.bind(tab_index))
		tab_bar.add_child(button)
		_tab_buttons.append(button)

	return tab_bar


func _build_tab_content() -> Control:
	var panel := PanelContainer.new()
	panel.name = "TabContent"
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override(
		"panel", _panel_style(UI_THEME.CHARCOAL, UI_THEME.STONE_MID, 1)
	)

	var page_stack := Control.new()
	page_stack.name = "PageStack"
	page_stack.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(page_stack)

	for tab_name in TAB_NAMES:
		var page := _build_placeholder_page(tab_name)
		page_stack.add_child(page)
		_tab_pages.append(page)

	return panel


func _build_placeholder_page(tab_name: String) -> Control:
	var page := CenterContainer.new()
	page.name = "%sPage" % tab_name.capitalize()
	page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var label := Label.new()
	label.text = "%s PANEL\nRESERVED FOR A LATER PASS" % tab_name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", UI_THEME.WARM_TAUPE)
	page.add_child(label)
	return page


func _select_tab(tab_index: int) -> void:
	if tab_index < 0 or tab_index >= _tab_pages.size():
		return

	_selected_tab = tab_index
	for index in _tab_pages.size():
		_tab_pages[index].visible = index == tab_index
		_tab_buttons[index].set_pressed_no_signal(index == tab_index)


func _muted_label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", UI_THEME.WARM_TAUPE)
	return label


func _divider() -> ColorRect:
	var divider := ColorRect.new()
	divider.color = UI_THEME.STONE_MID
	divider.custom_minimum_size.y = 1.0
	return divider


func _vertical_divider() -> ColorRect:
	var divider := ColorRect.new()
	divider.color = UI_THEME.STONE_MID
	divider.custom_minimum_size.x = 1.0
	divider.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return divider


func _panel_style(background: Color, border: Color, width: int) -> StyleBoxFlat:
	var style := UI_THEME.panel_style(background, border, width, 0)
	style.content_margin_left = 0
	style.content_margin_top = 0
	style.content_margin_right = 0
	style.content_margin_bottom = 0
	return style


func _tab_style(background: Color, border: Color, width: int = 1) -> StyleBoxFlat:
	var style := UI_THEME.panel_style(background, border, width, 1)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style


func _set_margins(container: MarginContainer, value: int) -> void:
	container.add_theme_constant_override("margin_left", value)
	container.add_theme_constant_override("margin_top", value)
	container.add_theme_constant_override("margin_right", value)
	container.add_theme_constant_override("margin_bottom", value)
