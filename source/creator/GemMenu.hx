package creator;

class GemMenu extends ComponentMenu
{
	public function new(back:Void->Void, forward:Void->Void, onAdd:Data.Gem->Float->Float->Void)
	{
		super("Gem", back, forward);

		for (g in Data.gem.all)
		{
			var itm = new ComponentMenuItem(g.sprite, g.cost <= PebbleGame.bestStats.mining, g.cost, MINE);
			itm.callback = (x, y) -> onAdd(g, x, y);
			addMenuItem(itm);
		}
	}
}
