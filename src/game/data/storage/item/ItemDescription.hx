package game.data.storage.item;

import game.data.storage.entity.EntityDescription;
import game.data.storage.entity.model.EntityAdditiveStatType;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.data.storage.entity.body.view.IEntityViewProvider;
import game.data.storage.entity.body.view.EntityComposerViewProvider;

typedef EquipStat = {
	var type : EntityAdditiveStatType;
	var amount : Int;
}

class ItemDescription extends DescriptionBase {

	public static inline function fromCdb( entry : Data.Item ) : ItemDescription {
		var equipAsset = null;
		var equipSlots = null;
		var equipStats = null;

		if ( entry.props.equippable ) {
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

		return new ItemDescription(
			equipAsset,
			equipSlots,
			equipStats,
			entry.iconAsset,
			entry.props.equippable,
			createTypes( entry ),
			entry.overworldPresentation.id.toString(),
			entry.isSplittable,
			entry.id.toString()
		);
	}

	static inline function createTypes( entry : Data.Item ) : Array<ItemType> {
		return [for ( itemType in entry.type.iterator() ) {
			switch itemType {
				case AnimalPart: ANIMALPART;
				case Blunt: BLUNT;
				case Food: FOOD;
				case Potion: POTION;
				case Scroll: SCROLL;
				case Sharp: SHARP;
				case Weapon: WEAPON;
				case Gold: GOLD;
			}
		}];
	}

	public final types : Array<ItemType>;
	public final equippable : Bool;
	public final equipAsset : Null<IEntityViewProvider>;
	public final equipSlots : Null<Array<EntityEquipmentSlotType>>;
	public final equipStats : Null<Array<EquipStat>>;
	public final iconAsset : String;
	public final overworldEntityId : String;
	public final isSplittable : Bool;

	public function new(
		equipAsset : EntityComposerViewProvider,
		equipSlots : Null<Array<EntityEquipmentSlotType>>,
		equipStats : Null<Array<EquipStat>>,
		iconAsset : String,
		equippable : Bool,
		types : Array<ItemType>,
		overworldEntityId : String,
		isSplittable : Bool,
		id : String
	) {
		super( id );

		this.equippable = equippable;
		this.iconAsset = iconAsset;
		this.types = types;
		this.equipAsset = equipAsset;
		this.equipSlots = equipSlots;
		this.equipStats = equipStats;
		this.overworldEntityId = overworldEntityId;
		this.isSplittable = isSplittable;
	}

	public inline function getOverworldReprEntityDesc() : EntityDescription {
		return DataStorage.inst.entityStorage.getById( overworldEntityId );
	}

	@:keep
	public function toString() : String {
		return "ItemDescription: " + id;
	}
}
