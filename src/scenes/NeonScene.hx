package scenes;

import milkshake.assets.SpriteSheets;
import milkshake.components.input.Input;
import milkshake.components.input.Key;
import milkshake.core.DisplayObject;
import milkshake.core.Graphics;
import milkshake.core.Sprite;
import milkshake.game.scene.camera.CameraPresets;
import milkshake.game.scene.Scene;
import milkshake.math.Vector2;
import milkshake.utils.Color;
import milkshake.utils.Globals;
import motion.easing.Elastic;
import motion.easing.Sine;
import pixi.core.textures.Texture;
import scenes.gameobjects.Player;

using milkshake.utils.TweenUtils;

class NeonScene extends Scene
{
	public static inline var MODE_RED:String = "red";
	public static inline var MODE_BLUE:String = "blue";

	public static inline var RED:Int = 0xFF0000;
	public static inline var BLUE:Int = 0x0099FF;

	var redPillars:Array<DisplayObject>;
	var bluePillars:Array<DisplayObject>;
	var graphics(default, null):pixi.core.graphics.Graphics;
	var bottomGraphics(default, null):pixi.core.graphics.Graphics;

	var verticalGridOffset:Float = 0;
	var verticalGridGap:Float;
	var speed:Float = 5;

	var mode:String = MODE_RED;

	var input:Input;

	public function new()
	{
		super("NeonScene", [  ], CameraPresets.DEFAULT, Color.BLUE);

		input = new Input();
	}

	override public function create():Void
	{
		super.create();

		displayObject.addChild(graphics = new pixi.core.graphics.Graphics());

		redPillars = [];
		bluePillars = [];

		createPillars();

		addNode(new Player(), {
			position: new Vector2(400, 0)
		});

		displayObject.addChild(bottomGraphics = new pixi.core.graphics.Graphics());

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

		bottomGraphics.beginFill(mode == MODE_RED ? RED : BLUE);
		bottomGraphics.drawRect(0, Globals.SCREEN_HEIGHT - 30, Globals.SCREEN_WIDTH, 30);
	}

	function createPillars()
	{
		for (i in 0 ... 10) {
			var height:Float = 200 + (Math.random() * 200);
			var x = i * 600;//(Math.random() * 3000);

			var pillar = generatePillar(height, 0xFF0000);

			addNode(pillar, {
				position: new Vector2(x, Globals.SCREEN_HEIGHT - height)
			});

			redPillars.push(pillar);
		}

		for (i in 0 ... 10) {
			var height:Float = 200 + (Math.random() * 200);
			var x = 300 + (i * 600);//(Math.random() * 3000);

			var pillar = generatePillar(height, 0x0099FF);

			addNode(pillar, {
				position: new Vector2(x, Globals.SCREEN_HEIGHT - height)
			});

			bluePillars.push(pillar);
		}
	}

	function generatePillar(height:Float, color:Int):milkshake.core.DisplayObject
	{
		var displayObject = new Graphics();
		displayObject.graphics.beginFill(0, 0.8);
		displayObject.graphics.lineStyle(2, color);
		displayObject.graphics.drawRect(0, 0, 200, height);

		return displayObject;
	}

	function updateGrid()
	{
		drawGrid(mode == MODE_RED ? RED : BLUE);

		verticalGridOffset += speed;

		if(verticalGridOffset > verticalGridGap) {
			verticalGridOffset = 0;
		}
	}

	function updatePillars()
	{
		var pillars = redPillars.concat(bluePillars);

		for(pillar in pillars) {
			pillar.x -= speed;
			if(pillar.x < -200) pillar.x = 10 * 600;
		}
	}

	override public function update(deltaTime:Float):Void
	{
		updateGrid();
		updatePillars();

		if(input.isDown(Key.SHIFT))
		{
			mode = mode == MODE_RED ? MODE_BLUE : MODE_RED;
		}

		super.update(deltaTime);
	}
}
