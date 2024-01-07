package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Future;
import save.AbstractSave;
#if desktop
import save.FileSystemSave;
#end
#if !desktop
import save.SharedObjectSave;
#end

class PebbleGame
{
	#if desktop
	private static var saveSys:AbstractSave = new FileSystemSave();
	#end
	#if !desktop
	private static var saveSys:AbstractSave = new SharedObjectSave();
	#end

	private static var loaded:Bool = false;

	public static var cursorGrab(default, default):Bool = false;

	public static var pebbleSlots:Int = 2;
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

		pebbleSlots = 2;
		for (i in getUnlockQueueForLocation(KITCHEN))
		{
			if (i <= bestStats.cooking)
			{
				pebbleSlots++;
			}
		}
	}

	public static function getUnlockQueueForLocation(locationType:PebbleLocation):Array<Int>
	{
		var list = switch (locationType)
		{
			case MINE:
				Data.gem.all.map(g -> g.cost); // gem type unlocks
			case KITCHEN:
				[2, 4, 6, 8, 10]; // pebble slot unlocks
			case OFFICE:
				Data.component.all.map(c -> c.cost); // pebble creator unlocks
			case NONE:
				[];
		}
		list.sort((a, b) -> a - b);
		return list;
	}

	public static function getUnlockItem(locationType:PebbleLocation, cost:Int):FlxSprite
	{
		return switch (locationType)
		{
			case MINE:
				new FlxSprite(Data.gem.all.filter(g -> g.cost == cost)[0].sprite);
			case KITCHEN:
				makeText("New Pebble Slot!");
			case OFFICE:
				new FlxSprite(Data.component.all.filter(g -> g.cost == cost)[0].sprite);
			case NONE:
				null;
		}
	}

	private static function makeText(s:String)
	{
		var t = new FlxText(0, 0, 0, s);
		t.setFormat(AssetPaths.Schoolbell__ttf, 80, FlxColor.BLACK, CENTER);
		return t;
	}

	public static function getIconForLocation(loc:PebbleLocation):FlxGraphicAsset
	{
		return switch (loc)
		{
			case MINE: AssetPaths.icon_mine__png;
			case KITCHEN: AssetPaths.icon_kitchen__png;
			case OFFICE: AssetPaths.icon_office__png;
			default: null;
		}
	}

	public static function load():Future<Bool>
	{
		if (!loaded)
		{
			return saveSys.loadGame().then(p ->
			{
				pebbleList = p.pebbles;
				bestStats = p.maxStats;
				calculateStats();

				loaded = true;
				return Future.withValue(true);
			});
		}

		return Future.withValue(false);
	}

	public static function save()
	{
		saveSys.saveGame({
			pebbles: pebbleList,
			maxStats: bestStats
		});
	}
}

typedef PebbleDefinition =
{
	var id:String;
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
