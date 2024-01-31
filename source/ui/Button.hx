package ui;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class Button extends FlxButton
{
	private var type:ButtonType;

	public var sound:FlxSoundAsset = AssetPaths.ui_button__ogg;

	public function new(text:String, type:ButtonType, onClick:Void->Void)
	{
		this.type = type;
		super(0, 0, text, function()
		{
			FlxG.sound.play(sound).persist = true;
			onClick();
		});
		resetHelpers();

		this.label.setFormat(AssetPaths.Schoolbell__ttf, 50, FlxColor.BLACK);
		for (o in this.labelOffsets)
		{
			o.y = this.height / 2 - this.label.height / 2;
		}

		setMode(true);
	}

	override function loadDefaultGraphic()
	{
		loadGraphic(getTypeGraphic(type));
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

	private static function getTypeGraphic(t:ButtonType):FlxGraphicAsset
	{
		return switch (t)
		{
			case LARGE: AssetPaths.button_large__png;
			case SMALL: AssetPaths.button_small__png;
			case MINI: AssetPaths.button_mini__png;
		}
	}
}

enum ButtonType
{
	LARGE;
	SMALL;
	MINI;
}
