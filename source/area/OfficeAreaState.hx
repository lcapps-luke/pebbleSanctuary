package area;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

class OfficeAreaState extends AbstractAreaState
{
	public function new()
	{
		super(OFFICE);
	}

	public function getAreaPoints():Int
	{
		return PebbleGame.stats.working;
	}

	public function getAreaMaxPoints():Int
	{
		return PebbleGame.bestStats.working;
	}

	public function getUnlockQueue():Array<Int>
	{
		return PebbleGame.getUnlockQueueForLocation(OFFICE);
	}

	public function getTitleText(current:Int, next:Int):String
	{
		if (next > 0)
		{
			return 'Working points: $current (next unlock at $next)';
		}
		return 'Working points: $current';
	}

	function createBackgroundSprites()
	{
		backFar = new FlxSprite(AssetPaths.main_bg_1__png);

		backMid = new FlxSprite(AssetPaths.main_bg_2__png);
		backMid.y = FlxG.height - backMid.height;

		backFor = new FlxSprite(AssetPaths.main_bg_3__png);
		backFor.y = FlxG.height - backFor.height;
	}

	private function createWalls(group:FlxTypedGroup<FlxBasic>):Float
	{
		var w = new FlxSprite();
		w.makeGraphic(FlxG.width, 64, FlxColor.TRANSPARENT);
		w.immovable = true;
		group.add(w);

		w = new FlxSprite();
		w.makeGraphic(FlxG.width, 320, FlxColor.TRANSPARENT);
		w.setPosition(0, FlxG.height - w.height);
		w.immovable = true;
		group.add(w);

		w = new FlxSprite();
		w.makeGraphic(20, FlxG.height, FlxColor.TRANSPARENT);
		w.immovable = true;
		group.add(w);

		w = new FlxSprite();
		w.makeGraphic(120, FlxG.height, FlxColor.TRANSPARENT);
		w.setPosition(FlxG.width - w.width, 0);
		w.immovable = true;
		group.add(w);

		return FlxG.height - 320;
	}
}
