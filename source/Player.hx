package ;

import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Player extends FlxSprite
{
	private var _jumpPower:Int;
	
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		
		loadGraphic('assets/player.png', true, true, 8, 8);
		
		var runSpeed:Int = 80;
		drag.x = runSpeed * 8;
		acceleration.y = 420;
		_jumpPower = 200;
		maxVelocity.x = runSpeed;
		maxVelocity.y = _jumpPower;
		
		//Setup animations.
		addAnimation('idle', [0]);
		addAnimation('run', [1, 2, 3, 4], 12);
		addAnimation('jump', [4, 3, 5], 12, false);
		
		
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update():Void
	{
		
		// Movement
		acceleration.x = 0;
		if(FlxG.keys.LEFT || FlxG.keys.A)
		{
			facing = FlxObject.LEFT;
			acceleration.x -= drag.x;
		}
		else if(FlxG.keys.RIGHT || FlxG.keys.D)
		{
			facing = FlxObject.RIGHT;
			acceleration.x += drag.x;
		}
		
		// Jumping
		if ((FlxG.keys.justPressed('UP') || FlxG.keys.justPressed('W') || FlxG.keys.justPressed('SPACE')) && velocity.y == 0) 
		{
			velocity.y = -_jumpPower;
			play('jump');
		}
		
		// Animation
		if(velocity.y != 0)
		{
			//play('jump');
		}
		else if(velocity.x == 0)
		{
			play('idle');
		}
		else
		{
			play('run');
		}
		
		super.update();
	}
	
	override public function hurt(damage:Float):Void
	{
		
		
		super.hurt(damage);
	}
	
	override public function kill():Void
	{
		if(!alive)
		{
			return;
		}
		
		super.kill();
		
		flicker(0);
		
		FlxG.camera.shake(0.05, 0.4);
		
	}
	
}