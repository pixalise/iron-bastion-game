class_name TooltipTarget
extends MarginContainer

const LOCALIZED_TOOLTIP := preload("res://game/ui/components/localized_tooltip.gd")

var _tooltip_content: Variant = null


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP


func set_tooltip_content(value: Variant) -> void:
	_tooltip_content = value
	tooltip_text = " "


func _make_custom_tooltip(_for_text: String) -> Object:
	var tooltip := LOCALIZED_TOOLTIP.new()
	tooltip.set_tooltip_content(_tooltip_content)
	return tooltip
