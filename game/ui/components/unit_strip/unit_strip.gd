class_name UnitStrip
extends Control

const UNIT_CARD_SCENE := preload("res://game/ui/components/unit_strip/unit_card.tscn")
const UNIT_CARD_COMPOSER := preload("res://game/ui/components/unit_strip/unit_card_composer.gd")

var _cards: HBoxContainer


func _ready() -> void:
	_build()
	add_card(UNIT_CARD_COMPOSER.rifle_man_preview())


func clear_cards() -> void:
	if _cards == null:
		return
	for child in _cards.get_children():
		child.queue_free()


func add_card(data: UnitCardData) -> UnitCard:
	if _cards == null:
		_build()
	var card := UNIT_CARD_SCENE.instantiate() as UnitCard
	_cards.add_child(card)
	card.set_data(data)
	return card


func _build() -> void:
	if _cards != null:
		return

	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var bottom := CenterContainer.new()
	bottom.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bottom.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bottom.offset_left = 0
	bottom.offset_top = -292
	bottom.offset_right = 0
	bottom.offset_bottom = -18
	add_child(bottom)

	_cards = HBoxContainer.new()
	_cards.mouse_filter = Control.MOUSE_FILTER_PASS
	_cards.add_theme_constant_override("separation", 8)
	bottom.add_child(_cards)
