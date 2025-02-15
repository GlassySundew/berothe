package game.data.storage.skill;

enum SkillType {
	LIFE;
}

typedef LevelProgressionInfo = { points : Float, xpReq : Float };

class SkillDescription extends DescriptionBase {

	public static function fromCdb( entry : Data.Skill ) : SkillDescription {
		var type = switch entry.id {
			case life: LIFE;
		}

		var progression : Array<LevelProgressionInfo> = [];
		for ( levelProgress in entry.progression ) {
			progression[levelProgress.level] = {
				points : levelProgress.points,
				xpReq : levelProgress.xpReq
			};
		};

		return new SkillDescription(
			type,
			progression,
			entry.id.toString()
		);
	}

	public final type : SkillType;
	public final progression : Array<LevelProgressionInfo>;

	public function new(
		type : SkillType,
		progression : Array<LevelProgressionInfo>,
		id : String
	) {
		super( id );
		this.progression = progression;
		this.type = type;
	}
}
