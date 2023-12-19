package area;

import flixel.FlxG;
import flixel.FlxSprite;

class KitchenAreaState extends AbstractAreaState
{
	public function new()
	{
		super(KITCHEN);
	}

	public function getAreaPoints():Int
	{
		return PebbleGame.stats.cooking;
	}

	public function getUnlockQueue():Array<Int>
	{
		return PebbleGame.getUnlockQueueForLocation(KITCHEN);
	}

	public function getTitleText(current:Int, next:Int):String
	{
		if (next > 0)
		{
			return 'Cooking points: $current (next unlock at $next)';
		}
		return 'Cooking points: $current';
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
