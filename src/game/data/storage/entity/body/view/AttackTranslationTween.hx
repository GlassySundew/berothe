package game.data.storage.entity.body.view;

enum abstract AttackTranslationTween( String ) from String {

	var LINEAR = "linear";

	public inline static function fromCdb(
		entry : Data.EntityPropertySetup_properties_attack_attackList_tweenType
	) : AttackTranslationTween {
		return switch entry {
			case Linear: LINEAR;
		}
	}
}
