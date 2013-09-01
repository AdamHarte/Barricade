package com.adamharte.barricade;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxText;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class WinState extends FlxState
{
	private var _finishTimer:Float;
	
	
	override public function create():Void 
	{
		_finishTimer = 0;
		
		//Reg.scores.push(Reg.score);
		
		var winText:FlxText = new FlxText(0, FlxG.height / 3, 256, 'YOU WIN!');
		winText.x = (FlxG.width - winText.width) / 2;
		winText.setFormat(null, 22, 0x31a2ee, 'center');
		winText.antialiasing = true;
		add(winText);
		
		var scoreText:FlxText = new FlxText(0, FlxG.height * 0.65, 256, 'Your score: ' + Std.string(Reg.getTotalScore()));
		scoreText.x = (FlxG.width - scoreText.width) / 2;
		scoreText.setFormat(null, 12, 0x31a2ee, 'center');
		scoreText.antialiasing = true;
		add(scoreText);
		
		FlxG.flash(0xff000000, 1);
		
		super.create();
	}
	
	override public function update():Void
	{
		_finishTimer += FlxG.elapsed;
		if (_finishTimer > 5) 
		{
			FlxG.switchState(new MenuState());
		}
	}
	
}