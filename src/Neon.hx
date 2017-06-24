package ;

import milkshake.Milkshake;

class Neon
{
	public static function main()
	{
		var milkshake = Milkshake.boot(new Settings(1280, 720));
		
		milkshake.scenes.addScene(new scenes.TitleScene());
		milkshake.scenes.addScene(new scenes.NeonScene());

		
	}
}
