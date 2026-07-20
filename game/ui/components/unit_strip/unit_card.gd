class_name UnitCard
extends PanelContainer

const CARD_SIZE := Vector2(210, 260)
const PORTRAIT_SIZE := Vector2(188, 118)
const UI_THEME := preload("res://game/ui/ui_theme.gd")
const LOCALIZED_RICH_TEXT := preload("res://game/ui/components/localized_rich_text.gd")

var portrait: TextureRect
var small_icon: TextureRect
var health_bar: ProgressBar
var name_label: Label
var description_label
var stat_row: HBoxContainer

var _built := false
var _data: UnitCardData
var _portrait_placeholder: Label


func _ready() -> void:
	_build()
	_apply_data(_data)


func set_data(data: UnitCardData) -> void:
	_data = data
	if _built:
		_apply_data(data)


func _build() -> void:
	if _built:
		return

	custom_minimum_size = CARD_SIZE
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	size_flags_vertical = Control.SIZE_SHRINK_END
	add_theme_stylebox_override("panel", UI_THEME.panel_style(UI_THEME.CARD, UI_THEME.BORDER))

	var margin := MarginContainer.new()
	UI_THEME.set_margin(margin, UI_THEME.SPACE_2)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", UI_THEME.SPACE_1 + 2)
	margin.add_child(root)

	var portrait_frame := Control.new()
	portrait_frame.custom_minimum_size = PORTRAIT_SIZE
	root.add_child(portrait_frame)

	var portrait_backing := Panel.new()
	portrait_backing.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	portrait_backing.add_theme_stylebox_override(
		"panel", UI_THEME.panel_style(UI_THEME.MUTED, UI_THEME.ACCENT)
	)
	portrait_frame.add_child(portrait_backing)

	portrait = TextureRect.new()
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	portrait.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	portrait_frame.add_child(portrait)

	_portrait_placeholder = Label.new()
	_portrait_placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_portrait_placeholder.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_portrait_placeholder.add_theme_color_override("font_color", UI_THEME.MUTED_FOREGROUND)
	_portrait_placeholder.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	portrait_frame.add_child(_portrait_placeholder)

	small_icon = TextureRect.new()
	small_icon.custom_minimum_size = Vector2(24, 24)
	small_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	small_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	small_icon.position = Vector2(5, 5)
	portrait_frame.add_child(small_icon)

	health_bar = ProgressBar.new()
	health_bar.min_value = 0
	health_bar.max_value = 100
	health_bar.value = 100
	health_bar.show_percentage = false
	health_bar.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	health_bar.offset_left = 5
	health_bar.offset_right = -5
	health_bar.offset_top = -15
	health_bar.offset_bottom = -5
	portrait_frame.add_child(health_bar)

	name_label = Label.new()
	name_label.clip_text = true
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	name_label.add_theme_font_size_override("font_size", UI_THEME.TEXT_BASE)
	name_label.add_theme_color_override("font_color", UI_THEME.CARD_FOREGROUND)
	root.add_child(name_label)

	description_label = LOCALIZED_RICH_TEXT.new()
	description_label.custom_minimum_size = Vector2(PORTRAIT_SIZE.x, 74)
	UI_THEME.set_rich_text_font_size(description_label, UI_THEME.TEXT_XS)
	description_label.add_theme_color_override("default_color", UI_THEME.CARD_FOREGROUND)
	root.add_child(description_label)

	stat_row = HBoxContainer.new()
	stat_row.add_theme_constant_override("separation", UI_THEME.SPACE_1)
	root.add_child(stat_row)

	_built = true


func _apply_data(data: UnitCardData) -> void:
	name_label.text = data.title.plain_text
	description_label.set_localized_text(data.description)
	portrait.texture = data.portrait
	_portrait_placeholder.visible = data.portrait == null
	_portrait_placeholder.text = name_label.text
	small_icon.texture = data.small_icon
	small_icon.visible = data.small_icon != null
	health_bar.value = clampf(data.health_ratio, 0.0, 1.0) * 100.0
