package area;

import flixel.FlxG;
import flixel.FlxSprite;

class MineAreaState extends AbstractAreaState
{
	public function new()
	{
		super(MINE);
	}

	public function getAreaPoints():Int
	{
		return PebbleGame.stats.mining;
	}

	public function getUnlockQueue():Array<Int>
	{
		return PebbleGame.getUnlockQueueForLocation(MINE);
	}

	public function getTitleText(current:Int, next:Int):String
	{
		if (next > 0)
		{
			return 'Mining points: $current (next unlock at $next)';
		}
		return 'Mining points: $current';
	}

	function createBackgroundSprites()
	{
		backFar = new FlxSprite(AssetPaths.mine_bg_1__png);

		backMid = new FlxSprite(AssetPaths.mine_bg_2__png);
		backMid.x = FlxG.width - backMid.width + 50;
		backMid.y = FlxG.height - backMid.height;

		backFor = new FlxSprite(AssetPaths.mine_bg_3__png);
		backFor.y = FlxG.height - backFor.height;
	}
}
