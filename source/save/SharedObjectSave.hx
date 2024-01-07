package save;

import PebbleGame.PebbleDefinition;
import PebbleGame.PebbleLocation;
import flixel.FlxG;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import lime.app.Future;
import save.AbstractSave.PebbleReference;

class SharedObjectSave extends AbstractSave
{
	function loadPebbleReferences():Array<PebbleReference>
	{
		return getPebbleReferenceList().copy();
	}

	function savePebble(p:PebbleDefinition)
	{
		var refList = getPebbleReferenceList();
		refList.push({
			id: p.id,
			location: p.location
		});

		var pebbleMap = getPebbleMap();

		var out = new BytesOutput();
		this.writePngData(p, out);
		trace(Base64.encode(out.getBytes()));
		pebbleMap.set(p.id, Base64.encode(out.getBytes()));
	}

	function loadPebble(p:PebbleReference):Future<PebbleDefinition>
	{
		var pebbleMap = getPebbleMap();

		var input = new BytesInput(Base64.decode(pebbleMap.get(p.id)));
		var pngData = this.readPngData(input);

		return pngData.sprite.then(spr -> Future.withValue({
			id: p.id,
			location: p.location,
			stats: pngData.stats,
			sprite: spr
		}));
	}

	function movePebble(p:PebbleDefinition, from:PebbleLocation)
	{
		var refList = getPebbleReferenceList();
		refList.filter(r -> r.id == p.id)[0].location = p.location;
	}

	function deletePebble(p:PebbleReference)
	{
		var refList = getPebbleReferenceList();
		var ref = refList.filter(r -> r.id == p.id)[0];
		refList.remove(ref);

		getPebbleMap().remove(p.id);
	}

	override function endSave()
	{
		super.endSave();
		FlxG.save.flush();
	}

	private function getPebbleReferenceList():Array<PebbleReference>
	{
		var refList:Array<PebbleReference> = FlxG.save.data.pebbleLocation;
		if (refList == null)
		{
			refList = new Array<PebbleDefinition>();
			FlxG.save.data.pebbleLocation = refList;
		}
		return refList;
	}

	private function getPebbleMap():Map<String, String>
	{
		var pebbleMap:Map<String, String> = FlxG.save.data.pebbles;
		if (pebbleMap == null)
		{
			pebbleMap = new Map<String, String>();
			FlxG.save.data.pebbles = pebbleMap;
		}

		return pebbleMap;
	}
}
