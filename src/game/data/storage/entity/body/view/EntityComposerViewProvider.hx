package game.data.storage.entity.body.view;

import dn.MacroTools;
import game.client.en.comp.view.AnimationKey;
import game.client.en.comp.view.EntityComposerView;
import game.client.en.comp.view.IEntityView;
import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;

class EntityComposerViewProvider implements IEntityViewProvider {

	final animationsByKey : Map<AnimationKey, Array<String>> = [];
	final animations : Data.EntityBody_view_animations;
	final file : String;

	public function new( file : String, animations : Data.EntityBody_view_animations ) {
		this.animations = animations;
		this.file = file;

		parseAnimations();
	}

	public function createView( setting : EntityViewExtraInitSetting ) : IEntityView {
		return new EntityComposerView( file );
	}

	function parseAnimations() {
		for ( key in MacroTools.getAbstractEnumValues( AnimationKey ) ) {
			var animationKeys : Array<{animationName : String }> = Reflect.field( animations, key.value );
			if ( animationsByKey[key.value] == null )
				animationsByKey[key.value] = [];
			for ( animationKey in animationKeys ) {
				animationsByKey[key.value].push( animationKey.animationName );
			}
		}

		#if debug
		if ( Lambda.count( cast animationsByKey ) != Reflect.fields( animations ).length ) {
			for ( animation in Reflect.fields( animations ) ) {
				if ( animationsByKey[animation] == null ) trace( 'animation key: $animation is not supported' );
			}
		}
		#end
	}
}
