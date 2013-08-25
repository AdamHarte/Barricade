package ;
import flash.display.BitmapData;
import openfl.Assets;
import org.flixel.FlxAssets;
import org.flixel.FlxCamera;
import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxTilemap;
import org.flixel.util.FlxPoint;
import org.flixel.util.FlxRandom;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class PlayState extends FlxState
{
	static private var TILE_WIDTH:Int = 8;
	static private var TILE_HEIGHT:Int = 8;
	static private var TILE_HALF_WIDTH:Int = 4;
	static private var TILE_HALF_HEIGHT:Int = 4;
	static private var SHUTDOWN_TIME_LIMIT:Float = 10;
	
	private var levelTilesPath:String;
	private var levelObjectsPath:String;
	
	private var _tileMap:FlxTilemap;
	private var _objectMap:FlxTilemap;
	private var _player:Player;
	private var _mainframe:Mainframe;
	private var _enemies:FlxGroup;
	private var _bullets:FlxGroup;
	private var _enemyBullets:FlxGroup;
	private var _walls:FlxGroup;
	private var _playerGibs:FlxEmitter;
	private var _robotGibs:FlxEmitter;
	
	// Collision groups
	private var _hazards:FlxGroup;
	private var _objects:FlxGroup;
	private var _playerStructures:FlxGroup;
	
	private var _playerSpawn:FlxPoint;
	private var _spawnPoint:FlxPoint;
	private var _shutdownTimer:Float;
	private var _isShutdown:Bool;
	
	
	public function new()
	{
		levelTilesPath = 'assets/level_tiles.png';
		levelObjectsPath = 'assets/level_objects.png';
		_shutdownTimer = 0;
		_isShutdown = false;
		
		super();
	}
	
	override public function create():Void
	{
		FlxG.bgColor = 0xff1e2936;
		
		Reg.enemiesKilled = 0;
		Reg.enemiesToSpawn = Reg.currentLevel.enemyCount;
		
		_playerSpawn = new FlxPoint();
		_spawnPoint = new FlxPoint();
		
		// Gibs
		_playerGibs = new FlxEmitter();
		_playerGibs.setXSpeed(-150, 150);
		_playerGibs.setYSpeed(-200, 0);
		_playerGibs.setRotation( -720, -720);
		_playerGibs.gravity = 360;
		_playerGibs.bounce = 0.5;
		_playerGibs.makeParticles('assets/player_gibs.png', 70, 16, true, 0.5);
		
		_robotGibs = new FlxEmitter();
		_robotGibs.setXSpeed(-150, 150);
		_robotGibs.setYSpeed(-200, 0);
		_robotGibs.setRotation( -720, -720);
		_robotGibs.gravity = 360;
		_robotGibs.bounce = 0.5;
		_robotGibs.makeParticles('assets/robot_gibs.png', 100, 16, true, 0.5);
		
		_mainframe = new Mainframe();
		
		// Setup groups.
		_enemies = new FlxGroup();
		_enemies.maxSize = 50;
		
		_bullets = new FlxGroup();
		_bullets.maxSize = 20; //TODO: Test how big this pool should be.
		
		_enemyBullets = new FlxGroup();
		_enemyBullets.maxSize = 100;
		
		_walls = new FlxGroup();
		
		var _bg = new FlxSprite(0, 0, 'assets/bg.png');
		_bg.scale.make(4.0, 4.0);
		_bg.scrollFactor.make(0.2, 0.2);
		
		// Setup tile maps.
		_tileMap = new FlxTilemap();
		Reg.tileMap = _tileMap;
		_objectMap = new FlxTilemap();
		Reg.objectMap = _objectMap;
		buildLevel();
		
		_player = new Player(_playerSpawn.x, _playerSpawn.y, _bullets, _playerGibs);
		
		// Add all the things.
		add(_bg);
		add(_tileMap);
		add(_objectMap);
		add(_mainframe);
		add(_walls);
		add(_player);
		add(_enemies);
		add(_bullets);
		add(_enemyBullets);
		add(_playerGibs);
		add(_robotGibs);
		
		_hazards = new FlxGroup();
		_hazards.add(_enemies);
		_hazards.add(_enemyBullets);
		
		_objects = new FlxGroup();
		_objects.add(_player);
		_objects.add(_enemies);
		_objects.add(_mainframe);
		_objects.add(_bullets);
		_objects.add(_enemyBullets);
		_objects.add(_walls);
		_objects.add(_playerGibs);
		_objects.add(_robotGibs);
		
		_playerStructures = new FlxGroup();
		_playerStructures.add(_mainframe);
		_playerStructures.add(_walls);
		
		// Setup camera.
		FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER);
		//FlxG.camera.zoom = 4;
		
		FlxG.watch(_player, 'health', 'Player health');
		FlxG.watch(Reg, 'enemiesToSpawn', 'enemiesToSpawn');
		
		super.create();
		
		FlxG.camera.fade(0xff000000, 1, true);
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		_player = null;
		_enemies = null;
		_mainframe = null;
		_bullets = null;
		_enemyBullets = null;
		_walls = null;
		_playerGibs = null;
		_robotGibs = null;
		
		_hazards = null;
		_objects = null;
		_playerStructures = null;
		
		_tileMap = null;
		_objectMap = null;
		
	}
	
	override public function update():Void
	{
		// Check win conditions. Killed all enemies, and not bullets still in the air, and the mainframe is still alive.
		if (Reg.enemiesKilled == Reg.currentLevel.enemyCount && _enemyBullets.countLiving() == 0 && _mainframe.alive) 
		{
			FlxG.fade(0xff000000, 1, false, winLevelFadeHandler);
		}
		
		_shutdownTimer += FlxG.elapsed;
		if (_shutdownTimer > SHUTDOWN_TIME_LIMIT) 
		{
			_shutdownTimer = 0;
			_isShutdown = !_isShutdown;
			if (_isShutdown) 
			{
				_enemies.callAll('shutdown');
			}
			else 
			{
				_enemies.callAll('bootup');
			}
		}
		
		FlxG.collide(_tileMap, _objects);
		FlxG.collide(_walls, _enemies);
		FlxG.overlap(_hazards, _player, overlapHandler);
		FlxG.overlap(_hazards, _playerStructures, overlapHandler);
		FlxG.overlap(_bullets, _hazards, overlapHandler);
		
		if (Reg.enemiesToSpawn > 0 && !_isShutdown && FlxRandom.chanceRoll(2)) 
		{
			spawnEnemy();
		}
		
		super.update();
	}
	
	private function spawnEnemy() 
	{
		Reg.enemiesToSpawn--;
		var enemy:Enemy = cast(_enemies.recycle(Enemy), Enemy);
		enemy.init(_spawnPoint.x, _spawnPoint.y, _enemyBullets, _player, _robotGibs, _mainframe);
	}
	
	
	
	private function buildLevel() 
	{
		_tileMap.loadMap(Reg.currentLevel.data, levelTilesPath, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO);
		
		// Place other objects
		_objectMap.loadMap(Reg.currentLevel.objData, levelObjectsPath, TILE_WIDTH, TILE_HEIGHT);
		for (ty in 0..._objectMap.heightInTiles) 
		{
			for (tx in 0..._objectMap.widthInTiles) 
			{
				var tileValue:Int = _objectMap.getTile(tx, ty);
				switch (tileValue) 
				{
					case 0:
						//
					case 1: // Player
						_objectMap.setTile(tx, ty, 0);
						_playerSpawn.make(tx * TILE_WIDTH + TILE_HALF_WIDTH, ty * TILE_HEIGHT + TILE_HALF_HEIGHT);
					case 2: // Mainframe
						_objectMap.setTile(tx, ty, 0);
						_mainframe.init(tx * TILE_WIDTH + TILE_HALF_WIDTH, ty * TILE_HEIGHT + TILE_HALF_HEIGHT, _robotGibs);
					case 3: // Spawner
						_spawnPoint.make(tx * TILE_WIDTH + TILE_HALF_WIDTH, ty * TILE_HEIGHT + TILE_HALF_HEIGHT);
					case 4: // Wall
						_objectMap.setTile(tx, ty, 0);
						var wall:Wall = cast(_walls.recycle(Wall), Wall);
						wall.init(tx * TILE_WIDTH + TILE_HALF_WIDTH, ty * TILE_HEIGHT + TILE_HALF_HEIGHT, _robotGibs);
					default:
						//trace('Unknown tile: ', tileValue);
				}
			}
		}
		
		FlxG.camera.setBounds(0, 0, _tileMap.width, _tileMap.height, true);
	}
	
	
	
	private function overlapHandler(sprite1:FlxObject, sprite2:FlxObject) 
	{
		if (Std.is(sprite1, Bullet) || Std.is(sprite1, EnemyBullet)) 
		{
			sprite1.kill();
		}
		
		// Don't hurt if flickering, unless it is an enemy.
		if ((!sprite1.flickering && !sprite2.flickering) || Std.is(sprite2, Enemy)) 
		{
			if (Std.is(sprite1, Enemy)) 
			{
				// If enemy is shutdown then don't hurt player.
				if (!cast(sprite1, Enemy).isShutdown) 
				{
					sprite2.hurt(1);
				}
			}
			else 
			{
				sprite2.hurt(1);
			}
		}
	}
	
	private function winLevelFadeHandler():Void 
	{
		if (Reg.level == Reg.levels.length - 1) 
		{
			// Beat the last level.
			FlxG.switchState(new WinState());
		}
		else 
		{
			Reg.level++;
			FlxG.resetState();
		}
	}
	
}