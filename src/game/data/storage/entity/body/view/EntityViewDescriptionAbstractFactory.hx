package game.data.storage.entity.body.view;

class EntityViewDescriptionAbstractFactory {

	public static function fromCdb( entry : Data.EntityView ) : EntityViewDescription {
		var description : IEntityViewProvider = //
			switch entry.type {
				case EntityComposer( file ):
					new EntityComposerViewProvider( file.file, entry.animations );
				case Graybox:
					new StaticObjectGrayboxViewProvider();
				case Model:
					new ModelObjectViewProvider();
				case e:
					trace( '$e is not supported as IEntityViewProvider' );
					null;
			}

		return new EntityViewDescription( description, entry.id.toString() );
	}
}
