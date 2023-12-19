package creator;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

abstract class ComponentMenu extends FlxTypedGroup<FlxBasic>
{
	private static inline var ITEM_COLS = 3;

	private var itemQty = 0;
	private var columns = ITEM_COLS;

	private var width:Float;
	private var x:Float;

	private var items = new Array<ComponentMenuItem>();

	public function new(name:String, back:Void->Void, forward:Void->Void, x:Float, width:Float)
	{
		super();
		this.width = width;
		this.x = x;

		// TODO add nav buttons
		var title = new FlxText();
		title.setFormat(AssetPaths.Schoolbell__ttf, 50);
		title.text = name;
		title.x = width / 2 - title.width / 2 + x;
		title.y = 40;
		add(title);
	}

	private function addMenuItem(itm:ComponentMenuItem)
	{
		var iy = Math.floor(itemQty / columns);
		var ix = itemQty - iy * columns;

		var cellSize = width / columns;

		itm.x = x + ix * cellSize + (cellSize / 2 - ComponentMenuItem.SIZE / 2);
		itm.y = 150 + iy * cellSize;

		add(itm);
		items.push(itm);

		itemQty++;
	}

	public function setComponentColour(c:FlxColor)
	{
		for (i in items)
		{
			i.setColour(c);
		}
	}
}
