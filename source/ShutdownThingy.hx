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
        Sys.command('shutdown -s');
    }

    public static function alertThing(message:String)
    {
        Sys.command('msg * ' + message);
    }
}