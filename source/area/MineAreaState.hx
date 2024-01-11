package area;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

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

	public function getAreaMaxPoints():Int
	{
		return PebbleGame.bestStats.mining;
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

	private function createWalls(group:FlxTypedGroup<FlxBasic>):Float
	{
		return FlxG.height - 320;
	}
}
