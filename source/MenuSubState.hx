package;

import flixel.FlxG;
import flixel.FlxSubState;
import lime.system.System;
import ui.Button;

class MenuSubState extends FlxSubState
{
	private var fullScreenButton:Button;

	public function new()
	{
		super(0x90000000);
	}

	override function create()
	{
		super.create();

		fullScreenButton = new Button(getFullscreenText(), LARGE, toggleFullScreen);
		fullScreenButton.x = FlxG.width / 2 - fullScreenButton.width / 2;
		fullScreenButton.y = FlxG.height * 0.25 - fullScreenButton.height / 2;
		add(fullScreenButton);

		var settingsButton = new Button("Settings", LARGE, showSettings);
		settingsButton.x = FlxG.width / 2 - settingsButton.width / 2;
		settingsButton.y = FlxG.height * 0.5 - settingsButton.height / 2;
		add(settingsButton);

		var creditsButton = new Button("Credits", LARGE, showCredits);
		creditsButton.x = FlxG.width / 2 - creditsButton.width / 2;
		creditsButton.y = FlxG.height * 0.75 - creditsButton.height / 2;
		add(creditsButton);

		var closeButton = new Button("Close", LARGE, close);
		closeButton.x = 20;
		closeButton.y = FlxG.height - closeButton.height - 20;
		add(closeButton);

		#if !html5
		var endButton = new Button("End Game", LARGE, function()
		{
			System.exit(0);
		});
		endButton.setMode(false);
		endButton.x = FlxG.width - endButton.width - 20;
		endButton.y = FlxG.height - endButton.height - 20;
		add(endButton);
		#end
	}

	private function toggleFullScreen()
	{
		FlxG.fullscreen = !FlxG.fullscreen;
		fullScreenButton.text = getFullscreenText();
	}

	private inline function getFullscreenText():String
	{
		return FlxG.fullscreen ? "Windowed" : "Fullscreen";
	}

	private function showSettings()
	{
		openSubState(new SettingsSubState());
	}

	private function showCredits()
	{
		openSubState(new CreditsSubState());
	}
}
