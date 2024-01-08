package creator;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

class PebbleComponent extends FlxTypedGroup<FlxSprite>
{
	private static inline var MIN_SIZE:Float = 40;

	public var sprite(default, null):FlxSprite;

	private var selected:Bool = false;
	private var pressPoint:FlxPoint = new FlxPoint();
	private var holdPoint:FlxPoint = new FlxPoint();

	private var mode:Mode = NONE;

	private var rotatePoint:FlxSprite;
	private var scalePoint:FlxSprite;
	private var lastAngle:Float = 0;

	public function new(asset:FlxGraphicAsset, x:Float, y:Float, colour:FlxColor)
	{
		super();
		sprite = new FlxSprite(0, 0, asset);
		sprite.x = x - sprite.width / 2;
		sprite.y = y - sprite.height / 2;
		setColour(colour);
		add(sprite);

		rotatePoint = new FlxSprite(AssetPaths.rotate__png);
		rotatePoint.visible = false;
		add(rotatePoint);

		scalePoint = new FlxSprite(AssetPaths.scale__png);
		scalePoint.visible = false;
		add(scalePoint);
	}

	public function setSelected(selected:Bool, mousePosition:FlxPoint)
	{
		this.selected = selected;
		if (!selected)
		{
			updateHandles();
			return;
		}

		holdPoint.copyFrom(mousePosition);

		if (rotatePoint.overlapsPoint(mousePosition))
		{
			holdPoint.subtract(sprite.x, sprite.y);
			holdPoint.subtract(sprite.origin.x, sprite.origin.y);
			lastAngle = sprite.angle;
			mode = ROTATE;
		}
		else if (scalePoint.overlapsPoint(mousePosition))
		{
			holdPoint.subtract(scalePoint.x, scalePoint.y);
			mode = SCALE;
		}
		else
		{
			if (mode == NONE)
			{
				FlxG.sound.play(AssetPaths.component_pick__ogg);
			}

			holdPoint.subtract(sprite.x, sprite.y);
			mode = MOVE;
		}

		updateHandles();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!selected)
		{
			return;
		}

		if (FlxG.mouse.pressed)
		{
			updateMode();
		}

		if (FlxG.mouse.justReleased)
		{
			if (mode == MOVE)
			{
				FlxG.sound.play(AssetPaths.component_place__ogg);
			}

			mode = NONE;
			updateHandles();
		}
	}

	private function updateMode()
	{
		FlxG.mouse.getPosition(pressPoint);

		if (mode == MOVE)
		{
			pressPoint.subtract(holdPoint.x, holdPoint.y);
			sprite.setPosition(pressPoint.x, pressPoint.y);
		}
		else if (mode == ROTATE)
		{
			var startHoldAngle = Math.atan2(holdPoint.y, holdPoint.x);
			pressPoint.subtract(sprite.x, sprite.y);
			pressPoint.subtract(sprite.origin.x, sprite.origin.y);
			var endHoldAngle = Math.atan2(pressPoint.y, pressPoint.x);
			sprite.angle = lastAngle + (180 / Math.PI) * (endHoldAngle - startHoldAngle);
		}
		else if (mode == SCALE)
		{
			pressPoint.subtract(sprite.x, sprite.y);
			pressPoint.subtract(holdPoint.x, holdPoint.y);

			sprite.flipX = pressPoint.x < 0;
			sprite.flipY = pressPoint.y < 0;

			sprite.setGraphicSize(Math.max(Math.abs(pressPoint.x), MIN_SIZE), Math.max(Math.abs(pressPoint.y), MIN_SIZE));
			sprite.updateHitbox();
			sprite.centerOrigin();
		}
	}

	private function updateHandles()
	{
		rotatePoint.x = sprite.x + sprite.width;
		rotatePoint.y = sprite.y - rotatePoint.height;
		rotatePoint.visible = selected && mode == NONE;

		scalePoint.x = sprite.x + sprite.width;
		scalePoint.y = sprite.y + sprite.height;
		scalePoint.visible = selected && mode == NONE;
	}

	public function overlapsPoint(point:FlxPoint):Bool
	{
		if (selected)
		{
			if (rotatePoint.overlapsPoint(point) || scalePoint.overlapsPoint(point))
			{
				return true;
			}
		}

		return sprite.pixelsOverlapPoint(point);
	}

	public function isWithin(workspace:FlxRect)
	{
		var sprRect = sprite.getScreenBounds();
		var intersect = sprRect.intersection(workspace);

		var inside = Math.abs(sprRect.width - intersect.width) < 5 && Math.abs(sprRect.height - intersect.height) < 5;

		FlxDestroyUtil.put(intersect);
		FlxDestroyUtil.put(sprRect);

		return inside;
	}

	public function setColour(c:FlxColor)
	{
		sprite.setColorTransform(c.redFloat, c.greenFloat, c.blueFloat);
	}
}

enum Mode
{
	NONE;
	MOVE;
	ROTATE;
	SCALE;
}
