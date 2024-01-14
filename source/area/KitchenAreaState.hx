package area;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSpace;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;

class KitchenAreaState extends AbstractAreaState
{
	private var walls:Body = null;

	public function new()
	{
		super(KITCHEN);
	}

	public function getAreaPoints():Int
	{
		return PebbleGame.stats.cooking;
	}

	public function getAreaMaxPoints():Int
	{
		return PebbleGame.bestStats.cooking;
	}

	public function getUnlockQueue():Array<Int>
	{
		return PebbleGame.getUnlockQueueForLocation(KITCHEN);
	}

	public function getTitleText(current:Int, next:Int):String
	{
		if (next > 0)
		{
			return 'Cooking points: $current (next unlock at $next)';
		}
		return 'Cooking points: $current';
	}

	function createBackgroundSprites()
	{
		backFar = new FlxSprite(AssetPaths.cafe_bg_1__png);
		backFar.y = 255;

		backMid = new FlxSprite(AssetPaths.cafe_bg_2__png);

		backFor = new FlxSprite(AssetPaths.cafe_bg_3__png);
		backFor.y = FlxG.height - backFor.height;
	}

	private function createWalls(group:FlxTypedGroup<FlxBasic>):Float
	{
		walls = new Body(BodyType.STATIC);
		walls.shapes.add(new Polygon(Polygon.rect(1358, 622, 160, 270)));
		walls.shapes.add(new Polygon(Polygon.rect(1520, 711, 100, 180)));
		walls.space = FlxNapeSpace.space;
		walls.setShapeMaterials(Material.wood());
		walls.cbTypes.add(AbstractAreaState.WALL_TYPE);

		return FlxG.height - 190;
	}

	override function destroy()
	{
		super.destroy();
		if (walls != null)
		{
			walls.space = null;
		}
	}
}
