package ui;

import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class Button extends FlxButton
{
	private var large:Bool;

	public function new(text:String, large:Bool, onClick:Void->Void)
	{
		this.large = large;
		super(0, 0, text, onClick);

		loadGraphic(large ? AssetPaths.button_large__png : AssetPaths.button_small__png);

		this.label.setFormat(AssetPaths.Schoolbell__ttf, 50, FlxColor.BLACK);
		for (o in this.labelOffsets)
		{
			o.y = this.height / 2 - this.label.height / 2;
		}

		setMode(true);
	}

	public function setMode(positive:Bool)
	{
		if (positive)
		{
			this.setColorTransform(0, 1, 0);
		}
		else
		{
			this.setColorTransform(1, 0, 0);
		}
	}
}
