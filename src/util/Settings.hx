package util;

import core.MutableProperty;

class Settings extends util.tools.Settings<
	{
		nickname : String,
		fullscreen : Bool,
		orthographics : MutableProperty<Bool>,
		saveFiles : Array<String>,
		windowWidth : Int,
		windowHeight : Int,
		windowX : Int,
		windowY : Int,
		debug : {
			physicsDebugVisible : MutableProperty<Bool>
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
			nickname : "unnamed player",
			fullscreen : false,
			orthographics : new MutableProperty( false ),
			saveFiles : [],
			windowWidth : 900,
			windowHeight : 650,
			windowX : -1,
			windowY : -1,
			debug : {
				physicsDebugVisible : new MutableProperty( false )
			}
		};
		super( Const.APPNAME );
	}

	override function saveSettings() {
		#if hlsdl
		@:privateAccess {
			params.windowWidth = Boot.inst.engine.width;
			params.windowHeight = Boot.inst.engine.height;

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
