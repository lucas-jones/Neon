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


class SimpleScene extends Scene
{
	var redPillars:Array<DisplayObject>;
	var bluePillars:Array<DisplayObject>;

	public function new()
	{
		super("TestScene", [ "assets/images/dino/stars.png" ], CameraPresets.DEFAULT, Color.BLUE);
	}

	override public function create():Void
	{
		super.create();

		addNode(new Sprite(Texture.fromImage("assets/images/dino/stars.png")));

		addNode(new Player(), {
			position: new Vector2(400, 0)
		});

		this.displayObject.filters = [
			new filters.CRTFilter()
		];

		redPillars = [];
		bluePillars = [];

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
		displayObject.graphics.beginFill(0, 0.5);
		displayObject.graphics.lineStyle(2, color);
		displayObject.graphics.drawRect(0, 0, 200, height);

		return displayObject;
	}

	override public function update(deltaTime:Float):Void
	{
		super.update(deltaTime);

		for(pillar in redPillars) pillar.x -= 3;
		for(pillar in bluePillars) pillar.x -= 3;
		// world.rotation += 0.001 * deltaTime;
	}
}