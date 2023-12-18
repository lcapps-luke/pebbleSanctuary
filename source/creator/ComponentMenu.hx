package creator;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

abstract class ComponentMenu extends FlxTypedGroup<FlxBasic>
{
	private static inline var ITEM_COLS = 3;

	private var bg:FlxSprite;

	private var itemSlotSize:Float;
	private var itemQty = 0;

	public function new(name:String, back:Void->Void, forward:Void->Void)
	{
		super();

		bg = new FlxSprite();
		bg.makeGraphic(Math.round(FlxG.width * 0.3), Math.round(FlxG.height), FlxColor.GRAY);
		bg.x = FlxG.width - bg.width;
		add(bg);

		// TODO add title and nav buttons
	}

	private function addMenuItem(itm:ComponentMenuItem)
	{
		var iy = Math.floor(itemQty / ITEM_COLS);
		var ix = itemQty - iy * ITEM_COLS;

		var cellSize = bg.width / ITEM_COLS;

		itm.x = bg.x + ix * cellSize + (cellSize / 2 - ComponentMenuItem.SIZE / 2);
		itm.y = 150 + iy * cellSize;

		add(itm);

		itemQty++;
	}
}
