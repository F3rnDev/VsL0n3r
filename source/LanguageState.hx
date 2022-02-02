package;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.graphics.FlxGraphic;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

class LanguageState extends MusicBeatState
{
    public static var curLanguage:Int = 1;

    var languageOption:Array<String> = ['brazil', 'english'];

    var menuItems:FlxTypedGroup<FlxSprite>;

    //textStuff
    var text1:FlxText;
    var text2:FlxText;

    //just a copy and paste of MainMenuState
    
    override function create()
    {   
        //Fade In 
        FlxG.camera.fade(FlxColor.BLACK, 2 ,true);

        //TransitionData
        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
        diamond.persist = true;

        FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width*1.4, FlxG.height*1.4));
        FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), {asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width*1.4, FlxG.height*1.4));

        transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

        //Add Objects
        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);

       
        // WARNING
        text1 = new FlxText(0, 20, 0, '', 50);
        text1.color = FlxColor.BLACK;
        text1.screenCenter(X);
        text1.setBorderStyle(OUTLINE_FAST, FlxColor.RED, 2);
        text1.antialiasing = true;
        add(text1);
        

        text2 = new FlxText(0, 100, 0, '', 35);
        text2.screenCenter(X);
        text2.setBorderStyle(SHADOW, FlxColor.RED, 2);
        text2.antialiasing = true;
        add(text2);

        //warningTweens
        FlxTween.tween(text1, {y: 40}, 2, {ease: FlxEase.smoothStepInOut, type: PINGPONG});
        FlxTween.tween(text2, {y: 120}, 2, {ease: FlxEase.smoothStepInOut, type: PINGPONG});
       
        // END

        //ADING THE FLAGS SPRITES
        menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);

        var tex:FlxAtlasFrames = Paths.getSparrowAtlas('flags');
        
        for (i in 0...languageOption.length)
        {
                var menuItem: FlxSprite = new FlxSprite(300, 0);
                menuItem.frames = tex;
                menuItem.animation.addByPrefix('idle', languageOption[i] + " basic", 24);
                menuItem.animation.addByPrefix('selecting', languageOption[i] + " white", 24);
                menuItem.animation.addByPrefix('selected', languageOption[i] + " yellow", 24, false);
                menuItem.animation.play('selecting');
                menuItem.ID = i;
                menuItem.screenCenter(Y);
                menuItems.add(menuItem);
                menuItem.antialiasing = false;
                menuItem.x = 300 + (i * 450);
        } 

        FlxG.mouse.visible = false;
                
        changeItem();
    }

    var selectedSomethin:Bool = false;

    override function update(elapsed:Float)
    {
        
        if(!selectedSomethin)
        {
            if(FlxG.keys.anyJustPressed([RIGHT, D]))
            {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                changeItem(1);
            }

            if(FlxG.keys.anyJustPressed([LEFT, A]))
            {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                changeItem(-1);
            }

            if(FlxG.keys.justPressed.ENTER)
            {
                selectedSomethin = true;
                FlxG.sound.play(Paths.sound('confirmMenu'));
                
                FlxG.camera.flash(FlxColor.WHITE, 1);
                new FlxTimer().start(1, function(tmr:FlxTimer)
                {
                    FlxG.switchState(new TitleState());
                });

                changeItem();
            }

        }
        super.update(elapsed);
    }

    function changeItem(huh:Int = 0)
    {
        curLanguage += huh;

        if (curLanguage >= menuItems.length)
        {
            curLanguage = 0;
        }
        if (curLanguage < 0)
        {
            curLanguage = menuItems.length - 1;
        }

        switch(curLanguage)
        {
            case 0:
                text1.text = 'AVISO';
                text2.text = 'O sistema de linguagem ainda está em desenvolvimento';

                //update centering
                text1.screenCenter(X);
                text2.screenCenter(X);

            case 1:
                text1.text = 'WARNING';
                text2.text = 'The language system is still in development';

                //update centering
                text1.screenCenter(X);
                text2.screenCenter(X);
        }

        menuItems.forEach(function(spr:FlxSprite)
        {
            spr.animation.play('idle');
            spr.offset.set(0, 0);

            if (spr.ID == curLanguage)
            {
                if (!selectedSomethin)  
                {  
                    spr.animation.play('selecting');
                    spr.offset.set(25, 25);
                }
                else
                {
                    spr.animation.play('selected');
                    spr.offset.set(25, 25);
                }
            }

        });

    }

}    
