package;

import flixel.*;

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
}