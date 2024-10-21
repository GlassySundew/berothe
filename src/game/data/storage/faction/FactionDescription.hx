package game.data.storage.faction;

import tink.CoreApi.Lazy;

class FactionDescription extends DescriptionBase {

	public static function fromCdb( entry : Data.Faction ) : FactionDescription {
		return new FactionDescription(
			[for ( hostile in entry.hostileTo ) {
				hostile.factionId.toString();
			}],
			entry.id.toString()
		);
	}

	public final hostileFactions : Lazy<Array<FactionDescription>>;
	final hostileToIds : Array<String>;

	public function new( hostileTo : Array<String>, id : String ) {
		super( id );
		this.hostileToIds = hostileTo;
		hostileFactions = Lazy.ofFunc( getHostileFactions );
	}

	inline function getHostileFactions() {
		return [for ( faction in hostileToIds ) {
			DataStorage.inst.factionStorage.getById( faction );
		}];
	}
}
