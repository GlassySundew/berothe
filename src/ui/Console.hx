package ui;

import hxd.Key;
import dn.heaps.input.ControllerAccess;
#if client
import game.net.client.GameClient;
import h2d.Console.ConsoleArg;
import h3d.col.Bounds;
import pass.CustomRenderer;

class Console extends h2d.Console {

	public static var inst : Console;

	#if debug
	var flags : Map<String, Bool>;
	#end

	final ca : ControllerAccess<game.client.ControllerAction>;

	public function new( f : h2d.Font, ?p : h2d.Object ) {
		super( f, p );
		ca = Main.inst.controller.createAccess();
		logTxt = new h2d.HtmlText( f, this );
		logTxt.x = 2;
		logTxt.dropShadow = {
			dx : 0,
			dy : 1,
			color : 0,
			alpha : 0.5
		};

		// tf.onFocusLost = _ -> {};

		// logTxt.visible = false;
		// scale(2); // TODO smarter scaling for 4k screens

		// Settings
		inst = this;
		h2d.Console.HIDE_LOG_TIMEOUT = 4.5;
		// Lib.redirectTracesToH2dConsole(this);

		tf.cursorTile.dy = 0;
	}

	#if debug
	public function setFlag( k : String, v ) return flags.set( k, v );

	public function hasFlag( k : String ) return flags.get( k ) == true;
	#else
	public function hasFlag( k : String ) return false;
	#end

	override function resetCommands() {
		super.resetCommands();

		addCommand( "unfriendly", "", [], () -> {
			GameClient.inst?.setUnfriendly();
		} );
	}

	override function show() {
		super.show();
		logTxt.visible = true;
		logTxt.alpha = 1;
		ca.takeExclusivity();
	}

	override function hide() {
		super.hide();
		Main.inst.delayer.addF(() -> {
			ca.releaseExclusivity();
		}, 1 );
	}

	override function log( text : String, ?color : Int ) {
		if ( color == null ) color = tf.textColor;
		var oldH = logTxt.textHeight;
		logTxt.text = '<font color="#${StringTools.hex( color & 0xFFFFFF, 6 )}">${StringTools.htmlEscape( text )}</font><br/>' + logTxt.text;
		if ( logDY != 0 ) logDY += logTxt.textHeight - oldH;
		logTxt.alpha = 1;
		logTxt.visible = true;
		lastLogTime = haxe.Timer.stamp();
	}

	override function sync( ctx : h2d.RenderContext ) {
		super.sync( ctx );

		var scene = ctx.scene;
		if ( scene != null ) {
			x = 0;
			y = 0;
			width = scene.width;
			tf.maxWidth = width;
			bg.tile.scaleToSize( width, logTxt.textHeight );
		}
		var log = logTxt;
		if ( log.visible ) {
			log.y = log.font.lineHeight;
			var dt = haxe.Timer.stamp() - lastLogTime;
			if ( dt > h2d.Console.HIDE_LOG_TIMEOUT && !bg.visible ) {
				log.alpha -= ctx.elapsedTime * 4;
				if ( log.alpha <= 0 ) log.visible = false;
			}
		}
	}

	override function getCommandSuggestion( cmd : String ) : String {
		var hadShortKey = false;
		if ( cmd.charCodeAt( 0 ) == shortKeyChar ) {
			hadShortKey = true;
			cmd = cmd.substr( 1 );
		}

		if ( cmd == "" || !hadShortKey ) {
			return "";
		}

		var closestCommand = "";
		var commandNames = commands.keys();
		for ( command in commandNames ) {
			if ( command.indexOf( cmd ) == 0 ) {
				if ( closestCommand == "" || closestCommand.length > command.length ) {
					closestCommand = command;
				}
			}
		}

		if ( aliases.exists( cmd ) )
			closestCommand = cmd;

		if ( hadShortKey && closestCommand != "" )
			closestCommand = String.fromCharCode( shortKeyChar ) + closestCommand;
		return closestCommand;
	}

	override function handleCommand( command : String ) {
		command = StringTools.trim( command );
		var validCommand = false;
		if ( command.charCodeAt( 0 ) == shortKeyChar ) {
			command = command.substr( 1 );
			validCommand = true;
		}
		if ( command == "" ) {
			hide();
			return;
		}
		logs.push( String.fromCharCode( shortKeyChar ) + command );
		logIndex = -1;

		if ( !validCommand ) {
			GameClient.inst?.sayMessage( command );
			if ( GameClient.inst == null )
				log( Data.locale.get(
					Random.fromArray( [
						Data.LocaleKind.unheard,
						Data.LocaleKind.unheard2
					] )
				).text );
			return;
		}

		var args = [];
		var c = '';
		var i = 0;

		function readString( endChar : String ) {
			var string = '';

			while ( i < command.length ) {
				c = command.charAt( ++i );
				if ( c == endChar ) {
					++i;
					return string;
				}
				string += c;
			}

			return null;
		}

		inline function skipSpace() {
			c = command.charAt( i );
			while ( c == ' ' || c == '\t' ) {
				c = command.charAt( ++i );
			}
			--i;
		}

		var last = '';
		while ( i < command.length ) {
			c = command.charAt( i );

			switch ( c ) {
				case ' ' | '\t':
					skipSpace();

					args.push( last );
					last = '';
				case "'" | '"':
					var string = readString( c );
					if ( string == null ) {
						log( 'Bad formated string', errorColor );
						return;
					}

					args.push( string );
					last = '';

					skipSpace();
				default:
					last += c;
			}

			++i;
		}
		args.push( last );

		var cmdName = args[0];
		if ( aliases.exists( cmdName ) ) cmdName = aliases.get( cmdName );
		var cmd = commands.get( cmdName );
		if ( cmd == null ) {
			log( 'Unknown command "${cmdName}"', errorColor );
			return;
		}
		var vargs = new Array<Dynamic>();
		for ( i in 0...cmd.args.length ) {
			var a = cmd.args[i];
			var v = args[i + 1];
			if ( v == null ) {
				if ( a.opt ) {
					vargs.push( null );
					continue;
				}
				log( 'Missing argument ${a.name}', errorColor );
				return;
			}
			switch ( a.t ) {
				case AInt:
					var i = Std.parseInt( v );
					if ( i == null ) {
						log( '$v should be Int for argument ${a.name}', errorColor );
						return;
					}
					vargs.push( i );
				case AFloat:
					var f = Std.parseFloat( v );
					if ( Math.isNaN( f ) ) {
						log( '$v should be Float for argument ${a.name}', errorColor );
						return;
					}
					vargs.push( f );
				case ABool:
					switch ( v ) {
						case "true", "1": vargs.push( true );
						case "false", "0": vargs.push( false );
						default:
							log( '$v should be Bool for argument ${a.name}', errorColor );
							return;
					}
				case AString:
					// if we take a single string, let's pass the whole args (allows spaces)
					vargs.push( cmd.args.length == 1 ? StringTools.trim( command.substr( args[0].length ) ) : v );
				case AEnum( values ):
					var found = false;
					for ( v2 in values )
						if ( v == v2 ) {
							found = true;
							vargs.push( v2 );
						}
					if ( !found ) {
						log( '$v should be [${values.join( "|" )}] for argument ${a.name}', errorColor );
						return;
					}
				case AArray( arg ): // TODO
			}
		}

		doCall( cmd.callb, vargs );
	}
}
#end
