package scenes;

import milkshake.assets.SpriteSheets;
import milkshake.core.Sprite;
import milkshake.game.scene.camera.CameraPresets;
import milkshake.game.scene.Scene;
import milkshake.math.Vector2;
import milkshake.utils.Color;
import milkshake.utils.Globals;
import motion.easing.Elastic;
import pixi.core.textures.Texture;

using milkshake.utils.TweenUtils;

class SimpleScene extends Scene
{
	var world:Sprite;
	var logo:Sprite;

	public function new()
	{
		super("TestScene", [ "assets/images/dino/stars.png" ], CameraPresets.DEFAULT, Color.BLUE);
	}

	override public function create():Void
	{
		super.create();

		addNode(new Sprite(Texture.fromImage("assets/images/dino/stars.png")));

		addNode(new Sprite(Texture.fromImage("assets/images/dino/moon.png")),
		{
			position: new Vector2(110, 105)
		});

		addNode(logo = new Sprite(Texture.fromImage("assets/images/dino/logo.png")),
		{
			anchor: Vector2.HALF,	
			position: new Vector2(Globals.SCREEN_CENTER.x, 160)
		});

		addNode(world = new Sprite(Texture.fromImage("assets/images/dino/world.png")),
		{
			anchor: Vector2.HALF,
			position: new Vector2(Globals.SCREEN_CENTER.x, Globals.SCREEN_HEIGHT + 200),
			scale: Vector2.EQUAL(0.8)
		});
		
		world.tweenFrom(2, { y: Globals.SCREEN_HEIGHT * 2 }).delay(1).ease(Elastic.easeOut);
		logo.tweenFrom(1, { y: -200 }).delay(1).ease(Elastic.easeOut);
	}

	override public function update(deltaTime:Float):Void
	{
		super.update(deltaTime);

		world.rotation += 0.001 * deltaTime;
	}
}