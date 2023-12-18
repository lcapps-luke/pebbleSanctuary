package area;

import PebbleGame.PebbleDefinition;
import PebbleGame.PebbleLocation;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

abstract class AbstractAreaState extends FlxState
{
	private var locationType:PebbleLocation;
	private var unlockQueue:Array<Int>;
	private var nextUnlockQty:Int;
	private var currentPoints:Int;
	private var displayPoints:Int;

	private var title:FlxText;

	public function new(locationType:PebbleLocation)
	{
		super();
		this.locationType = locationType;
		unlockQueue = getUnlockQueue();
	}

	override function create()
	{
		this.bgColor = FlxColor.BLACK;
		super.create();
		// TODO background
		// TODO midground
		// TODO foreground

		// ui
		var pebbleList = new Array<PebbleDefinition>();
		for (p in PebbleGame.pebbleList)
		{
			if (p.location == NONE || p.location == locationType)
			{
				pebbleList.push(p);
			}
		}

		var acc = 30.0;
		for (p in pebbleList)
		{
			var placed = p.location == locationType;
			var opt = new PebbleOption(acc, FlxG.height - PebbleOption.SIZE - 30, p, placed, onPebbleOption);
			add(opt);

			acc += PebbleOption.SIZE + 30;
		}

		var back = new FlxButton(50, 50, "Back", onBack);
		add(back);

		// score & next unlock text
		currentPoints = getAreaPoints();
		displayPoints = currentPoints;
		nextUnlockQty = getNextUnlockQty();

		title = new FlxText();
		title.setFormat(AssetPaths.Schoolbell__ttf, 40);
		title.text = getTitleText(currentPoints, nextUnlockQty);
		title.x = FlxG.width / 2 - title.width / 2;
		title.y = FlxG.height * 0.1;
		add(title);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (currentPoints != displayPoints)
		{
			displayPoints = currentPoints;
			title.text = getTitleText(displayPoints, nextUnlockQty);
		}
	}

	private function onPebbleOption(opt:PebbleOption)
	{
		if (opt.placed)
		{
			// TODO remove pebble
			opt.pebble.location = NONE;
			opt.placed = false;
			PebbleGame.calculateStats();
		}
		else
		{
			// TODO add pebble
			opt.pebble.location = locationType;
			opt.placed = true;
			PebbleGame.calculateStats();
		}

		FlxTween.tween(this, {currentPoints: getAreaPoints()}, 0.5, {
			onComplete: function(t:FlxTween)
			{
				nextUnlockQty = getNextUnlockQty();
				title.text = getTitleText(currentPoints, nextUnlockQty);
			}
		});
	}

	private function onBack()
	{
		FlxG.switchState(new MainState());
	}

	private function getNextUnlockQty():Int
	{
		for (u in unlockQueue)
		{
			if (u > currentPoints)
			{
				return u;
			}
		}
		return -1;
	}

	public abstract function getAreaPoints():Int;

	public abstract function getUnlockQueue():Array<Int>;

	public abstract function getTitleText(current:Int, next:Int):String;
}
