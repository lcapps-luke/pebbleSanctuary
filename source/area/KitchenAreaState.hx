package area;

class KitchenAreaState extends AbstractAreaState
{
	public function new()
	{
		super(KITCHEN);
	}

	public function getAreaPoints():Int
	{
		return PebbleGame.stats.cooking;
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
}
