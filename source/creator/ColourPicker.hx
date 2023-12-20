package creator;

import flixel.FlxBasic;
import flixel.addons.ui.FlxSlider;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;

class ColorPicker extends FlxTypedGroup<FlxBasic>
{
	public var colour(get, set):FlxColor;

	@:keep
	private var colorHue:Float;
	@:keep
	private var colorSat:Float;
	@:keep
	private var colorBri:Float;

	private var hue:FlxSlider;
	private var sat:FlxSlider;
	private var bri:FlxSlider;

	public function new(initial:FlxColor, x:Float, y:Float, width:Float, height:Float)
	{
		super();

		var sliderHeight = Math.round(height / 4);
		var sliderOffset = Math.round(height / 3);

		colorHue = initial.hue;
		colorSat = initial.saturation;
		colorBri = initial.brightness;

		hue = new FlxSlider(this, "colorHue", x, y, 0, 360, Math.round(width), sliderHeight, 3, 0xFFFF0000, FlxColor.WHITE);
		hideLabels(hue);

		var chunk = hue.body.width / 360;
		for (h in 0...360)
		{
			FlxSpriteUtil.drawRect(hue.body, Math.floor(chunk * h), 0, Math.ceil(chunk), hue.body.height, FlxColor.fromHSB(h, 1, 1));
		}

		hue.callback = v ->
		{
			updateHandle(hue, FlxColor.fromHSB(colorHue, 1, 1));
			updateSat();
			updateBri();
		};

		add(hue);

		sat = new FlxSlider(this, "colorSat", x, y + sliderOffset, 0.0, 1.0, Math.round(width), sliderHeight, 3, 0xFF00FF00, FlxColor.WHITE);
		hideLabels(sat);
		updateSat();

		sat.callback = v ->
		{
			updateBri();
			updateHandle(sat, get_colour());
		};

		add(sat);

		bri = new FlxSlider(this, "colorBri", x, y + sliderOffset * 2, 0.0, 1.0, Math.round(width), sliderHeight, 3, 0xFF0000FF, FlxColor.WHITE);
		hideLabels(bri);
		updateBri();

		bri.callback = v ->
		{
			updateSat();
			updateHandle(bri, get_colour());
		};

		add(bri);
	}

	private inline function hideLabels(s:FlxSlider)
	{
		s.maxLabel.visible = false;
		s.minLabel.visible = false;
		s.nameLabel.visible = false;
		s.valueLabel.visible = false;
	}

	private function updateSat()
	{
		var from = FlxColor.fromHSB(Math.round(colorHue), 0, colorBri);
		var to = FlxColor.fromHSB(Math.round(colorHue), 1, colorBri);

		FlxGradient.overlayGradientOnFlxSprite(sat.body, Math.round(sat.body.width), Math.round(sat.body.height), [from, to], 0, 0, 1, 0);
		updateHandle(sat, get_colour());
	}

	private function updateBri()
	{
		var from = FlxColor.fromHSB(Math.round(colorHue), colorSat, 0);
		var to = FlxColor.fromHSB(Math.round(colorHue), colorSat, 1);

		FlxGradient.overlayGradientOnFlxSprite(bri.body, Math.round(bri.body.width), Math.round(bri.body.height), [from, to], 0, 0, 1, 0);
		updateHandle(bri, get_colour());
	}

	private function updateHandle(s:FlxSlider, selected:FlxColor)
	{
		var hCol = selected.getInverted();
		s.handle.setColorTransform(hCol.redFloat, hCol.greenFloat, hCol.blueFloat);
	}

	private function set_colour(value:FlxColor):FlxColor
	{
		colorHue = value.hue;
		colorSat = value.saturation;
		colorBri = value.brightness;

		updateHandle(hue, FlxColor.fromHSB(colorHue, 1, 1));
		updateSat();
		updateBri();

		return value;
	}

	private function get_colour():FlxColor
	{
		return FlxColor.fromHSB(colorHue, colorSat, colorBri);
	}
}
