package ui;

import dn.Tweenie.TType;
import dn.heaps.slib.HSprite;
import h2d.Bitmap;
import h2d.Flow;
import h2d.Object;
import h2d.Tile;
import h3d.Vector4;
import h3d.mat.Texture;
import hxd.System;
import util.Assets;
import util.GameUtil;
import ui.core.Button;
import ui.core.TextButton;
import ui.dialog.ConnectMenu;
import ui.dialog.OptionsMenu;
import ui.dialog.PopupBase;

class MainMenu extends PopupBase {

	static var inst : MainMenu;

	var vertFlow : Flow;
	var socialFlow : Flow;
	var planetFlow : Object;
	var blackOverlay : Bitmap;

	public function new( ?parent : Object ) {
		super( parent );

		escapableByKey = false;

		vertFlow = new Flow( contentFlow );
		socialFlow = new Flow( contentFlow );
		planetFlow = new Object( contentFlow );

		contentFlow.getProperties( vertFlow ).isAbsolute = true;
		contentFlow.getProperties( socialFlow ).isAbsolute = true;
		contentFlow.getProperties( planetFlow ).isAbsolute = true;

		vertFlow.paddingLeft = 10;
		vertFlow.verticalAlign = Middle;
		vertFlow.layout = Vertical;
		vertFlow.verticalSpacing = 1;

		vertFlow.addSpacing( 10 );

		new TextButton(
			"connect",
			( _ ) -> new ConnectMenu( contentFlow ),
			vertFlow
		);

		new TextButton(
			"options",
			( _ ) -> new OptionsMenu( root ),
			vertFlow
		);

		new TextButton(
			"quitnow",
			( _ ) -> System.exit(),
			vertFlow
		);

		// createAppearFlash();

		// Boot.inst.engine.backgroundColor = 0x0c0c0c;

		#if debug
		// delayer.addF(() -> {
		// 	var client = new DebugClient();
		// 	isHostDebug = new ShadowedText( contentFlow );
		// 	contentFlow.getProperties( isHostDebug ).isAbsolute = true;
		// 	client.onConnection.add(() -> {
		// 		client.requestServerStatus( ( msg : Message ) -> {
		// 			switch msg {
		// 				case ServerStatus( isHost ):
		// 					trace( "got respond" );

		// 					if ( isHost ) {
		// 						isHostDebug.color = dn.Color.intToVector( 0x4cbb17 );
		// 						isHostDebug.text = "Host online";
		// 					} else {
		// 						isHostDebug.color = dn.Color.intToVector( 0xff0038 );
		// 						isHostDebug.text = "Host offline";
		// 					}
		// 				default: "";
		// 			}
		// 		} );
		// 	}, true );
		// }, 10 );
		#end

		ca.releaseExclusivity();

		onResize();
	}

	function createPlanetShader() {
		var riversBmp = new Bitmap( Tile.fromTexture( new Texture( 100, 100 ) ).center(), planetFlow );

		var riversShader = new shader.planets.rivers.Rivers();
		riversShader.pixels = 100;
		riversShader.river_cutoff = 0.368;
		riversShader.col1 = new Vector4( 0.388235, 0.670588, 0.247059, 1 );
		riversShader.col2 = new Vector4( 0.231373, 0.490196, 0.309804, 1 );
		riversShader.col3 = new Vector4( 0.184314, 0.341176, 0.32549, 1 );
		riversShader.col4 = new Vector4( 0.156863, 0.207843, 0.25098, 1 );
		riversShader.river_col = new Vector4( 0.309804, 0.643137, 0.721569, 1 );
		riversShader.river_col_dark = new Vector4( 0.25098, 0.286275, 0.45098, 1 );
		riversShader.dither_size = 2;
		riversShader.seed = Random.float( 1, 10 );
		riversShader.size = 3;
		riversShader.OCTAVES = 5;

		riversBmp.addShader( riversShader );

		var cloudsBmp = new Bitmap( Tile.fromTexture( new Texture( 102, 102 ) ).center(), planetFlow );

		var cloudsShader = new shader.planets.landMasses.Clouds();
		cloudsShader.pixels = 102;
		cloudsShader.cloud_cover = 0.47;
		cloudsShader.stretch = 2;
		cloudsShader.cloud_curve = 1.3;
		cloudsShader.light_border_1 = 0.52;
		cloudsShader.light_border_2 = 0.62;
		cloudsShader.base_color = new Vector4( 0.960784, 1, 0.909804, 1 );
		cloudsShader.outline_color = new Vector4( 0.87451, 0.878431, 0.909804, 1 );
		cloudsShader.shadow_base_color = new Vector4( 0.407843, 0.435294, 0.6, 1 );
		cloudsShader.shadow_outline_color = new Vector4( 0.25098, 0.286275, 0.45098, 1 );
		cloudsShader.size = 7.315;
		cloudsShader.OCTAVES = 2;
		cloudsShader.seed = Random.float( 1, 10 );

		cloudsBmp.addShader( cloudsShader );

		planetFlow.scale( 1.9 );

		cloudsShader.time_speed = 0.05;
		riversShader.time_speed = 0.03;
	}

	function createSocials() {
		socialFlow.verticalAlign = Bottom;
		socialFlow.horizontalAlign = Right;
		socialFlow.paddingRight = 7;
		socialFlow.paddingBottom = 7;
		socialFlow.horizontalSpacing = 9;

		var disco0 = new HSprite( Assets.ui, "discord0" );
		var disco1 = new HSprite( Assets.ui, "discord1" );
		var disco2 = new HSprite( Assets.ui, "discord2" );

		var disco = new Button( [disco0.tile, disco1.tile, disco2.tile], socialFlow );
		disco.scale( .5 );
		disco.onClickEvent.add( ( _ ) -> {
			System.openURL( "https://discord.gg/8v2DFd6" );
		} );

		var twitter0 = new HSprite( Assets.ui, "twitter0" );
		var twitter1 = new HSprite( Assets.ui, "twitter1" );
		var twitter2 = new HSprite( Assets.ui, "twitter2" );

		var twitter = new Button( [twitter0.tile, twitter1.tile, twitter2.tile], socialFlow );
		twitter.scale( .5 );
		twitter.onClickEvent.add( ( _ ) -> {
			System.openURL( "https://twitter.com/GlassySundew" );
		} );

		socialFlow.addSpacing( -4 );

		var vk0 = new HSprite( Assets.ui, "vk0" );
		var vk1 = new HSprite( Assets.ui, "vk1" );
		var vk2 = new HSprite( Assets.ui, "vk2" );

		var vk = new Button( [vk0.tile, vk1.tile, vk2.tile], socialFlow );
		vk.scale( .5 );
		vk.onClickEvent.add( ( _ ) -> System.openURL( "https://vk.com/totalcondemn" ) );
		socialFlow.getProperties( vk ).offsetY = -1;
	}

	function createAppearFlash() {
		blackOverlay = new Bitmap( Tile.fromColor( 0x000000, GameUtil.wScaled, GameUtil.hScaled ) );

		contentFlow.addChildAt( blackOverlay, 1000 );
		contentFlow.getProperties( blackOverlay ).isAbsolute = true;

		Main.inst.tw.createS( blackOverlay.alpha, 1 > 0, TType.TBackOut, 2 ).end(() -> {
			blackOverlay.remove();
			blackOverlay = null;
			trace( "asdasdasd" );
		} );
	}

	override function onResize() {
		super.onResize();

		if ( vertFlow == null ) return;

		vertFlow.minHeight = //
			vertFlow.maxHeight = //
				socialFlow.minHeight = //
					socialFlow.maxHeight = //
						contentFlow.minHeight = //
							contentFlow.maxHeight = Std.int( GameUtil.hScaled );
		vertFlow.minWidth = vertFlow.maxWidth = socialFlow.minWidth = socialFlow.maxWidth = contentFlow.minWidth = contentFlow.maxWidth = Std.int( GameUtil.wScaled );
	}

	override function onDispose() {
		super.onDispose();
		contentFlow.remove();
		inst = null;
		if ( blackOverlay != null ) blackOverlay.remove();
	}

	override function update() {
		super.update();
	}
}
