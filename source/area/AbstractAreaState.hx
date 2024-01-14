package area;

import PebbleGame.PebbleDefinition;
import PebbleGame.PebbleLocation;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.Listener;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import ui.Button;

abstract class AbstractAreaState extends FlxTransitionableState
{
	private static var WALL_TYPE(default, null) = new CbType();

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
	private var floor:Body = null;
	private var floorPosition:Float = 0;

	private var handJoint:PivotJoint;
	private var pebbleCollisionListener:InteractionListener;

	public function new(locationType:PebbleLocation)
	{
		var td = new TransitionData(FADE, FlxColor.BLACK, 0.2);
		super(td, td);
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

		FlxNapeSpace.init();

		pebbleCollisionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, [WALL_TYPE, InteractivePebble.PEBBLE_TYPE],
			InteractivePebble.PEBBLE_TYPE, onPebbleCollisionBegin);
		pebbleCollisionListener.space = FlxNapeSpace.space;

		floorPosition = createWalls(pebbleGroup);

		floor = FlxNapeSpace.createWalls(0, -500, 0, floorPosition, 10, Material.sand());
		floor.cbTypes.add(WALL_TYPE);
		FlxNapeSpace.space.gravity.setxy(0, 2000);
		handJoint = new PivotJoint(FlxNapeSpace.space.world, null, Vec2.weak(), Vec2.weak());
		handJoint.active = false;
		handJoint.stiff = false;
		handJoint.space = FlxNapeSpace.space;

		// ui
		var acc = 30.0;
		var pblX = 300.0;
		for (p in PebbleGame.pebbleList)
		{
			if (p.location == NONE || p.location == locationType)
			{
				var placed = (p.location == locationType && p.location != NONE);
				var opt = makePebbleOption(acc, FlxG.height - PebbleOption.SIZE - 30, p, placed);
				add(opt);

				acc += PebbleOption.SIZE + 30;

				if (placed)
				{
					var pbl = new InteractivePebble(pblX, floorPosition - 100, p.sprite.graphic, 0.3); // TODO place on floor
					pbl.setPosition(pbl.x, floorPosition - pbl.height);
					opt.interactivePebble = pbl;
					pebbleGroup.add(pbl);

					pblX += pbl.width + 50;
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

	private function onPebbleCollisionBegin(callback:InteractionCallback):Void
	{
		if (callback.arbiters.empty())
		{
			return;
		}

		var imp = callback.arbiters.at(0).collisionArbiter.totalImpulse();
		var len = Math.abs(imp.length);

		if (len > 0)
		{
			var com = callback.int2.castBody.worldCOM;
			var pan = (com.x / FlxG.width) * 2 - 1;

			var vol = Math.min(1, len / 50000);
			FlxG.sound.play(FlxG.random.getObject([
				AssetPaths.pebble_1__ogg,
				AssetPaths.pebble_2__ogg,
				AssetPaths.pebble_3__ogg,
				AssetPaths.pebble_4__ogg,
				AssetPaths.pebble_5__ogg,
				AssetPaths.pebble_6__ogg,
				AssetPaths.pebble_7__ogg
			]), vol).pan = pan;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Math.round(currentPoints) != displayPoints)
		{
			displayPoints = Math.round(currentPoints);
			title.text = getTitleText(displayPoints, nextUnlockQty);
		}

		FlxG.mouse.getPosition(mousePosition);
		var scrollPercent = mousePosition.x / FlxG.width;
		backFar.x = FlxMath.bound(scrollPercent * backDiff - backDiff, -backDiff, 0);
		backFor.x = FlxMath.bound(-scrollPercent * backDiff, -backDiff, 0);

		// grab pebbles (any dynamic object actually)
		if (handJoint.active || FlxG.mouse.justPressed)
		{
			handJoint.anchor1.set(handJoint.body1.worldPointToLocal(Vec2.weak(mousePosition.x, mousePosition.y), true));
		}

		if (FlxG.mouse.justPressed)
		{
			var mouseVec = Vec2.get(mousePosition.x, mousePosition.y);

			FlxNapeSpace.space.bodiesUnderPoint(mouseVec).foreach(b ->
			{
				if (!b.isDynamic())
				{
					return;
				}

				handJoint.body2 = b;
				handJoint.anchor2.set(b.worldPointToLocal(mouseVec, true));
				handJoint.active = true;
			});

			mouseVec.dispose();
		}

		if (FlxG.mouse.justReleased)
		{
			handJoint.active = false;
		}
	}

	private function onPebbleOption(opt:PebbleOption)
	{
		if (opt.placed)
		{
			// remove pebble
			opt.pebble.location = NONE;
			opt.placed = false;
			PebbleGame.calculateStats();

			opt.interactivePebble?.kill();
		}
		else
		{
			// add pebble
			opt.pebble.location = locationType;
			opt.placed = true;
			PebbleGame.calculateStats();

			if (opt.interactivePebble == null)
			{
				var pbl = new InteractivePebble(FlxG.random.float(200, FlxG.width - 500), 0, opt.pebble.sprite.graphic, 0.3);
				if (pbl != null)
				{
					opt.interactivePebble = pbl;
					pebbleGroup.add(pbl);
				}
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
		FlxG.switchState(new MainState(true));
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

	override function destroy()
	{
		super.destroy();
		if (floor != null)
		{
			floor.space = null;
		}
		handJoint.space = null;

		pebbleCollisionListener.space = null;
	}

	private abstract function createBackgroundSprites():Void;

	private abstract function createWalls(group:FlxTypedGroup<FlxBasic>):Float;

	public abstract function getAreaPoints():Int;

	public abstract function getAreaMaxPoints():Int;

	public abstract function getUnlockQueue():Array<Int>;

	public abstract function getTitleText(current:Int, next:Int):String;
}
