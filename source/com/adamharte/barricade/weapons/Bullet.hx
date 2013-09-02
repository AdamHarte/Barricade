package com.adamharte.barricade.weapons;

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
	
	
	public function new() 
	{
		super();
		
		loadGraphic('assets/bullet.png', true);
		width = 4;
		height = 4;
		offset.x = 6;
		offset.y = 6;
		
		addAnimation('idle', [2]);
		addAnimation('hit', [4, 5, 6], 12, false);
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
		
		velocity.x = 0;
		velocity.y = 0;
		
		alive = false;
		solid = false;
		
		play('hit');
		
		//super.kill();
	}
	
	public function shoot(startLocation:FlxPoint, rotationAngle:Float):Void
	{
		super.reset(startLocation.x - width / 2, startLocation.y - height / 2);
		solid = true;
		play('idle');
		angle = FlxAngle.asDegrees(rotationAngle);
		velocity.x = Math.cos(rotationAngle) * speed;
		velocity.y = Math.sin(rotationAngle) * speed;
	}
}