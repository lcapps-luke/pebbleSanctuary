package area;

import PebbleGame.PebbleDefinition;
import PebbleGame.PebbleLocation;
import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

abstract class AbstractAreaState extends FlxState
{
	private var locationType:PebbleLocation;

	public function new(locationType:PebbleLocation)
	{
		super();
		this.locationType = locationType;
	}

	override function create()
	{
		super.create();
		// TODO background
		// TODO midground
		// TODO foreground

		// ui
		var pebbleList = new Array<PebbleDefinition>();
		for (p in PebbleGame.pebbleList)
		{
			if (p.location == NONE || p.location == locationType)
			{
				pebbleList.push(p);
			}
		}

		var acc = 30.0;
		for (p in pebbleList)
		{
			var placed = p.location == locationType;
			var opt = new PebbleOption(acc, FlxG.height - PebbleOption.SIZE - 30, p, placed, onPebbleOption);
			add(opt);

			acc += PebbleOption.SIZE + 30;
		}

		var back = new FlxButton(50, 50, "Back", onBack);
		add(back);
	}

	private function onPebbleOption(opt:PebbleOption)
	{
		if (opt.placed)
		{
			// TODO remove pebble
			opt.pebble.location = NONE;
			opt.placed = false;
			PebbleGame.calculateStats();
		}
		else
		{
			// TODO add pebble
			opt.pebble.location = locationType;
			opt.placed = true;
			PebbleGame.calculateStats();
		}
	}

	private function onBack()
	{
		FlxG.switchState(new MainState());
	}
}
