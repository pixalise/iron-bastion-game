class_name LocalizedTooltip
extends PanelContainer

const UI_THEME := preload("res://game/ui/ui_theme.gd")


func _init() -> void:
	custom_minimum_size = Vector2(UI_THEME.TOOLTIP_WIDTH, 0.0)
	add_theme_stylebox_override(
		"panel", UI_THEME.panel_style(UI_THEME.TOOLTIP_BACKGROUND, UI_THEME.TOOLTIP_BORDER)
	)


func set_tooltip_content(content: Variant) -> void:
	_clear_children()

	var margin := MarginContainer.new()
	UI_THEME.set_margin(margin, UI_THEME.TOOLTIP_PADDING)
	add_child(margin)

	var content_box := VBoxContainer.new()
	content_box.add_theme_constant_override("separation", UI_THEME.TOOLTIP_GAP)
	margin.add_child(content_box)

	if content == null:
		return

	var icon_path := String(content.icon_path)
	var title_text: ChiselLocalization.LocalizedText = content.title
	if not icon_path.is_empty() or not title_text.plain_text.is_empty():
		content_box.add_child(_title_row(icon_path, title_text))

	var description_text: ChiselLocalization.LocalizedText = content.description
	if not description_text.plain_text.is_empty():
		var description_label: LocalizedRichText = _localized_label(
			description_text, _content_width(), UI_THEME.TOOLTIP_BODY_FONT_SIZE
		)
		description_label.add_theme_color_override("default_color", UI_THEME.TOOLTIP_BODY_TEXT)
		content_box.add_child(description_label)


func _title_row(icon_path: String, title_text: ChiselLocalization.LocalizedText) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", UI_THEME.TOOLTIP_TITLE_GAP)

	if not icon_path.is_empty():
		var icon := TextureRect.new()
		icon.custom_minimum_size = UI_THEME.TOOLTIP_ICON_SIZE
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture = load(icon_path) as Texture2D
		row.add_child(icon)

	if not title_text.plain_text.is_empty():
		var title_width := _content_width()
		if not icon_path.is_empty():
			title_width -= UI_THEME.TOOLTIP_ICON_SIZE.x + UI_THEME.TOOLTIP_TITLE_GAP
		var title_label: LocalizedRichText = _localized_label(
			title_text, title_width, UI_THEME.TOOLTIP_TITLE_FONT_SIZE
		)
		title_label.add_theme_color_override("default_color", UI_THEME.TOOLTIP_TITLE_TEXT)
		row.add_child(title_label)

	return row


func _localized_label(
	value: ChiselLocalization.LocalizedText, minimum_width: float, font_size: int
) -> LocalizedRichText:
	var label := LocalizedRichText.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(minimum_width, 0.0)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UI_THEME.set_rich_text_font_size(label, font_size)
	label.set_localized_text(value)
	return label


func _content_width() -> float:
	return UI_THEME.TOOLTIP_WIDTH - float(UI_THEME.TOOLTIP_PADDING * 2)


func _clear_children() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
