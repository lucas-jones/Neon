package ;

import milkshake.Milkshake;

class Neon
{
	public static function main()
	{
		var milkshake = Milkshake.boot(new Settings(1280, 720));
		
		milkshake.scenes.addScene(new scenes.NeonScene());

		milkshake.sounds.playSound('assets/sounds/totally_legit_royalty_free.mp3', true);
	}
}
