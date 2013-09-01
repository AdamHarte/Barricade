package com.adamharte.barricade;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import openfl.Assets;
import org.flixel.FlxAssets;
import flash.text.TextFormatAlign;
import org.flixel.util.FlxMath;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class GameHUD extends Sprite
{
	private var _scoreLabel:TextField;
	private var _scoreTxt:TextField;
	private var _botsKilledLabel:TextField;
	private var _botsKilledTxt:TextField;
	private var _countdownLabel:TextField;
	private var _countdownTxt:TextField;
	//private var _botsLabel:TextField;
	//private var _botTxt:TextField;
	
	
	public function new() 
	{
		super();
		
		if (stage != null) 
			init();
		else 
			addEventListener(Event.ADDED_TO_STAGE, init);
		
	}
	
	private function init(?e:Event = null):Void 
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		_scoreLabel = createTextField(10, 10, 200, 'Score:', 12);
		_scoreLabel.height = 50;
		_scoreTxt = createTextField(10, 26, 200, '0', 18);
		_scoreTxt.height = 50;
		addChild(_scoreLabel);
		addChild(_scoreTxt);
		
		//_botsKilledLabel = createTextField(10, 50, 200, 'Bots killed:', 10);
		//_botsKilledTxt = createTextField(10, 66, 200, '0', 18);
		_botsKilledLabel = createTextField(stage.stageWidth - 210, 10, 200, 'Bots destroyed:', 12, 1);
		_botsKilledLabel.height = 50;
		_botsKilledTxt = createTextField(stage.stageWidth - 210, 26, 200, '0', 18, 1);
		_botsKilledTxt.height = 50;
		addChild(_botsKilledLabel);
		addChild(_botsKilledTxt);
		
		/*_botsLabel = createTextField(stage.stageWidth - 210, 10, 200, 'Bots Remaining:', 10, true);
		_botTxt = createTextField(stage.stageWidth - 210, 24, 200, '0', 18, true);
		addChild(_botsLabel);
		addChild(_botTxt);*/
		
		_countdownLabel = createTextField(stage.stageWidth / 2 - 100, 10, 200, 'COUNTDOWN', 12, 2);
		_countdownLabel.height = 50;
		_countdownTxt = createTextField(stage.stageWidth / 2 - 100, 26, 200, '0', 24, 2);
		_countdownTxt.height = 50;
		addChild(_countdownLabel);
		addChild(_countdownTxt);
		
		//Reg.shutdownTimer
	}
	
	public function update():Void 
	{
		_scoreTxt.text = Std.string(Reg.score);
		_botsKilledTxt.text = Std.string(Reg.enemiesKilled) +'/'+ Std.string(Reg.currentLevel.enemyCount);
		//_botTxt.text = Std.string(Reg.enemiesToSpawn);
		//_countdownTxt.text = Std.string(FlxMath.roundDecimal(10 - Reg.shutdownTimer, 1));
		_countdownTxt.text = Std.string(Math.ceil(10 - Reg.shutdownTimer));
		
	}
	
	private function createTextField(x:Float, y:Float, width:Int, text:String = null, size:Int = 8, align:Int = 0):TextField 
	{
		var tf = new TextField();
		tf.x = x;
		tf.y = y;
		tf.width = width;
		tf.selectable = false;
		tf.multiline = true;
		tf.wordWrap = true;
		var format:TextFormat = new TextFormat(Assets.getFont(FlxAssets.defaultFont).fontName, size, 0xffffff);
		if (align == 1) 
		{
			format.align = TextFormatAlign.RIGHT;
		}
		else if (align == 2) 
		{
			format.align = TextFormatAlign.CENTER;
		}
		tf.defaultTextFormat = format;
		tf.text = text;
		tf.embedFonts = true;
		#if flash
		tf.sharpness = 100;
		#end
		tf.height = 10;
		
		tf.alpha = 0.8;
		
		return tf;
	}
	
}