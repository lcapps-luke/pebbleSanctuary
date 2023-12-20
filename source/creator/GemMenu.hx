package creator;

class GemMenu extends ComponentMenu
{
	public function new(back:Void->Void, forward:Void->Void, onAdd:Data.Gem->Float->Float->Void, x:Float, width:Float)
	{
		super("Gem", back, forward, x, width);
		columns = 2;

		for (g in Data.gem.all)
		{
			var itm = new ComponentMenuItem(g.sprite, g.cost > PebbleGame.bestStats.mining, g.cost, MINE, 170);
			itm.setStats(g.working, g.cooking, g.mining);
			itm.callback = (x, y) -> onAdd(g, x, y);
			addMenuItem(itm);
		}
	}
}
