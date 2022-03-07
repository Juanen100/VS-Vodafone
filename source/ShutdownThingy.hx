package;

import flixel.*;
import haxe.Exception;

class ShutdownThingy 
{
    public static function closeGame()
    {
        Sys.exit(0);
    }

    public static function shutdownPC()
    {
        if(!MainMenuState.onMainMenu)
            Sys.command('shutdown -s -t 10');
    }

    public static function alertThing(message:String)
    {
        Sys.command('msg * ' + message);
    }
}