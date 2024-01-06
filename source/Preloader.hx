package;

import flixel.system.FlxAssets;
import flixel.system.FlxBasePreloader;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.GradientType;
import openfl.display.InterpolationMethod;
import openfl.display.Shape;
import openfl.display.SpreadMethod;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.text.TextFormat;

@:keep @:bitmap("gem-mask.png")
private class GemMask extends BitmapData {}

class Preloader extends FlxBasePreloader
{
	private static inline var BG_COLOUR_1 = 0x7F5EFB;
	private static inline var BG_COLOUR_2 = 0xFD60E2;
	private static inline var BODY_COLOUR = 0xCBBFD2;

	private var buffer:Sprite;
	private var bg:Shape;
	private var body:Shape;
	private var gemMask:Bitmap;
	private var barBack:Shape;
	private var barFront:Shape;
	private var eyeLeft:PreloaderEye;
	private var eyeRight:PreloaderEye;
	private var text:TextField;

	private var barStartY:Float = 0;
	private var barHeight:Float = 100;

	override public function new()
	{
		super(2);
	}

	override function create()
	{
		var width = Lib.current.stage.stageWidth;
		var height = Lib.current.stage.stageHeight;

		buffer = new Sprite();
		addChild(buffer);

		var matrix = new Matrix();
		matrix.createGradientBox(width, height, (Math.PI / 180) * 105, 0, 0);

		bg = new Shape();
		bg.graphics.beginGradientFill(GradientType.LINEAR, [BG_COLOUR_1, BG_COLOUR_2], [1, 1], [0, 255], matrix, SpreadMethod.PAD,
			InterpolationMethod.LINEAR_RGB, 0);
		bg.graphics.drawRect(0, 0, width, height);
		buffer.addChild(bg);

		body = new Shape();
		body.graphics.lineStyle(20, 0x000000);
		body.graphics.beginFill(BODY_COLOUR);
		body.graphics.drawEllipse(0, 0, width - 64, height * 1.5);
		body.graphics.endFill();
		body.x = 32;
		body.y = height / 4;
		buffer.addChild(body);

		barBack = new Shape();
		barBack.graphics.beginFill(0xFFFFFF);
		barBack.graphics.drawRect(0, 0, 1, 1);
		barBack.graphics.endFill();
		buffer.addChild(barBack);

		barFront = new Shape();
		barFront.graphics.beginFill(BG_COLOUR_1);
		barFront.graphics.drawRect(0, 0, 1, 1);
		barFront.graphics.endFill();
		barFront.scaleY = 0;
		buffer.addChild(barFront);

		gemMask = createBitmap(GemMask, function(bmp:Bitmap)
		{
			bmp.x = width / 2 - bmp.width / 2;
			bmp.y = height / 2 - bmp.height / 2;

			barBack.x = bmp.x + 5;
			barBack.y = bmp.y + 5;
			barBack.scaleX = bmp.width - 10;
			barBack.scaleY = bmp.height - 10;

			barFront.x = bmp.x + 5;
			barStartY = bmp.y + bmp.height - 20;
			barFront.y = barStartY;
			barFront.scaleX = bmp.width - 10;
			barHeight = bmp.height - 40;
		});
		buffer.addChild(gemMask);

		eyeLeft = new PreloaderEye(width / 5.5);
		eyeLeft.x = width / 2 - eyeLeft.width * 0.7;
		eyeLeft.y = height - eyeLeft.height * 0.2;
		buffer.addChild(eyeLeft);

		eyeRight = new PreloaderEye(width / 5.5);
		eyeRight.x = width / 2 + eyeRight.width * 0.7;
		eyeRight.y = height - eyeRight.height * 0.2;
		buffer.addChild(eyeRight);

		var textHeight = Math.round(height * 0.1);
		text = new TextField();
		text.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEFAULT, textHeight, 0xffffff, true, false, false, null, null, CENTER);
		text.embedFonts = true;
		text.selectable = false;
		text.multiline = false;
		text.y = textHeight / 2;
		text.width = width;
		text.text = "Loading...";
		buffer.addChild(text);

		super.create();
	}

	override function destroy()
	{
		if (buffer != null)
		{
			removeChild(buffer);
		}
		buffer = null;
		bg = null;
		body = null;
		barBack = null;
		barFront = null;
		gemMask = null;
		text = null;

		eyeLeft.destroy();
		eyeRight.destroy();
		eyeLeft = null;
		eyeRight = null;

		super.destroy();
	}

	override function update(percent:Float)
	{
		barFront.scaleY = barHeight * percent;
		barFront.y = barStartY - barHeight * percent;

		eyeLeft.update();
		eyeRight.update();
	}
}

private class PreloaderEye extends Sprite
{
	private var back:Shape;
	private var front:Shape;
	private var lookDist:Float;

	override public function new(s:Float)
	{
		super();

		back = new Shape();
		back.graphics.lineStyle(15, 0x000000);
		back.graphics.beginFill(0xFFFFFF);
		back.graphics.drawCircle(0, 0, s / 2);
		back.graphics.endFill();
		addChild(back);

		front = new Shape();
		front.graphics.beginFill(0x000000);
		front.graphics.drawCircle(0, 0, s * 0.3);
		front.graphics.endFill();
		addChild(front);

		lookDist = s * 0.2;
	}

	public function update()
	{
		var dx = Lib.current.stage.mouseX - this.x;
		var dy = Lib.current.stage.mouseY - this.y;

		var dir = Math.atan2(dy, dx);

		front.x = Math.cos(dir) * lookDist;
		front.y = Math.sin(dir) * lookDist;
	}

	public function destroy()
	{
		removeChild(back);
		removeChild(front);
		back = null;
		front = null;
	}
}
