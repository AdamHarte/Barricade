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
	private var _bullets:FlxGroup;
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
		
		// Generate levels.
		Reg.addLevel('assets/levels/01.png');
		Reg.addLevel('assets/levels/02.png');
		
		
		
		_tileMap = new FlxTilemap();
		_tileMap.loadMap(Reg.levels[Reg.level], 'assets/level_tiles.png', TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO);
		add(_tileMap);
		
		_bullets = new FlxGroup();
		_bullets.maxSize = 50; //TODO: Test how big this pool should be.
		
		_player = new Player(40, 40, _bullets);
		
		
		
		
		// Add all the things.
		add(_player);
		
		// Setup camera.
		FlxG.camera.setBounds(0, 0, 800, 800, true);
		FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER);
		//FlxG.camera.zoom = 2;
		
		add(_bullets);
		
		_objects = new FlxGroup();
		_objects.add(_player);
		_objects.add(_bullets);
		
		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		_player = null;
		_bullets = null;
		
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