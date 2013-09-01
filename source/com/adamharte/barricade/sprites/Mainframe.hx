package com.adamharte.barricade.sprites;

import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
#if (flash)
import org.flixel.plugin.photonstorm.api.FlxKongregate;
#end

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Mainframe extends FlxSprite
{
	private var _gibs:FlxEmitter;
	private var _restart:Float;
	
	
	public function new() 
	{
		super();
		
		_restart = 0;
		
		loadGraphic('assets/mainframe.png', true, false, Reg.tileWidth, Reg.tileHeight);
		width = 12;
		height = 14;
		offset.x = 2;
		offset.y = 2;
		immovable = true;
		
		// Setup animations.
		addAnimation('idle', [1, 2], 2);
		addAnimation('dead', [3, 4, 5, 6], 6);
	}
	
	public function init(xPos:Float, yPos:Float, gibs:FlxEmitter):Void 
	{
		_gibs = gibs;
		reset(xPos - width / 2, yPos - height / 2);
		health = 5;
		play('idle');
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		_gibs = null;
	}
	
	override public function update():Void 
	{
		if (!alive) 
		{
			_restart += FlxG.elapsed;
			var delta:Float = Math.min(_restart / 2, 1.0);
			FlxG.timeScale = (0.8 * delta) + 0.2;
			if (_restart > 4) 
			{
				FlxG.resetState();
			}
		}
		
		super.update();
	}
	
	override public function hurt(damage:Float):Void 
	{
		//play('hit');
		flicker(0.4);
		Reg.score -= 20;
		
		super.hurt(damage);
	}
	
	override public function kill():Void 
	{
		if (!alive) 
		{
			return;
		}
		
		super.kill();
		
		#if (flash)
		if (FlxKongregate.hasLoaded) 
		{
			FlxKongregate.submitStats('MainframeDeaths', 1);
		}
		#end
		
		flicker(0);
		exists = true;
		play('dead');
		FlxG.play('Explosion', 0.8);
		
		_gibs.at(this);
		_gibs.start(true, 3, 0, 20);
		
		//Reg.score -= 100;
		Reg.statusText.text = 'FAIL';
		
		FlxG.camera.shake(0.05, 0.4);
		FlxG.camera.flash(0xffd7c590, 0.35);
		FlxG.timeScale = 0.2;
	}
	
}