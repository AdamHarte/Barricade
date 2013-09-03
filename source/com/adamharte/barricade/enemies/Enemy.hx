package com.adamharte.barricade.enemies;

import com.adamharte.barricade.Player;
import com.adamharte.barricade.Reg;
import com.adamharte.barricade.sprites.Mainframe;
import com.adamharte.barricade.weapons.Bullet;
import haxe.macro.Expr.Function;
import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;
import org.flixel.util.FlxMath;
import org.flixel.util.FlxPoint;
import org.flixel.util.FlxRandom;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Enemy extends FlxSprite
{
	public var isShutdown:Bool;
	public var atMainframe:Bool;
	
	private var _healthMax:Float;
	private var _reloadTime:Float;
	private var _jumpPower:Int;
	private var _walkSpeed:Int;
	private var _player:Player;
	private var _bullets:FlxGroup;
	private var _gibs:FlxEmitter;
	private var _mainframe:Mainframe;
	private var _jumpTimer:Float;
	private var _jumpTimerLimit:Float;
	private var _wakeTimer:Float;
	private var _shootTimer:Float;
	private var _aggression:Int;
	
	
	public function new() 
	{
		super();
	}
	
	public function init(xPos:Float, yPos:Float, bullets:FlxGroup, player:Player, gibs:FlxEmitter, mainframe:Mainframe):Void 
	{
		_player = player;
		_bullets = bullets;
		_gibs = gibs;
		_mainframe = mainframe;
		
		reset(xPos - width / 2, yPos - height / 2);
		health = _healthMax;
		atMainframe = false;
		isShutdown = false;
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
			
			if (!atMainframe && velocity.y == 0) 
			{
				if (isTouching(FlxObject.LEFT)) // blocked by anything but the mainframe.
				{
					_jumpTimer += FlxG.elapsed;
					if (_jumpTimer > _jumpTimerLimit) 
					{
						velocity.y = -_jumpPower;
						play('jump');
						_jumpTimer = 0;
					}
				}
				else if (isTouching(FlxObject.FLOOR))
				{
					//Detect if walking off edge, and randomly decide to jump.
					var tx:Int = Math.round(x / Reg.tileWidth);
					var ty:Int = Math.round(y / Reg.tileHeight);
					var tile:Int = Reg.tileMap.getTile(tx - 1, ty + 1);
					var chance:Int = 5;
					if (tile == 0 && FlxRandom.chanceRoll(chance)) 
					{
						velocity.y = -_jumpPower;
						play('jump');
					}
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
			//TODO: These low level bots just always shoot, but better ones should be more targeted.
			//var minShootRange:Int = 80; // Just under half the screen
			//var playerDist:Int = FlxMath.distanceBetween(this, _player);
			//var mainframeDist:Int = FlxMath.distanceBetween(this, _mainframe);
			if (_shootTimer == 0 /*&& (playerDist < minShootRange || mainframeDist < minShootRange)*/) 
			{
				//var canSeePlayer:Bool = Reg.tileMap.ray(getMidpoint(), _player.playerMidPoint);
				if (/*canSeePlayer &&*/ FlxRandom.chanceRoll(_aggression)) 
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
		
		FlxG.play('Explosion', 0.5);
		
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
		
		// Make the shoot sound.
		FlxG.play('EnemyShoot', 0.3);
		
		// Fire the bullet.
		var bullet:Bullet = cast(_bullets.recycle(Bullet), Bullet);
		bullet.speed = 200;
		bullet.shoot(getMidpoint(), Math.PI);
		
		
		
	}
	
	
	
}