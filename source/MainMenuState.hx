package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.2" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;

	//newShit
	var spikeDown:FlxSprite; 
	var spikeUp:FlxSprite;
	//these sprites are relative to the direction they're pointing to
	var spikeCompletionUp:FlxSprite;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);	 
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		//newShit
		spikeDown = new FlxSprite(0, 0).loadGraphic(Paths.image('spikeBG'));
		spikeDown.scrollFactor.x = 0;
		spikeDown.scrollFactor.y = 0;
		spikeDown.setGraphicSize(Std.int(spikeDown.width * 6));
		spikeDown.flipY = true;
		spikeDown.updateHitbox();
		spikeDown.x = FlxG.width/2 - spikeDown.width/2;
		spikeDown.y = FlxG.height/2 - 360;
		add(spikeDown);

		spikeUp = new FlxSprite(0, 0).loadGraphic(Paths.image('spikeBG'));
		spikeUp.scrollFactor.x = 0;
		spikeUp.scrollFactor.y = 0;
		spikeUp.setGraphicSize(Std.int(spikeUp.width * 6));
		spikeUp.updateHitbox();
		spikeUp.x = FlxG.width/2 - spikeUp.width/2;
		spikeUp.y = FlxG.height - 200;
		add(spikeUp);

		spikeCompletionUp = new FlxSprite().makeGraphic(Std.int(spikeUp.width), FlxG.height, FlxColor.BLACK); //big, cause transition
		spikeCompletionUp.y = spikeUp.y + spikeUp.height;
		add(spikeCompletionUp);
		//END

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(FlxG.width, FlxG.height - 160);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.scrollFactor.set();
			menuItems.add(menuItem);
			menuItem.antialiasing = true;
		}

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	//took this froom Sonic.Exe mod source
	//i know, i'm bad at coding
	var tweenDisShit:Bool = true;

	override function update(elapsed:Float)
	{
		if(tweenDisShit)
		{
			tweenDisShit = false;
			FlxTween.tween(spikeUp, {x: spikeUp.x + 72}, 1, {
				onComplete: function(twn:FlxTween)
				{
					spikeUp.x = FlxG.width/2 - spikeUp.width/2;
					tweenDisShit = true;
				}
			});
			
			FlxTween.tween(spikeDown, {x: spikeDown.x - 72}, 1, {
				onComplete: function(twn:FlxTween)
				{
					spikeDown.x = FlxG.width/2 - spikeDown.width/2;
				}
			});		
		}

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		
		if (!selectedSomethin)
		{
			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					fancyOpenURL("https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
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

			if(spr.ID == curSelected)
			{
				spr.animation.play('selected');

				FlxTween.tween(spr, {x: FlxG.width/2 - spr.frameWidth/2}, 0.2, {ease: FlxEase.expoInOut, 
					onComplete: function(twn:FlxTween)
					{
						spr.screenCenter(X);
					}
				});
			}

			if(spr.ID < curSelected)
			{
				FlxTween.tween(spr, {x: -FlxG.width}, 0.2, {ease: FlxEase.expoInOut});
			}

			if(spr.ID > curSelected)
			{
				FlxTween.tween(spr, {x: FlxG.width}, 0.2, {ease: FlxEase.expoInOut});
			}

			spr.updateHitbox();
		});
	}
}
