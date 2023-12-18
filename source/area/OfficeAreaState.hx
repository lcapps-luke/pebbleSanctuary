package area;

class OfficeAreaState extends AbstractAreaState
{
	public function new()
	{
		super(OFFICE);
	}

	public function getAreaPoints():Int
	{
		return PebbleGame.stats.working;
	}

	public function getUnlockQueue():Array<Int>
	{
		return PebbleGame.getUnlockQueueForLocation(OFFICE);
	}

	public function getTitleText(current:Int, next:Int):String
	{
		if (next > 0)
		{
			return 'Working points: $current (next unlock at $next)';
		}
		return 'Working points: $current';
	}
}
