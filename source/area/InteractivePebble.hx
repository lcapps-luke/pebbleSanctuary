package area;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class InteractivePebble extends FlxTypedGroup<FlxSprite>
{
	private var spr:FlxSprite;
	private var jumpTimer:Float;

	public function new(spr:FlxSprite)
	{
		super();

		add(spr);
		this.spr = spr;

		spr.acceleration.y = 1500;

		jumpTimer = FlxG.random.float(1, 5);
	}

	override function update(elapsed:Float)
	{
		jumpTimer -= elapsed;
		if (jumpTimer < 0)
		{
			jumpTimer = FlxG.random.float(1, 5);

			if (spr.isTouching(FLOOR))
			{
				spr.velocity.setPolarDegrees(spr.acceleration.y * 0.7, FlxG.random.float(225, 315));
			}
		}

		spr.drag.x = spr.isTouching(FLOOR) ? 800 : 0;

		super.update(elapsed);

		if (spr.y > FlxG.height)
		{
			spr.y = -spr.height;
		}

		if (spr.x + spr.width < 0 || spr.x > FlxG.width)
		{
			spr.setPosition(FlxG.width / 2 - spr.width / 2, -spr.height);
		}
	}
}
