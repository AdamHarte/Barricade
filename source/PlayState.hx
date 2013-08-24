package ;
import flash.display.BitmapData;
import openfl.Assets;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxState;
import org.flixel.FlxTilemap;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class PlayState extends FlxState
{
	private var TILE_WIDTH:Int;
	private var TILE_HEIGHT:Int;
	
	private var _player:Player;
	private var _tileMap:FlxTilemap;
	private var _objects:FlxGroup;
	
	
	public function new()
	{
		TILE_WIDTH = 8;
		TILE_HEIGHT = 8;
		
		super();
	}
	
	override public function create():Void
	{
		FlxG.bgColor = 0xff1e2936;
		
		_tileMap = new FlxTilemap();
		//_tileMap.loadMap(Assets.getText('assets/default_level.txt'), 'assets/level_tiles.png', TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO);
		var levelBMP:BitmapData = Assets.getBitmapData('assets/level01.png');
		var levelCSV:String = FlxTilemap.bitmapToCSV(levelBMP);
		_tileMap.loadMap(levelCSV, 'assets/level_tiles.png', TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO);
		add(_tileMap);
		
		_player = new Player(40, 40);
		
		
		
		
		// Add all the things.
		add(_player);
		
		// Setup camera.
		FlxG.camera.setBounds(0, 0, 800, 800, true);
		FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER);
		//FlxG.camera.zoom = 2;
		
		
		_objects = new FlxGroup();
		_objects.add(_player);
		
		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		_player = null;
		
		_objects = null;
		
	}
	
	override public function update():Void
	{
		FlxG.collide(_tileMap, _objects);
		
		super.update();
	}
	
	
	
	private function buildLevel() 
	{
		
	}
	
}