package scenes;

import milkshake.core.DisplayObject;
import externs.SeedRandom;
import pixi.extras.BitmapText;
import scenes.NeonScene;
import scenes.gameobjects.GhostPlayer;
import motion.actuators.IGenericActuator;
import milkshake.utils.TweenUtils;
import differ.Collision;
import milkshake.Milkshake;
import milkshake.components.input.Input;
import milkshake.components.input.Key;
import milkshake.game.scene.camera.CameraPresets;
import milkshake.game.scene.Scene;
import milkshake.math.Vector2;
import milkshake.utils.Globals;
import motion.easing.Sine;
import scenes.gameobjects.Pillar;
import scenes.gameobjects.Player;

using milkshake.utils.TweenUtils;

class NeonScene extends Scene
{
	public static inline var RED:Int = 0xFF0000;
	public static inline var BLUE:Int = 0x0099FF;

	static var GhostMovements:Array<Array<Vector2>>;
	static var GhostIteration:Int = 0;

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
	var scoreContainer:DisplayObject;
	var ghostContainer:DisplayObject;

	var distAlongLine:Float = 0;

	var isGameOver:Bool = false;

	public function new()
	{
		super("NeonScene", [ 'assets/fonts/8bit_wonder/8bit_wonder.fnt' ], CameraPresets.DEFAULT, BLUE);

		input = Milkshake.getInstance().input;
	}

	override public function create():Void
	{
		super.create();

		score = 0;

		SeedRandom.seedrandom("barry");

		displayObject.addChild(graphics = new pixi.core.graphics.Graphics());

		redPillars = [];
		bluePillars = [];

		createPillars();
		addNode(startingPillar = new Pillar(600, 250, RED), {
			position: new Vector2(0, Globals.SCREEN_HEIGHT - 250)
		});

		redPillars.push(startingPillar);


		var test = new Pillar(1200, 250, RED);

		cast addNode(test, {
			position: new Vector2(6800, Globals.SCREEN_HEIGHT - 250)
		});
		redPillars.push(test);


		var testa = new Pillar(1200, 50, BLUE);

		cast addNode(testa, {
			position: new Vector2(7300, Globals.SCREEN_HEIGHT - 400)
		});
		bluePillars.push(testa);

		var testB = new Pillar(1200, 50, RED);

		cast addNode(testB, {
			position: new Vector2(8000, Globals.SCREEN_HEIGHT - 550)
		});
		redPillars.push(testB);

		addNode(ghostContainer = new DisplayObject());

		addNode(player = new Player(gameColor), {
			position: new Vector2(200, 340)
		});

		displayObject.addChild(bottomGraphics = new pixi.core.graphics.Graphics());

		addNode(scoreContainer = new DisplayObject());

		scoreContainer.displayObject.addChild(scoreText = new BitmapText("3213213", { font: "40px 8bit_wonder", tint: 0xFFFFFF}));
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

		distAlongLine+= 0.005;
		if(distAlongLine > 1) distAlongLine = 0;

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

			var pointA = new Vector2(-Globals.SCREEN_WIDTH / 2 + i * verticalGridGap - verticalGridOffset, 0);
			var pointB = new Vector2(i * offset - verticalGridOffset / 2, 200);

			graphics.moveTo(pointA.x, pointA.y);
			graphics.lineTo(pointB.x, pointB.y);

			var midPoint = pointAlongLine(pointA, pointB, 1 - distAlongLine);
			graphics.beginFill(gameColor);
			graphics.drawCircle(midPoint.x, midPoint.y, 2);
		}

		// Bottom Vertical Lines
		for (i in 0...columns) {
			var offset = Globals.SCREEN_WIDTH / columns;

			var pointA = new Vector2(i * offset - verticalGridOffset / 2, Globals.SCREEN_HEIGHT / 1.5);
			var pointB = new Vector2(-Globals.SCREEN_WIDTH / 2 + i * verticalGridGap - verticalGridOffset, Globals.SCREEN_HEIGHT);

			graphics.moveTo(pointA.x, pointA.y);
			graphics.lineTo(pointB.x, pointB.y);

			var midPoint = pointAlongLine(pointA, pointB, distAlongLine);
			graphics.beginFill(gameColor);
			graphics.drawCircle(midPoint.x, midPoint.y, 2);
		}

		bottomGraphics.clear();
		bottomGraphics.beginFill(gameColor);
		bottomGraphics.drawRect(0, Globals.SCREEN_HEIGHT - 30, Globals.SCREEN_WIDTH, 30);
	}

	function pointAlongLine(pointA:Vector2, pointB:Vector2, percent:Float)
	{
		return new Vector2(pointA.x + (pointB.x - pointA.x) * percent, pointA.y + (pointB.y - pointA.y) * percent);
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
			// if(pillar != startingPillar && pillar.x < -200) pillar.x = 10 * 600;
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
    			if(result.separationX == 0)
    			{
    				player.velocity.y = 0;
    				player.onFloor = true;
    			}

    			player.position.y += result.separationY;
    			player.position.x += result.separationX;

    		}
    	}

    	player.x -= speed; 
    }

	public function gameOver():Void
	{
		scoreContainer.scale.tween(0.5, {x: 1.75, y: 1.75}).ease(Sine.easeOut);
		scoreContainer.position.tween(0.5, {x: Globals.SCREEN_WIDTH / 2 - (scoreContainer.width), y: 250}).ease(Sine.easeOut).onComplete(function()
		{
			var gameOverContainer = new DisplayObject();
			var gameOverText = new BitmapText("GAME OVER", { font: "85px 8bit_wonder", tint: 0xFFFFFF});
			addNode(gameOverContainer,
			{
				position: new Vector2(275, 100)
			});
			gameOverContainer.displayObject.addChild(gameOverText);
			gameOverContainer.alpha = 0;

			gameOverContainer.tween(0.5, {alpha: 1}).ease(Sine.easeOut);


			var contContainer = new DisplayObject();
			var contText = new BitmapText("PRESS SPACEBAR TO CONTINUE", { font: "50px 8bit_wonder", tint: 0xFFFFFF});
			addNode(contContainer,
			{
				position: new Vector2(50, 600)
			});
			contContainer.displayObject.addChild(contText);
			contContainer.alpha = 0;

			contContainer.tween(0.5, {alpha: 1}).ease(Sine.easeIn).repeat().reflect();

			isGameOver = true;
		});
	}

    var started:Bool = false;
	override public function update(deltaTime:Float):Void
	{
		if(isGameOver&& input.isEitherDown([Key.UP, Key.SPACE]))
		{
			var sceneManager = Milkshake.getInstance().scenes;
			sceneManager.removeScene(scene.id);
			sceneManager.addScene(new NeonScene());
			return;
		}

		if(speed == 0 && started == false)
		{

			if(input.isEitherDown([ Key.UP, Key.RIGHT, Key.LEFT, Key.SPACE ]))
			{
				started = true;
				Milkshake.getInstance().sounds.playSound('assets/sounds/totally_legit_royalty_free_2.mp3', true, true, 0.5);
				if(NeonScene.GhostMovements != null) {
					for (movements in NeonScene.GhostMovements) {
						ghostContainer.addNode(new GhostPlayer(movements.copy()), {
							position: new Vector2(200, 340)
						});
					}

					GhostIteration++;
				} else {
					NeonScene.GhostMovements = new Array<Array<Vector2>>();
				}

				NeonScene.GhostMovements[GhostIteration] = [];

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

		if(!player.dead && input.isDownOnce(Key.SPACE))
		{
			Milkshake.getInstance().sounds.playSound('assets/sounds/switch.mp3', true, false);
			gameColor = gameColor == RED ? BLUE : RED;
            player.color = gameColor;
		}

		if(player.dead) {
			speed = 0;
			motion.Actuate.stop(updateTween);
		} else {
			if(speed != 0) NeonScene.GhostMovements[GhostIteration].push(player.position.clone());
		}

		untyped this.displayObject.filters[0].update(deltaTime);

		super.update(deltaTime);

		checkCollision();
	}
}
