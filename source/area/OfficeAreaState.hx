package area;

import flixel.FlxG;
import flixel.FlxSprite;

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
}
