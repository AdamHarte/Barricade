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
	private var _titleImg:FlxSprite;
	private var _playButton:FlxButton;
	
	
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
		
		Reg.level = 0;
		Reg.score = 0;
		
		_titleImg = new FlxSprite(0, 0, 'assets/title_screen.png');
		_titleImg.origin.make();
		_titleImg.scale.make(2, 2);
		add(_titleImg);
		
		/*var title:FlxText = new FlxText(0, FlxG.height / 3, 256, 'Barricade');
		title.x = (FlxG.width - title.width) / 2;
		title.setFormat(null, 42, 0x31a2ee, 'center');
		title.antialiasing = true;
		add(title);*/
		
		var credits:FlxText = new FlxText(0, 0, 256, 'by Adam Harte');
		credits.x = (FlxG.width - credits.width) - 40;
		credits.y = 46; // (FlxG.height - credits.height) - 1;
		credits.setFormat(null, 8, 0x0e354b, 'right');
		credits.antialiasing = true;
		add(credits);
		
		_playButton = new FlxButton(0, FlxG.height * 0.6, 'PLAY', playClickHandler);
		_playButton.x = (FlxG.width - _playButton.width) / 2;
		_playButton.scale.make(0.8, 0.8);
		_playButton.color = 0x31a2ee;
		_playButton.label.color = 0x31a2ee;
		add(_playButton);
		
		FlxG.flash(0xff31a2ee, 1.4, flashCompleteHandler);
		
		
		//TEMP: go straight to the play state.
		//FlxG.switchState(new PlayState());
		
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
		//FlxG.camera
		
		super.update();
	}
	
	
	
	
	private function flashCompleteHandler() 
	{
		
	}
	
	function playClickHandler() 
	{
		//FlxG.switchState(new PlayState());
		FlxG.switchState(new GuideState());
	}
	
	
}