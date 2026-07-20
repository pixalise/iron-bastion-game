extends Control

const UI := preload("res://game/ui/ui.gd")
const ZOO_SCENE := preload("res://game/scenes/zoo/zoo.tscn")


func _ready() -> void:
	_build()
	var math = GraphiteMath.new()
	print(math.add_numbers(1.0, 2.0))


func _build() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	(
		UI
		. Widgets
		. mount(
			self,
			(
				UI
				. Widgets
				. Scaffold(
					(
						UI
						. Widgets
						. Center(
							(
								UI
								. Widgets
								. Card(
									(
										UI
										. Widgets
										. Column(
											[
												UI.Widgets.Text(
													"Iron Bastion", UI.TextStyle.title()
												),
												UI.Widgets.Button(
													"zoo",
													_on_zoo_pressed,
													UI.ButtonStyle.width(220)
												),
												UI.Widgets.Button(
													"quit",
													_on_quit_pressed,
													UI.ButtonStyle.width(220)
												),
											],
											UI.FlexStyle.with_gap(16)
										)
									),
									UI.SurfaceStyle.card(UI.EdgeInsets.all(28))
								)
							)
						)
					),
					UI.ScaffoldStyle.default_style()
				)
			)
		)
	)


func _on_zoo_pressed() -> void:
	assert(get_tree().change_scene_to_packed(ZOO_SCENE) == OK)


func _on_quit_pressed() -> void:
	get_tree().quit()
