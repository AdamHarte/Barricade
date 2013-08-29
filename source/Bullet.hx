package ;

import org.flixel.addons.FlxTrail;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;
import org.flixel.util.FlxAngle;
import org.flixel.util.FlxPoint;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Bullet extends FlxSprite
{
	public var speed:Float;
	public var trail:FlxTrail;
	
	
	public function new() 
	{
		super();
		
		speed = 350;
		
		loadGraphic('assets/bullet.png', true);
		width = 4;
		height = 4;
		offset.x = 6;
		offset.y = 6;
		
		addAnimation('idle', [0]);
		addAnimation('hit', [1, 2, 3], 12, false);
	}
	
	override public function update():Void
	{
		if (!alive) 
		{
			if (finished) 
			{
				exists = false;
			}
		}
		else if (touching != 0) 
		{
			kill();
		}
		
		super.update();
	}
	
	override public function kill():Void
	{
		if(!alive)
		{
			return;
		}
		
		trail.kill();
		
		velocity.x = 0;
		velocity.y = 0;
		
		alive = false;
		solid = false;
		
		play('hit');
		
		//super.kill();
	}
	
	public function shoot(location:FlxPoint, direction:Int):Void
	{
		super.reset(location.x - width / 2, location.y - height / 2);
		solid = true;
		angle = 0;
		play('idle');
		switch (direction) 
		{
			case FlxObject.UP:
				velocity.y = -speed;
			case FlxObject.DOWN:
				velocity.y = speed;
			case FlxObject.LEFT:
				velocity.x = -speed;
			case FlxObject.RIGHT:
				velocity.x = speed;
		}
	}
	
	public function shootPrecise(location:FlxPoint, rotationAngle:Float):Void
	{
		super.reset(location.x - width / 2, location.y - height / 2);
		solid = true;
		play('idle');
		velocity.x = Math.cos(rotationAngle) * speed;
		velocity.y = Math.sin(rotationAngle) * speed;
	}
}