package area;

import PebbleGame.PebbleDefinition;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import ui.Button;

class PebbleOption extends FlxTypedGroup<FlxSprite>
{
	public static inline var SIZE:Int = 230;
	public static inline var VIEW_HEIGHT:Int = 150;
	public static inline var BUTTON_HEIGHT:Int = SIZE - VIEW_HEIGHT;
	public static inline var STAT_ICON_SIZE:Int = 40;
	public static inline var PEBBLE_WIDTH = SIZE * 0.9;
	public static inline var PEBBLE_HEIGHT = VIEW_HEIGHT * 0.9;

	public var pebble(default, null):PebbleDefinition;
	public var placed(default, set):Bool;

	private var callback:PebbleOption->Void;
	private var placeButton:Button;
	private var removeButton:Button;

	public function new(x:Float, y:Float, pebble:PebbleDefinition, placed:Bool, callback:PebbleOption->Void)
	{
		super();
		this.pebble = pebble;
		this.callback = callback;

		var bg = new FlxSprite(x, y);
		bg.makeGraphic(SIZE, SIZE, 0xFFC0C0C0);
		add(bg);

		var pSpr = pebble.sprite.clone();
		var pScale = Math.min(PEBBLE_WIDTH / pSpr.width, PEBBLE_HEIGHT / pSpr.height);
		pSpr.scale.set(pScale, pScale);
		pSpr.updateHitbox();
		pSpr.x = SIZE / 2 - pSpr.width / 2 + x;
		pSpr.y = VIEW_HEIGHT / 2 - pSpr.height / 2 + y;

		add(pSpr);

		// stat icons
		makeStat(AssetPaths.icon_office__png, pebble.stats.working, x, y, 0);
		makeStat(AssetPaths.icon_kitchen__png, pebble.stats.cooking, x, y, 1);
		makeStat(AssetPaths.icon_mine__png, pebble.stats.mining, x, y, 2);

		placeButton = new Button("Place", false, onButton);
		placeButton.setPosition(x + SIZE / 2 - placeButton.width / 2, y + VIEW_HEIGHT);
		add(placeButton);

		removeButton = new Button("Remove", false, onButton);
		removeButton.setPosition(x, y + VIEW_HEIGHT);
		removeButton.setMode(false);
		add(removeButton);
		this.placed = placed;
	}

	private function makeStat(icon:FlxGraphicAsset, val:Int, x:Float, y:Float, pos:Int)
	{
		var px = x + (SIZE / 3) * 0.05;

		var bg = new FlxSprite(px + (SIZE / 3) * pos, y + VIEW_HEIGHT - STAT_ICON_SIZE);
		bg.makeGraphic(Math.round((SIZE / 3) * 0.9), STAT_ICON_SIZE, 0x90000000);
		add(bg);

		var spr = new FlxSprite(px + (SIZE / 3) * pos, y + VIEW_HEIGHT - STAT_ICON_SIZE, icon);
		spr.setGraphicSize(STAT_ICON_SIZE, STAT_ICON_SIZE);
		spr.updateHitbox();
		add(spr);

		var txt = new FlxText(spr.x + spr.width + STAT_ICON_SIZE * 0.1, spr.y - (STAT_ICON_SIZE * 0.1), 0, Std.string(val));
		txt.setFormat(AssetPaths.Schoolbell__ttf, STAT_ICON_SIZE, FlxColor.WHITE);
		add(txt);
	}

	private function onButton()
	{
		callback(this);
	}

	private function set_placed(value:Bool):Bool
	{
		placeButton.visible = !value;
		removeButton.visible = value;
		return placed = value;
	}
}
