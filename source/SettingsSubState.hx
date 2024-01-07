package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.ui.FlxSlider;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import ui.Button;

class SettingsSubState extends FlxSubState
{
	public function new()
	{
		super(0x90000000);
	}

	override function create()
	{
		super.create();

		var closeButton = new Button("Close", LARGE, close);
		closeButton.x = 20;
		closeButton.y = FlxG.height - closeButton.height - 20;
		add(closeButton);

		var sound = new FlxSlider(FlxG.sound, "volume", 100, FlxG.height * 0.25, 0, 1, FlxG.width - 200, 50, 50, FlxColor.WHITE, 0xFF00FF00);
		sound.setTexts(null, false);
		add(sound);
		makeLabel(sound, "Sound");

		var sound = new FlxSlider(FlxG.sound.defaultMusicGroup, "volume", 100, FlxG.height * 0.50, 0, 1, FlxG.width - 200, 50, 50, FlxColor.WHITE, 0xFF00FF00);
		sound.setTexts(null, false);
		add(sound);
		makeLabel(sound, "Music");
	}

	private function makeLabel(ele:FlxSprite, label:String)
	{
		var txt = new FlxText(ele.x, ele.y - 60, ele.width, label);
		txt.setFormat(AssetPaths.Schoolbell__ttf, 60, FlxColor.WHITE, LEFT);
		add(txt);
	}

	override function close()
	{
		super.close();

		if (FlxG.save.isBound)
		{
			FlxG.save.data.volume = FlxG.sound.volume;
			FlxG.save.data.musicVolume = FlxG.sound.defaultMusicGroup.volume;
			FlxG.save.flush();
		}
	}
}
