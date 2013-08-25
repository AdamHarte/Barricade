package ;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.util.FlxPoint;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class HUD extends FlxGroup
{
	private var _scoreTxt:FlxText;

	public function new() 
	{
		super();
		
		// Setup UI
		
		_scoreTxt = new FlxText(1, 1, 100, 'Score: 0');
		//_scoreTxt.scrollFactor.make(0, 0);
		//_scoreTxt.antialiasing = true;
		//_scoreTxt.setFormat('assets/slkscr.ttf', 8);
		_scoreTxt.setFormat(null, 6);
		//_scoreTxt.scale.make(0.8, 0.8);
		//_scoreTxt.alpha = 0.6;
		
		
		add(_scoreTxt);
		
		var scrollPt:FlxPoint = new FlxPoint();
		setAll('scrollFactor', scrollPt);
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
	}
	
	override public function update():Void
	{
		_scoreTxt.text = 'Score: ' + Reg.score;
		
		
	}
	
}