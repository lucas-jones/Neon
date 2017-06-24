package scenes;

import milkshake.components.input.Key;
import milkshake.Milkshake;
import pixi.extras.BitmapText;
import milkshake.core.DisplayObject;
import milkshake.utils.Color;
import milkshake.game.scene.camera.CameraPresets;
import milkshake.game.scene.Scene;
import milkshake.math.Vector2;
import milkshake.utils.Globals;
import milkshake.utils.TweenUtils;
import motion.easing.Sine;
import scenes.gameobjects.Pillar;

using milkshake.utils.TweenUtils;

class TitleScene extends Scene
{
	var redPillars:Array<Pillar>;
	var bluePillars:Array<Pillar>;
	var pillarContainer:DisplayObject;

	var graphics(default, null):pixi.core.graphics.Graphics;
	var bottomGraphics(default, null):pixi.core.graphics.Graphics;
	var text(default, null):pixi.extras.BitmapText;
	var text2(default, null):pixi.extras.BitmapText;

	var verticalGridOffset:Float = 0;
	var verticalGridGap:Float;
	var speed:Float = 10;

	var gameColor:Int = Color.RED;

	var sceneAlpha:Float = 0;

	public function new()
	{
		super("TitleScene", [ 'assets/fonts/8bit_wonder/8bit_wonder.fnt' ], CameraPresets.DEFAULT);
	}

	override public function create():Void
	{
		super.create();

		displayObject.addChild(graphics = new pixi.core.graphics.Graphics());

		redPillars = [];
		bluePillars = [];

		createPillars();

		displayObject.addChild(bottomGraphics = new pixi.core.graphics.Graphics());

		displayObject.addChild(text = new pixi.extras.BitmapText("N E O N", { font: "75px 8bit_wonder", tint: 0xFFFFFF}));
		displayObject.addChild(text2 = new pixi.extras.BitmapText("INSERT COIN", { font: "32px 8bit_wonder", tint: 0xFFFFFF}));

		text.position.x = 450;
		text.position.y = 275;
		text.alpha = 0;

		text2.position.x = 500;
		text2.position.y = 375;
		text2.alpha = 0;


		this.displayObject.filters = [
			new filters.CRTFilter()
		];

		text.tween(1.5, {alpha: 1}).ease(Sine.easeIn).onComplete(function() {
			text2.tween(0.5, {alpha: 1}).ease(Sine.easeIn).repeat().reflect();
		});
		this.tween(5, { sceneAlpha: 1 }).ease(Sine.easeIn);
		this.tween(100, { gameColor: Color.BLUE }).ease(Sine.easeInOut).repeat().reflect();
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
		if(Milkshake.getInstance().input.isEitherDown([Key.SPACE, Key.ENTER]))
		{
			Milkshake.getInstance().scenes.changeScene('NeonScene');
		}

		updateGrid();
		updatePillars();

		graphics.alpha = bottomGraphics.alpha = pillarContainer.alpha = sceneAlpha;

		untyped this.displayObject.filters[0].update(deltaTime);

		super.update(deltaTime);
	}
}
