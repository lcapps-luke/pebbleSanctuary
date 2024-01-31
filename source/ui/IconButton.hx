package ui;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.ui.FlxSpriteButton;

class IconButton extends FlxSpriteButton
{
	public function new(x:Float, y:Float, labelAsset:FlxGraphicAsset, onClick:Void->Void)
	{
		var label = new FlxSprite(0, 0, labelAsset);
		super(x, y, label, onClick);
		resetHelpers();

		var ox = width / 2 - label.width / 2;
		var oy = height / 2 - label.height / 2;
		for (offset in labelOffsets)
		{
			offset.set(offset.x + ox, offset.y + oy);
		}

		this.setColorTransform(0, 1, 0);
	}

	override function loadDefaultGraphic()
	{
		loadGraphic(AssetPaths.button_mini__png);
	}
}
