extends RefCounted


class Components:
	static func create_button(
		variant: GameUiTheme.ButtonVariant = GameUiTheme.ButtonVariant.DEFAULT,
		size: GameUiTheme.ButtonSize = GameUiTheme.ButtonSize.DEFAULT
	) -> GameButton:
		var button := preload("res://game/ui/components/button/button.gd").new() as GameButton
		button.button_variant = variant
		button.button_size = size
		return button
