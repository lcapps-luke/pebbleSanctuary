package;

import area.KitchenAreaState;
import area.MineAreaState;
import area.OfficeAreaState;
import creator.PebbleCreatorState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import ui.Button;

class MainState extends FlxState
{
	override public function create()
	{
		this.bgColor = FlxColor.BLACK;
		super.create();

		var createButton = new Button("Create Pebble", true, onCreatePebble);
		createButton.x = FlxG.width - createButton.width - 50;
		createButton.y = 50;
		add(createButton);

		var mineButton = new Button("Mine", true, onGotoMine);
		mineButton.x = FlxG.width * 0.75 - mineButton.width / 2;
		mineButton.y = FlxG.height * 0.8;
		add(mineButton);

		var kitchenButton = new Button("Kitchen", true, onGotoKitchen);
		kitchenButton.x = FlxG.width * 0.5 - kitchenButton.width / 2;
		kitchenButton.y = FlxG.height * 0.8;
		add(kitchenButton);

		var officeButton = new Button("Office", true, onGotoOffice);
		officeButton.x = FlxG.width * 0.25 - officeButton.width / 2;
		officeButton.y = FlxG.height * 0.8;
		add(officeButton);
	}

	private function onCreatePebble()
	{
		FlxG.switchState(new PebbleCreatorState());
	}

	private function onGotoMine()
	{
		FlxG.switchState(new MineAreaState());
	}

	private function onGotoKitchen()
	{
		FlxG.switchState(new KitchenAreaState());
	}

	private function onGotoOffice()
	{
		FlxG.switchState(new OfficeAreaState());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
