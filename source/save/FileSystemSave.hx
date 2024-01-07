package save;

import PebbleGame.PebbleDefinition;
import PebbleGame.PebbleLocation;
import haxe.io.Path;
import lime.app.Future;
import lime.system.System;
import save.AbstractSave.PebbleReference;
import sys.FileSystem;
import sys.io.File;

class FileSystemSave extends AbstractSave
{
	private static inline var DIR_PEBBLES = "pebbles";

	function loadPebbleReferences():Array<PebbleReference>
	{
		var pebbleDir = Path.join([System.applicationStorageDirectory, DIR_PEBBLES]); // C:\Users\{name}\AppData\Roaming\LC-Apps\PebbleSanctuary\pebbles
		FileSystem.createDirectory(pebbleDir);

		var pebbleList = new Array<PebbleReference>();
		loadReferencesFromDir(pebbleDir, PebbleLocation.NONE, pebbleList);

		return pebbleList;
	}

	private function loadReferencesFromDir(dir:String, locationType:PebbleLocation, list:Array<PebbleReference>)
	{
		for (file in FileSystem.readDirectory(dir))
		{
			var path = Path.join([dir, file]);
			var isDir = FileSystem.isDirectory(path);

			if (isDir && locationType == NONE)
			{
				var dirLocation = switch (file)
				{
					case "mine": PebbleLocation.MINE;
					case "kitchen": PebbleLocation.KITCHEN;
					case "office": PebbleLocation.OFFICE;
					default: null;
				}

				if (dirLocation != null)
				{
					loadReferencesFromDir(path, dirLocation, list);
				}
			}

			var ext = Path.extension(path);
			if (!isDir && ext.toLowerCase() == "png")
			{
				list.push({
					id: Path.withoutExtension(file),
					location: locationType
				});
			}
		}
	}

	function savePebble(p:PebbleDefinition)
	{
		var filePath = Path.join([
			System.applicationStorageDirectory,
			DIR_PEBBLES,
			getPathForLocation(p.location),
			'${p.id}.png'
		]);
		FileSystem.createDirectory(Path.directory(filePath));
		var output = File.write(filePath);
		this.writePngData(p, output);
		output.close();
	}

	function movePebble(p:PebbleDefinition, from:PebbleLocation)
	{
		var fromPath = Path.join([
			System.applicationStorageDirectory,
			DIR_PEBBLES,
			getPathForLocation(from),
			'${p.id}.png'
		]);
		var toPath = Path.join([
			System.applicationStorageDirectory,
			DIR_PEBBLES,
			getPathForLocation(p.location),
			'${p.id}.png'
		]);

		FileSystem.createDirectory(Path.directory(toPath));
		FileSystem.rename(fromPath, toPath);
	}

	function deletePebble(p:PebbleReference)
	{
		var fromPath = Path.join([
			System.applicationStorageDirectory,
			DIR_PEBBLES,
			getPathForLocation(p.location),
			'${p.id}.png'
		]);
		var toPath = Path.join([System.applicationStorageDirectory, DIR_PEBBLES, 'released/${p.id}.png']);
		FileSystem.createDirectory(Path.directory(toPath));
		FileSystem.rename(fromPath, toPath);
	}

	private function getPathForLocation(l:PebbleLocation):String
	{
		return switch (l)
		{
			case NONE:
				"";
			case MINE:
				"mine";
			case KITCHEN:
				"kitchen";
			case OFFICE:
				"office";
		}
	}

	function loadPebble(p:PebbleReference):Future<PebbleDefinition>
	{
		var filePath = Path.join([
			System.applicationStorageDirectory,
			DIR_PEBBLES,
			getPathForLocation(p.location),
			'${p.id}.png'
		]);
		var input = File.read(filePath);
		var pngData = this.readPngData(input);
		input.close();

		return pngData.sprite.then(spr ->
		{
			input.close();

			return Future.withValue({
				id: p.id,
				location: p.location,
				stats: pngData.stats,
				sprite: spr
			});
		});
	}
}
