package;

import openfl.Assets;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.util.FlxMath;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.bgColor = 0xff1e2936;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		
		var title:FlxText = new FlxText(0, FlxG.height / 3, 256, 'Barricade');
		title.x = (FlxG.width - title.width) / 2;
		title.setFormat(null, 42, 0x31a2ee, 'center');
		title.antialiasing = true;
		add(title);
		
		var playButton:FlxButton = new FlxButton(0, FlxG.height / 3 + 62, 'PLAY', playClickHandler);
		playButton.x = (FlxG.width - playButton.width) / 2;
		//TODO: Maybe scale buttons.
		playButton.color = 0x31a2ee;
		playButton.label.color = 0x31a2ee;
		add(playButton);
		
		
		FlxG.flash(0xff31a2ee, 0.4);
		
		
		//TEMP: go straigt to the play state.
		FlxG.switchState(new PlayState());
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}
	
	
	
	
	function playClickHandler() 
	{
		FlxG.switchState(new PlayState());
	}
	
	
}