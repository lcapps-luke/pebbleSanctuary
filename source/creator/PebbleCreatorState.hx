package creator;

import PebbleGame.PebbleStats;
import creator.ColourPicker.ColorPicker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import lime.tools.GUID;
import ui.Button;

class PebbleCreatorState extends FlxTransitionableState
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
	private var activeMenuIndex:Int = 0;

	public function new()
	{
		var td = new TransitionData(FADE, FlxColor.BLACK, 0.2);
		super(td, td);
	}

	override function create()
	{
		this.bgColor = FlxColor.WHITE;
		super.create();

		if (FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			FlxG.sound.music.fadeOut(0.2, 0, function(t)
			{
				FlxG.sound.playMusic(AssetPaths.cafe_latte__ogg, 0);
				FlxG.sound.music.fadeIn(0.2);
			});
		}

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

		colourPicker = new ColorPicker(FlxColor.WHITE, menuBg.x + 20, FlxG.height - 170, menuBg.width - 50, 150);
		add(colourPicker);

		var gemMenu = new GemMenu(null, onMenuForward, onAddGem, menuBg.x, menuBg.width);
		add(gemMenu);
		menus.push(gemMenu);
		colourPicker.colour = gemMenu.componentColour;

		for (ct in [Data.ComponentType.EYE, Data.ComponentType.MOUTH, Data.ComponentType.OTHER])
		{
			var cm = new OtherMenu(ct, onMenuBack, ct == OTHER ? null : onMenuForward, onAddComponent, menuBg.x, menuBg.width);
			cm.kill();
			add(cm);
			menus.push(cm);
		}

		var finishButton = new Button("Finish", LARGE, onFinish);
		finishButton.x = FlxG.width * 0.35 - finishButton.width / 2;
		finishButton.y = FlxG.height * 0.85;
		add(finishButton);

		var cancelButton = new Button("Cancel", SMALL, onCancel);
		cancelButton.setMode(false);
		cancelButton.x = 20;
		cancelButton.y = 20;
		add(cancelButton);
	}

	private function onAddGem(gemDef:Data.Gem, x:Float, y:Float)
	{
		pebbleLayer.forEach(c -> c.setSelected(false, null));

		if (gem != null)
		{
			pebbleLayer.remove(gem);
			gem.destroy();
		}

		gem = new PebbleComponent(gemDef.sprite, x, y, colourPicker.colour);
		gemStats.cooking = gemDef.cooking;
		gemStats.mining = gemDef.mining;
		gemStats.working = gemDef.working;

		FlxG.mouse.getPosition(mousePosition);
		gem.setSelected(true, mousePosition);

		add(gem);
		heldComponent = gem;
		justAdded = true;
	}

	private function onAddComponent(componentDefinition:Data.Component, x:Float, y:Float)
	{
		pebbleLayer.forEach(c -> c.setSelected(false, null));

		var component = new PebbleComponent(componentDefinition.sprite, x, y, colourPicker.colour);

		FlxG.mouse.getPosition(mousePosition);
		component.setSelected(true, mousePosition);

		add(component);
		heldComponent = component;
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

				if (heldComponent.isWithin(workspace))
				{
					pebbleLayer.add(heldComponent);
				}
				else
				{
					heldComponent.destroy();
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

		menus[activeMenuIndex].componentColour = colourPicker.colour;

		justAdded = false;
	}

	private function onFinish()
	{
		var bounds = new FlxRect(body.x, body.y, body.width, body.height);

		pebbleLayer.forEach(c ->
		{
			bounds.left = Math.min(bounds.left, c.sprite.x);
			bounds.top = Math.min(bounds.top, c.sprite.y);
			bounds.right = Math.max(bounds.right, c.sprite.x + c.sprite.width);
			bounds.bottom = Math.max(bounds.bottom, c.sprite.y + c.sprite.height);
		});

		var pebble = new FlxSprite();
		pebble.makeGraphic(Math.round(bounds.width), Math.round(bounds.height), FlxColor.TRANSPARENT, true);

		var offsetX = Math.round(body.x - bounds.x);
		var offsetY = Math.round(body.y - bounds.y);
		pebble.stamp(body, offsetX, offsetY);

		pebbleLayer.forEach(c ->
		{
			// stamp doesn't seem to respect the origin or something
			var shiftX = c.sprite.origin.x * (c.sprite.scale.x - 1);
			var shiftY = c.sprite.origin.y * (c.sprite.scale.y - 1);

			pebble.stamp(c.sprite, Math.round(c.sprite.x - body.x + shiftX) + offsetX, Math.round(c.sprite.y - body.y + shiftY) + offsetY);
		});

		PebbleGame.pebbleList.push({
			id: GUID.uuid(),
			sprite: pebble,
			stats: gemStats,
			location: NONE
		});

		FlxG.switchState(new MainState(true));
	}

	private function onCancel()
	{
		FlxG.switchState(new MainState(true));
	}

	private function onMenuBack()
	{
		menus[activeMenuIndex].kill();
		activeMenuIndex -= 1;
		colourPicker.colour = menus[activeMenuIndex].componentColour;
		menus[activeMenuIndex].revive();
	}

	private function onMenuForward()
	{
		menus[activeMenuIndex].kill();
		activeMenuIndex += 1;
		colourPicker.colour = menus[activeMenuIndex].componentColour;
		menus[activeMenuIndex].revive();
	}

	override function startOutro(onOutroComplete:() -> Void)
	{
		super.startOutro(onOutroComplete);
		FlxG.sound?.music?.fadeOut(0.2);
	}

	override function finishTransOut()
	{
		super.finishTransOut();
		FlxG.sound?.music?.stop();
	}
}
