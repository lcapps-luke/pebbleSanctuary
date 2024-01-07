package save;

import PebbleGame.PebbleDefinition;
import PebbleGame.PebbleLocation;
import PebbleGame.PebbleStats;
import flixel.FlxSprite;
import format.png.Data;
import format.png.Reader;
import format.png.Writer;
import haxe.Json;
import haxe.exceptions.ArgumentException;
import haxe.exceptions.NotImplementedException;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Input;
import haxe.io.Output;
import lime.app.Future;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.geom.Rectangle;

abstract class AbstractSave
{
	private static inline var SAVE_VERSION = 1;
	private static inline var PNG_CHUNK_ID = "peBl";

	public function new() {}

	public function saveGame(pebbles:Array<PebbleDefinition>)
	{
		var current = loadPebbleReferences();

		for (p in pebbles)
		{
			var currentPebble = current.filter(r -> r.id == p.id).pop();
			if (currentPebble == null)
			{
				savePebble(p);
			}
			else if (currentPebble.location != p.location)
			{
				movePebble(p, currentPebble.location);
			}
		}

		var newIds = pebbles.map(p -> p.id);
		for (c in current)
		{
			if (!newIds.contains(c.id))
			{
				deletePebble(c);
			}
		}

		endSave();
	}

	public function loadGame():Future<Array<PebbleDefinition>>
	{
		var pebbleRefs = loadPebbleReferences();

		if (pebbleRefs.length == 0)
		{
			return Future.withValue([]);
		}

		var res = new Array<PebbleDefinition>();
		var last:Future<PebbleDefinition> = null;

		for (r in pebbleRefs)
		{
			if (last == null)
			{
				last = loadPebble(r);
			}
			else
			{
				last = last.then(p ->
				{
					res.push(p);
					return loadPebble(r);
				});
			}
		}

		return last.then(p ->
		{
			res.push(p);
			return Future.withValue(res);
		});
	};

	private function writePngData(p:PebbleDefinition, output:Output)
	{
		var bitmapData = p.sprite.graphic.bitmap;

		var rect = new Rectangle(0, 0, bitmapData.width, bitmapData.height);
		var bytes = bitmapData.encode(rect, new PNGEncoderOptions());

		var reader = new Reader(new BytesInput(bytes));
		var pngData = reader.read();
		pngData.remove(CEnd);

		var pebbleData:PebbleSaveData = {
			saveVersion: SAVE_VERSION,
			stats: p.stats
		};

		var pebbleDataBytes = Bytes.ofString(Json.stringify(pebbleData), UTF8);
		pngData.add(CUnknown(PNG_CHUNK_ID, pebbleDataBytes));
		pngData.add(CEnd);

		var writer = new Writer(output);
		writer.write(pngData);
	}

	private function readPngData(input:Input):PebbleLoadData
	{
		var pngBytes = input.readAll();
		var bitmapData = BitmapData.loadFromBytes(pngBytes);
		var sprite = bitmapData.then(bd -> Future.withValue(new FlxSprite(0, 0, bd)));

		var reader = new Reader(new BytesInput(pngBytes));
		var pngData = reader.read();
		var pebbleData:PebbleSaveData = null;
		for (chunk in pngData)
		{
			switch (chunk)
			{
				case CUnknown(PNG_CHUNK_ID, data):
					var json = data.getString(0, data.length, UTF8);
					pebbleData = Json.parse(json);
				default:
			}
		}

		if (pebbleData == null)
		{
			// throw new ArgumentException("input", 'PNG is missing "$PNG_CHUNK_ID" chunk');
		}

		return {
			sprite: sprite,
			stats: pebbleData.stats
		};
	}

	abstract private function loadPebbleReferences():Array<PebbleReference>;

	abstract private function savePebble(p:PebbleDefinition):Void;

	abstract private function loadPebble(p:PebbleReference):Future<PebbleDefinition>;

	abstract private function movePebble(p:PebbleDefinition, from:PebbleLocation):Void;

	abstract private function deletePebble(p:PebbleReference):Void;

	private function endSave() {}
}

typedef PebbleReference =
{
	var id:String;
	var location:PebbleLocation;
}

typedef PebbleSaveData =
{
	var saveVersion:Int;
	var stats:PebbleStats;
}

typedef PebbleLoadData =
{
	var sprite:Future<FlxSprite>;
	var stats:PebbleStats;
}
