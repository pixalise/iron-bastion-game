extends RefCounted


class Components:
	const UI_THEME := preload("res://game/ui/ui_theme.gd")
	const LOCALIZED_RICH_TEXT_SCRIPT := preload("res://game/ui/components/localized_rich_text.gd")
	const LOCALIZED_TOOLTIP_SCRIPT := preload("res://game/ui/components/localized_tooltip.gd")
	const TOOLTIP_TARGET_SCRIPT := preload("res://game/ui/components/tooltip_target.gd")

	static func create_button_default(
		size: GameUiTheme.ButtonSize = GameUiTheme.ButtonSize.DEFAULT
	) -> Button:
		var button := Button.new()
		_apply_button_theme(button, GameUiTheme.ButtonVariant.DEFAULT, size)
		return button

	static func create_localized_rich_text(
		value: ChiselLocalization.LocalizedText,
		font_size: int = UI_THEME.TEXT_BASE
	) -> LocalizedRichText:
		var label := LOCALIZED_RICH_TEXT_SCRIPT.new() as LocalizedRichText
		UI_THEME.set_rich_text_font_size(label, font_size)
		label.set_localized_text(value)
		return label

	static func create_localized_tooltip(tooltip_data: Variant) -> LocalizedTooltip:
		var tooltip := LOCALIZED_TOOLTIP_SCRIPT.new() as LocalizedTooltip
		tooltip.set_tooltip_content(tooltip_data)
		return tooltip

	static func create_tooltip_target(tooltip_data: Variant) -> TooltipTarget:
		var target := TOOLTIP_TARGET_SCRIPT.new() as TooltipTarget
		target.set_tooltip_content(tooltip_data)
		return target

	static func _apply_button_theme(
		button: Button,
		variant: GameUiTheme.ButtonVariant,
		size: GameUiTheme.ButtonSize
	) -> void:
		button.focus_mode = Control.FOCUS_ALL
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.add_theme_font_size_override("font_size", UI_THEME.button_font_size(size))
		button.add_theme_color_override("font_color", UI_THEME.button_font_color(variant))
		button.add_theme_color_override("font_hover_color", UI_THEME.button_font_color(variant))
		button.add_theme_color_override("font_pressed_color", UI_THEME.button_font_color(variant))
		button.add_theme_color_override("font_focus_color", UI_THEME.button_font_color(variant))
		button.add_theme_color_override("font_hover_pressed_color", UI_THEME.button_font_color(variant))
		button.add_theme_color_override("font_disabled_color", UI_THEME.button_font_color(variant, true))
		button.add_theme_stylebox_override("normal", UI_THEME.button_stylebox(variant, size))
		button.add_theme_stylebox_override("hover", UI_THEME.button_stylebox(variant, size, true))
		button.add_theme_stylebox_override("pressed", UI_THEME.button_stylebox(variant, size, false, true))
		button.add_theme_stylebox_override(
			"focus", UI_THEME.button_stylebox(variant, size, false, false, false, true)
		)
		button.add_theme_stylebox_override(
			"disabled", UI_THEME.button_stylebox(variant, size, false, false, true)
		)

		var width := button.custom_minimum_size.x
		button.custom_minimum_size = Vector2(width, UI_THEME.button_minimum_height(size))


# Code-first widget builder inspired by Flutter's nested widget trees.
class Widget:
	var node: Node

	func _init(next_node: Node) -> void:
		node = next_node

	func child(widget):
		if widget is Widget:
			node.add_child(widget.build())
			return self
		node.add_child(widget)
		return self

	func children(widgets: Array):
		for widget in widgets:
			child(widget)
		return self

	func full_rect():
		var control := node as Control
		control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		return self

	func mouse_filter_mode(value: int):
		var control := node as Control
		control.mouse_filter = value
		return self

	func text(value: String):
		if node is RichTextLabel:
			(node as RichTextLabel).text = value
			return self
		if node is Label:
			(node as Label).text = value
			return self
		var button := node as BaseButton
		button.set("text", value)
		return self

	func localized_text(value: Variant):
		var label := node as LocalizedRichText
		label.set_localized_text(value)
		return self

	func tooltip_text(value: String):
		var control := node as Control
		control.tooltip_text = value
		return self

	func tooltip_content(value: Variant):
		if node is LocalizedTooltip:
			(node as LocalizedTooltip).set_tooltip_content(value)
			return self
		if node is TooltipTarget:
			(node as TooltipTarget).set_tooltip_content(value)
			return self

		var host := Components.create_tooltip_target(value)
		host.add_child(node)
		node = host
		return self

	func color(value: Color):
		var color_rect := node as ColorRect
		color_rect.color = value
		return self

	func center_text():
		if node is RichTextLabel:
			(node as RichTextLabel).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			return self
		var label := node as Label
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		return self

	func font_size(value: int):
		if node is RichTextLabel:
			GameUiTheme.set_rich_text_font_size(node as RichTextLabel, value)
			return self
		var control := node as Control
		control.add_theme_font_size_override("font_size", value)
		return self

	func font_color(value: Color):
		if node is RichTextLabel:
			(node as RichTextLabel).add_theme_color_override("default_color", value)
			return self
		var control := node as Control
		control.add_theme_color_override("font_color", value)
		return self

	func gap(value: int):
		var box := node as BoxContainer
		box.add_theme_constant_override("separation", value)
		return self

	func min_width(value: float):
		var control := node as Control
		control.custom_minimum_size.x = value
		return self

	func min_height(value: float):
		var control := node as Control
		control.custom_minimum_size.y = value
		return self

	func min_size(value: Vector2):
		var control := node as Control
		control.custom_minimum_size = value
		return self

	func texture(value: Texture2D):
		var texture_rect := node as TextureRect
		texture_rect.texture = value
		return self

	func texture_path(path: String):
		return texture(load(path) as Texture2D)

	func stretch_mode(value: int):
		var texture_rect := node as TextureRect
		texture_rect.stretch_mode = value
		return self

	func expand_mode(value: int):
		var texture_rect := node as TextureRect
		texture_rect.expand_mode = value
		return self

	func autowrap(mode: int):
		if node is Label:
			(node as Label).autowrap_mode = mode
			return self
		var rich_text := node as RichTextLabel
		rich_text.autowrap_mode = mode
		return self

	func fit_content(value: bool = true):
		var rich_text := node as RichTextLabel
		rich_text.fit_content = value
		return self

	func bbcode_enabled(value: bool = true):
		var rich_text := node as RichTextLabel
		rich_text.bbcode_enabled = value
		return self

	func stylebox(slot: String, style: StyleBox):
		var control := node as Control
		control.add_theme_stylebox_override(slot, style)
		return self

	func on_pressed(callback: Callable):
		var button := node as BaseButton
		button.pressed.connect(callback)
		return self

	func build() -> Node:
		return node

	func mount(parent: Node) -> Node:
		parent.add_child(node)
		return node


class Builder:
	const UI_THEME := preload("res://game/ui/ui_theme.gd")

	static func control():
		return Widget.new(Control.new())

	static func background(color: Color = UI_THEME.BACKGROUND):
		return Widget.new(ColorRect.new()).color(color).full_rect()

	static func center():
		return Widget.new(CenterContainer.new()).full_rect()

	static func column(separation: int = 0):
		var widget = Widget.new(VBoxContainer.new())
		if separation > 0:
			widget.gap(separation)
		return widget

	static func row(separation: int = 0):
		var widget = Widget.new(HBoxContainer.new())
		if separation > 0:
			widget.gap(separation)
		return widget

	static func label(value: String = ""):
		return Widget.new(Label.new()).text(value)

	static func rich_text(value: String = "", use_bbcode: bool = true):
		var label := RichTextLabel.new()
		label.scroll_active = false
		return Widget.new(label).bbcode_enabled(use_bbcode).fit_content().text(value)

	static func localized_rich_text(
		value: ChiselLocalization.LocalizedText, font_size: int = UI_THEME.TEXT_BASE
	):
		return Widget.new(Components.create_localized_rich_text(value, font_size))

	static func image(
		texture: Texture2D = null,
		minimum_size: Vector2 = Vector2.ZERO,
		stretch_mode: int = TextureRect.STRETCH_KEEP_ASPECT_CENTERED,
		expand_mode: int = TextureRect.EXPAND_IGNORE_SIZE
	):
		var widget = Widget.new(TextureRect.new())
		widget.texture(texture).stretch_mode(stretch_mode).expand_mode(expand_mode)
		if minimum_size != Vector2.ZERO:
			widget.min_size(minimum_size)
		return widget

	static func button_default(
		value: String,
		size: GameUiTheme.ButtonSize = GameUiTheme.ButtonSize.DEFAULT,
		on_pressed: Callable = Callable()
	):
		var widget = Widget.new(Components.create_button_default(size)).text(value)
		if on_pressed.is_valid():
			widget.on_pressed(on_pressed)
		return widget

	static func card(padding: int = 24):
		var panel := PanelContainer.new()
		panel.add_theme_stylebox_override("panel", UI_THEME.card_panel_style(padding))
		return Widget.new(panel)

	static func tooltip(tooltip_data: Variant):
		return Widget.new(Components.create_localized_tooltip(tooltip_data))
