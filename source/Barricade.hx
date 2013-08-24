package;

import flash.Lib;
import org.flixel.FlxGame;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Barricade extends FlxGame
{	
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var zoomLevel:Int = 4; // 200, 120
		var ratioX:Float = stageWidth / (800 / zoomLevel);
		var ratioY:Float = stageHeight / (480 / zoomLevel);
		var ratio:Float = Math.min(ratioX, ratioY);
		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), MenuState, ratio, 60, 60);
	}
}
