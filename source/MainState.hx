package;

import PebbleGame.PebbleLocation;
import area.KitchenAreaState;
import area.MineAreaState;
import area.OfficeAreaState;
import area.ReleaseAreaState;
import creator.PebbleCreatorState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.ui.FlxClickArea;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import ui.Button;
#if !hl
import flixel.addons.effects.chainable.FlxOutlineEffect;
#end

class MainState extends FlxState
{
	private var backFar:FlxSprite;
	private var backMid:FlxSprite;
	private var backFor:FlxSprite;
	private var mousePosition = new FlxPoint();
	private var backDiff:Float;

	private var createButton:Button;
	private var qty:FlxText;
	private var locationQty = new Map<PebbleLocation, FlxText>();

	private var areaSpriteLink = new Array<AreaSprite>();
	private var fullScreenButton:Button;

	private var pebblesLoaded = false;

	override public function create()
	{
		this.bgColor = FlxColor.BLACK;
		super.create();

		backFar = new FlxSprite(AssetPaths.main_bg_1__png);
		add(backFar);

		backMid = new FlxSprite(AssetPaths.main_bg_2__png);
		backMid.y = FlxG.height - backMid.height;
		add(backMid);

		addLocationSpr(AssetPaths.office__png, 0.2, 930, onGotoOffice, PebbleLocation.OFFICE);
		addLocationSpr(AssetPaths.cafe__png, 0.5, 930, onGotoKitchen, PebbleLocation.KITCHEN);
		addLocationSpr(AssetPaths.mine__png, 0.8, 930, onGotoMine, PebbleLocation.MINE);

		backFor = new FlxSprite(AssetPaths.main_bg_3__png);
		backFor.y = FlxG.height - backFor.height;
		add(backFor);
		backDiff = (backFar.width - FlxG.width) * 0.5;

		createButton = new Button("Create Pebble", LARGE, onCreatePebble);
		createButton.x = FlxG.width - createButton.width - 50;
		createButton.y = 50;
		createButton.visible = false;
		add(createButton);

		qty = new FlxText(createButton.x - 50, createButton.height + 10, createButton.width + 100);
		qty.setFormat(AssetPaths.Schoolbell__ttf, 50, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		qty.borderSize = 3;
		qty.text = 'Loading Pebbles';
		add(qty);

		fullScreenButton = new Button(getFullscreenText(), SMALL, toggleFullScreen);
		fullScreenButton.setPosition(20, 20);
		add(fullScreenButton);

		var releaseButton = new Button("Release", SMALL, onRelease);
		releaseButton.setMode(false);
		releaseButton.setPosition(20, FlxG.height - releaseButton.height - 20);
		add(releaseButton);

		PebbleGame.load().onComplete(loaded ->
		{
			if (!loaded)
			{
				PebbleGame.save();
			}
			onLoaded();
		}).onError(e ->
			{
				FlxG.log.error(e);
				onLoaded();
			});
	}

	private function onLoaded()
	{
		pebblesLoaded = true;

		if (PebbleGame.pebbleList.length < PebbleGame.pebbleSlots)
		{
			createButton.visible = true;
		}

		for (kv in locationQty.keyValueIterator())
		{
			var pebbleQty = PebbleGame.pebbleList.filter(p -> p.location == kv.key).length;
			kv.value.text = '$pebbleQty Pebbles';
		}

		qty.text = '${PebbleGame.pebbleList.length} / ${PebbleGame.pebbleSlots} Pebbles';
	}

	private function addLocationSpr(spr:FlxGraphicAsset, xPercent:Float, yBottom:Float, onClick:Void->Void, type:PebbleLocation)
	{
		var locSpr = new FlxSprite(spr);
		locSpr.x = FlxG.width * xPercent - locSpr.width / 2;
		locSpr.y = yBottom - locSpr.height;

		#if hl
		add(locSpr);
		#end

		#if !hl
		var effSpr = new FlxEffectSprite(locSpr, [new FlxOutlineEffect(NORMAL, FlxColor.WHITE, 20)]);
		effSpr.effectsEnabled = false;
		effSpr.x = FlxG.width * xPercent - locSpr.width / 2;
		effSpr.y = yBottom - locSpr.height;
		add(effSpr);
		#end

		var office = new FlxClickArea(locSpr.x, locSpr.y, locSpr.width, locSpr.height, onClick);
		add(office);

		#if !hl
		areaSpriteLink.push({
			area: office,
			sprite: effSpr
		});
		#end

		var pebbleQty = PebbleGame.pebbleList.filter(p -> p.location == type).length;

		var qty = new FlxText(office.x, office.y, office.width);
		qty.setFormat(AssetPaths.Schoolbell__ttf, 50, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		qty.borderSize = 3;
		qty.text = 'Loading Pebbles';
		add(qty);

		locationQty.set(type, qty);
	}

	private function onCreatePebble()
	{
		if (pebblesLoaded)
		{
			FlxG.switchState(new PebbleCreatorState());
		}
	}

	private function onGotoMine()
	{
		if (pebblesLoaded)
		{
			FlxG.switchState(new MineAreaState());
		}
	}

	private function onGotoKitchen()
	{
		if (pebblesLoaded)
		{
			FlxG.switchState(new KitchenAreaState());
		}
	}

	private function onGotoOffice()
	{
		if (pebblesLoaded)
		{
			FlxG.switchState(new OfficeAreaState());
		}
	}

	private function onRelease()
	{
		if (pebblesLoaded)
		{
			FlxG.switchState(new ReleaseAreaState());
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.mouse.getPosition(mousePosition);
		var scrollPercent = mousePosition.x / FlxG.width;
		backFar.x = FlxMath.bound(scrollPercent * backDiff - backDiff, -backDiff, 0);
		backFor.x = FlxMath.bound(-scrollPercent * backDiff, -backDiff, 0);

		for (a in areaSpriteLink)
		{
			a.sprite.effectsEnabled = a.area.status != FlxButton.NORMAL;
		}
	}

	private function toggleFullScreen()
	{
		FlxG.fullscreen = !FlxG.fullscreen;
		fullScreenButton.text = getFullscreenText();
	}

	private inline function getFullscreenText():String
	{
		return FlxG.fullscreen ? "Windowed" : "Fullscreen";
	}
}

private typedef AreaSprite =
{
	var area:FlxClickArea;
	var sprite:FlxEffectSprite;
}
