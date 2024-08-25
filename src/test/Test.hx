package test;

class Test {

	public static function signalTest() {
		var signal = new signals.Signal<String>();
		var clickStream = ObservableFactory.fromSignal( signal );

		var subscriber : Observer<Int> = new Observer(
			() -> trace( "on completed" ),
			( error : String ) -> throw error,
			( s : Int ) -> trace( s )
		);

		// var sourceStream = ObservableFactory.interval( 3 );
		// var displayStream = ObservableFactory.interval(3.14);

		var multiClickStream = clickStream
			.bufferWhen( function () {
				var stream = clickStream.throttle( 2, null );
				stream.observe( ( tset ) -> trace( "throttle emits : " + tset ) );
				return stream;
			} )
			.map( function ( list ) {
				trace( "reading list of clicks with length : " + list.length );
				return list.length;} )
			.filter( function ( x ) {
				return x >= 2;
			} );

		var singleClickStream = clickStream
			.bufferWhen( function () {
				return clickStream.throttle( 2, null );
			} )
			.map( function ( list ) {
				return list.length;} )
			.filter( function ( x ) {
				return x == 1;} );

		singleClickStream.observe( ( i ) -> trace( "single" ) );
		multiClickStream.observe( ( i ) -> trace( "multi: " + i ) );

		ObservableFactory.concat( singleClickStream, [multiClickStream] )
			.throttle( 5 )
			.observe( function ( suggestion ) {
				trace( "cleared!" );
			} );

		new TextButton( "test rx", ( _ ) -> {
			signal.dispatch( 'ADasdasdas' );
		}, vertFlow );
	}

	public static function name() : T {

		#if server
		var pinger = new TestNetPinger();
		addChild( pinger );

		GameServer.inst.delayer.addS( "a", () -> {
			removeChild( pinger );
			pinger.unregister(NetworkHost.current);

			GameServer.inst.delayer.addS( "a", () -> {
				trace(addChild( pinger ));
			}, 2 );

		}, 3 );
		
		#end
	}
}
