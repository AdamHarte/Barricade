package ;
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
	
	
	public function new(levelName:String, fileName:String) 
	{
		this.levelName = levelName;
		data = Assets.getText('assets/levels/' + fileName + '.csv');
		objData = Assets.getText('assets/levels/' + fileName + '_objs.csv');
		
	}
	
}