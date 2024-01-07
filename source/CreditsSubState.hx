package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import ui.Button;

class CreditsSubState extends FlxSubState
{
	private var lineAcc:Float;

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

		lineAcc = FlxG.height * 0.15;

		addCreditLine("Game By Luke Cann.");
		addCreditLine("Music by Nogika Chaba.");
		addCreditLine("Characters are the property of cover corp.\nSee their fan work terms for details: https://en.hololive.tv/terms");
	}

	private function addCreditLine(str:String)
	{
		var txt = new FlxText(100, lineAcc, FlxG.width - 200);
		txt.setFormat(AssetPaths.Schoolbell__ttf, 70, FlxColor.WHITE, LEFT);
		txt.text = str;
		add(txt);

		lineAcc += txt.height + 70;
	}
}
