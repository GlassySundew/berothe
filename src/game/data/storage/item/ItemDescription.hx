package game.data.storage.item;

import game.data.storage.entity.model.EntityAdditiveStatType;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.data.storage.entity.body.view.IEntityViewProvider;
import game.data.storage.entity.body.view.EntityComposerViewProvider;

typedef EquipStat = {
	var type : EntityAdditiveStatType;
	var amount : Int;
}

class ItemDescription extends DescriptionBase {

	public final types : Array<ItemType>;

	public final equippable : Bool;
	public final equipAsset : Null<IEntityViewProvider>;
	public final equipSlots : Null<Array<EntityEquipmentSlotType>>;
	public final equipStats : Null<Array<EquipStat>>;
	public final iconAsset : String;

	public function new( entry : Data.Item ) {
		super( entry.id.toString() );

		types = createTypes( entry );
		equippable = entry.props.equippable;
		iconAsset = entry.iconAsset;

		if ( equippable ) {
			equipAsset = new EntityComposerViewProvider(
				entry.props.equipAsset.file,
				entry.props.equipAsset.animations
			);
			equipSlots = [
				for ( slot in entry.props.equipSlots ) {
					EntityEquipmentSlotType.fromCdb( slot.type );
				}
			];
			equipStats = [
				for ( stat in entry.props.equipStats ) {
					{
						type : EntityAdditiveStatType.fromCdb( stat.type ),
						amount : stat.amount
					}
				}
			];
		}
	}

	function createTypes( entry : Data.Item ) : Array<ItemType> {
		return [for ( itemType in entry.type.iterator() ) {
			switch itemType {
				case AnimalPart: ANIMALPART;
				case Blunt: BLUNT;
				case Food: FOOD;
				case Potion: POTION;
				case Scroll: SCROLL;
				case Sharp: SHARP;
				case Weapon: WEAPON;
			}
		}];
	}

	@:keep
	public function toString() : String {
		return "ItemDescription: " + id;
	}
}
