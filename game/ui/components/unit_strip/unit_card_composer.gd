class_name UnitCardComposer
extends RefCounted

const RIFLE_MAN_PREVIEW_DAMAGE := 12.0


static func rifle_man_preview() -> UnitCardData:
	var data := UnitCardData.new()
	data.title = ChiselTranslations.unit.rifle_man.name()
	data.description = ChiselTranslations.unit.rifle_man.description(
		ChiselTranslations.UnitRifleManDescriptionParameters.new(
			{"physical_damage": RIFLE_MAN_PREVIEW_DAMAGE}
		)
	)
	data.small_icon = _load_texture("PHYSICAL_DAMAGE")
	data.health_ratio = 0.72
	return data


static func _load_texture(asset_id: String) -> Texture2D:
	var asset: Dictionary = ChiselAssets.BY_ID.get(asset_id, {})
	var path := String(asset.get("path", ""))
	assert(not path.is_empty())
	return load(path) as Texture2D
