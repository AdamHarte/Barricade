package ;

import haxe.macro.Expr.Function;
import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;
import org.flixel.util.FlxMath;
import org.flixel.util.FlxRandom;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Enemy extends FlxSprite
{
	private static var _reloadTime:Float = 2;
	private static var _jumpPower:Int = 110;
	
	public var isShutdown:Bool;
	
	private var _player:Player;
	private var _bullets:FlxGroup;
	private var _gibs:FlxEmitter;
	private var _mainframe:Mainframe;
	private var _jumpTimer:Float;
	private var _wakeTimer:Float;
	private var _shootTimer:Float;
	private var _aggression:Int;
	
	
	public function new() 
	{
		super();
		
		loadGraphic('assets/bot_walker.png', true, true, 8, 8);
		width = 6;
		height = 7;
		offset.x = 1;
		offset.y = 1;
		
		var walkSpeed:Int = FlxRandom.intRanged(25, 35);
		drag.x = walkSpeed * 8;
		acceleration.y = 420;
		maxVelocity.x = walkSpeed;
		maxVelocity.y = _jumpPower;
		
		// Setup animations.
		addAnimation('idle', [0, 1], 6);
		addAnimation('walk', [2, 3], 6);
		addAnimation('sleep', [4, 5, 6, 7, 8], 6, false);
		addAnimation('wake', [8, 7, 6, 5, 4], 6, false);
		addAnimation('hit', [9, 10, 11, 12], 6);
		addAnimation('jump', [13, 14], 6, false);
		
	}
	
	public function init(xPos:Float, yPos:Float, bullets:FlxGroup, player:Player, gibs:FlxEmitter, mainframe:Mainframe):Void 
	{
		_player = player;
		_bullets = bullets;
		_gibs = gibs;
		_mainframe = mainframe;
		
		reset(xPos - width / 2, yPos - height / 2);
		health = 2;
		isShutdown = false;
		_aggression = 100;// FlxRandom.intRanged(2, 4);
		_jumpTimer = 0;
		_wakeTimer = 0;
		_shootTimer = 0;
		
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		_player = null;
		_bullets = null;
		_gibs = null;
		_mainframe = null;
	}
	
	override public function update():Void 
	{
		acceleration.x = 0;
		
		var isAwake:Bool = false;
		if (!isShutdown) 
		{
			_wakeTimer += FlxG.elapsed;
			if (_wakeTimer > 0.6) 
			{
				isAwake = true;
			}
		}
		
		if (isAwake) 
		{
			if (!flickering) 
			{
				if (velocity.y == 0) 
				{
					play('walk');
				}
				acceleration.x -= drag.x;
			}
			
			if (velocity.y == 0 && isTouching(FlxObject.LEFT)) 
			{
				_jumpTimer += FlxG.elapsed;
				if (_jumpTimer > 2) 
				{
					velocity.y = -_jumpPower;
					play('jump');
					_jumpTimer = 0;
				}
			}
			else
			{
				_jumpTimer = 0;
			}
			
			if (velocity.x > 0) 
			{
				facing = FlxObject.RIGHT;
			}
			else if (velocity.x < 0)
			{
				facing = FlxObject.LEFT;
			}
			
			_shootTimer = Math.max(_shootTimer - FlxG.elapsed, 0);
			
			// Shoot
			var minShootRange:Int = 80; // Just under half the screen
			var playerDist:Int = FlxMath.distanceBetween(this, _player);
			var mainframeDist:Int = FlxMath.distanceBetween(this, _mainframe);
			
			if (_shootTimer == 0 && (playerDist < minShootRange || mainframeDist < minShootRange)) 
			{
				var canSeePlayer:Bool = Reg.tileMap.ray(getMidpoint(), _player.playerMidPoint);
				if (canSeePlayer && FlxRandom.chanceRoll(_aggression)) 
				{
					shoot();
				}
			}
		}
		
		super.update();
	}
	
	override public function hurt(damage:Float):Void 
	{
		play('hit');
		flicker(0.4);
		Reg.score += 10;
		
		super.hurt(damage);
	}
	
	override public function kill():Void 
	{
		if (!alive) 
		{
			return;
		}
		
		super.kill();
		
		flicker(0);
		_gibs.at(this);
		_gibs.start(true, 3, 0, 20);
		Reg.score += 100;
		Reg.enemiesKilled++;
	}
	
	public function shutdown():Void 
	{
		isShutdown = true;
		play('sleep');
		
	}
	
	public function bootup():Void 
	{
		isShutdown = false;
		_wakeTimer = 0;
		play('wake');
	}
	
	private function shoot() 
	{
		_shootTimer = _reloadTime;
		var bullet:EnemyBullet = cast(_bullets.recycle(EnemyBullet), EnemyBullet);
		bullet.shoot(getMidpoint(), FlxObject.LEFT);
	}
	
	
	
}