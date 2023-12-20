package area;

import PebbleGame.PebbleDefinition;
import flixel.FlxG;
import flixel.FlxSprite;

class ReleaseAreaState extends AbstractAreaState
{
	public function new()
	{
		super(NONE);
	}

	private function createBackgroundSprites()
	{
		backFar = new FlxSprite(AssetPaths.main_bg_1__png);

		backMid = new FlxSprite(AssetPaths.main_bg_2__png);
		backMid.y = FlxG.height - backMid.height;

		backFor = new FlxSprite(AssetPaths.main_bg_3__png);
		backFor.y = FlxG.height - backFor.height;
	}

	public function getAreaPoints():Int
	{
		return -1;
	}

	public function getAreaMaxPoints():Int
	{
		return -1;
	}

	public function getUnlockQueue():Array<Int>
	{
		return [];
	}

	public function getTitleText(current:Int, next:Int):String
	{
		return "Release Pebbles";
	}

	override function onPebbleOption(opt:PebbleOption)
	{
		PebbleGame.pebbleList.remove(opt.pebble);
		opt.kill();

		opt.pebble.sprite.destroy();
	}

	override private function makePebbleOption(x:Float, y:Float, pebble:PebbleDefinition, placed:Bool)
	{
		return new PebbleOption(x, y, pebble, placed, onPebbleOption, "Release", "Release");
	}
}
