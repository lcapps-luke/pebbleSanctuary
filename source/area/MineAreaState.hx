package area;

class MineAreaState extends AbstractAreaState
{
	public function new()
	{
		super(MINE);
	}

	public function getAreaPoints():Int
	{
		return PebbleGame.stats.mining;
	}

	public function getUnlockQueue():Array<Int>
	{
		return PebbleGame.getUnlockQueueForLocation(MINE);
	}

	public function getTitleText(current:Int, next:Int):String
	{
		if (next > 0)
		{
			return 'Mining points: $current (next unlock at $next)';
		}
		return 'Mining points: $current';
	}
}
