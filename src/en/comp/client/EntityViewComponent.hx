// package en.comp.client;

// import en.comp.net.EntityDynamicsComponent;
// import en.comp.client.view.EntityAnimationController;
// import en.comp.client.view.EntityComposerView;
// import en.comp.client.view.IEntityView;

// enum abstract AnimationKey( String ) from String to String {

// 	var IDLE = "idle";
// 	var WALK = "walk";
// 	var ATTACK_PRIME_IDLE = "attack_prime_idle";
// 	var ATTACK_SECO_IDLE = "attack_seco_idle";
// }

// class EntityViewComponent extends EntityComponent {

// 	public var view( default, null ) : IEntityView;

// 	public final viewCdb : Data.Entity_view;

// 	var animationController : EntityAnimationController;

// 	public function new( viewCdb : Data.Entity_view, entity : Entity ) {
// 		super( entity );
// 		this.viewCdb = viewCdb;

// 		createView();
// 		createAnimationController();

// 		view.setPosition( entity.x, entity.y, entity.z );

// 		entity.components.onAppear( EntityDynamicsComponent, ( key, dynamicsComponent ) -> {
// 			dynamicsComponent.onMove.add(() -> {
// 				view.setPosition( entity.x, entity.y, entity.z );
// 			} );
// 		} );
// 	}

// 	function createView() {

// 		switch viewCdb.type {
// 			case EntityComposer( file ):
// 				view = new EntityComposerView( entity, viewCdb, file.file );
// 		}
// 	}

// 	function createAnimationController() {
// 		animationController = new EntityAnimationController( this );
// 	}
// }
