package game.data.storage.item;

import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.data.storage.entity.body.view.IEntityViewProvider;
import game.data.storage.entity.body.view.EntityComposerViewProvider;

class ItemDescription extends DescriptionBase {

	public final types : Array<ItemType>;
	
	public final equippable : Bool;
	public final equipAsset : Null<IEntityViewProvider>;
	public final equipSlots : Null<Array<EntityEquipmentSlotType>>;

	public function new( entry : Data.Item ) {
		super( entry.id.toString() );

		types = createTypes( entry );
		equippable = entry.props.equippable;

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
}
