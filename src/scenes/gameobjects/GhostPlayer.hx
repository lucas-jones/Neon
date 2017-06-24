package scenes.gameobjects;

import milkshake.utils.Color;
import milkshake.core.Graphics;
import milkshake.math.Vector2;

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
