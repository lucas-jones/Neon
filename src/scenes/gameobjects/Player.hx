package scenes.gameobjects;

import differ.shapes.Polygon;
import milkshake.core.ParticleEmitter;
import milkshake.Milkshake;
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
import milkshake.utils.MathHelper;
import motion.easing.Elastic;
import motion.easing.Sine;
import pixi.core.textures.Texture;

using milkshake.utils.TweenUtils;

class Player extends milkshake.core.DisplayObject
{
	public var color(default, set):Int;
	public var polygon:Polygon;
	public var dead(default, null):Bool = false;

	var _color:Int;

	var graphics:Graphics;
	var input:Input;
	var particles:ParticleEmitter;

	public var velocity:Vector2;
	public var onFloor:Bool = false;

	var lastPositions:Array<Vector2>;

	public function new(color:Int = Color.RED)
	{
		super();

		graphics = new Graphics();
		addNode(graphics);

		this.color = color;

		velocity = new Vector2();

		polygon = Polygon.rectangle(0, 0, 40, 40, true);

		input = Milkshake.getInstance().input;
	}

	public function set_color(color:Int):Int
	{
		graphics.graphics.beginFill(color);
		graphics.graphics.drawRect(-20, -20, 40, 40);

		graphics.graphics.beginFill(0);
		graphics.graphics.drawRect(-15, -5, 9, 9);
		graphics.graphics.drawRect(10, -5, 9, 9);

		return _color = color;
	}

	override public function update(deltaTime:Float):Void
	{
		if(dead) return;

		velocity.y += 0.7;

		if(input.isDownOnce(Key.UP) && onFloor)
		{
			jump();
		}

		if(input.isUpOnce(Key.UP) && velocity.y < 0)
		{
			// velocity.y = 0;
		}

		if(input.isDown(Key.RIGHT)) velocity.x = onFloor ? 10 : 15;
		else if(input.isDown(Key.LEFT)) velocity.x = onFloor ? -10 : -15;
		else velocity.x *= onFloor ? 0.3 : 0.9;

		position.add(velocity);

		if(position.y > 690 || x < 0)
		{
			die();
		}

		super.update(deltaTime);

		polygon.position = new differ.math.Vector(position.x, position.y);
	}

	public function jump()
	{
		velocity.y = -18;
		this.scale.tween(0.15, { x: 0.7, y: 1.3 }).ease(Sine.easeOut).onComplete(function()
		{
			this.scale.tween(0.4, { x: 1.2, y: 0.9 }).ease(Sine.easeOut).onComplete(function()
			{
				this.scale.tween(0.2, { x: 1, y: 1 }).ease(Sine.easeOut);
			});
		});
	}

	public function die()
	{
		if(dead) return;

		dead = true;
		velocity.x = velocity.y = 0;

		scene.addNode(particles = new ParticleEmitter([
			Texture.fromImage('assets/images/player/particles/Pixel25px.png'),
			Texture.fromImage('assets/images/player/particles/Pixel50px.png'),
			Texture.fromImage('assets/images/player/particles/Pixel100px.png')
		], 'death particles', {
			"alpha": {
				"start": 0.8,
				"end": 0.7
			},
			"scale": {
				"start": 1,
				"end": 0.3,
				"minimumScaleMultiplier": 1
			},
			"color": {
				"start": _color == Color.RED ? "#ff0000" : "#0099ff",
				"end": _color == Color.RED ? "#ff0000": "#0099ff"
			},
			"speed": {
				"start": 200,
				"end": 200,
				"minimumSpeedMultiplier": 1
			},
			"acceleration": {
				"x": 0,
				"y": 0
			},
			"maxSpeed": 0,
			"startRotation": {
				"min": 0,
				"max": 0
			},
			"noRotation": false,
			"rotationSpeed": {
				"min": 0,
				"max": 0
			},
			"lifetime": {
				"min": 0.8,
				"max": 0.8
			},
			"blendMode": "normal",
			"frequency": 0.3,
			"emitterLifetime": 0.41,
			"maxParticles": 1000,
			"pos": {
				"x": 0,
				"y": 0
			},
			"addAtBack": false,
			"spawnType": "burst",
			"particlesPerWave": 8,
			"particleSpacing": 45,
			"angleStart": 0
		}),
		{
			position: position
		});

		alpha = 0;

		haxe.Timer.delay(function() {
			scene.removeNode(particles);
			particles.emitter.destroy();
			particles = null;

			var sceneManager = Milkshake.getInstance().scenes;
			sceneManager.removeScene(scene.id);
			sceneManager.addScene(new NeonScene());
		}, 3000);
	}
}
