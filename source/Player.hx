package ;

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
	private var _jumpPower:Int;
	private var _bullets:FlxGroup;
	
	
	public function new(x:Int, y:Int, bullets:FlxGroup) 
	{
		super(x, y);
		
		loadGraphic('assets/player.png', true, true, 8, 8);
		width = 6;
		height = 7;
		offset.x = 1;
		offset.y = 0;
		
		var runSpeed:Int = 80;
		drag.x = runSpeed * 8;
		acceleration.y = 420;
		_jumpPower = 200;
		maxVelocity.x = runSpeed;
		maxVelocity.y = _jumpPower;
		
		//Setup animations.
		addAnimation('idle', [0]);
		addAnimation('run', [1, 2, 3, 4], 12);
		addAnimation('jump', [4, 3, 5], 12, false);
		
		_bullets = bullets;
		
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		_bullets = null;
	}
	
	override public function update():Void
	{
		
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
		if ((FlxG.keys.justPressed('W') || FlxG.keys.justPressed('SPACE')) && velocity.y == 0) 
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
		
		FlxG.camera.shake(0.05, 0.4);
		
	}
	
}