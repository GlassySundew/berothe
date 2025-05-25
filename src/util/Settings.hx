package util;

import core.MutableProperty;

class Settings extends util.tools.Settings<
	{
		fullscreen : Bool,
		orthographics : MutableProperty<Bool>,
		saveFiles : Array<String>,
		windowWidth : Int,
		windowHeight : Int,
		windowX : Int,
		windowY : Int,
		debug : {
			#if debug
			physicsDebugVisible : MutableProperty<Bool>,
			chunksDebugVisible : MutableProperty<Bool>,
			#end
		}
	}
	> {

	public static var inst( get, null ) : Settings;
	static inline function get_inst() : Settings {
		if ( inst == null ) inst = new Settings();
		return inst;
	}

	private function new() {
		params = {
			fullscreen : false,
			orthographics : new MutableProperty( false ),
			saveFiles : [],
			windowWidth : 900,
			windowHeight : 650,
			windowX : -1,
			windowY : -1,

			debug : {
				#if debug
				physicsDebugVisible : new MutableProperty( false ),
				chunksDebugVisible : new MutableProperty( false ),
				#end
			}
		};
		super( Const.APPNAME );
	}

	override function saveSettings() {
		#if hlsdl
		@:privateAccess {
			params.windowWidth = ClientBoot.inst.engine.width;
			params.windowHeight = ClientBoot.inst.engine.height;

			params.windowX = hxd.Window.getInstance().window.x;
			params.windowY = hxd.Window.getInstance().window.y;
		}
		#end
		super.saveSettings();
	}

	override function loadSettings() {
		super.loadSettings();

		#if hlsdl
		@:privateAccess {
			hxd.Window.getInstance().resize( params.windowWidth, params.windowHeight );

			if ( params.windowX > 0 && params.windowY > 0 ) {
				hxd.Window.getInstance().window.setPosition(
					params.windowX,
					params.windowY
				);
			}
		}
		#end
	}
}
