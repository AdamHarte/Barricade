package com.adamharte.barricade;

import flash.events.Event;
import flash.Lib;
import openfl.Assets;
import org.flixel.FlxG;
import org.flixel.FlxGame;
#if (flash)
import org.flixel.plugin.photonstorm.api.FlxKongregate;
#end

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Barricade extends FlxGame
{	
	public function new()
	{
		loadLevels();
		
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var zoomLevel:Int = 2; // {400, 240}
		var ratioX:Float = stageWidth / (800 / zoomLevel);
		var ratioY:Float = stageHeight / (480 / zoomLevel);
		var ratio:Float = Math.min(ratioX, ratioY);
		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), MenuState, ratio, 60, 60);
		
		var gameHud:GameHUD = new GameHUD();
		Reg.gameHud = gameHud;
		
		if (stage != null) 
			init();
		else 
			addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function loadLevels() 
	{
		Reg.addLevel('Main Entry', 		'01', 20);
		Reg.addLevel('Main Entry 2', 	'02', 40);
		Reg.addLevel('Small caves',		'03', 60);
		Reg.addLevel('Triple', 			'04', 70);
		Reg.addLevel('Waterfall', 		'05', 60);
		Reg.addLevel('Pitfall', 		'06', 80);
		Reg.addLevel('Long roads', 		'07', 100);
		Reg.addLevel('Barricade', 		'08', 80);
		
	}
	
	private function init(?e:Event = null):Void 
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		#if (flash)
		FlxKongregate.init(kongInitHandler);
		#end
		
	}
	
	
	#if (flash)
	private function kongInitHandler() 
	{
		FlxKongregate.connect();
	}
	#end
}
