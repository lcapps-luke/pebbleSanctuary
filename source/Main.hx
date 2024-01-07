package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxGame;
import haxe.Resource;
import openfl.display.Sprite;
#if html5
import js.Browser;
#end

class Main extends Sprite
{
	public static var canPlayMusic(default, null) = new CanPlayMusicPlugin();

	public function new()
	{
		super();

		Data.load(Resource.getString("database.cdb"));

		addChild(new FlxGame(1920, 1080, MainState, 60, 60, true));

		FlxG.autoPause = false;

		FlxG.plugins.add(new CursorPlugin());

		var musicVolume = 0.25;
		if (FlxG.save.isBound && FlxG.save.data.musicVolume != null)
		{
			musicVolume = FlxG.save.data.musicVolume;
		}

		FlxG.sound.defaultMusicGroup.volume = musicVolume;
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

private class CanPlayMusicPlugin
{
	public var canPlay(default, null):Bool = false;

	public function new()
	{
		#if !html5
		canPlay = true;
		#end

		#if html5
		Browser.document.addEventListener("click", onUserGesture);
		Browser.document.addEventListener("contextmenu", onUserGesture);
		Browser.document.addEventListener("dblclick", onUserGesture);
		Browser.document.addEventListener("mouseup", onUserGesture);
		Browser.document.addEventListener("pointerup", onUserGesture);
		Browser.document.addEventListener("touchend", onUserGesture);
		#end
	}

	#if html5
	private function onUserGesture()
	{
		if (!canPlay)
		{
			canPlay = true;
		}
	}
	#end
}
