package scenes;

import milkshake.core.DisplayObject;
import milkshake.utils.Color;
import differ.Collision;
import milkshake.components.input.Input;
import milkshake.components.input.Key;
import milkshake.game.scene.camera.CameraPresets;
import milkshake.game.scene.Scene;
import milkshake.math.Vector2;
import milkshake.Milkshake;
import milkshake.utils.Globals;
import milkshake.utils.TweenUtils;
import motion.actuators.IGenericActuator;
import motion.easing.Sine;
import scenes.gameobjects.GhostPlayer;
import scenes.gameobjects.Pillar;
import scenes.gameobjects.Player;

using milkshake.utils.TweenUtils;

class TitleScene extends Scene
{
	var redPillars:Array<Pillar>;
	var bluePillars:Array<Pillar>;
	var pillarContainer:DisplayObject;

	var graphics(default, null):pixi.core.graphics.Graphics;
	var bottomGraphics(default, null):pixi.core.graphics.Graphics;

	var verticalGridOffset:Float = 0;
	var verticalGridGap:Float;
	var speed:Float = 10;

	var gameColor:Int = Color.RED;

	var sceneAlpha:Float = 0;

	public function new()
	{
		super("TitleScene", [  ], CameraPresets.DEFAULT);
	}

	override public function create():Void
	{
		super.create();

		displayObject.addChild(graphics = new pixi.core.graphics.Graphics());

		redPillars = [];
		bluePillars = [];

		createPillars();

		displayObject.addChild(bottomGraphics = new pixi.core.graphics.Graphics());


		this.displayObject.filters = [
			new filters.CRTFilter()
		];

		this.tween(5, { sceneAlpha: 1 }).ease(Sine.easeIn);

		this.tween(100, { gameColor: Color.BLUE }).ease(Sine.easeInOut);
	}

	private function drawGrid():Void
	{
		var rows = 25;
		var columns = 20;

		verticalGridGap = Globals.SCREEN_WIDTH / columns * 2;

		graphics.clear();

		graphics.lineStyle(1, gameColor);
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

		bottomGraphics.clear();
		bottomGraphics.beginFill(gameColor);
		bottomGraphics.drawRect(0, Globals.SCREEN_HEIGHT - 30, Globals.SCREEN_WIDTH, 30);
	}

	function createPillars()
	{
		addNode(pillarContainer = new DisplayObject(),
		{
			position: new Vector2(-600, 100)
		});

		for (i in 0 ... 10) {
			var height:Float = 200 + (Math.random() * 200);
			var x = 800 + i * 600;

			var pillar = new Pillar(200, height, 0xFF0000);

			pillarContainer.addNode(pillar, {
				position: new Vector2(x, Globals.SCREEN_HEIGHT - height)
			});

			redPillars.push(pillar);
		}

		for (i in 0 ... 10) {
			var height:Float = 200 + (Math.random() * 200);
			var x = 800 + 300 + (i * 600);//(Math.random() * 3000);

			var pillar = new Pillar(200, height, 0x0099FF);

			pillarContainer.addNode(pillar, {
				position: new Vector2(x, Globals.SCREEN_HEIGHT - height)
			});

			bluePillars.push(pillar);
		}
	}

	function updateGrid()
	{
		drawGrid();

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

		graphics.alpha = bottomGraphics.alpha = pillarContainer.alpha = sceneAlpha;

		untyped this.displayObject.filters[0].update(deltaTime);

		super.update(deltaTime);
	}
}
