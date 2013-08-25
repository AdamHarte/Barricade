package;

import flash.Lib;
import openfl.Assets;
import org.flixel.FlxGame;

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
		var zoomLevel:Int = 4; // 200, 120
		var ratioX:Float = stageWidth / (800 / zoomLevel);
		var ratioY:Float = stageHeight / (480 / zoomLevel);
		var ratio:Float = Math.min(ratioX, ratioY);
		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), MenuState, ratio, 60, 60);
		
		var gameHud:GameHUD = new GameHUD();
		Reg.gameHud = gameHud;
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
}
