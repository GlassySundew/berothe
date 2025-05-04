package net;

enum Message {

	COMMAND( type : ClientCommandType );

	/** seed on client side can only be used to generate icons in navigation window **/
	ClientAuth; // todo auth
	Disconnect;
}
