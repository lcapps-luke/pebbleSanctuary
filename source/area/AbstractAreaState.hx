package area;

import PebbleGame.PebbleDefinition;
import PebbleGame.PebbleLocation;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
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

	private var pebbleGroup = new FlxTypedGroup<FlxBasic>();
	private var floorPosition:Float = 0;

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
		add(pebbleGroup);
		add(backFor);

		floorPosition = createWalls(pebbleGroup);

		// ui
		var acc = 30.0;
		for (p in PebbleGame.pebbleList)
		{
			if (p.location == NONE || p.location == locationType)
			{
				var placed = p.location == locationType;
				var opt = makePebbleOption(acc, FlxG.height - PebbleOption.SIZE - 30, p, placed);
				add(opt);

				acc += PebbleOption.SIZE + 30;

				if (placed)
				{
					var pbl = createInteractivePebble(p);
					opt.interactivePebble = pbl;
					pebbleGroup.add(pbl);
				}
			}
		}

		var back = new Button("Back", LARGE, onBack);
		back.setPosition(50, 50);
		add(back);

		// score & next unlock text
		currentPoints = getAreaPoints();
		displayPoints = currentPoints;
		nextUnlockQty = getNextUnlockQty();

		title = new FlxText();
		title.setFormat(AssetPaths.Schoolbell__ttf, 70, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		title.borderSize = 3;
		title.text = getTitleText(currentPoints, nextUnlockQty);
		title.x = FlxG.width / 2 - title.width / 2;
		title.y = FlxG.height * 0.1;
		add(title);
	}

	override function update(elapsed:Float)
	{
		FlxG.collide(pebbleGroup);
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

			if (opt.interactivePebble != null)
			{
				opt.interactivePebble.kill();
			}
		}
		else
		{
			// TODO add pebble
			opt.pebble.location = locationType;
			opt.placed = true;
			PebbleGame.calculateStats();

			if (opt.interactivePebble == null)
			{
				var pbl = createInteractivePebble(opt.pebble);
				opt.interactivePebble = pbl;
				pebbleGroup.add(pbl);
			}
			else
			{
				opt.interactivePebble.revive();
			}
		}

		FlxTween.tween(this, {currentPoints: getAreaPoints()}, 0.5, {
			onComplete: function(t:FlxTween)
			{
				var newNextUnlockQty = getNextUnlockQty();

				if (newNextUnlockQty != nextUnlockQty)
				{
					showUnlock(nextUnlockQty);
				}

				nextUnlockQty = newNextUnlockQty;
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
			if (u > getAreaMaxPoints())
			{
				return u;
			}
		}
		return -1;
	}

	private function showUnlock(unlockQty:Int)
	{
		var spr = PebbleGame.getUnlockItem(locationType, unlockQty);
		openSubState(new UnlockSubstate(spr));
	}

	private function makePebbleOption(x:Float, y:Float, pebble:PebbleDefinition, placed:Bool)
	{
		return new PebbleOption(x, y, pebble, placed, onPebbleOption);
	}

	private function createInteractivePebble(p:PebbleDefinition):InteractivePebble
	{
		var spr = p.sprite.clone();
		spr.scale.set(0.3, 0.3);
		spr.updateHitbox();

		spr.x = FlxG.random.float(200, FlxG.width - spr.width - 200);
		spr.y = floorPosition - spr.height;

		return new InteractivePebble(spr);
	}

	private abstract function createBackgroundSprites():Void;

	private abstract function createWalls(group:FlxTypedGroup<FlxBasic>):Float;

	public abstract function getAreaPoints():Int;

	public abstract function getAreaMaxPoints():Int;

	public abstract function getUnlockQueue():Array<Int>;

	public abstract function getTitleText(current:Int, next:Int):String;
}
