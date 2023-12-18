package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxGame;
import haxe.Resource;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		Data.load(Resource.getString("database.cdb"));

		addChild(new FlxGame(1920, 1080, MainState, 60, 60, true));

		FlxG.plugins.add(new CursorPlugin());
	}
}

private class CursorPlugin extends FlxBasic
{
	private var lastCursor:Bool;

	public function new()
	{
		super();
		lastCursor = PebbleGame.cursorGrab;
		setCursor(lastCursor);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (lastCursor != PebbleGame.cursorGrab)
		{
			setCursor(PebbleGame.cursorGrab);
			lastCursor = PebbleGame.cursorGrab;
		}
	}

	private inline function setCursor(grab:Bool)
	{
		FlxG.mouse.load(PebbleGame.cursorGrab ? AssetPaths.grab__png : AssetPaths.pointer__png);
	}
}
