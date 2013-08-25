package ;

import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Mainframe extends FlxSprite
{
	private var _gibs:FlxEmitter;
	private var _restart:Float;
	
	
	public function new() 
	{
		super();
		
		_restart = 0;
		
		loadGraphic('assets/mainframe.png', true, false, 8, 8);
		width = 6;
		height = 7;
		offset.x = 1;
		offset.y = 0;
		
		// Setup animations.
		addAnimation('idle', [1, 2], 2);
		addAnimation('dead', [3, 4, 5, 6], 6);
	}
	
	public function init(xPos:Float, yPos:Float, gibs:FlxEmitter):Void 
	{
		_gibs = gibs;
		reset(xPos - width / 2, yPos - height / 2);
		health = 5;
		play('idle');
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		_gibs = null;
	}
	
	override public function update():Void 
	{
		if (!alive) 
		{
			_restart += FlxG.elapsed;
			var delta:Float = Math.min(_restart / 2, 1.0);
			FlxG.timeScale = (0.8 * delta) + 0.2;
			if (_restart > 4) 
			{
				FlxG.resetState();
			}
		}
		
		super.update();
	}
	
	override public function hurt(damage:Float):Void 
	{
		//play('hit');
		flicker(0.6);
		Reg.score -= 20;
		
		super.hurt(damage);
	}
	
	override public function kill():Void 
	{
		if (!alive) 
		{
			return;
		}
		
		super.kill();
		
		flicker(0);
		exists = true;
		play('dead');
		FlxG.play('Explosion', 0.8);
		
		_gibs.at(this);
		_gibs.start(true, 3, 0, 20);
		
		//Reg.score -= 100;
		
		FlxG.camera.shake(0.05, 0.4);
		FlxG.camera.flash(0xffd7c590, 0.35);
		FlxG.timeScale = 0.2;
	}
	
}