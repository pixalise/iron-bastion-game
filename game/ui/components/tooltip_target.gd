class_name TooltipTarget
extends MarginContainer

const LOCALIZED_TOOLTIP := preload("res://game/ui/components/localized_tooltip.gd")

var _tooltip_content: Variant = null


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP


func set_tooltip_content(value: Variant) -> void:
	_tooltip_content = value
	tooltip_text = " " if _has_tooltip_content(value) else ""


func _make_custom_tooltip(_for_text: String) -> Object:
	if not _has_tooltip_content(_tooltip_content):
		return _empty_tooltip()

	var tooltip := LOCALIZED_TOOLTIP.new()
	tooltip.set_tooltip_content(_tooltip_content)
	return tooltip


func _has_tooltip_content(content: Variant) -> bool:
	if content == null:
		return false
	var title_text: ChiselLocalization.LocalizedText = content.title
	var description_text: ChiselLocalization.LocalizedText = content.description
	return (
		not String(content.icon_path).is_empty()
		or not title_text.plain_text.is_empty()
		or not description_text.plain_text.is_empty()
	)


func _empty_tooltip() -> Control:
	var empty := Control.new()
	empty.custom_minimum_size = Vector2.ZERO
	empty.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return empty
