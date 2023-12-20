package creator;

import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import ui.Button;

abstract class ComponentMenu extends FlxTypedGroup<FlxBasic>
{
	private static inline var ITEM_COLS = 3;

	private var itemQty = 0;
	private var columns = ITEM_COLS;

	private var width:Float;
	private var x:Float;

	private var items = new Array<ComponentMenuItem>();

	public var componentColour(default, set):FlxColor = FlxColor.WHITE;

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

		if (back != null)
		{
			var navButton = new Button("<", MINI, back);
			navButton.x = title.x - navButton.width * 1.5;
			navButton.y = title.y;
			add(navButton);
		}
		if (forward != null)
		{
			var navButton = new Button(">", MINI, forward);
			navButton.x = title.x + title.width + navButton.width * 0.5;
			navButton.y = title.y;
			add(navButton);
		}
	}

	private function addMenuItem(itm:ComponentMenuItem)
	{
		var iy = Math.floor(itemQty / columns);
		var ix = itemQty - iy * columns;

		var cellSize = width / columns;

		itm.x = x + ix * cellSize + (cellSize / 2 - ComponentMenuItem.SIZE / 2);
		itm.y = 150 + iy * cellSize;
		itm.setColour(componentColour);

		add(itm);
		items.push(itm);

		itemQty++;
	}

	private function set_componentColour(value:FlxColor):FlxColor
	{
		for (i in items)
		{
			i.setColour(value);
		}
		return componentColour = value;
	}
}
