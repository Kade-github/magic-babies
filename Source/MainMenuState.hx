import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.TransitionData;
import io.newgrounds.NG;
import flixel.text.FlxText;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import openfl.Assets;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import flixel.addons.display.FlxGridOverlay;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

class MainMenuState extends FlxUIState
{
    public static var newgrounds:NGio;

    var bopper:FlxSprite;
    var bopperPressed:FlxSprite;
    var enterer:FlxSprite;
    var whenYouPressed:FlxSprite;
    var gridBG:FlxBackdrop;
    var text:FlxText;

    override function create()
    {
        // newgrounds = new NGio("","");


        
        FlxG.sound.playMusic("assets/music/title/title_loop.ogg");

        gridBG = new FlxBackdrop(FlxGridOverlay.createGrid(40,40,1280,720,true, FlxColor.fromRGB(197, 139, 231), FlxColor.fromRGB(255, 183, 197)));

        gridBG.velocity.x = 20;
        gridBG.velocity.y = 20;

        persistentUpdate = true;

        add(gridBG);

        bopper = new FlxSprite((1280 / 2) - 545,(720 / 2) - 470);
        bopper.frames = FlxAtlasFrames.fromSparrow("assets/logobump.png","assets/logobump.xml");
        bopper.setGraphicSize(Std.int(bopper.width * 0.5));
        bopper.animation.addByPrefix("frick","logobump");

        bopperPressed = new FlxSprite((1280 / 2) - 895,(720 / 2) - 620);
        bopperPressed.frames = FlxAtlasFrames.fromSparrow("assets/logopressed.png","assets/logopressed.xml");
        bopperPressed.setGraphicSize(Std.int(bopperPressed.width * 0.5));
        bopperPressed.animation.addByPrefix("frick","logopressed");

        add(bopper);

        enterer = new FlxSprite((1280 / 2) - 460,(720 / 2) + 150);
        enterer.frames = FlxAtlasFrames.fromSparrow("assets/presstostart.png","assets/presstostart.xml");
        enterer.animation.addByPrefix("frick","press_to_start");

        bopper.animation.play("frick");
        enterer.animation.play("frick");

        whenYouPressed = new FlxSprite(enterer.x,enterer.y);
        whenYouPressed.frames = FlxAtlasFrames.fromSparrow("assets/pressedenter.png","assets/pressedenter.xml");
        whenYouPressed.animation.addByPrefix("frick","pressed_enter");

        add(enterer);

        add(whenYouPressed);
        add(bopperPressed);

        whenYouPressed.visible = false;
        bopperPressed.visible = false;

        text = new FlxText((1280/2) - 195, FlxG.height - 40, 0, "Version 1x - " + (NGio.isLoggedIn ? "Logged in as " + NGio.username : "Not logged into newgrounds"));
        text.setFormat("Chinacat",18,FlxColor.WHITE,FlxTextAlign.CENTER,FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
        text.borderSize = 2;
        text.borderQuality = 2;
        add(text);

        var vigi = new FlxSprite(0,0).loadGraphic("assets/vignette.png");
        add(vigi);

        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
        diamond.persist = true;
        diamond.destroyOnNoUse = false;

        FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.4, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
            new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
        FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.4, new FlxPoint(0, 1),
            {asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

        transIn = FlxTransitionableState.defaultTransIn;
        transOut = FlxTransitionableState.defaultTransOut;
    }

    var pressed = false;
    
    override function update(elapsed)
    {
        text.text = "Version 1x - " + (NGio.isLoggedIn ? "Logged in as " + NGio.username : "Not logged into newgrounds");

        if (FlxG.keys.justPressed.ENTER && !pressed)
        {
            FlxG.sound.playMusic("assets/music/title/title_end_short.ogg",1,false);
            bopper.visible = false;
            enterer.visible = false;
            whenYouPressed.visible = true;
            bopperPressed.visible = true;
            whenYouPressed.animation.play("frick");
            bopperPressed.animation.play("frick");
            pressed = true;
            FlxG.camera.flash(FlxColor.WHITE,0.4,function() {
                FlxG.switchState(new MainUI());
            });

            FlxG.sound.play("assets/sfx/all/4_select1.ogg");
        }

        super.update(elapsed);
    }

}