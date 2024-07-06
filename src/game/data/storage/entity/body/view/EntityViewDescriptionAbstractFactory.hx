package game.data.storage.entity.body.view;

class EntityViewDescriptionAbstractFactory {

	public static function fromCdb( entry : Data.EntityBody_view ) : EntityViewDescription {
		var description : IEntityViewProvider = switch entry.type {
			case EntityComposer( file ):
				new EntityComposerViewDescription();
			case Graybox:
				new StaticObjectGrayboxViewDescription();
		}

		return new EntityViewDescription( description, entry.id.toString() );
	}
}
