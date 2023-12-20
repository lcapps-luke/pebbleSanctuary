package area;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

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

	public function getAreaMaxPoints():Int
	{
		return PebbleGame.bestStats.cooking;
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
		backFar = new FlxSprite(AssetPaths.cafe_bg_1__png);
		backFar.y = 255;

		backMid = new FlxSprite(AssetPaths.cafe_bg_2__png);

		backFor = new FlxSprite(AssetPaths.cafe_bg_3__png);
		backFor.y = FlxG.height - backFor.height;
	}

	private function createWalls(group:FlxTypedGroup<FlxBasic>):Float
	{
		var w = new FlxSprite();
		w.makeGraphic(FlxG.width, 64, FlxColor.TRANSPARENT);
		w.immovable = true;
		group.add(w);

		w = new FlxSprite();
		w.makeGraphic(FlxG.width, 190, FlxColor.TRANSPARENT);
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

		w = new FlxSprite();
		w.makeGraphic(160, 270, FlxColor.TRANSPARENT);
		w.setPosition(1358, 622);
		w.immovable = true;
		group.add(w);

		w = new FlxSprite();
		w.makeGraphic(100, 180, FlxColor.TRANSPARENT);
		w.setPosition(1520, 711);
		w.immovable = true;
		group.add(w);

		return FlxG.height - 190;
	}
}
