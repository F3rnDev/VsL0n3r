package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var selector:FlxText;
	var curSelected:Int = 0;

	var options:Array<OptionCategory>;

	public var acceptInput:Bool = true;

	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<Alphabet>;
	public static var versionShit:FlxText;

	var currentSelectedCat:OptionCategory;
	var blackBorder:FlxSprite;
	
	// VsLoner Custom Shit
	var descTxt:String; //to show the "Please select a category" in different languages
	var descLength:Int; //debbuging purpuses
	// END
	override function create()
	{
		//put this function first, cause this shit showed up --> Uncatchable Throw: Null Object Reference
		//so yea, don't move dis
		changeLanguage();

		instance = this;
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false, true);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		versionShit = new FlxText(5, FlxG.height + 40, FlxG.width, currentDescription, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.SHADOW, FlxColor.RED);
		
		blackBorder = new FlxSprite(-30,FlxG.height + 40).makeGraphic(FlxG.width + 200, Std.int((versionShit.height + 600) * 2),FlxColor.BLACK);
		blackBorder.alpha = 0.7;

		add(blackBorder);
		add(versionShit);
		
		changeSelection();
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			tweenDesc();
		});

		super.create();
	}

	var isCat:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (acceptInput){
			if (controls.BACK && !isCat)
				FlxG.switchState(new MainMenuState());
			else if (controls.BACK)
			{
				isCat = false;
				grpControls.clear();
				for (i in 0...options.length)
					{
						var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false);
						controlLabel.isMenuItem = true;
						controlLabel.targetY = i;
						grpControls.add(controlLabel);
						// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
					}
				curSelected = 0;
				changeSelection();
				tweenDesc();
			}
			if (controls.UP_P)
			{
				changeSelection(-1);
				tweenDesc();
			}
			if (controls.DOWN_P)
			{
				changeSelection(1);
				tweenDesc();
			}
			
			if (isCat)
			{			
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
				{
						if (FlxG.keys.justPressed.RIGHT)
							currentSelectedCat.getOptions()[curSelected].right();

						if (FlxG.keys.justPressed.LEFT)
							currentSelectedCat.getOptions()[curSelected].left();
				}

				if (currentSelectedCat.getOptions()[curSelected].getAccept())
					versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + ' -' + descTxt + '- '  + currentDescription;
				else
					versionShit.text = currentDescription;
			}
			else{			
				if (FlxG.keys.pressed.RIGHT)
					FlxG.save.data.offset += 0.1;

				if (FlxG.keys.pressed.LEFT)
					FlxG.save.data.offset -= 0.1;
			}

			if (controls.RESET)
					FlxG.save.data.offset = 0;

			if (controls.ACCEPT)
			{
				if (isCat)
				{
					if (currentSelectedCat.getOptions()[curSelected].press()) {
						grpControls.remove(grpControls.members[curSelected]);
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, currentSelectedCat.getOptions()[curSelected].getDisplay(), true, false);
						ctrl.isMenuItem = true;
						grpControls.add(ctrl);
					}
				}
				else
				{
					currentSelectedCat = options[curSelected];
					isCat = true;
					grpControls.clear();
					for (i in 0...currentSelectedCat.getOptions().length)
						{
							var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), true, false);
							controlLabel.isMenuItem = true;
							controlLabel.targetY = i;
							grpControls.add(controlLabel);
							// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
						}
					curSelected = 0;
					changeSelection();
					tweenDesc();
				}
			}
		}

		if (FlxG.keys.justPressed.ANY){ //lags af if done on the update function. Not the best way to fix this, but will do for now
			FlxG.save.flush();
			trace('SAVED');
		}


		FlxG.watch.addQuick('lesgo', FlxG.save.data.language);
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end

		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		if (isCat){
			currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();

			if (currentSelectedCat.getOptions()[curSelected].getAccept())
				versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + ' -' + descTxt + '- ' + currentDescription;
			else
				versionShit.text = currentDescription;
		}
		else
		{
			switch (LanguageState.langString)
			{
				case 'PtBr':
					currentDescription = "Selecione uma categoria";			
				case 'Eng':
					currentDescription = "Please select a category";
			}

			versionShit.text = currentDescription;
		}
			
		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY >= 2 || item.targetY <= -2)
			{
				item.alpha = 0.3;
			}
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	
	function tweenDesc()
	{
		if (versionShit.text.length >= 69)
		{
			FlxTween.tween(versionShit,{y: FlxG.height - 60},0.2,{ease: FlxEase.elasticInOut});
			FlxTween.tween(blackBorder,{y: FlxG.height - 60},0.2, {ease: FlxEase.elasticInOut});
		}
		else
		{
			FlxTween.tween(versionShit,{y: FlxG.height - 32},0.2,{ease: FlxEase.elasticInOut});
			FlxTween.tween(blackBorder,{y: FlxG.height - 32},0.2, {ease: FlxEase.elasticInOut});
		}
	}

	function changeLanguage()
	{
		//Change Options Based on curLanguage
		//was poluting the code up there, so i made a function for it
		switch (LanguageState.langString)
		{
			// PORTUGUÊS
			case 'PtBr':
			{
				descTxt = "Descrição";
				options = [
					new OptionCategory("Opcoes do VsLoner", [
						new Fullscreen("Ligue a opção em tela cheia."),
						new ArrowParticles("Ligue os efeitos das setinhas quando se consegue um 'sick' (sprites do VsAGOTI). |--AVISO: pode diminuir o FPS--|"),
						new LanguageOption('Mude a Linguagem do jogo. |--Use as setas do teclado para selecionar a língua--|')
					]),
					new OptionCategory("Gameplay", [
						new DFJKOption(controls),
						new DownscrollOption("Muda a direcao das setas. |--Upscrool: baixo pra cima | Downscrool: cima pra baixo--|"),
						new GhostTapOption("Se ligado, você não é penalizado ao acertar as teclas fora do tempo."),
						new Judgement("Controles: (Direita ou Esquerda)."),
						#if desktop
						new FPSCapOption("Limite seu FPS"),
						#end
						new ScrollSpeedOption("Mude a velocidade de scroll (1 = velocidade da Chart atual)."), 
						new AccuracyDOption("Mude como a precisão é calculada (Precisa = Simples, Complexa = Baseada em milissegundos)."),
						new ResetButtonOption("Se ligado, aperte R pra dar GameOver."),
						// new OffsetMenu("Get a note offset based off of your inputs!"),
						new CustomizeGameplay("Arraste os elementos do HUD pra customizar sua gameplay.")
					]),
					new OptionCategory("Aparencia", [
						#if desktop
						new DistractionsAndEffectsOption("Liga distrações nas fases que podem atrapalhar sua gameplay."),
						new RainbowFPSOption("O contador de FPS fica em arco-íris."),
						new AccuracyOption("Mostra a sua precisão."),
						new NPSDisplayOption("Mostra as notas atuais por segundo."),
						new SongPositionOption("Mostra a posição atual da música (como uma barra)."),
						new CpuStrums("Notas do CPU acendem quando ele acerta uma nota."),
						#else
						new DistractionsAndEffectsOption("Liga distrações nas fases que podem atrapalhar sua gameplay.")
						#end
					]),
					
					new OptionCategory("Misc", [
						#if desktop
						new FPSOption("Liga o contador de FPS."),
						new ReplayOption("Veja os replays."),
						#end
						new FlashingLightsOption("Se ligado, o jogo mostra luzes piscando que podem ser prejudiciais para pessoas sensíveis."),
						new WatermarkOption("Se ligado, mostra a marca d'água da engine."),
						new BotPlay("Autoplay: um bot joga o jogo pra você.")
					])
				];
			}
			// ENGLISH
			case 'Eng':
			{
				descTxt = "Description";
				options = [			
					new OptionCategory("VsLoner Options", [
						new Fullscreen("Toggle fullscreen mode."),
						new ArrowParticles("Toggle the cool arrow effects when getting a sick (sprites from VsAGOTI). |--WARNING: can slow the fps--|"),
						new LanguageOption('Change the game Language. |--Use the arrow keys to select the language--|')
					]),
					new OptionCategory("Gameplay", [
						new DFJKOption(controls),
						new DownscrollOption("Change the layout of the strumline."),
						new GhostTapOption("Ghost Tapping is when you tap a direction and it doesn't give you a miss."),
						new Judgement("Controls (LEFT or RIGHT)."),
						#if desktop
						new FPSCapOption("Cap your FPS."),
						#end
						new ScrollSpeedOption("Change your scroll speed (1 = ChartDependent)."), 
						new AccuracyDOption("Change how accuracy is calculated (Accurate = Simple, Complex = Milisecond Based)."),
						new ResetButtonOption("Toggle pressing R to gameover."),
						// new OffsetMenu("Get a note offset based off of your inputs!"),
						new CustomizeGameplay("Drag'n'Drop Gameplay Modules around to your preference.")
					]),
					new OptionCategory("Appearance", [
						#if desktop
						new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay."),
						new RainbowFPSOption("Make the FPS Counter Rainbow."),
						new AccuracyOption("Display accuracy information."),
						new NPSDisplayOption("Shows your current Notes Per Second."),
						new SongPositionOption("Show the songs current position (as a bar)."),
						new CpuStrums("CPU's strumline lights up when a note hits it."),
						#else
						new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay.")
						#end
					]),
					new OptionCategory("Misc", [
						#if desktop
						new FPSOption("Toggle the FPS Counter."),
						new ReplayOption("View replays."),
						#end
						new FlashingLightsOption("Toggle flashing lights that can cause epileptic seizures and strain."),
						new WatermarkOption("Enable and disable all watermarks from the engine."),
						new BotPlay("Showcase your charts and mods with autoplay.")
					])
					
				];
			}
		}
	}
}
