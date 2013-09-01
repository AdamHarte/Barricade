package com.adamharte.barricade;

import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class GuideState extends FlxState
{
	private var _titleImg:FlxSprite;
	private var _playButton:FlxButton;
	
	
	public function new() 
	{
		
		
		super();
	}
	
	override public function create():Void
	{
		FlxG.bgColor = 0xff1e2936;
		
		_titleImg = new FlxSprite(0, 0, 'assets/guide_screen.png');
		_titleImg.origin.make();
		_titleImg.scale.make(2, 2);
		add(_titleImg);
		
		_playButton = new FlxButton(0, FlxG.height * 0.8, 'PLAY', playClickHandler);
		_playButton.x = (FlxG.width - _playButton.width) / 2;
		_playButton.scale.make(0.8, 0.8);
		_playButton.color = 0x31a2ee;
		_playButton.label.color = 0x31a2ee;
		add(_playButton);
		
		//FlxG.flash(0xff31a2ee, 1.4, flashCompleteHandler);
		
		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
	}
	
	override public function update():Void
	{
		
		
		super.update();
	}
	
	function playClickHandler() 
	{
		FlxG.switchState(new PlayState());
	}
	
	
	
}