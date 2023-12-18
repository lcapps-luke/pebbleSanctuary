package creator;

import PebbleGame.PebbleStats;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;

class PebbleCreatorState extends FlxState
{
	private static inline var WORKSPACE_MARGIN = 100;

	private var workspace:FlxRect;

	private var body:FlxSprite;
	private var pebbleLayer:FlxTypedGroup<PebbleComponent>;
	private var gem:PebbleComponent = null;
	private var gemStats:PebbleStats = {mining: 0, working: 0, cooking: 0};

	private var justAdded = false;
	private var heldComponent:PebbleComponent = null;

	override function create()
	{
		this.bgColor = FlxColor.WHITE;
		super.create();

		workspace = new FlxRect(WORKSPACE_MARGIN, WORKSPACE_MARGIN, FlxG.width * 0.7 - WORKSPACE_MARGIN * 2, FlxG.height - WORKSPACE_MARGIN * 2);
		var w = new FlxSprite(WORKSPACE_MARGIN, WORKSPACE_MARGIN);
		w.makeGraphic(Math.round(workspace.width), Math.round(workspace.height), FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRect(w, 0, 0, w.width, w.height, FlxColor.TRANSPARENT, {
			thickness: 5,
			color: FlxColor.RED
		});
		add(w);

		body = new FlxSprite(0, 0, AssetPaths.pebble_1__png);
		body.y = workspace.height / 2 - body.height / 2 + workspace.y;
		body.x = workspace.width / 2 - body.width / 2 + workspace.x;
		body.setColorTransform(FlxG.random.float(0.5, 1), FlxG.random.float(0.5, 1), FlxG.random.float(0.5, 1));
		add(body);

		pebbleLayer = new FlxTypedGroup<PebbleComponent>();
		add(pebbleLayer);

		var gemMenu = new GemMenu(null, null, onAddGem);
		add(gemMenu);

		var finishButton = new FlxButton(0, 0, "Finish", onFinish);
		finishButton.x = FlxG.width * 0.85 - finishButton.width / 2;
		finishButton.y = FlxG.height * 0.85;
		add(finishButton);
	}

	private function onAddGem(gemDef:Data.Gem, x:Float, y:Float)
	{
		if (gem != null)
		{
			pebbleLayer.remove(gem);
			gem.destroy();
		}

		gem = new PebbleComponent(gemDef.sprite, x, y);
		gemStats.cooking = gemDef.cooking;
		gemStats.mining = gemDef.mining;
		gemStats.working = gemDef.working;

		var mousePosition = FlxG.mouse.getPosition();
		gem.setSelected(true, mousePosition);
		FlxDestroyUtil.put(mousePosition);

		add(gem);
		heldComponent = gem;
		justAdded = true;
	}

	override function update(elapsed:Float)
	{
		PebbleGame.cursorGrab = heldComponent != null;

		super.update(elapsed);

		if (FlxG.mouse.justPressed && !justAdded)
		{
			heldComponent = null;

			var mousePosition = FlxG.mouse.getPosition();

			pebbleLayer.forEach(c ->
			{
				if (c.overlapsPoint(mousePosition))
				{
					heldComponent = c;
				}
			});

			if (heldComponent != null)
			{
				pebbleLayer.remove(heldComponent);
				add(heldComponent);

				heldComponent.setSelected(true, mousePosition);
			}

			FlxDestroyUtil.put(mousePosition);
		}

		if (FlxG.mouse.justReleased)
		{
			if (heldComponent != null)
			{
				remove(heldComponent);
				pebbleLayer.add(heldComponent);

				if (!heldComponent.isWithin(workspace))
				{
					heldComponent.setSelected(false, null);
					heldComponent.kill();
				}

				heldComponent = null;
			}
		}

		justAdded = false;
	}

	private function onFinish()
	{
		var bounds = new FlxRect(body.x, body.y, body.width, body.height);

		var toStamp = new Array<FlxSprite>();
		for (c in pebbleLayer.members)
		{
			var component:PebbleComponent = cast c;

			toStamp.push(component.sprite);

			bounds.left = Math.min(bounds.left, component.sprite.x);
			bounds.top = Math.min(bounds.top, component.sprite.y);
			bounds.right = Math.max(bounds.right, component.sprite.x + component.sprite.width);
			bounds.bottom = Math.max(bounds.bottom, component.sprite.y + component.sprite.height);
		}

		var pebble = new FlxSprite();
		pebble.makeGraphic(Math.round(bounds.width), Math.round(bounds.height), FlxColor.TRANSPARENT, true);

		var offsetX = Math.round(body.x - bounds.x);
		var offsetY = Math.round(body.y - bounds.y);
		pebble.stamp(body, offsetX, offsetY);

		for (c in toStamp)
		{
			pebble.stamp(c, Math.round(c.x - body.x) + offsetX, Math.round(c.y - body.y) + offsetY);
		}

		PebbleGame.pebbleList.push({
			sprite: pebble,
			stats: gemStats,
			location: NONE
		});

		FlxG.switchState(new MainState());
	}
}
