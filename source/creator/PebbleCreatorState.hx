package creator;

import PebbleGame.PebbleStats;
import creator.ColourPicker.ColorPicker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import ui.Button;

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

	private var mousePosition = new FlxPoint();
	private var background:FlxBackdrop;

	private var colourPicker:ColorPicker;
	private var menus = new Array<ComponentMenu>();

	override function create()
	{
		this.bgColor = FlxColor.WHITE;
		super.create();

		background = new FlxBackdrop(AssetPaths.create_bg__png);
		add(background);

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

		var menuBg = new FlxSprite();
		menuBg.makeGraphic(Math.round(FlxG.width * 0.3), Math.round(FlxG.height), FlxColor.GRAY);
		menuBg.x = FlxG.width - menuBg.width;
		add(menuBg);

		var colour = FlxColor.fromRGBFloat(FlxG.random.float(0.5, 1), FlxG.random.float(0.5, 1), FlxG.random.float(0.5, 1));
		colourPicker = new ColorPicker(colour, menuBg.x + 20, FlxG.height - 170, menuBg.width - 50, 150);
		add(colourPicker);

		var gemMenu = new GemMenu(null, null, onAddGem, menuBg.x, menuBg.width);
		add(gemMenu);
		menus.push(gemMenu);

		var finishButton = new Button("Finish", true, onFinish);
		finishButton.x = FlxG.width * 0.35 - finishButton.width / 2;
		finishButton.y = FlxG.height * 0.85;
		add(finishButton);

		var cancelButton = new Button("Cancel", false, onCancel);
		cancelButton.setMode(false);
		cancelButton.x = 20;
		cancelButton.y = 20;
		add(cancelButton);
	}

	private function onAddGem(gemDef:Data.Gem, x:Float, y:Float)
	{
		if (gem != null)
		{
			pebbleLayer.remove(gem);
			gem.destroy();
		}

		gem = new PebbleComponent(gemDef.sprite, x, y, colourPicker.getColour());
		gemStats.cooking = gemDef.cooking;
		gemStats.mining = gemDef.mining;
		gemStats.working = gemDef.working;

		FlxG.mouse.getPosition(mousePosition);
		gem.setSelected(true, mousePosition);

		add(gem);
		heldComponent = gem;
		justAdded = true;
	}

	override function update(elapsed:Float)
	{
		PebbleGame.cursorGrab = heldComponent != null;

		super.update(elapsed);

		FlxG.mouse.getPosition(mousePosition);
		background.x = -FlxMath.bound(mousePosition.x, 0, FlxG.width) * 0.2;

		if (FlxG.mouse.justPressed && !justAdded)
		{
			heldComponent = null;

			pebbleLayer.forEach(c ->
			{
				if (c.overlapsPoint(mousePosition))
				{
					heldComponent = c;
				}
				c.setSelected(false, null);
			});

			if (heldComponent != null)
			{
				pebbleLayer.remove(heldComponent);
				add(heldComponent);

				heldComponent.setSelected(true, mousePosition);
			}
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

		if (!FlxG.mouse.pressed)
		{
			pebbleLayer.forEach(c ->
			{
				if (c.overlapsPoint(mousePosition))
				{
					PebbleGame.cursorGrab = true;
				}
			});
		}

		for (m in menus)
		{
			m.setComponentColour(colourPicker.getColour());
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

	private function onCancel()
	{
		FlxG.switchState(new MainState());
	}
}
