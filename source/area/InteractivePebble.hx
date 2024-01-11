package area;

import flixel.FlxG;
import flixel.addons.nape.FlxNapeSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxDestroyUtil;
import nape.geom.AABB;
import nape.geom.MarchingSquares;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;

class InteractivePebble extends FlxNapeSprite
{
	private var jumpTimer:Float;

	public function new(x:Float, y:Float, spr:FlxGraphicAsset, scale:Float)
	{
		super(x, y, spr, false);

		var w = this.frameWidth * scale;
		var h = this.frameHeight * scale;

		this.setGraphicSize(w, h);
		updateHitbox();

		var b = new Body(BodyType.DYNAMIC, Vec2.weak(x, y));
		b.setShapeMaterials(new Material(0, 0.45, 0.6, 8, 0.5));
		var poly = MarchingSquares.run(iso, new AABB(0, 0, w, h), Vec2.weak(20, 20));
		poly.foreach(p ->
		{
			p.simplify(1.5).convexDecomposition(true).foreach(qp ->
			{
				b.shapes.add(new Polygon(qp));
				qp.dispose();
			});
			p.dispose();
		});
		var comOffset = b.localCOM.copy();
		b.align();
		comOffset = comOffset.sub(b.localCOM);

		this.addPremadeBody(b);

		if (b.shapes.empty())
		{
			createRectangularBody(w, h);
		}

		offset.set(0, 0);
		origin.x += (comOffset.x - w / 2) * (1 / scale);
		origin.y += (comOffset.y - h / 2) * (1 / scale);
		comOffset.dispose();

		jumpTimer = FlxG.random.float(1, 5);
	}

	override function update(elapsed:Float)
	{
		var constrained = false;
		this.body.constraints.foreach(c ->
		{
			constrained = constrained || c.active;
		});

		jumpTimer -= elapsed;
		if (jumpTimer < 0)
		{
			jumpTimer = FlxG.random.float(1, 5);

			if (!constrained && Math.abs(this.body.velocity.y) < 5)
			{
				var vec = FlxPoint.get();
				vec.setPolarDegrees(1500 * this.body.mass, FlxG.random.float(225, 315));
				this.body.applyImpulse(Vec2.weak(vec.x, vec.y));
				FlxDestroyUtil.put(vec);
			}
		}

		if (!constrained && Math.abs(this.body.velocity.y) < 20)
		{
			var ang = FlxAngle.wrapAngle(FlxAngle.asDegrees(body.rotation));

			if (Math.abs(ang) > 10)
			{
				var rdir = ang > 0 ? -1 : 1;
				body.angularVel += 1 * rdir;
			}
		}

		super.update(elapsed);
	}

	private function iso(x:Float, y:Float):Float
	{
		var point = FlxPoint.get();
		point.set(this.x + x, this.y + y);
		return this.getPixelAt(point).alpha > 0.5 ? -1 : 1;
	}
}
