package ;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Level
{
	public var levelName:String;
	public var data:String;
	public var objData:String;
	
	
	public function new(levelName:String, data:String, objData:String) 
	{
		this.levelName = levelName;
		this.data = data;
		this.objData = objData;
	}
	
}