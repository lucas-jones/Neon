package ;

import milkshake.Milkshake;

class Seed
{
	public static function main()
	{
		var milkshake = Milkshake.boot(new Settings(1280, 720));
		
		milkshake.scenes.addScene(new scenes.SimpleScene());
	}
}
