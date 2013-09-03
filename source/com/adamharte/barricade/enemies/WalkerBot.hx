package com.adamharte.barricade.enemies;
import com.adamharte.barricade.sprites.Mainframe;
import org.flixel.FlxEmitter;
import com.adamharte.barricade.Player;
import com.adamharte.barricade.Reg;
import org.flixel.FlxGroup;
import org.flixel.util.FlxRandom;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class WalkerBot extends Enemy
{

	public function new() 
	{
		super();
		
		loadGraphic('assets/bot_walker.png', true, true, Reg.tileWidth, Reg.tileHeight);
		width = 12;
		height = 14;
		offset.x = 2;
		offset.y = 2;
		
		_healthMax = 2;
		_reloadTime = 2.0;
		_jumpPower = 220;
		_walkSpeed = FlxRandom.intRanged(50, 70) + (Reg.level * 2);
		_jumpTimerLimit = Math.max(2.0 - (Reg.level * 0.05), 0.1);
		
		drag.x = _walkSpeed * 8;
		acceleration.y = 840;
		maxVelocity.x = _walkSpeed;
		maxVelocity.y = _jumpPower;
		
		// Setup animations.
		addAnimation('idle', [0, 1], 6);
		addAnimation('walk', [2, 3], 6);
		addAnimation('sleep', [4, 5, 6, 7, 8], 6, false);
		addAnimation('wake', [8, 7, 6, 5, 4], 6, false);
		addAnimation('hit', [9, 10, 11, 12], 6);
		addAnimation('jump', [13, 14], 6, false);
	}
	
	override public function init(xPos:Float, yPos:Float, bullets:FlxGroup, player:Player, gibs:FlxEmitter, mainframe:Mainframe):Void 
	{
		super.init(xPos, yPos, bullets, player, gibs, mainframe);
		
		_aggression = FlxRandom.intRanged(2, 4);
	}
	
}