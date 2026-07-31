extends RefCounted


class Components:
	const UI_THEME := preload("res://game/ui/theme/ui_theme.gd")
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

enum ThemeColorToken {
	BACKGROUND,
	FOREGROUND,
	CARD,
	CARD_FOREGROUND,
	PRIMARY,
	PRIMARY_FOREGROUND,
	SECONDARY,
	SECONDARY_FOREGROUND,
	MUTED,
	MUTED_FOREGROUND,
	ACCENT,
	ACCENT_FOREGROUND,
	BORDER,
	RING,
}


class EdgeInsets:
	extends RefCounted

	var left: int
	var top: int
	var right: int
	var bottom: int

	func _init(next_left: int, next_top: int, next_right: int, next_bottom: int) -> void:
		left = next_left
		top = next_top
		right = next_right
		bottom = next_bottom

	static func all(value: int) -> EdgeInsets:
		return EdgeInsets.new(value, value, value, value)

	static func symmetric(horizontal: int = 0, vertical: int = 0) -> EdgeInsets:
		return EdgeInsets.new(horizontal, vertical, horizontal, vertical)

	static func only(
		left: int = 0, top: int = 0, right: int = 0, bottom: int = 0
	) -> EdgeInsets:
		return EdgeInsets.new(left, top, right, bottom)

	static func zero() -> EdgeInsets:
		return EdgeInsets.new(0, 0, 0, 0)


class BoxConstraints:
	extends RefCounted

	var min_width: float
	var min_height: float

	func _init(next_min_width: float = 0.0, next_min_height: float = 0.0) -> void:
		min_width = next_min_width
		min_height = next_min_height

	static func none() -> BoxConstraints:
		return BoxConstraints.new()

	static func width(value: float) -> BoxConstraints:
		return BoxConstraints.new(value, 0.0)

	static func height(value: float) -> BoxConstraints:
		return BoxConstraints.new(0.0, value)

	static func tight(width: float = 0.0, height: float = 0.0) -> BoxConstraints:
		return BoxConstraints.new(width, height)


class FlexStyle:
	extends RefCounted

	var gap: int

	func _init(next_gap: int = 0) -> void:
		gap = next_gap

	static func default_style() -> FlexStyle:
		return FlexStyle.new(GameUiTheme.SPACE_2)

	static func with_gap(value: int) -> FlexStyle:
		return FlexStyle.new(value)


class TextStyle:
	extends RefCounted

	var font_size: int
	var color_token: ThemeColorToken
	var centered: bool
	var autowrap: bool
	var bbcode_enabled: bool

	func _init(
		next_font_size: int,
		next_color_token: ThemeColorToken,
		next_centered: bool = false,
		next_autowrap: bool = false,
		next_bbcode_enabled: bool = true
	) -> void:
		font_size = next_font_size
		color_token = next_color_token
		centered = next_centered
		autowrap = next_autowrap
		bbcode_enabled = next_bbcode_enabled

	static func body() -> TextStyle:
		return TextStyle.new(GameUiTheme.TEXT_BASE, ThemeColorToken.FOREGROUND)

	static func card_body() -> TextStyle:
		return TextStyle.new(GameUiTheme.TEXT_BASE, ThemeColorToken.CARD_FOREGROUND)

	static func title() -> TextStyle:
		return TextStyle.new(36, ThemeColorToken.FOREGROUND, true)


class ScaffoldStyle:
	extends RefCounted

	var background_color_token: ThemeColorToken

	func _init(next_background_color_token: ThemeColorToken) -> void:
		background_color_token = next_background_color_token

	static func default_style() -> ScaffoldStyle:
		return ScaffoldStyle.new(ThemeColorToken.BACKGROUND)


class SurfaceStyle:
	extends RefCounted

	var background_color_token: ThemeColorToken
	var border_color_token: ThemeColorToken
	var border_width: int
	var radius: int
	var padding: EdgeInsets

	func _init(
		next_background_color_token: ThemeColorToken,
		next_border_color_token: ThemeColorToken,
		next_border_width: int,
		next_radius: int,
		next_padding: EdgeInsets
	) -> void:
		background_color_token = next_background_color_token
		border_color_token = next_border_color_token
		border_width = next_border_width
		radius = next_radius
		padding = next_padding

	static func card(padding: EdgeInsets) -> SurfaceStyle:
		return SurfaceStyle.new(
			ThemeColorToken.CARD,
			ThemeColorToken.BORDER,
			1,
			GameUiTheme.RADIUS_MD,
			padding
		)

	static func card_default() -> SurfaceStyle:
		return card(EdgeInsets.all(24))


class ImageStyle:
	extends RefCounted

	var constraints: BoxConstraints
	var stretch_mode: int
	var expand_mode: int

	func _init(
		next_constraints: BoxConstraints,
		next_stretch_mode: int = TextureRect.STRETCH_KEEP_ASPECT_CENTERED,
		next_expand_mode: int = TextureRect.EXPAND_IGNORE_SIZE
	) -> void:
		constraints = next_constraints
		stretch_mode = next_stretch_mode
		expand_mode = next_expand_mode

	static func default_style() -> ImageStyle:
		return ImageStyle.new(BoxConstraints.none())

	static func constrained(constraints: BoxConstraints) -> ImageStyle:
		return ImageStyle.new(constraints)


class ButtonStyle:
	extends RefCounted

	var size: GameUiTheme.ButtonSize
	var constraints: BoxConstraints

	func _init(next_size: GameUiTheme.ButtonSize, next_constraints: BoxConstraints) -> void:
		size = next_size
		constraints = next_constraints

	static func default_style() -> ButtonStyle:
		return ButtonStyle.new(GameUiTheme.ButtonSize.DEFAULT, BoxConstraints.none())

	static func width(value: float) -> ButtonStyle:
		return ButtonStyle.new(GameUiTheme.ButtonSize.DEFAULT, BoxConstraints.width(value))

	static func constrained(
		constraints: BoxConstraints,
		size: GameUiTheme.ButtonSize = GameUiTheme.ButtonSize.DEFAULT
	) -> ButtonStyle:
		return ButtonStyle.new(size, constraints)


class ThemePalette:
	extends RefCounted

	static func resolve_color(token: ThemeColorToken) -> Color:
		match token:
			ThemeColorToken.BACKGROUND:
				return GameUiTheme.BACKGROUND
			ThemeColorToken.FOREGROUND:
				return GameUiTheme.FOREGROUND
			ThemeColorToken.CARD:
				return GameUiTheme.CARD
			ThemeColorToken.CARD_FOREGROUND:
				return GameUiTheme.CARD_FOREGROUND
			ThemeColorToken.PRIMARY:
				return GameUiTheme.PRIMARY
			ThemeColorToken.PRIMARY_FOREGROUND:
				return GameUiTheme.PRIMARY_FOREGROUND
			ThemeColorToken.SECONDARY:
				return GameUiTheme.SECONDARY
			ThemeColorToken.SECONDARY_FOREGROUND:
				return GameUiTheme.SECONDARY_FOREGROUND
			ThemeColorToken.MUTED:
				return GameUiTheme.MUTED
			ThemeColorToken.MUTED_FOREGROUND:
				return GameUiTheme.MUTED_FOREGROUND
			ThemeColorToken.ACCENT:
				return GameUiTheme.ACCENT
			ThemeColorToken.ACCENT_FOREGROUND:
				return GameUiTheme.ACCENT_FOREGROUND
			ThemeColorToken.BORDER:
				return GameUiTheme.BORDER
			ThemeColorToken.RING:
				return GameUiTheme.RING
			_:
				return GameUiTheme.FOREGROUND


class Widgets:
	static func mount(parent: Node, child: Node) -> Node:
		parent.add_child(child)
		return child

	static func Scaffold(body: Node, style: ScaffoldStyle) -> Control:
		var root := Control.new()
		root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		root.mouse_filter = Control.MOUSE_FILTER_STOP

		var background := ColorRect.new()
		background.color = ThemePalette.resolve_color(style.background_color_token)
		background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		root.add_child(background)
		root.add_child(body)

		return root

	static func Center(child: Node) -> CenterContainer:
		var center := CenterContainer.new()
		center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		center.add_child(child)
		return center

	static func Column(children: Array, style: FlexStyle) -> VBoxContainer:
		var column := VBoxContainer.new()
		if style.gap > 0:
			column.add_theme_constant_override("separation", style.gap)
		_append_children(column, children)
		return column

	static func Row(children: Array, style: FlexStyle) -> HBoxContainer:
		var row := HBoxContainer.new()
		if style.gap > 0:
			row.add_theme_constant_override("separation", style.gap)
		_append_children(row, children)
		return row

	static func Card(child: Node, style: SurfaceStyle) -> PanelContainer:
		var panel := PanelContainer.new()
		panel.add_theme_stylebox_override("panel", _surface_stylebox(style))
		panel.add_child(child)
		return panel

	static func Padding(child: Node, insets: EdgeInsets) -> MarginContainer:
		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", insets.left)
		margin.add_theme_constant_override("margin_top", insets.top)
		margin.add_theme_constant_override("margin_right", insets.right)
		margin.add_theme_constant_override("margin_bottom", insets.bottom)
		margin.add_child(child)
		return margin

	static func Margin(child: Node, insets: EdgeInsets) -> MarginContainer:
		return Padding(child, insets)

	static func SizedBox(child: Control, constraints: BoxConstraints) -> Control:
		_apply_constraints(child, constraints)
		return child

	static func Text(
		value: String,
		style: TextStyle
	) -> Label:
		var label := Label.new()
		label.text = value
		label.add_theme_font_size_override("font_size", style.font_size)
		label.add_theme_color_override("font_color", ThemePalette.resolve_color(style.color_token))
		if style.centered:
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if style.autowrap:
			label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		return label

	static func RichText(
		value: String,
		style: TextStyle
	) -> RichTextLabel:
		var label := RichTextLabel.new()
		label.scroll_active = false
		label.fit_content = true
		label.bbcode_enabled = style.bbcode_enabled
		label.text = value
		GameUiTheme.set_rich_text_font_size(label, style.font_size)
		label.add_theme_color_override("default_color", ThemePalette.resolve_color(style.color_token))
		return label

	static func LocalizedText(
		value: ChiselLocalization.LocalizedText,
		style: TextStyle
	) -> LocalizedRichText:
		var label := Components.create_localized_rich_text(value, style.font_size)
		label.add_theme_color_override(
			"default_color", ThemePalette.resolve_color(style.color_token)
		)
		if style.centered:
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		return label

	static func Image(texture: Texture2D, style: ImageStyle) -> TextureRect:
		var image := TextureRect.new()
		image.texture = texture
		image.stretch_mode = style.stretch_mode
		image.expand_mode = style.expand_mode
		_apply_constraints(image, style.constraints)
		return image

	static func Button(value: String, on_pressed: Callable, style: ButtonStyle) -> Button:
		var button := Components.create_button_default(style.size)
		button.text = value
		button.pressed.connect(on_pressed)
		_apply_constraints(button, style.constraints)
		return button

	static func Tooltip(child: Node, tooltip_data: Variant) -> TooltipTarget:
		var target := Components.create_tooltip_target(tooltip_data)
		target.add_child(child)
		return target

	static func TooltipPanel(tooltip_data: Variant) -> LocalizedTooltip:
		return Components.create_localized_tooltip(tooltip_data)

	static func _apply_constraints(control: Control, constraints: BoxConstraints) -> void:
		var size := control.custom_minimum_size
		if constraints.min_width > 0.0:
			size.x = constraints.min_width
		if constraints.min_height > 0.0:
			size.y = constraints.min_height
		control.custom_minimum_size = size

	static func _surface_stylebox(style: SurfaceStyle) -> StyleBoxFlat:
		var stylebox := GameUiTheme.panel_style(
			ThemePalette.resolve_color(style.background_color_token),
			ThemePalette.resolve_color(style.border_color_token),
			style.border_width,
			style.radius
		)
		stylebox.content_margin_left = style.padding.left
		stylebox.content_margin_top = style.padding.top
		stylebox.content_margin_right = style.padding.right
		stylebox.content_margin_bottom = style.padding.bottom
		return stylebox

	static func _append_children(parent: Node, children: Array) -> void:
		for child in children:
			parent.add_child(child)
