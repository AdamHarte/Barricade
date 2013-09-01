package com.adamharte.barricade;

import openfl.Assets;
import org.flixel.util.FlxPoint;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Level
{
	public var levelName:String;
	public var data:String;
	public var objData:String;
	public var enemyCount:Int;
	
	
	public function new(levelName:String, fileName:String, enemyCount:Int) 
	{
		this.levelName = levelName;
		this.enemyCount = enemyCount;
		data = Assets.getText('assets/levels/' + fileName + '.csv');
		objData = Assets.getText('assets/levels/' + fileName + 'b.csv');
	}
	
}