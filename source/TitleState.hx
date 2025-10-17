package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		#if android FlxG.android.preventDefaultKeys = [BACK]; #end
		
		PlayerSettings.init();

		#if windows
		DiscordClient.initialize();

		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		 
		#end

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		Highscore.load();

		// Create save data for week unlocks. Changed name to softWeekUnlock so that it doesn't share data with other mods.
		if(FlxG.save.data.softWeekUnlocked == null){
			FlxG.save.data.softWeekUnlocked = [true, false, false, false, false, false, false, false];
			FlxG.save.flush();
		}
		// This one is just incase everything gets fucky, it'll reset the unlock data rather than lock you out of all weeks. Shouldn't need to be here, just a safty net.
		/*else if(FlxG.save.data.softWeekUnlocked[0] == false){ 
			FlxG.save.data.softWeekUnlocked = [true, false, false, false, false, false, false, false];
			FlxG.save.flush();
		}*/

		StoryMenuState.softWeekUnlocked = FlxG.save.data.softWeekUnlocked;

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else

		if (!initialized)
			{
				var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
				diamond.persist = true;
				diamond.destroyOnNoUse = false;
	
				FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
					new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
				FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
					{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
	
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
	
				// HAD TO MODIFY SOME BACKEND SHIT
				// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
				// https://github.com/HaxeFlixel/flixel-addons/pull/348
	
				// var music:FlxSound = new FlxSound();
				// music.loadStream(Paths.music('freakyMenu'));
				// FlxG.sound.list.add(music);
				// music.play();
			}
			
		startIntro();
		#end
	}

	var logoBl:FlxSprite;
	var bfmenu:FlxSprite;
	var picomenu:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('titlebg'));
		bg.setGraphicSize(Std.int(bg.width * 1.12));
		bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

			logoBl = new FlxSprite(-150, -100);
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
			logoBl.antialiasing = true;
			logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
			logoBl.animation.play('bump');
			logoBl.updateHitbox();
			logoBl.screenCenter(X);
			// logoBl.color = FlxColor.BLACK;

		bfmenu = new FlxSprite(900,300);
		bfmenu.frames = Paths.getSparrowAtlas('softie');
		bfmenu.animation.addByPrefix('idle', 'BF idle dance', 24, false);
		bfmenu.animation.addByPrefix('hey', 'BF HEY', 24, false);
		bfmenu.animation.play('idle');
		bfmenu.antialiasing = true;

		picomenu = new FlxSprite(0,310);
		picomenu.frames = Paths.getSparrowAtlas('soft_pico_assets');
		//picomenu.animation.addByPrefix('idle', 'soft_pico idle', 24, true);
		picomenu.animation.addByIndices('danceLeft', 'soft_pico idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		picomenu.animation.addByIndices('danceRight', 'soft_pico idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		picomenu.animation.addByPrefix('hey', 'soft_pico cheer', 24, false);
		picomenu.animation.play('danceLeft');
		picomenu.antialiasing = true;
		picomenu.flipX = true;


		add(logoBl);
		add(bfmenu);
		add(picomenu);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		// credTextShit.alignment = CENTER;

		ngSpr = new FlxSprite(0, FlxG.height * 0.32).loadGraphic(Paths.image('NGLOGO'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;


		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else{
			initialized = true;
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			#if !switch
			//NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			//if (Date.now().getDay() == 5)
			//	NGio.unlockMedal(61034);
			#end

			titleText.animation.play('press');
			bfmenu.animation.play('hey');
			picomenu.animation.play('hey');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();


			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				FlxG.switchState(new WarningState());
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro && initialized)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump', true);
		danceLeft = !danceLeft;

		if(!transitioning){

		bfmenu.animation.play('idle', true);

		if (danceLeft)
			picomenu.animation.play('danceRight', true);
		else
			picomenu.animation.play('danceLeft', true);

		}

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				
				ngSpr.visible = true;
			case 3:
				ngSpr.visible = false;
			case 4:
				createCoolText(['The Soft Team']);
			case 6:
				addMoreText('presents');
			case 8:
				deleteCoolText();
			case 9:
				createCoolText([curWacky[0]]);
			case 11:
				addMoreText(curWacky[1]);
			case 12:
				deleteCoolText();
			case 13:
				createCoolText(['FNF']);
			case 14:
				addMoreText("SOFT");
			case 15:
				addMoreText("MOD");
			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
