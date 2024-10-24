package game.client.en.comp.view.ui;

import util.Repeater;
import rx.disposables.ISubscription;
import util.Assert;
import game.domain.overworld.entity.component.model.EntityModelComponent;

class EntitySleepSpeech {

	public static inline function subscribe( view : EntityViewComponent ) {
		var model = view.entity.components.get( EntityModelComponent );

		Assert.notNull( model );

		var sub : ISubscription = null;

		inline function createRepeater() : ISubscription {
			function emitMessage() {
				view.statusBar.sayChatMessage( "(snort)" );
			}
			emitMessage();

			return Repeater.repeatSeconds( emitMessage, 8 );
		}

		model.isSleeping.addOnValueImmediately( ( oldVal, val ) -> {
			if ( val ) {
				sub = createRepeater();
			} else {
				if ( sub == null ) return;
				view.statusBar.sayChatMessage( "(yawn)" );

				sub?.unsubscribe();
				sub = null;
			}
		} );
	}
}
