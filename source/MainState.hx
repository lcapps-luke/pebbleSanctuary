package;

import area.KitchenAreaState;
import area.MineAreaState;
import area.OfficeAreaState;
import creator.PebbleCreatorState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import flixel.addons.ui.FlxClickArea;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import ui.Button;

class MainState extends FlxState
{
	private var backFar:FlxSprite;
	private var backMid:FlxSprite;
	private var backFor:FlxSprite;
	private var mousePosition = new FlxPoint();
	private var backDiff:Float;

	private var areaSpriteLink = new Array<AreaSprite>();

	override public function create()
	{
		this.bgColor = FlxColor.BLACK;
		super.create();

		backFar = new FlxSprite(AssetPaths.main_bg_1__png);
		add(backFar);

		backMid = new FlxSprite(AssetPaths.main_bg_2__png);
		backMid.y = FlxG.height - backMid.height;
		add(backMid);

		addLocationSpr(AssetPaths.office__png, 0.2, 930, onGotoOffice);
		addLocationSpr(AssetPaths.cafe__png, 0.5, 930, onGotoKitchen);
		addLocationSpr(AssetPaths.mine__png, 0.8, 930, onGotoMine);

		backFor = new FlxSprite(AssetPaths.main_bg_3__png);
		backFor.y = FlxG.height - backFor.height;
		add(backFor);
		backDiff = (backFar.width - FlxG.width) * 0.5;

		var createButton = new Button("Create Pebble", true, onCreatePebble);
		createButton.x = FlxG.width - createButton.width - 50;
		createButton.y = 50;
		add(createButton);
	}

	private function addLocationSpr(spr:FlxGraphicAsset, xPercent:Float, yBottom:Float, onClick:Void->Void)
	{
		var locSpr = new FlxSprite(spr);

		#if hl
		locSpr.x = FlxG.width * xPercent - locSpr.width / 2;
		locSpr.y = yBottom - locSpr.height;
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
	}

	private function onCreatePebble()
	{
		FlxG.switchState(new PebbleCreatorState());
	}

	private function onGotoMine()
	{
		FlxG.switchState(new MineAreaState());
	}

	private function onGotoKitchen()
	{
		FlxG.switchState(new KitchenAreaState());
	}

	private function onGotoOffice()
	{
		FlxG.switchState(new OfficeAreaState());
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
}

private typedef AreaSprite =
{
	var area:FlxClickArea;
	var sprite:FlxEffectSprite;
}
