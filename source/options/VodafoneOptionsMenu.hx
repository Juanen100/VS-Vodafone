package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class VodafoneOptionsMenu extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Secure Net Settings';
		rpcTitle = 'Secure Net Settings'; //for Discord Rich Presence

		var option:Option = new Option('Language:',
			"What language should this thing speak",
			'language',
			'string',
			'English',
			['English', 'Spanish']);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		addOption(option);

        var option:Option = new Option('Shutdown PC',
			"Uncheck this if you don't want your PC to Shutdown",
			'shutdownPC',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Spam Messages',
			"If you are annoyed cuz of the Spam Messages during Vodafone, remove them completly",
			'spamMessages',
			'bool',
			true);
		addOption(option);

        var option:Option = new Option('Window Movement',
			"Removes the window movement in Vodafone",
			'windowMoves',
			'bool',
			true);
		addOption(option);

		super();
	}
}