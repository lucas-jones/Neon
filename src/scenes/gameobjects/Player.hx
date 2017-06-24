package scenes.gameobjects;

import differ.shapes.Polygon;
import milkshake.assets.SpriteSheets;
import milkshake.components.input.Input;
import milkshake.components.input.Key;
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

using milkshake.utils.TweenUtils;

class Player extends milkshake.core.DisplayObject
{
	public var color(default, set):Int;
	public var polygon:Polygon;

	var _color:Int;

	var graphics:Graphics;
	var input:Input;
	public var velocity:Vector2;

	var lastPositions:Array<Vector2>;

	public function new(color:Int = Color.RED)
	{
		super();

		graphics = new Graphics();
		addNode(graphics);

		this.color = color;

		velocity = new Vector2();
		input = new Input();

		polygon = Polygon.rectangle(0, 0, 40, 40, true);
	}

	public function set_color(color:Int):Int
	{
		graphics.graphics.beginFill(color);
		graphics.graphics.drawRect(-20, -20, 40, 40);

		return _color = color;
	}

	override public function update(deltaTime:Float):Void
	{
		velocity.y += 0.8;

		if(position.y > 700)
		{
			velocity.y = 0;
		}

		if(input.isDown(Key.SPACE))
		{
			jump();
		}

		if(input.isDown(Key.RIGHT)) velocity.x = 10;
		else if(input.isDown(Key.LEFT)) velocity.x = -10;
		else velocity.x = 0;

		position.add(velocity);

		super.update(deltaTime);

		polygon.position = new differ.math.Vector(position.x, position.y);
	}

	public function jump()
	{
		velocity.y = -20;
		// this.scale.tween(0.5, { x: 0.7, y: 1.3 }).ease(Sine.easeOut).onComplete(function()
		// {
		// 	this.scale.tween(0.8, { x: 1.3, y: 0.7 }).ease(Elastic.easeIn).delay(0);
		// });
	}
}
