package com.adamharte.barricade;

import org.flixel.addons.FlxTrail;
import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;
import org.flixel.util.FlxAngle;
import org.flixel.util.FlxPoint;
#if (flash)
import org.flixel.plugin.photonstorm.api.FlxKongregate;
#end

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Player extends FlxSprite
{
	private static var _maxHealth:Int = 10;
	private static var _jumpPower:Int = 300;
	
	public var playerMidPoint:FlxPoint;
	
	private var _bullets:FlxGroup;
	private var _bulletTrails:FlxGroup;
	private var _gibs:FlxEmitter;
	private var _restart:Float;
	private var _spawnPoint:FlxPoint;
	private var _reloadTimer:Float;
	private var _reloadMax:Float;
	
	
	public function new(startX:Float, startY:Float, bullets:FlxGroup, gibs:FlxEmitter, bulletTrails:FlxGroup) 
	{
		super(startX, startY);
		
		_spawnPoint = new FlxPoint(startX, startY);
		_bullets = bullets;
		_gibs = gibs;
		_bulletTrails = bulletTrails;
		
		playerMidPoint = new FlxPoint();
		_restart = 0;
		_reloadTimer = 0;
		_reloadMax = 0.2;
		
		loadGraphic('assets/player.png', true, true, Reg.tileWidth, Reg.tileHeight);
		width = 12;
		height = 16;
		offset.x = 2;
		
		var runSpeed:Int = 150;
		drag.x = runSpeed * 8;
		acceleration.y = 840;
		maxVelocity.x = runSpeed;
		maxVelocity.y = _jumpPower;
		
		// Setup animations.
		addAnimation('idle', [0]);
		addAnimation('run', [1, 2, 3, 4], 12);
		addAnimation('jump', [4, 3, 5], 12, false);
		
		health = _maxHealth;
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		_bullets = null;
		_gibs = null;
		playerMidPoint = null;
	}
	
	override public function update():Void
	{
		if (!alive) 
		{
			_restart += FlxG.elapsed;
			if (_restart > 2) 
			{
				respawn();
			}
			return;
		}
		
		getMidpoint(playerMidPoint);
		
		// Movement
		acceleration.x = 0;
		if(FlxG.keys.A)
		{
			facing = FlxObject.LEFT;
			acceleration.x -= drag.x;
		}
		else if(FlxG.keys.D)
		{
			facing = FlxObject.RIGHT;
			acceleration.x += drag.x;
		}
		
		// Jumping
		if (velocity.y == 0 && (FlxG.keys.justPressed('W') || FlxG.keys.justPressed('SPACE'))) 
		{
			velocity.y = -_jumpPower;
			FlxG.play('Jump', 0.5);
			play('jump');
		}
		
		// Animation
		if (velocity.y != 0)
		{
			// Don't change animation if our Y vel is zero.
		}
		else if(velocity.x == 0)
		{
			play('idle');
		}
		else 
		{
			play('run');
		}
		
		// Shoot
		_reloadTimer += FlxG.elapsed;
		var shotReady:Bool = false;
		if (_reloadTimer >= _reloadMax) 
		{
			_reloadTimer = 0;
			shotReady = true;
		}
		if (FlxG.mouse.justPressed() || (shotReady && FlxG.mouse.pressed())) 
		{
			shoot(FlxAngle.angleBetweenMouse(this));
		}
		else if (FlxG.keys.justPressed('LEFT') || (shotReady && FlxG.keys.LEFT)) 
		{
			shoot(Math.PI);
		}
		else if (FlxG.keys.justPressed('RIGHT') || (shotReady && FlxG.keys.RIGHT)) 
		{
			shoot(0);
		}
		else if (FlxG.keys.justPressed('UP') || (shotReady && FlxG.keys.UP)) 
		{
			shoot(Math.PI * 1.5);
		}
		else if (FlxG.keys.justPressed('DOWN') || (shotReady && FlxG.keys.DOWN)) 
		{
			shoot(Math.PI * 0.5);
		}
		
		super.update();
	}
	
	override public function hurt(damage:Float):Void
	{
		flicker(0.2);
		
		super.hurt(damage);
	}
	
	override public function kill():Void
	{
		if(!alive)
		{
			return;
		}
		
		super.kill();
		
		#if (flash)
		if (FlxKongregate.hasLoaded) 
		{
			FlxKongregate.submitStats('Deaths', 1);
		}
		#end
		
		flicker(0);
		FlxG.play('Explosion', 0.6);
		exists = true;
		visible = false;
		velocity.make();
		acceleration.x = 0;
		
		_gibs.at(this);
		_gibs.start(true, 5, 0, 35);
		
		FlxG.camera.shake(0.05, 0.4);
	}
	
	
	
	private function respawn() 
	{
		reset(_spawnPoint.x, _spawnPoint.y);
		acceleration.x = 0;
		velocity.make();
		_restart = 0;
		exists = true;
		visible = true;
		health = _maxHealth;
		_reloadTimer = 0;
		flicker(1);
	}
	
	private function shoot(angle:Float) 
	{
		_reloadTimer = 0;
		
		// Make the shoot sound.
		var soundId:String = (FlxG.timeScale < 0.7) ? 'ShootSlow' : 'Shoot';
		FlxG.play(soundId, 0.5);
		
		// Fire the bullet.
		var bullet:Bullet = cast(_bullets.recycle(Bullet), Bullet);
		bullet.shoot(playerMidPoint, angle);
		
		// Add trail.
		if (bullet.trail == null) 
		{
			var trail:FlxTrail = new FlxTrail(bullet, 'assets/bullet_trail.png', 4, 0, 0.8, 0.15);
			bullet.trail = trail;
			_bulletTrails.add(trail);
		}
		else 
		{
			bullet.trail.sprite = bullet;
			bullet.trail.resetTrail();
			bullet.trail.revive();
		}
	}
	
}