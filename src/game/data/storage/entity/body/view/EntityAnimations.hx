package game.data.storage.entity.body.view;

import game.client.en.comp.view.anim.AnimationState;
import dn.MacroTools;

class EntityAnimations {

	/**
		values are identifiers from entity composer animation
	**/
	public final byKey : Map<AnimationKey, Array<String>> = [];

	public function new( animations : Data.EntityBody_view_animations ) {

		for ( key in MacroTools.getAbstractEnumValues( AnimationKey ) ) {
			var animationKeys : Array<{animationName : String }> = Reflect.field( animations, key.value );
			if ( byKey[key.value] == null )
				byKey[key.value] = [];

			for ( animationKey in animationKeys ) {
				byKey[key.value].push( animationKey.animationName );
			}
		}

		#if debug
		if ( Lambda.count( cast byKey ) != Reflect.fields( animations ).length ) {
			for ( animation in Reflect.fields( animations ) ) {
				if ( byKey[animation] == null )
					trace( 'animation key: $animation is not supported' );
			}
		}
		#end
	}

}
