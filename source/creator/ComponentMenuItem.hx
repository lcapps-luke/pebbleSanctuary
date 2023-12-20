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
	private var img:FlxSprite;
	private var locked:Bool;

	public function new(spr:FlxGraphicAsset, locked:Bool, cost:Int, costType:PebbleLocation, size:Float = SIZE)
	{
		super();

		this.locked = locked;
		this.size = size;
		statIconSize = size / 6;

		img = new FlxSprite(spr);
		img.setGraphicSize(size);
		img.updateHitbox();
		img.x = x + size / 2 - img.width / 2;
		img.y = y + size / 2 - img.height / 2;
		add(img);

		// lock mask
		if (locked)
		{
			var lockMask = new FlxSprite(0, 0, AssetPaths.locked__png);
			lockMask.setGraphicSize(size);
			lockMask.x = x + size / 2 - lockMask.width / 2;
			lockMask.y = y + size / 2 - lockMask.height / 2;
			add(lockMask);

			var spr = new FlxSprite(0, size - statIconSize * 1.5, PebbleGame.getIconForLocation(costType));
			spr.setGraphicSize(statIconSize, statIconSize);
			spr.updateHitbox();
			add(spr);

			var txt = new FlxText(0, size - (statIconSize * 1.6), 0, Std.string(cost));
			txt.setFormat(AssetPaths.Schoolbell__ttf, Math.round(statIconSize), FlxColor.BLACK);
			add(txt);

			var w = (spr.width + txt.width) * 1.1;
			spr.x = size / 2 - w / 2;
			txt.x = spr.x + w - txt.width;
		}
	}

	public function setStats(work:Int, cook:Int, mine:Int)
	{
		if (!locked)
		{
			makeStat(AssetPaths.icon_office__png, work, x, y, 0);
			makeStat(AssetPaths.icon_kitchen__png, cook, x, y, 1);
			makeStat(AssetPaths.icon_mine__png, mine, x, y, 2);
		}
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

		if (locked)
		{
			return;
		}

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

	private function set_x(value:Float):Float
	{
		var shift = value - x;
		this.forEach(m -> m.x += shift);
		return x = value;
	}

	private function set_y(value:Float):Float
	{
		var shift = value - y;
		this.forEach(m -> m.y += shift);
		return y = value;
	}

	public function setColour(c:FlxColor)
	{
		img.setColorTransform(c.redFloat, c.greenFloat, c.blueFloat);
	}
}
