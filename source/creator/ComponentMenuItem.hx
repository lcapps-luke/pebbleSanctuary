package creator;

import PebbleGame.PebbleLocation;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxDestroyUtil;

class ComponentMenuItem extends FlxTypedGroup<FlxSprite>
{
	public static inline var SIZE = 128;

	public var x(default, set):Float = 0;
	public var y(default, set):Float = 0;

	public var callback:Float->Float->Void;

	public function new(spr:FlxGraphicAsset, locked:Bool, cost:Int, costType:PebbleLocation)
	{
		super();

		var img = new FlxSprite(AssetPaths.gem_1__png);
		var pScale = Math.min(SIZE / img.width, SIZE / img.height);
		img.scale.set(pScale, pScale);
		img.updateHitbox();
		img.x = x + SIZE / 2 - img.width / 2;
		img.y = y + SIZE / 2 - img.height / 2;

		FlxG.debugger.track(img, "gem item");

		add(img);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var mPos = FlxG.mouse.getPosition();
		if (mPos.x > x && mPos.x < x + SIZE && mPos.y > y && mPos.y < y + SIZE)
		{
			PebbleGame.cursorGrab = true;

			if (FlxG.mouse.justPressed)
			{
				callback(mPos.x, mPos.y);
			}
		}

		FlxDestroyUtil.destroy(mPos);
	}

	function set_x(value:Float):Float
	{
		var shift = value - x;
		this.forEach(m -> m.x += shift);
		return x = value;
	}

	function set_y(value:Float):Float
	{
		var shift = value - y;
		this.forEach(m -> m.y += shift);
		return y = value;
	}
}
