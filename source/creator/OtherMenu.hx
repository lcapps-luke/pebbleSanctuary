package creator;

class OtherMenu extends ComponentMenu
{
	public function new(type:Data.ComponentType, back:Void->Void, forward:Void->Void, onAdd:Data.Component->Float->Float->Void, x:Float, width:Float)
	{
		super(getNameForType(type), back, forward, x, width);

		for (c in Data.component.all)
		{
			if (c.type != type)
			{
				continue;
			}

			var itm = new ComponentMenuItem(c.sprite, c.cost > PebbleGame.bestStats.working, c.cost, OFFICE);
			itm.callback = (x, y) -> onAdd(c, x, y);
			addMenuItem(itm);
		}
	}

	private static function getNameForType(t:Data.ComponentType):String
	{
		return switch (t)
		{
			case EYE: "Eyes";
			case MOUTH: "Mouth";
			default: "Other";
		}
	}
}
