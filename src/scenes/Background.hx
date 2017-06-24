package scenes;

import pixi.core.math.shapes.Rectangle;
import milkshake.utils.Globals;
import pixi.core.graphics.Graphics;
import milkshake.math.Vector2;
import milkshake.core.Sprite;
import milkshake.game.scene.camera.CameraPresets;
import milkshake.game.scene.Scene;
import milkshake.utils.Color;
import pixi.core.textures.Texture;

using milkshake.utils.TweenUtils;

class Background extends Scene
{
	var bgImage:Sprite;
	var graphics(default, null):pixi.core.graphics.Graphics;

	var verticalGridOffset:Float = 0;
	var verticalGridGap:Float;
	var speed:Float = 5;

	public function new()
	{
		super("Background", [ "assets/images/bg.png" ], CameraPresets.DEFAULT, Color.BLUE);
	}

	override public function create():Void
	{
		super.create();

//		addNode(new Sprite(Texture.fromImage("assets/images/bg.png")),
//		{
//			scale: Vector2.EQUAL(1.25)
//		});

		addNode(new scenes.gameobjects.Player(), {
			position: new Vector2(400, 0)
		});

		displayObject.addChild(graphics = new pixi.core.graphics.Graphics());

		this.displayObject.filters = [
			new filters.CRTFilter()
		];
	}

	private function drawGrid(color = Color.RED, rows:Int = 25, columns:Int = 20):Void
	{
		var rows = 25;
		var columns = 20;

		verticalGridGap = Globals.SCREEN_WIDTH / columns * 2;

		graphics.clear();

		graphics.lineStyle(1, color);
		graphics.moveTo(0, 0);

		//Top Horizontal Lines
		for (i in 0...rows) {
			var distortion = i * -i * 1 / 2 + 200;

			graphics.moveTo(0, i + distortion);
			graphics.lineTo(Globals.SCREEN_WIDTH, i + distortion);
		}

		//Bottom Horizontal Lines
		for (i in 0...rows) {
			var distortion = i * i * 1 / 2 + Globals.SCREEN_HEIGHT / 1.5;

			graphics.moveTo(0, i + distortion);
			graphics.lineTo(Globals.SCREEN_WIDTH, i + distortion);
		}

		// Top Vertical Lines
		for (i in 0...columns) {
			var offset = Globals.SCREEN_WIDTH / columns;

			graphics.moveTo(-Globals.SCREEN_WIDTH / 2 + i * verticalGridGap - verticalGridOffset, 0);
			graphics.lineTo(i * offset - verticalGridOffset / 2, 200);
		}

		// Bottom Vertical Lines
		for (i in 0...columns) {
			var offset = Globals.SCREEN_WIDTH / columns;

			graphics.moveTo(i * offset - verticalGridOffset / 2, Globals.SCREEN_HEIGHT / 1.5);
			graphics.lineTo(-Globals.SCREEN_WIDTH / 2 + i * verticalGridGap - verticalGridOffset, Globals.SCREEN_HEIGHT);
		}
	}

	override public function update(deltaTime:Float):Void
	{
		drawGrid();

		verticalGridOffset += speed;

		if(verticalGridOffset > verticalGridGap) {
			verticalGridOffset = 0;
		}

		super.update(deltaTime);
	}
}
