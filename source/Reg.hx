package;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.text.Font;
import openfl.Assets;
import org.flixel.FlxSave;
import org.flixel.FlxText;
import org.flixel.FlxTilemap;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 * 
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	static public var tileMap:FlxTilemap;
	static public var objectMap:FlxTilemap;
	
	static public var gameHud:GameHUD;
	
	static public var shutdownTimer:Float;
	static public var isShutdown:Bool = false;
	static public var statusText:FlxText;
	
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	static public var levels:Array<Level> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	static public var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	static public var scores:Array<Int> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	static public var score:Int = 0;
	/**
	 * Generic bucket for storing different <code>FlxSaves</code>.
	 * Especially useful for setting up multiple save slots.
	 */
	static public var saves:Array<FlxSave> = [];
	/**
	 * Generic container for a <code>FlxSave</code>. You might want to 
	 * consider assigning <code>FlxG._game._prefsSave</code> to this in
	 * your state if you want to use the same save flixel uses internally
	 */
	static public var save:FlxSave;
	
	static public var currentLevel(get, never):Level;
	
	static public var enemiesToSpawn:Int = 0;
	static public var enemiesKilled:Int = 0;
	
	
	
	static private function get_currentLevel():Level 
	{
		return Reg.levels[Reg.level];
	}
	
	
	
	static public function addLevel(levelName:String, fileName:String, enemyCount:Int):Void 
	{
		var level:Level = new Level(levelName, fileName, enemyCount);
		Reg.levels.push(level);
	}
}