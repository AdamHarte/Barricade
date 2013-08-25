package ;

import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Wall extends FlxSprite
{
	private var _gibs:FlxEmitter;
	
	
	public function new() 
	{
		super();
		
		loadGraphic('assets/wall.png', true, false, 8, 8);
		width = 4;
		height = 7;
		offset.x = 2;
		offset.y = 0;
		immovable = true;
		
		// Setup animations.
		addAnimation('idle', [0], 12, false);
		addAnimation('damage1', [1], 12, false);
		addAnimation('damage2', [2], 12, false);
		addAnimation('damage3', [3], 12, false);
		addAnimation('damage4', [4], 12, false);
	}
	
	public function init(xPos:Float, yPos:Float, gibs:FlxEmitter, heavyWall = false):Void 
	{
		_gibs = gibs;
		reset(xPos - width / 2, yPos - height / 2);
		health = (heavyWall) ? 10 : 5;
		play('idle');
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		_gibs = null;
	}
	
	/*override public function update():Void 
	{
		super.update();
	}*/
	
	override public function hurt(damage:Float):Void 
	{
		flicker(0.1);
		
		super.hurt(damage);
		
		if (!alive) 
		{
			return;
		}
		
		switch (health) 
		{
			case 4:
				play('damage1');
			case 3:
				play('damage2');
			case 2:
				play('damage3');
			case 1:
				play('damage4');
			default:
				
		}
	}
	
	override public function kill():Void 
	{
		if (!alive) 
		{
			return;
		}
		
		super.kill();
		
		flicker(0);
		_gibs.at(this);
		_gibs.start(true, 2, 0, 15);
		
		//Reg.score -= 100;
		
		FlxG.camera.shake(0.02, 0.2);
	}
	
}