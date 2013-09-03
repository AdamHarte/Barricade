package com.adamharte.barricade.enemies;
import com.adamharte.barricade.Reg;
import com.adamharte.barricade.sprites.Mainframe;
import org.flixel.FlxEmitter;
import com.adamharte.barricade.Player;
import org.flixel.FlxGroup;
import org.flixel.util.FlxRandom;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class SpiderBot extends Enemy
{

	public function new() 
	{
		super();
		
		loadGraphic('assets/spiderbot.png', true, true, Reg.tileWidth, Reg.tileHeight);
		width = 14;
		height = 8;
		offset.x = 1;
		offset.y = 8;
		
		_healthMax = 1;
		_reloadTime = 2.0;
		_jumpPower = 300;
		_walkSpeed = FlxRandom.intRanged(50, 70) + (Reg.level * 2);
		_jumpTimerLimit = Math.max(1.0 - (Reg.level * 0.02), 0.01);
		
		drag.x = _walkSpeed * 8;
		acceleration.y = 840;
		maxVelocity.x = _walkSpeed;
		maxVelocity.y = _jumpPower;
		
		// Setup animations.
		addAnimation('idle', [0, 1], 6);
		addAnimation('walk', [2, 3, 4, 0], 12);
		addAnimation('sleep', [5, 6, 7, 8, 9], 6, false);
		addAnimation('wake', [9, 8, 7, 6, 5], 6, false);
		addAnimation('hit', [10, 11, 12, 13], 6);
		addAnimation('jump', [14, 15], 6, false);
	}
	
	override public function init(xPos:Float, yPos:Float, bullets:FlxGroup, player:Player, gibs:FlxEmitter, mainframe:Mainframe):Void 
	{
		super.init(xPos, yPos, bullets, player, gibs, mainframe);
		
		_aggression = FlxRandom.intRanged(2, 4);
	}
	
	
	
	override private function shoot() 
	{
		//super.shoot();
		
		
	}
	
}