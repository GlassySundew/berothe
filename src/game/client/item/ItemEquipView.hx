package game.client.item;

import util.Assert;
import hrt.prefab.Object3D;
import util.Const;
import haxe.exceptions.NotImplementedException;
import game.data.location.DataSheetIdent;
import game.client.en.comp.view.EntityComposerView;
import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.item.Item;
import game.data.storage.entity.model.EntityEquipmentSlotType;

class ItemEquipView {

	public final item : Item;

	public function new(
		item : Item,
		type : EntityEquipmentSlotType,
		parentViewComp : EntityViewComponent
	) {
		this.item = item;
		var itemView = item.desc.equipAsset.createView( parentViewComp, [] );

		parentViewComp.addChildComponent( itemView );

		parentViewComp.view.then( ( parentViewResult ) -> {
			var manager = //
				Std.downcast( parentViewResult, EntityComposerView )
					.entityComposer.animationManager;

			manager.context.listenMountpoint( type, ( prefab ) -> {
				var obj = Std.downcast( prefab, Object3D );
				Assert.notNull( obj );
				itemView.getGraphics().setPosition(
					obj.x,
					obj.y,
					obj.z
				);
			} );
		} );
	}
}
