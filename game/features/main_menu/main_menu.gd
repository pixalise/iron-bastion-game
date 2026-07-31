extends Control

const UI := preload("res://game/ui/ui.gd")

@export var start_game_scene: PackedScene


func _ready() -> void:
	_build()


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
													"Pachingod", UI.TextStyle.title()
												),
												UI.Widgets.Button(
													"start game",
													_on_start_game_pressed,
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


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_game_pressed() -> void:
	assert(get_tree().change_scene_to_packed(start_game_scene) == OK)
