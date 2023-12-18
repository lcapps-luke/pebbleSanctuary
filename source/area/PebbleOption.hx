package area;

import PebbleGame.PebbleDefinition;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxButton;

class PebbleOption extends FlxTypedGroup<FlxSprite>
{
	public static inline var SIZE:Int = 230;
	public static inline var VIEW_HEIGHT:Int = 150;
	public static inline var BUTTON_HEIGHT:Int = SIZE - VIEW_HEIGHT;

	public var pebble(default, null):PebbleDefinition;
	public var placed(default, set):Bool;

	private var callback:PebbleOption->Void;
	private var placeButton:FlxButton;
	private var removeButton:FlxButton;

	public function new(x:Float, y:Float, pebble:PebbleDefinition, placed:Bool, callback:PebbleOption->Void)
	{
		super();
		this.pebble = pebble;
		this.callback = callback;

		var bg = new FlxSprite(x, y);
		bg.makeGraphic(SIZE, SIZE, 0xFFC0C0C0);
		add(bg);

		var pSpr = pebble.sprite.clone();
		pSpr.x = x;
		pSpr.y = y;

		var pScale = Math.min(SIZE / pSpr.width, VIEW_HEIGHT / pSpr.height);
		pSpr.scale.set(pScale, pScale);
		pSpr.updateHitbox();
		add(pSpr);

		placeButton = new FlxButton(x, y + VIEW_HEIGHT, "Place", onButton);
		add(placeButton);
		removeButton = new FlxButton(x, y + VIEW_HEIGHT, "Remove", onButton);
		add(removeButton);
		this.placed = placed;
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