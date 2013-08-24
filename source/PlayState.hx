package ;
import flash.display.BitmapData;
import openfl.Assets;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxTilemap;
import org.flixel.util.FlxRandom;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class PlayState extends FlxState
{
	static private var TILE_WIDTH:Int = 8;
	static private var TILE_HEIGHT:Int = 8;
	
	private var _tileMap:FlxTilemap;
	private var _player:Player;
	private var _enemies:FlxGroup;
	private var _bullets:FlxGroup;
	private var _enemyBullets:FlxGroup;
	
	// Collision groups
	private var _hazards:FlxGroup;
	private var _objects:FlxGroup;
	
	
	public function new()
	{
		
		super();
	}
	
	override public function create():Void
	{
		FlxG.bgColor = 0xff1e2936;
		
		// Generate levels.
		Reg.addLevel('assets/levels/01.png');
		Reg.addLevel('assets/levels/02.png');
		
		
		var _bg = new FlxSprite(0, 0, 'assets/bg.png');
		_bg.scale.make(4.0, 4.0);
		_bg.scrollFactor.make(0.2, 0.2);
		
		_tileMap = new FlxTilemap();
		_tileMap.loadMap(Reg.levels[Reg.level], 'assets/level_tiles.png', TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO);
		
		_enemies = new FlxGroup();
		_enemies.maxSize = 50;
		
		_bullets = new FlxGroup();
		_bullets.maxSize = 20; //TODO: Test how big this pool should be.
		
		_enemyBullets = new FlxGroup();
		_enemyBullets.maxSize = 100;
		
		
		_player = new Player(40, 40, _bullets);
		
		// Add all the things.
		add(_bg);
		add(_tileMap);
		add(_player);
		add(_enemies);
		add(_bullets);
		add(_enemyBullets);
		
		_hazards = new FlxGroup();
		_hazards.add(_enemies);
		_hazards.add(_enemyBullets);
		
		_objects = new FlxGroup();
		_objects.add(_player);
		_objects.add(_enemies);
		_objects.add(_bullets);
		_objects.add(_enemyBullets);
		
		// Setup camera.
		FlxG.camera.setBounds(0, 0, 800, 800, true);
		FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER);
		//FlxG.camera.zoom = 4;
		
		FlxG.watch(_player, 'health', 'Player health');
		
		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		_player = null;
		_enemies = null;
		_bullets = null;
		_enemyBullets = null;
		
		_hazards = null;
		_objects = null;
		
	}
	
	override public function update():Void
	{
		FlxG.collide(_tileMap, _objects);
		FlxG.overlap(_hazards, _player, overlapHandler);
		FlxG.overlap(_bullets, _hazards, overlapHandler);
		
		if (FlxRandom.chanceRoll(2)) 
		{
			var enemy:Enemy = cast(_enemies.recycle(Enemy), Enemy);
			enemy.init(FlxRandom.intRanged(0, FlxG.width), FlxRandom.intRanged(0, FlxG.height), _enemyBullets, _player);
		}
		
		super.update();
	}
	
	
	
	private function overlapHandler(sprite1:FlxObject, sprite2:FlxObject) 
	{
		if (Std.is(sprite1, Bullet) || Std.is(sprite1, EnemyBullet)) 
		{
			sprite1.kill();
		}
		sprite2.hurt(1);
	}
	
}