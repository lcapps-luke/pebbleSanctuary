package area;

import PebbleGame.PebbleDefinition;
import PebbleGame.PebbleLocation;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import ui.Button;

abstract class AbstractAreaState extends FlxState
{
	private var locationType:PebbleLocation;
	private var unlockQueue:Array<Int>;
	private var nextUnlockQty:Int;
	private var currentPoints:Int;
	private var displayPoints:Int;

	private var title:FlxText;

	private var backFar:FlxSprite;
	private var backMid:FlxSprite;
	private var backFor:FlxSprite;
	private var backDiff:Float;
	private var mousePosition = new FlxPoint();

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

		createBackgroundSprites();
		backDiff = Math.min((backFar.width - FlxG.width) * 0.5, (backFor.width - FlxG.width) * 0.5);

		add(backFar);
		add(backMid);

		// TODO pebble layer

		add(backFor);

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

		var back = new Button("Back", true, onBack);
		back.setPosition(50, 50);
		add(back);

		// score & next unlock text
		currentPoints = getAreaPoints();
		displayPoints = currentPoints;
		nextUnlockQty = getNextUnlockQty();

		title = new FlxText();
		title.setFormat(AssetPaths.Schoolbell__ttf, 60);
		title.text = getTitleText(currentPoints, nextUnlockQty);
		title.x = FlxG.width / 2 - title.width / 2;
		title.y = FlxG.height * 0.1;
		add(title);
	}

	private abstract function createBackgroundSprites():Void;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (currentPoints != displayPoints)
		{
			displayPoints = currentPoints;
			title.text = getTitleText(displayPoints, nextUnlockQty);
		}

		FlxG.mouse.getPosition(mousePosition);
		var scrollPercent = mousePosition.x / FlxG.width;
		backFar.x = FlxMath.bound(scrollPercent * backDiff - backDiff, -backDiff, 0);
		backFor.x = FlxMath.bound(-scrollPercent * backDiff, -backDiff, 0);
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
