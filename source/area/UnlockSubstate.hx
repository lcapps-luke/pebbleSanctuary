package area;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import ui.Button;

class UnlockSubstate extends FlxSubState
{
	private var icon:FlxSprite;

	public function new(icon:FlxSprite)
	{
		super();
		this.icon = icon;
	}

	override function create()
	{
		super.create();

		var t = new FlxText(0, 0, 0, "Unlocked!");
		t.setFormat(AssetPaths.Schoolbell__ttf, 100, FlxColor.BLACK, CENTER);
		t.x = FlxG.width / 2 - t.width / 2;

		icon.x = FlxG.width / 2 - icon.width / 2;

		var ok = new Button("OK", LARGE, close);
		ok.x = FlxG.width / 2 - ok.width / 2;

		var totalHeight = t.height + icon.height + ok.height;
		var space = totalHeight / 3;
		var startY = FlxG.height / 2 - totalHeight / 2;

		t.y = startY;
		icon.y = startY + space;
		ok.y = startY + space * 2;

		var width = Math.max(Math.max(t.width, icon.width), ok.width);
		var bg = new FlxSprite();
		bg.makeGraphic(Math.round(width + 100), Math.round(totalHeight + 100), 0x80BBBBBB);
		bg.setPosition(FlxG.width / 2 - bg.width / 2, FlxG.height / 2 - bg.height / 2);
		add(bg);

		add(t);
		add(icon);
		add(ok);
	}
}
