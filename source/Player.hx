package ;

import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;
import org.flixel.util.FlxAngle;
import org.flixel.util.FlxPoint;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Player extends FlxSprite
{
	private static var MAX_HEALTH:Int = 10;
	
	private var _jumpPower:Int;
	private var _bullets:FlxGroup;
	private var _gibs:FlxEmitter;
	private var _restart:Float;
	private var _spawnPoint:FlxPoint;
	
	
	public function new(startX:Float, startY:Float, bullets:FlxGroup, gibs:FlxEmitter) 
	{
		super(startX, startY);
		
		_spawnPoint = new FlxPoint(startX, startY);
		_bullets = bullets;
		_gibs = gibs;
		_restart = 0;
		
		loadGraphic('assets/player.png', true, true, 8, 8);
		width = 6;
		height = 7;
		offset.x = 1;
		offset.y = 1;
		
		var runSpeed:Int = 80;
		drag.x = runSpeed * 8;
		acceleration.y = 420;
		_jumpPower = 200; //TODO: Find a good jump power value.
		maxVelocity.x = runSpeed;
		maxVelocity.y = _jumpPower;
		
		// 2Setup animations.
		addAnimation('idle', [0]);
		addAnimation('run', [1, 2, 3, 4], 12);
		addAnimation('jump', [4, 3, 5], 12, false);
		
		health = MAX_HEALTH;
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		_bullets = null;
		_gibs = null;
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
		if (FlxG.mouse.justPressed()) 
		{
			getMidpoint(_point);
			cast(_bullets.recycle(Bullet), Bullet).shootPrecise(_point, FlxAngle.angleBetweenMouse(this));
		}
		else if (FlxG.keys.justPressed('LEFT')) 
		{
			getMidpoint(_point);
			cast(_bullets.recycle(Bullet), Bullet).shoot(_point, FlxObject.LEFT);
		}
		else if (FlxG.keys.justPressed('RIGHT')) 
		{
			getMidpoint(_point);
			cast(_bullets.recycle(Bullet), Bullet).shoot(_point, FlxObject.RIGHT);
		}
		else if (FlxG.keys.justPressed('UP')) 
		{
			getMidpoint(_point);
			cast(_bullets.recycle(Bullet), Bullet).shoot(_point, FlxObject.UP);
		}
		else if (FlxG.keys.justPressed('DOWN')) 
		{
			getMidpoint(_point);
			cast(_bullets.recycle(Bullet), Bullet).shoot(_point, FlxObject.DOWN);
		}
		
		super.update();
	}
	
	override public function hurt(damage:Float):Void
	{
		flicker(0.2);
		//FlxG.camera.shake(0.002, 0.2);
		
		super.hurt(damage);
	}
	
	override public function kill():Void
	{
		if(!alive)
		{
			return;
		}
		
		super.kill();
		
		flicker(0);
		exists = true;
		visible = false;
		velocity.make();
		acceleration.x = 0;
		
		FlxG.camera.shake(0.05, 0.4);
		//FlxG.camera.flash(0xffd8eba2, 0.35);
		
		if (_gibs != null) 
		{
			_gibs.at(this);
			_gibs.start(true, 5, 0, 35);
		}
	}
	
	
	
	private function respawn() 
	{
		reset(_spawnPoint.x, _spawnPoint.y);
		acceleration.x = 0;
		velocity.make();
		_restart = 0;
		exists = true;
		visible = true;
		health = MAX_HEALTH;
		flicker(1);
	}
	
}