package net;

enum Message {

	/** seed on client side can only be used to generate icons in navigation window **/
	WorldInfo( seed : String );
	ClientAuth(); // todo auth
	MapLoad( name : String );
	Disconnect;

	#if debug
	GetServerStatus;
	ServerStatus( isHost : Bool );
	#end
}
