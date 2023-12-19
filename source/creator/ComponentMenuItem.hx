package creator;

import PebbleGame.PebbleLocation;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

class ComponentMenuItem extends FlxTypedGroup<FlxSprite>
{
	public static inline var SIZE = 128;

	public var x(default, set):Float = 0;
	public var y(default, set):Float = 0;

	public var callback:Float->Float->Void;

	private var size:Float;
	private var statIconSize:Float;

	public function new(spr:FlxGraphicAsset, locked:Bool, cost:Int, costType:PebbleLocation, size:Float = SIZE)
	{
		super();

		this.size = size;
		statIconSize = size / 6;

		var img = new FlxSprite(AssetPaths.gem_1__png);
		var pScale = Math.min(size / img.width, size / img.height);
		img.scale.set(pScale, pScale);
		img.updateHitbox();
		img.x = x + size / 2 - img.width / 2;
		img.y = y + size / 2 - img.height / 2;

		FlxG.debugger.track(img, "gem item");

		add(img);
	}

	public function setStats(work:Int, cook:Int, mine:Int)
	{
		makeStat(AssetPaths.icon_office__png, work, x, y, 0);
		makeStat(AssetPaths.icon_kitchen__png, cook, x, y, 1);
		makeStat(AssetPaths.icon_mine__png, mine, x, y, 2);
	}

	private function makeStat(icon:FlxGraphicAsset, val:Int, x:Float, y:Float, pos:Int)
	{
		var px = x + (size / 3) * 0.05;

		var bg = new FlxSprite(px + (size / 3) * pos, y + size - statIconSize);
		bg.makeGraphic(Math.round((size / 3) * 0.9), Math.round(statIconSize), 0x90000000);
		add(bg);

		var spr = new FlxSprite(px + (size / 3) * pos, y + size - statIconSize, icon);
		spr.setGraphicSize(statIconSize, statIconSize);
		spr.updateHitbox();
		add(spr);

		var txt = new FlxText(spr.x + spr.width + statIconSize * 0.1, spr.y - (statIconSize * 0.1), 0, Std.string(val));
		txt.setFormat(AssetPaths.Schoolbell__ttf, Math.round(statIconSize), FlxColor.WHITE);
		add(txt);
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
