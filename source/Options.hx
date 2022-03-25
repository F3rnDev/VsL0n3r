package;

import lime.app.Application;
import lime.system.DisplayMode;
import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class OptionCategory
{
	private var _options:Array<Option> = new Array<Option>();
	public final function getOptions():Array<Option>
	{
		return _options;
	}

	private var _hasCat:Bool = false;
	public final function checkCat():Bool{
		return _hasCat;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	
	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Category";
	public final function getName() {
		return _name;
	}

	public function new (catName:String, options:Array<Option>, hasMoreCat:Bool)
	{
		_name = catName;
		_options = options;
		_hasCat = hasMoreCat;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}
	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;
	private var languageTxt:Array<String> = ["", ""];
	private var curLang:String = LanguageState.langString; //Writing LanguageState all the time is kinda boring, so i made a variable for it


	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	public function getValue():String { return throw "stub!"; };
	
	// Returns whether the label is to be updated.
	public function press():Bool { return throw "stub!"; }
	private function updateDisplay():String { return throw "stub!"; }
	public function left():Bool { return throw "stub!"; }
	public function right():Bool { return throw "stub!"; }
}



class DFJKOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		OptionsMenu.instance.openSubState(new KeyBindMenu());
		return false;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Atalhos do Teclado";
			case 'Eng':
				languageTxt[0] = "Key Bindings";
		}

		return languageTxt[0];
	}
}

class CpuStrums extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.cpuStrums = !FlxG.save.data.cpuStrums;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "setas do Cpu " + (FlxG.save.data.cpuStrums ? "ligam" : "nao ligam");
			case 'Eng':
				languageTxt[0] = FlxG.save.data.cpuStrums ? "Light CPU Strums" : "CPU Strums stay static";
		}

		return languageTxt[0];
	}

}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.downscroll ? "Downscroll" : "Upscroll";
	}
}

class GhostTapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.ghost = !FlxG.save.data.ghost;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = FlxG.save.data.ghost ? "Com Ghost Tapping" : "Sem Ghost Tapping";
			case 'Eng':
				languageTxt[0] = FlxG.save.data.ghost ? "Ghost Tapping" : "No Ghost Tapping";
		}

		return languageTxt[0];
	}
}

class AccuracyOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Precisao " + (!FlxG.save.data.accuracyDisplay ? "off" : "on");
			case 'Eng':
				languageTxt[0] = "Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on");
		}

		return languageTxt[0];
	}
}

class SongPositionOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Posicao da Musica " + (!FlxG.save.data.songPosition ? "off" : "on");
			case 'Eng':
				languageTxt[0] = "Song Position " + (!FlxG.save.data.songPosition ? "off" : "on");
		}

		return languageTxt[0];
	}
}

class DistractionsAndEffectsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.distractions = !FlxG.save.data.distractions;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Distracoes " + (!FlxG.save.data.distractions ? "off" : "on");
			case 'Eng':
				languageTxt[0] = "Distractions " + (!FlxG.save.data.distractions ? "off" : "on");
		}

		return languageTxt[0];
	}
}

class ResetButtonOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.resetButton = !FlxG.save.data.resetButton;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Botao de Reset " + (!FlxG.save.data.resetButton ? "off" : "on");
			case 'Eng':
				languageTxt[0] = "Reset Button " + (!FlxG.save.data.resetButton ? "off" : "on");
		}

		return languageTxt[0];
	}
}

class FlashingLightsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.flashing = !FlxG.save.data.flashing;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Luzes Piscantes " + (!FlxG.save.data.flashing ? "off" : "on");
			case 'Eng':
				languageTxt[0] = "Flashing Lights " + (!FlxG.save.data.flashing ? "off" : "on");
		}
		
		return languageTxt[0];
	}
}

class Judgement extends Option
{


	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}
	
	public override function press():Bool
	{
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Frames Seguros";
			case 'Eng':
				languageTxt[0] = "Safe Frames";
		}

		return languageTxt[0];
	}

	override function left():Bool {

		if (Conductor.safeFrames == 1)
			return false;

		Conductor.safeFrames -= 1;
		FlxG.save.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();
		return true;
	}

	override function getValue():String {
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[1] = "Frames Seguros: " + Conductor.safeFrames +
				" - SIK: " + HelperFunctions.truncateFloat(45 * Conductor.timeScale, 0) +
				"ms GD: " + HelperFunctions.truncateFloat(90 * Conductor.timeScale, 0) +
				"ms BD: " + HelperFunctions.truncateFloat(135 * Conductor.timeScale, 0) + 
				"ms SHT: " + HelperFunctions.truncateFloat(155 * Conductor.timeScale, 0) +
				"ms TOTAL: " + HelperFunctions.truncateFloat(Conductor.safeZoneOffset,0) + "ms";

			case 'Eng':
				languageTxt[1] = "Safe Frames: " + Conductor.safeFrames +
				" - SIK: " + HelperFunctions.truncateFloat(45 * Conductor.timeScale, 0) +
				"ms GD: " + HelperFunctions.truncateFloat(90 * Conductor.timeScale, 0) +
				"ms BD: " + HelperFunctions.truncateFloat(135 * Conductor.timeScale, 0) + 
				"ms SHT: " + HelperFunctions.truncateFloat(155 * Conductor.timeScale, 0) +
				"ms TOTAL: " + HelperFunctions.truncateFloat(Conductor.safeZoneOffset,0) + "ms";
		}
		
		return languageTxt[1];
	}

	override function right():Bool {

		if (Conductor.safeFrames == 20)
			return false;

		Conductor.safeFrames += 1;
		FlxG.save.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();
		return true;
	}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fps = !FlxG.save.data.fps;
		(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Medidor de Fps " + (!FlxG.save.data.fps ? "off" : "on");
			case 'Eng':
				languageTxt[0] = "FPS Counter " + (!FlxG.save.data.fps ? "off" : "on");
		}
		
		return languageTxt[0];
	}
}

class FPSCapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Limite de Fps";
			case 'Eng':
				languageTxt[0] = "FPS Cap";
		}
		
		return languageTxt[0];
	}
	
	override function right():Bool {
		if (FlxG.save.data.fpsCap >= 290)
		{
			FlxG.save.data.fpsCap = 290;
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);
		}
		else
			FlxG.save.data.fpsCap = FlxG.save.data.fpsCap + 10;
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		return true;
	}

	override function left():Bool {
		if (FlxG.save.data.fpsCap > 290)
			FlxG.save.data.fpsCap = 290;
		else if (FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = Application.current.window.displayMode.refreshRate;
		else
			FlxG.save.data.fpsCap = FlxG.save.data.fpsCap - 10;
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
		return true;
	}

	override function getValue():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[1] = "Limite de Fps Atual: " + FlxG.save.data.fpsCap + 
				(FlxG.save.data.fpsCap == Application.current.window.displayMode.refreshRate ? "Hz (Taxa de Atualização)" : "");
			case 'Eng':
				languageTxt[1] = "Current FPS Cap: " + FlxG.save.data.fpsCap + 
				(FlxG.save.data.fpsCap == Application.current.window.displayMode.refreshRate ? "Hz (Refresh Rate)" : "");
		}

		return languageTxt[1];
	}
}


class ScrollSpeedOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Velocidade de Scroll";
			case 'Eng':
				languageTxt[0] = "Scroll Speed";
		}
		
		return languageTxt[0];
	}

	override function right():Bool {
		FlxG.save.data.scrollSpeed += 0.1;

		if (FlxG.save.data.scrollSpeed < 1)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.scrollSpeed > 4)
			FlxG.save.data.scrollSpeed = 4;
		return true;
	}

	override function getValue():String {
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[1] = "Velocidade de Scroll Atual: " + HelperFunctions.truncateFloat(FlxG.save.data.scrollSpeed,1);
			case 'Eng':
				languageTxt[1] = "Current Scroll Speed: " + HelperFunctions.truncateFloat(FlxG.save.data.scrollSpeed,1);
		}
		
		return languageTxt[1];
	}

	override function left():Bool {
		FlxG.save.data.scrollSpeed -= 0.1;

		if (FlxG.save.data.scrollSpeed < 1)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.scrollSpeed > 4)
			FlxG.save.data.scrollSpeed = 4;

		return true;
	}
}


class RainbowFPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fpsRain = !FlxG.save.data.fpsRain;
		(cast (Lib.current.getChildAt(0), Main)).changeFPSColor(FlxColor.WHITE);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Rainbow " + (!FlxG.save.data.fpsRain ? "off" : "on");
	}
}

class NPSDisplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.npsDisplay = !FlxG.save.data.npsDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Exibicao de NPS " + (!FlxG.save.data.npsDisplay ? "off" : "on");
			case 'Eng':
				languageTxt[0] = "NPS Display " + (!FlxG.save.data.npsDisplay ? "off" : "on");
		}
		
		return languageTxt[0];
	}
}

class ReplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new LoadReplayState());
		return false;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Carregar Replays";
			case 'Eng':
				languageTxt[0] = "Load replays";
		}
		
		return languageTxt[0];
	}
}

class AccuracyDOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		FlxG.save.data.accuracyMod = FlxG.save.data.accuracyMod == 1 ? 0 : 1;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Presisao Tipo " + (FlxG.save.data.accuracyMod == 0 ? "Precisa" : "Complexa");
			case 'Eng':
				languageTxt[0] = "Accuracy Mode: " + (FlxG.save.data.accuracyMod == 0 ? "Accurate" : "Complex");
		}
		
		return languageTxt[0];
	}
}

class CustomizeGameplay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new GameplayCustomizeState());
		return false;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Customizar a Gameplay";
			case 'Eng':
				languageTxt[0] = "Customize Gameplay";
		}
		
		return languageTxt[0];
	}
}

class WatermarkOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		Main.watermarks = !Main.watermarks;
		FlxG.save.data.watermark = Main.watermarks;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Marca da Agua " + (Main.watermarks ? "on" : "off");
			case 'Eng':
				languageTxt[0] = "Watermarks " + (Main.watermarks ? "on" : "off");
		}
		
		return languageTxt[0];
	}
}

class OffsetMenu extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		
		PlayState.SONG = Song.loadFromJson("tutorial");
		PlayState.isStoryMode = false;
		Diff.diffID = 0;
		PlayState.storyWeek = 0;
		PlayState.offsetTesting = true;
		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Time your offset";
	}
}
class BotPlay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		FlxG.save.data.botplay = !FlxG.save.data.botplay;
		trace('BotPlay : ' + FlxG.save.data.botplay);
		display = updateDisplay();
		return true;
	}
	
	private override function updateDisplay():String
		return "BotPlay " + (FlxG.save.data.botplay ? "on" : "off");
}

class Fullscreen extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;

	}

	public override function press():Bool
	{
		FlxG.save.data.fullscreen = !FlxG.save.data.fullscreen;	
		display = updateDisplay();
		
		if (FlxG.save.data.fullscreen)
			FlxG.fullscreen = true;
		else
			FlxG.fullscreen = false;

		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Tela Cheia " + (!FlxG.save.data.fullscreen ? "off" : "on");
			case 'Eng':
				languageTxt[0] = "Fullscreen " + (!FlxG.save.data.fullscreen ? "off" : "on");
		}

		return languageTxt[0];
	}
}

class ArrowParticles extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.arrowParticles = !FlxG.save.data.arrowParticles;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Particulas " + (!FlxG.save.data.arrowParticles ? "off" : "on");
			case 'Eng':
				languageTxt[0] = "Particles " + (!FlxG.save.data.arrowParticles ? "off" : "on");
		}
		
		return languageTxt[0];
	}
}

class LanguageOption extends Option{
	var lang_cur_txt:String;
	var lang_cur_id:Int;
	var lang_selected:String; //checks if the current language checks with the selected language

	public function new(desc:String)
	{
		super();

		switch(curLang){
			case 'PtBr':
				lang_cur_id = 0;
			case 'Eng':
				lang_cur_id = 1;
		}
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		if (curLang != lang_selected){ //so it won't reset everytime you press enter
			curLang = lang_selected;
			LanguageState.langString = curLang;
			FlxG.save.data.language = curLang; //saving this to when you restart the game

			FlxG.resetState();
		}

		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':{
				languageTxt[0] = 'Mude a Linguagem';
			}
			case 'Eng':{
				languageTxt[0] = 'Change the Language';
			}
		}
		
		return languageTxt[0];
	}

	override function right():Bool {
		lang_cur_id++;

		if (lang_cur_id > 1){ //change if ya add more languages
			lang_cur_id = 0;
		}

		return true;
	}

	override function getValue():String {
		check_lang_txt(); //making a bit more clean

		switch(curLang)
		{
			case 'PtBr':{
				languageTxt[1] = "Lingua Selecionada: " + lang_cur_txt;
			}
			case 'Eng':{
				languageTxt[1] = "Selected Language: " + lang_cur_txt;
			}
		}
		
		return languageTxt[1];
	}

	override function left():Bool {
		lang_cur_id--;

		if (lang_cur_id < 0){
			lang_cur_id = 1;
		}

		return true;
	}

	private function check_lang_txt(){
		switch (lang_cur_id){
			case 0:{
				lang_cur_txt = 'Português(Brasil)';
				lang_selected = 'PtBr';
			}
			case 1:{
				lang_cur_txt = 'English';
				lang_selected = 'Eng';
			}
		}
	}
}

class OpponentMode extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.opponent = !FlxG.save.data.opponent;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		switch(curLang)
		{
			case 'PtBr':
				languageTxt[0] = "Jogue como " + (!FlxG.save.data.opponent ? "Jogador" : "Oponente");
			case 'Eng':
				languageTxt[0] = "Play as " + (!FlxG.save.data.opponent ? "Player" : "Opponent");
		}
		
		return languageTxt[0];
	}
}