package;

import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import openfl.media.Sound;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	static inline final GF_DEFAULT = 'gf default';

	var box:FlxSprite;
	var skipText:FlxText;
	var curCharacter:String = '';

	var curAnim:String = '';
	var prevChar:String = '';

	var effectQue:Array<String> = [""];
	var effectParamQue:Array<String> = [""];

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???/
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;
	//Cutscene shit, HAS TO LOAD ON EVERY STAGE IDIOT
	var cutsceneImage:FlxSprite;
	var sound:FlxSound;

	public var finishThing:Void->Void;


	var portraitBF:Portrait;
	var portraitBFXMAS:Portrait;
	var portraitGF:Portrait;
	var portraitPICO:Portrait;
	var portraitPICOXMAS:Portrait;
	var portraitDAD:Portrait;
	var portraitDADXMAS:Portrait;
	var portraitMOM:Portrait;
	var portraitMOMXMAS:Portrait;
	var portraitNOCHAR:Portrait;
	var portraitSKIDPUMP:Portrait;
	var portraitMONSTER:Portrait;
	var portraitMONSTERXMAS:Portrait;
	var portraitOGBF:Portrait;
	var portraitOGGF:Portrait;
	var portraitSHADOWS:Portrait;
	var portraitNARRATOR:Portrait;
	var portraitDOUBLES:Portrait;
	var portraitICONS:Portrait;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	
	//var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var blackBG:FlxSprite;


	var canAdvance = false;
	var skip:FlxSprite;
	
	

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();
		
		
		
	


		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
				canAdvance = true;
		});

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		
		}

		blackBG = new FlxSprite(-256, -256).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		add(blackBG);
	
		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		cutsceneImage = new FlxSprite(0, 0);
		cutsceneImage.visible = false;
		add(cutsceneImage);	

	
		FlxTween.tween(bgFade, {alpha: 0.7}, 1, {ease: FlxEase.circOut});

		box = new FlxSprite(-20, 385);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			
			default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('bawks', 'shared');
				box.animation.addByPrefix('normalOpen', 'dialogue_box.png', 24, false);
				box.animation.addByIndices('normal', 'dialogue_box.png', [1], "", 24);
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
		}

		this.dialogueList = dialogueList;

		if (!hasDialog)
			return;
		if (PlayState.SONG.song.toLowerCase() == 'senpai'
			|| PlayState.SONG.song.toLowerCase() == 'roses'
			|| PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.animation.addByIndices('idle', 'Senpai Portrait Enter', [3], "", 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
		}
		else
		{
		

			portraitBF = new Portrait (850, 235, "bf");
			add(portraitBF);
			
			portraitBFXMAS = new Portrait (850, 265, "bfxmas");
			add(portraitBFXMAS);

			portraitPICO = new Portrait (190, 190, "pico");
			add(portraitPICO);
			
			portraitPICOXMAS = new Portrait (190, 228, "picoxmas");
			add(portraitPICOXMAS);
	
			portraitDAD = new Portrait (180, 180, "dad");
			add(portraitDAD);
			
			portraitDADXMAS = new Portrait (180, 180, "dadxmas");
			add(portraitDADXMAS);
			
			portraitMOM = new Portrait (170, 210, "mom");
			add(portraitMOM);
			
			portraitMOMXMAS = new Portrait (170, 210, "momxmas");
			add(portraitMOMXMAS);
			
			portraitMONSTER = new Portrait (190, 145, "monster");
			add(portraitMONSTER);
			
			portraitMONSTERXMAS = new Portrait (170, 150, "monsterxmas");
			add(portraitMONSTERXMAS);
			
			portraitGF = new Portrait (170, 200, "gf");
			add(portraitGF);
			
			portraitOGBF = new Portrait (170, 220, "ogbf");
			add(portraitOGBF);
			
			portraitOGGF = new Portrait (180, 235, "oggf");
			add(portraitOGGF);
			
			portraitSKIDPUMP = new Portrait (220, 240, "skidnpump");
			add(portraitSKIDPUMP);
			
			portraitSHADOWS = new Portrait (180, 260, "shadows");

			add(portraitSHADOWS);

			portraitNOCHAR = new Portrait (0, 9999, "noChar");
			add(portraitNOCHAR);
			
			portraitDOUBLES = new Portrait (180, 260, "doubles");
			add(portraitDOUBLES);
			
			portraitICONS = new Portrait (180, 260, "icons");
			add(portraitICONS);

			portraitNARRATOR =  new Portrait (180, 180, "narrator");
			add(portraitNARRATOR);
			hideAll();
			
			
		}
		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.animation.addByIndices('idle', 'Boyfriend portrait enter', [3], "", 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;


		switch PlayState.SONG.song.toLowerCase(){
		case 'senpai' | 'roses' | 'thorns':
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);	
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * 0.9));
		box.updateHitbox();
		add(box);
		box.animation.play('normalOpen'); 
		box.setGraphicSize(Std.int(box.width * 0.9));
		box.updateHitbox();
		add(box);
	
		
		default:
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * 0.9));
		box.updateHitbox();
		add(box);
		}
	
		box.screenCenter(X);


		skip = new FlxSprite(625,315).loadGraphic(Paths.image('ShiftSkip'));
		skip.setGraphicSize(Std.int(skip.width * .2));
		skip.antialiasing = true;
		add(skip);
	

		//handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('hand_textbox', 'shared'));
		//add(handSelect);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'DK Inky Fingers';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'DK Inky Fingers';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.finishSounds = true;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (cutsceneImage.alpha < 1)
			cutsceneImage.alpha += 1 * elapsed;
			
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}
		
		dropText.text = swagDialogue.text;

		
		
		
		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}
		//portraitIMPS.y = 205;
		//if (curAnim == "imps") portraitIMPS.y = 220;
		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if(FlxG.keys.justPressed.SHIFT #if android || FlxG.android.justReleased.BACK #end alogueStarted{

			isEnding = true;
			endDialogue();

		}
		
		#if mobile
        var jusTouched:Bool = false;

        for (touch in FlxG.touches.list)
          if (touch.justPressed)
            jusTouched = true;
        #end

		if (FlxG.keys.justPressed.ANY #if mobile || jusTouched #end && dialogueStarted == true && canAdvance && !isEnding)
		{
			remove(dialogue);
			canAdvance = false;

			new FlxTimer().start(0.15, function(tmr:FlxTimer)
			{
				canAdvance = true;
			});

			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;
					endDialogue();
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function endDialogue(){

		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
			FlxG.sound.music.fadeOut(2.2, 0);

		hideAll();
		if (this.sound != null) this.sound.stop();
		FlxTween.tween(skip,{alpha: 0}, 1.2, {ease: FlxEase.circOut});
		FlxTween.tween(box, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
		FlxTween.tween(bgFade, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
		FlxTween.tween(cutsceneImage, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
		FlxTween.tween(swagDialogue, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
		FlxTween.tween(blackBG, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
		FlxTween.tween(dropText, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
		FlxG.sound.music.fadeOut(1.2, 0);


		new FlxTimer().start(1.2, function(tmr:FlxTimer)
		{
			finishThing();
			kill();
			FlxG.sound.music.stop();
		});

	}

	
	function startDialogue():Void
	{

		var setDialogue = false;
		var skipDialogue = false;
		cleanDialog();
		hideAll();

		box.visible = true;
		skip.visible = true;
		box.flipX = true;
		swagDialogue.visible = true;
		dropText.visible = true;

		switch (curCharacter)
		{
			
			case "bf":
				portraitBF.playFrame(curAnim);
			case "bfxmas":
				portraitBFXMAS.playFrame(curAnim);
			case "dad":
				portraitDAD.playFrame(curAnim);
			case "dadxmas":
				portraitDADXMAS.playFrame(curAnim);
			case "pico":
				portraitPICO.playFrame(curAnim);
			case "picoxmas":
				portraitPICOXMAS.playFrame(curAnim);
			case "gf":
				portraitGF.playFrame(curAnim);
			case "mom":
				portraitMOM.playFrame(curAnim);
			case "momxmas":
				portraitMOMXMAS.playFrame(curAnim);
			case "monster":
				portraitMONSTER.playFrame(curAnim);
			case "monsterxmas":
				portraitMONSTERXMAS.playFrame(curAnim);
			case "skidnpump":
				portraitSKIDPUMP.playFrame(curAnim);
			case "ogbf":
				portraitOGBF.playFrame(curAnim);
			case "oggf":
				portraitOGGF.playFrame(curAnim);
			case "shadows":
				portraitSHADOWS.playFrame(curAnim);
			case "narrator":
				portraitNARRATOR.playFrame(curAnim);
			case "doubles":
				portraitDOUBLES.playFrame(curAnim);
			case "icons":
				portraitICONS.playFrame(curAnim);
			
			case "effect":
				switch(curAnim){
					case "hidden":
						swagDialogue.visible = false;
						dropText.visible = false;
						box.visible = false;
						skip.visible = false;
						setDialogue = true;
						swagDialogue.resetText("");
					default:
						effectQue.push(curAnim);
						effectParamQue.push(dialogueList[0]);
						skipDialogue = true;
				}
			case "bg":
				trace(curAnim);
				skipDialogue = true;
				switch(curAnim){
					case "hide":
						cutsceneImage.visible = false;
					default:
						cutsceneImage.visible = true;
						cutsceneImage.alpha = 0;
						cutsceneImage.loadGraphic(Paths.image('bg/' + curAnim, 'dialogue'));
				}
			case 'sound':
				skipDialogue = true;
				if(this.sound != null) this.sound.stop();
				sound = new FlxSound().loadEmbedded(Sound.fromFile("assets/dialogue/sounds/" + curAnim + ".ogg"));
				sound.play();
				
			default:
				trace("default dialogue event");
				portraitBF.playFrame();
		}


		prevChar = curCharacter;

		if(!skipDialogue){
			if(!setDialogue){
				swagDialogue.resetText(dialogueList[0]);
			}

			swagDialogue.start(0.04, true);
			runEffectsQue();
		}
		else{

			dialogueList.remove(dialogueList[0]);
			startDialogue();
			
		}

	}

	function cleanDialog():Void
	{
		while(dialogueList[0] == ""){
			dialogueList.remove(dialogueList[0]);
		}

		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		curAnim = splitName[2];
	
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[2].length  + 3).trim();
		
		
	}

	function runEffectsQue(){
	
		for(i in 0...effectQue.length){

			switch(effectQue[i]){

				case "fadeOut":
					effectFadeOut(Std.parseFloat(effectParamQue[i]));
				case "fadeIn":
					effectFadeIn(Std.parseFloat(effectParamQue[i]));
				case "exitStageLeft":
					effectExitStageLeft(Std.parseFloat(effectParamQue[i]));
				case "exitStageRight":
					effectExitStageRight(Std.parseFloat(effectParamQue[i]));
				case "enterStageLeft":
					effectEnterStageLeft(Std.parseFloat(effectParamQue[i]));
				case "enterStageRight":
					effectEnterStageRight(Std.parseFloat(effectParamQue[i]));
				case "rightSide":
					effectFlipRight();
				case "flip":
					effectFlipDirection();
				case "toLeft":
					effectToLeft();
				case "toRight":
					effectToRight();
				case "lightningStrike":
					effectlightningStrike();
				case "beep":
					effectbeep();
				//case "shake":
					//effectShake(Std.parseFloat(effectParamQue[i]));
				default:

			}

		}

		effectQue = [""];
		effectParamQue = [""];

	}

	function changeSound(sound:String, volume:Float){
	swagDialogue.sounds = [FlxG.sound.load(Paths.sound(sound, 'dialogue'), volume)];
	
	}

	function portraitArray(){
		var portraitArray =[
			portraitNARRATOR,
			portraitBF,
			portraitBFXMAS,
			portraitGF,
			portraitPICO,
			portraitPICOXMAS,
			portraitDAD,
			portraitDADXMAS,
			portraitMOM,
			portraitMOMXMAS,
			portraitNOCHAR,
			portraitSKIDPUMP,
			portraitMONSTER,
			portraitMONSTERXMAS,
			portraitOGBF,
			portraitOGGF,
			portraitSHADOWS,
			portraitDOUBLES,
			portraitICONS];
			
			return portraitArray;
		}
	

	function hideAll():Void
		{ 
			portraitNARRATOR.hide();
			portraitBF.hide();
			portraitBFXMAS.hide();
			portraitGF.hide();
			portraitPICO.hide();
			portraitPICOXMAS.hide();
			portraitDAD.hide();
			portraitDADXMAS.hide();
			portraitMOM.hide();
			portraitMOMXMAS.hide();
			portraitNOCHAR.hide();
			portraitSKIDPUMP.hide();
			portraitMONSTER.hide();
			portraitMONSTERXMAS.hide();
			portraitOGBF.hide();
			portraitOGGF.hide();
			portraitSHADOWS.hide();
			portraitDOUBLES.hide();
			portraitICONS.hide();
			
			
	
		}

	function effectFadeOut(?time:Float = 1):Void{
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectFadeOut(time);
		}
	}

	function effectFadeIn(?time:Float = 1):Void{
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectFadeIn(time);
		}
	}

	function effectExitStageLeft(?time:Float = 1):Void{
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectExitStageLeft(time);
			}
	}

	function effectExitStageRight(?time:Float = 1):Void{
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectExitStageRight(time);
			}
	}

	function effectFlipRight(){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectFlipRight();
			}
			box.flipX = false;
		
	}
	
	function effectFlipDirection(){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectFlipDirection();
			}
		
	}

	function effectEnterStageLeft(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectEnterStageLeft(time);
			}
		
	}

	function effectEnterStageRight(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectEnterStageRight(time);
			}
	
	}

	function effectToRight(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectToRight(time);
			}
		
		box.flipX = false;
	}

	function effectToLeft(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectToLeft(time);
			}
		
	}

	function effectlightningStrike(){
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
	}
	function effectbeep(){
		FlxG.sound.play(Paths.soundRandom('Carbeep',1,1));
	}


	
}
