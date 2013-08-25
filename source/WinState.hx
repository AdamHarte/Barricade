package ;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxText;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class WinState extends FlxState
{

	override public function create():Void 
	{
		FlxG.flash(0xff000000, 1);
		
		var winText:FlxText = new FlxText(0, FlxG.height / 3, 256, 'YOU WIN!');
		winText.x = (FlxG.width - winText.width) / 2;
		winText.setFormat(null, 22, 0x31a2ee, 'center');
		winText.antialiasing = true;
		add(winText);
		
		super.create();
	}
	
}