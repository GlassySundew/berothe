package game.data.storage.skill;

enum SkillType {
	LIFE;
}

class SkillDescription extends DescriptionBase {

	public static function fromCdb( entry : Data.Skill ) : SkillDescription {
		var type = switch entry.id {
			case life: LIFE;
		}

		return new SkillDescription(
			type,
			entry.id.toString()
		);
	}

	public final type : SkillType;

	public function new(
		type : SkillType,
		id : String
	) {
		super( id );
		this.type = type;
	}
}
