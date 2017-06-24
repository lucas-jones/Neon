package scenes.gameobjects;

import motion.easing.Sine;
import pixi.extras.BitmapText;
import milkshake.utils.Color;
import milkshake.core.Graphics;
import milkshake.math.Vector2;

using milkshake.utils.TweenUtils;

class GhostPlayer extends milkshake.core.DisplayObject
{
    private var movement:Array<Vector2>;
    var graphics:Graphics;

    public function new(movement:Array<Vector2>)
    {
        super();

        this.movement = movement;
        graphics = new Graphics();
        addNode(graphics);

        graphics.graphics.beginFill(Color.WHITE);
        graphics.graphics.drawRect(-20, -20, 40, 40);

        graphics.graphics.beginFill(0);
        graphics.graphics.drawRect(-15, -5, 9, 9);
        graphics.graphics.drawRect(10, -5, 9, 9);

        alpha = 0.3;

        externs.SeedRandom.seedrandom(null);

        var textOptions = ["BOO", "OUCH", "WEE"];
        var text = textOptions[Math.floor(Math.random() * textOptions.length)];

        var boo = new BitmapText(text, { font: "14px 8bit_wonder", tint: 0xFFFFFF});
        boo.position.x = -20;
        boo.position.y = -30;
        boo.alpha = 0;

        var delay = Math.random() * 60;

        boo.tween(1, {alpha: 1}).delay(delay).ease(Sine.easeOut).onComplete(function()
        {
            boo.tween(1, {alpha: 0}).ease(Sine.easeOut);
            boo.position.tween(1, {y: -30}).ease(Sine.easeOut);
        });
        boo.position.tween(1, {y: -50}).delay(delay).ease(Sine.easeOut);

        displayObject.addChild(boo);
    }

    override public function update(deltaTime:Float):Void
    {
        if(movement.length > 0) {
            var movement = movement.shift();
            position = movement;
        } else {
            alpha = 0;
        }

        super.update(deltaTime);
    }
}
