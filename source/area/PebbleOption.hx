package area;

import PebbleGame.PebbleDefinition;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxButton;
import ui.Button;

class PebbleOption extends FlxTypedGroup<FlxSprite>
{
	public static inline var SIZE:Int = 230;
	public static inline var VIEW_HEIGHT:Int = 150;
	public static inline var BUTTON_HEIGHT:Int = SIZE - VIEW_HEIGHT;

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
		pSpr.x = x;
		pSpr.y = y;

		var pScale = Math.min(SIZE / pSpr.width, VIEW_HEIGHT / pSpr.height);
		pSpr.scale.set(pScale, pScale);
		pSpr.updateHitbox();
		add(pSpr);

		placeButton = new Button("Place", false, onButton);
		placeButton.setPosition(x, y + VIEW_HEIGHT);
		add(placeButton);

		removeButton = new Button("Remove", false, onButton);
		removeButton.setPosition(x, y + VIEW_HEIGHT);
		removeButton.setMode(false);
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
