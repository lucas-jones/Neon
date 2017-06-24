package scenes;

import pixi.extras.BitmapText;
import scenes.NeonScene;
import scenes.gameobjects.GhostPlayer;
import motion.actuators.IGenericActuator;
import milkshake.utils.TweenUtils;
import differ.Collision;
import milkshake.Milkshake;
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
import scenes.gameobjects.Pillar;
import scenes.gameobjects.Player;

using milkshake.utils.TweenUtils;

class NeonScene extends Scene
{
	public static inline var RED:Int = 0xFF0000;
	public static inline var BLUE:Int = 0x0099FF;

	static var GhostMovements:Array<Vector2>;

	var startingPillar:Pillar;
	var redPillars:Array<Pillar>;
	var bluePillars:Array<Pillar>;

	var graphics(default, null):pixi.core.graphics.Graphics;
	var bottomGraphics(default, null):pixi.core.graphics.Graphics;

	var verticalGridOffset:Float = 0;
	var verticalGridGap:Float;
	var speed:Float = 0;

	var gameColor:Int = RED;

	var input:Input;
	var player:Player;
	var updateTween:IGenericActuator;

	var score:Float = 0;
	var scoreText:BitmapText;

	public function new()
	{
		super("NeonScene", [ 'assets/fonts/8bit_wonder/8bit_wonder.fnt' ], CameraPresets.DEFAULT, BLUE);

		input = Milkshake.getInstance().input;
	}

	override public function create():Void
	{
		super.create();

		score = 0;

		displayObject.addChild(graphics = new pixi.core.graphics.Graphics());

		redPillars = [];
		bluePillars = [];

		createPillars();
		addNode(startingPillar = new Pillar(600, 250, RED), {
			position: new Vector2(0, Globals.SCREEN_HEIGHT - 250)
		});

		redPillars.push(startingPillar);

		addNode(player = new Player(gameColor), {
			position: new Vector2(200, 340)
		});

		if(NeonScene.GhostMovements != null) {
			addNode(new GhostPlayer(NeonScene.GhostMovements.copy()), {
				position: new Vector2(200, 340)
			});
		}

		NeonScene.GhostMovements = [];

		displayObject.addChild(bottomGraphics = new pixi.core.graphics.Graphics());

		displayObject.addChild(scoreText = new BitmapText("3213213", { font: "40px 8bit_wonder", tint: 0xFFFFFF}));
		Reflect.setField(js.Browser.window, "text", scoreText);
		scoreText.position.x = 1010;
		scoreText.position.y = 30;

		this.displayObject.filters = [
			new filters.CRTFilter()
		];

		
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
		for (i in 0 ... 10) {
			var height:Float = 200 + (Math.random() * 200);
			var x = 800 + i * 600;//(Math.random() * 3000);

			var pillar = new Pillar(200, height, 0xFF0000);

			addNode(pillar, {
				position: new Vector2(x, Globals.SCREEN_HEIGHT - height)
			});

			redPillars.push(pillar);
		}

		for (i in 0 ... 10) {
			var height:Float = 200 + (Math.random() * 200);
			var x = 800 + 300 + (i * 600);//(Math.random() * 3000);

			var pillar = new Pillar(200, height, 0x0099FF);

			addNode(pillar, {
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
			if(pillar != startingPillar && pillar.x < -200) pillar.x = 10 * 600;
		}

		for(pillar in bluePillars) pillar.alpha = (gameColor == RED) ? 0.4 : 1;
		for(pillar in redPillars) pillar.alpha = (gameColor == BLUE) ? 0.4 : 1;
 	}

    function checkCollision()
    {
		if(player.dead) return;

    	player.alpha = 0.8;
    	player.onFloor = false;

    	var pillars = gameColor == RED ? redPillars : bluePillars;

    	for(piller in pillars)
    	{
    		var result = Collision.shapeWithShape(player.polygon, piller.polygon);

    		if(result != null)
    		{
    			// trace("Collison");

    			if(result.separationX == 0)
    			{
    				player.velocity.y = 0;
    				player.onFloor = true;
    			}

    			player.position.y += result.separationY;
    			player.position.x += result.separationX;
    			
    		}
    		else
    		{

    		}
    	}

    	player.x -= speed; 
    }

	override public function update(deltaTime:Float):Void
	{
		if(speed == 0)
		{
			if(input.isEitherDown([ Key.UP, Key.RIGHT, Key.LEFT, Key.SPACE ]))
			{
				updateTween = this.tween(3, { speed: 5 }).ease(Sine.easeIn).onComplete(function()
				{
					updateTween = this.tween(10, { speed: 10 }).ease(Sine.easeIn);
				});
			}
		}

		score += speed;

		scoreText.text = "SCORE: " + Std.string(Std.int(score));
		scoreText.x = 30;

		updateGrid();
		updatePillars();

		if(input.isDownOnce(Key.SPACE))
		{
			gameColor = gameColor == RED ? BLUE : RED;
            player.color = gameColor;
		}

		if(player.dead) {
			speed = 0;
			motion.Actuate.stop(updateTween);
		} else {
			NeonScene.GhostMovements.push(player.position.clone());
		}

		untyped this.displayObject.filters[0].update(deltaTime);

		super.update(deltaTime);

		checkCollision();
	}
}
