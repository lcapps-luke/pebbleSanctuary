package;

import flixel.FlxSprite;
import flixel.math.FlxMath;

class PebbleGame
{
	public static var cursorGrab(default, default):Bool = false;

	public static var pebbleList = new Array<PebbleDefinition>();
	public static var stats:PebbleStats = {
		mining: 0,
		working: 0,
		cooking: 0
	};
	public static var bestStats:PebbleStats = {
		mining: 0,
		working: 0,
		cooking: 0
	}

	public static function calculateStats()
	{
		stats.cooking = 0;
		stats.working = 0;
		stats.mining = 0;

		for (p in pebbleList)
		{
			switch (p.location)
			{
				case MINE:
					stats.mining += p.stats.mining;
				case KITCHEN:
					stats.cooking += p.stats.cooking;
				case OFFICE:
					stats.working += p.stats.working;
				case NONE:
			}
		}

		bestStats.cooking = FlxMath.maxInt(stats.cooking, bestStats.cooking);
		bestStats.working = FlxMath.maxInt(stats.working, bestStats.working);
		bestStats.mining = FlxMath.maxInt(stats.mining, bestStats.mining);
	}
}

typedef PebbleDefinition =
{
	var sprite:FlxSprite;
	var stats:PebbleStats;
	var location:PebbleLocation;
}

typedef PebbleStats =
{
	var mining:Int;
	var cooking:Int;
	var working:Int;
}

enum PebbleLocation
{
	NONE;
	MINE;
	KITCHEN;
	OFFICE;
}
