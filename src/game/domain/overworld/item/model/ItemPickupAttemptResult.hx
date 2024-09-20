package game.domain.overworld.item.model;

enum ItemPickupStatus {
	SUCCESS;
	FAILURE;
}

class ItemPickupAttemptResult {

	public inline static function success() : ItemPickupAttemptResult {
		return new ItemPickupAttemptResult( SUCCESS );
	}

	public inline static function failure() : ItemPickupAttemptResult {
		return new ItemPickupAttemptResult( FAILURE );
	}

	public final status : ItemPickupStatus;

	public function new( status : ItemPickupStatus ) {
		this.status = status;
	}
}
