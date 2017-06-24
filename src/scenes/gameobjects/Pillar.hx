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

class Pillar extends milkshake.core.DisplayObject
{
	public var color(default, set):Int;

	public var polygon:Polygon;

	var _width:Float;
	var _height:Float;
	var _color:Int;

	var graphics:Graphics;

	public function new(width:Float = 200, height:Float = 300, color:Int = Color.RED)
	{
		super();

		addNode(graphics = new Graphics());

		this._width = width;
		this._height = height;

		polygon = Polygon.rectangle(0, 0, _width, _height, false);

		this.color = color;
	}

	public function set_color(color:Int):Int
	{
		graphics.graphics.beginFill(0, 0.8);
		graphics.graphics.lineStyle(2, color);
		graphics.graphics.drawRect(0, 0, _width, _height);

		return _color = color;
	}

	override public function update(deltaTime:Float):Void
	{
		super.update(deltaTime);

		polygon.position = new differ.math.Vector(position.x, position.y);
	}
}
