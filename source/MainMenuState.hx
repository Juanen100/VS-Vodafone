package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		#if !switch 'donate', #end
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var bg:FlxSprite;

	var playAgainstVodafone:FlxText;
	var playsacurenet:FlxText;
	var credits:FlxText;
	var options:FlxText;
	var shutdownOption:FlxText;
	var shutdownInfo:FlxText;

	public static var onMainMenu:Bool = true;

	override function create()
	{
		onMainMenu = true;
		FlxG.mouse.visible = true;
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		bg = new FlxSprite(-640, -360).loadGraphic(Paths.image('miedo', 'shared'));
		//bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		//bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		//var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		/*for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}*/

		playAgainstVodafone = new FlxText(965, 355, 0, "Play VS Vodafone", 12);
		playAgainstVodafone.scrollFactor.set();
		playAgainstVodafone.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
		add(playAgainstVodafone);
		
		playsacurenet = new FlxText(462, 0, 0, "Play Vs Secure Net", 12);
		playsacurenet.scrollFactor.set();
		playsacurenet.screenCenter(Y);
		playsacurenet.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
		add(playsacurenet);

		shutdownOption = new FlxText(462, 505.5, 0, "Shutdown PC: " + ClientPrefs.shutdownPC, 12);
		shutdownOption.scrollFactor.set();
		shutdownOption.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
		add(shutdownOption);
		
		shutdownInfo = new FlxText(342, 575.5, 0, "Press Enter to determine if\nYou want the mod to shutdown the PC or not\n", 12);
		shutdownInfo.scrollFactor.set();
		shutdownInfo.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT);
		add(shutdownInfo);

		credits = new FlxText(995, 475, 0, "Credits", 12);
		credits.scrollFactor.set();
		credits.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
		add(credits);
		
		options = new FlxText(995, 605, 0, "Options", 12);
		options.scrollFactor.set();
		options.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
		add(options);

		switch(ClientPrefs.language)
		{
			case 'Spanish':
				playAgainstVodafone.text = 'Jugar VS Vodafone';
				credits.text = 'Creditos';
				options.text = 'Opciones';
				playsacurenet.text = 'Jugar VS Secure Net';
				shutdownOption.text = 'Apagar PC: ' + ClientPrefs.shutdownPC;
				shutdownInfo.text = 'Presiona Enter para ver si\nquieres que el mod apague tu PC o no\n';
			case 'English':
				playAgainstVodafone.text = 'Play VS Vodafone';
				credits.text = 'Credits';
				options.text = 'Options';
				playsacurenet.text = 'Play VS Secure Net';
				shutdownOption.text = 'Shutdown PC: ' + ClientPrefs.shutdownPC;
				shutdownInfo.text = 'Press Enter to determine if\nYou want the mod to shutdown the PC or not\n';
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 344, 0, 
		" If you close the game while you're playing\nyour PC will shutdown\nif you get 300 misses or more your PC will\nshutdown.\n\n\nREMEMBER\nThis mod contains flashing lights\nand serious epileptic effects\nyou can disable those lights from the\n	options menu.\nAnd, if you die 1 time, your miss limit will\nbe 299 instead, if you die 2 times 298 and so on.\nGood Luck!\n\nWARNING!", 12);
		versionShit.scrollFactor.set();
		switch(ClientPrefs.language)
		{
			case 'Spanish':
				versionShit.text = "Si cierras el juego mientras juegas\ntu PC se apagara\nSi tienes 300 misses o m??s tu PC\nse apagar??.\n\n\nRECUERDA\nEste mod contiene luces parpadeantes\ny efectos epilepticos serios\npuedes desabilitarlas desde el\nmen?? de opciones.\nY, si mueres 1 vez, tu limites de fallos\nser?? de 299, si mueres 2 veces 298 y as??\nBUENA SUERTE\n";
			case 'English':
				versionShit.text = " If you close the game while you're playing\nyour PC will shutdown\nif you get 300 misses or more your PC will\nshutdown.\n\n\nREMEMBER\nThis mod contains flashing lights\nand serious epileptic effects\nyou can disable those lights from the\n	options menu.\nAnd, if you die 1 time, your miss limit will\nbe 299 instead, if you die 2 times 298 and so on.\nGood Luck!\n\nWARNING!";
		}
		versionShit.setFormat(Paths.font('impact.ttf'), 12, FlxColor.WHITE, LEFT);
		add(versionShit);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Vodafone Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(controls.ACCEPT)
			ClientPrefs.shutdownPC = !ClientPrefs.shutdownPC;

		if(ClientPrefs.shutdownPC){
			switch(ClientPrefs.language)
			{
				case 'Spanish':
					shutdownOption.text = 'Apagar PC: Si';
				case 'English':
					shutdownOption.text = 'Shutdown PC: Yes';
			}
		}
		else{
			switch(ClientPrefs.language)
			{
				case 'Spanish':
					shutdownOption.text = 'Apagar PC: No';
				case 'English':
					shutdownOption.text = 'Shutdown PC: No';
			}
		}

		if(FlxG.keys.justPressed.B)
			ClientPrefs.gameplaySettings.set('botplay', true);
		if(FlxG.keys.justPressed.O)
			ClientPrefs.gameplaySettings.set('botplay', false);
		
		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if(FlxG.mouse.overlaps(playAgainstVodafone))
			{
				if(FlxG.mouse.pressed){
					PlayState.storyPlaylist = ['Dad Battle'];
					PlayState.isStoryMode = true;
					var diffic = CoolUtil.getDifficultyFilePath(2);
					if(diffic == null) diffic = '-hard';
					PlayState.storyDifficulty = 2;
					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-hard', PlayState.storyPlaylist[0].toLowerCase());
					PlayState.campaignScore = 0;
					PlayState.campaignMisses = 0;
					LoadingState.loadAndSwitchState(new PlayState(), true);
					onMainMenu = false;
				}
			}

			if(FlxG.mouse.overlaps(playsacurenet))
				{
					if(FlxG.mouse.pressed){
						PlayState.storyPlaylist = ['security'];
						PlayState.isStoryMode = true;
						var diffic = CoolUtil.getDifficultyFilePath(2);
						if(diffic == null) diffic = '-hard';
						PlayState.storyDifficulty = 2;
						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-hard', PlayState.storyPlaylist[0].toLowerCase());
						PlayState.campaignScore = 0;
						PlayState.campaignMisses = 0;
						LoadingState.loadAndSwitchState(new PlayState(), true);
						onMainMenu = false;
						ClientPrefs.middleScroll = true;
					}
				}

			if(FlxG.mouse.overlaps(credits))
			{
				if(FlxG.mouse.pressed){
					MusicBeatState.switchState(new CreditsState());
					onMainMenu = true;
				}
			}

			if(FlxG.mouse.overlaps(options))
				{
					if(FlxG.mouse.pressed){
						LoadingState.loadAndSwitchState(new options.OptionsState());
						onMainMenu = false;
					}
				}

			/*if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}*/

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
				onMainMenu = false;
			}

			#if desktop
			if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
				onMainMenu = false;
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
