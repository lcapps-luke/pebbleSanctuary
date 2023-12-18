package creator;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxDestroyUtil;

class PebbleComponent extends FlxTypedGroup<FlxSprite>
{
	public var sprite(default, null):FlxSprite;

	private var selected:Bool = false;
	private var pressPoint:FlxPoint = new FlxPoint();
	private var holdPoint:FlxPoint = new FlxPoint();

	public function new(asset:FlxGraphicAsset, x:Float, y:Float)
	{
		super();
		sprite = new FlxSprite(0, 0, asset);
		sprite.setColorTransform(FlxG.random.float(0.5, 1), FlxG.random.float(0.5, 1), FlxG.random.float(0.5, 1));
		sprite.x = x - sprite.width / 2;
		sprite.y = y - sprite.height / 2;
		add(sprite);
	}

	public function setSelected(selected:Bool, holdX:Float, holdY:Float)
	{
		this.selected = selected;
		holdPoint.set(holdX, holdY);
		holdPoint.subtract(sprite.x, sprite.y);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.pressed && selected)
		{
			FlxG.mouse.getPosition(pressPoint);
			pressPoint.subtract(holdPoint.x, holdPoint.y);
			sprite.setPosition(pressPoint.x, pressPoint.y);
		}
	}

	public function overlapsPoint(point:FlxPoint)
	{
		return sprite.pixelsOverlapPoint(point);
	}

	public function isWithin(workspace:FlxRect)
	{
		var sprRect = sprite.getScreenBounds();
		var intersect = sprRect.intersection(workspace);

		var inside = intersect.width == sprRect.width && intersect.height == sprRect.height;

		FlxDestroyUtil.put(intersect);
		FlxDestroyUtil.put(sprRect);

		return inside;
	}
}
