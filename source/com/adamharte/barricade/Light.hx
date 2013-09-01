package com.adamharte.barricade;

import org.flixel.FlxSprite;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Light extends FlxSprite
{
	private var _lightType:Int;
	private var _darkness:FlxSprite;
	
	
	public function new() 
	{
		super();
		
		loadGraphic('assets/lights.png', true, true, Reg.tileWidth, Reg.tileHeight);
		
		// Setup animations.
		addAnimation('light0_on', [0], 6, false);
		addAnimation('light0_off', [1], 6, false);
		addAnimation('light1_on', [2], 6, false);
		addAnimation('light1_off', [3], 6, false);
		
	}
	
	public function init(xPos:Float, yPos:Float, lightType:Int, darkness:FlxSprite):Void 
	{
		reset(xPos - width / 2, yPos - height / 2);
		_lightType = lightType;
		_darkness = darkness;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		_darkness = null;
	}
	
	override public function update():Void 
	{
		var onOff:String = (Reg.isShutdown) ? '_off' : '_on';
		play('light' + Std.string(_lightType) + onOff);
		
		super.update();
	}
	
}