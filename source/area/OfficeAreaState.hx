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
		backFar = new FlxSprite(AssetPaths.office_bg_1__png);
		backFar.y = 250;

		backMid = new FlxSprite(AssetPaths.office_bg_2__png);

		backFor = new FlxSprite(AssetPaths.office_bg_3__png);
		backFor.y = FlxG.height - backFor.height;
	}

	private function createWalls(group:FlxTypedGroup<FlxBasic>):Float
	{
		return FlxG.height - 270;
	}
}
