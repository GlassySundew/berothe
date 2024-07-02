package game.data.storage.entity.body.view;

class EntityViewDescriptionAbstractFactory {

	public static function fromCdb( entry : Data.EntityBody_view ) : EntityViewDescription {
		var description : IEntityView = switch entry.type {
			case EntityComposer( file ):
				trace( entry.type + " is not supported" );
				null;
			case Graybox:
				new StaticObjectGrayboxViewDescription();
		}

		return new EntityViewDescription( description, entry.id.toString() );
	}
}
