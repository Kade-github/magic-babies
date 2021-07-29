import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import haxe.Exception;
import openfl.Assets;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxSprite;

class Baby extends FlxSprite
{
    public var baby:Int = 0;

    public var timer:FlxTimer;

    public var careState:String = "";

    public var doing:String = "idle";

    public var food:Float = 100;
    public var hp:Float = 100;

    public var tree = -1;

    public var pathID:String = "";

    var startX:Float = 0;
    var startY:Float = 0;

    public var nextTrack = "";

    public function new(x:Float,y:Float)
    {
        super(x,y);

        startX = x;
        startY = y;

        baby = 0;
        careState = "baby";

        loadFrames(0,false);

        animation.play("idle");
    }

    public function loadFrames(type:Int, ?start:Bool = true)
    {
        if (start)
        {
            timer = new FlxTimer();
            feedTimer = new FlxTimer();
            feedTimer.start(60);
            timer.start(60, nextBaby);
        }

        var path = "";

        if (baby - 1 == 0)
        {
            trace("updating tree " + careState);
            switch(careState)
            {
                case "neutral":
                    nextTrack = "assets/music/main_screen/nuetral_main.ogg";
                    tree = 0;
                case "high-care":
                    nextTrack = "assets/music/main_screen/highcare_main.ogg";
                    tree = 1;
                case "neglected":
                    nextTrack = "assets/music/main_screen/neglected_main.ogg";
                    tree = 2;
            }
            trace(tree);
        }

        switch(tree)
        {
            case 0:
                path += "n";
            case 1:
                path += "a";
            case 2:
                path += "b";
            case -1:
                path += "baby";
        }

        if (type != 0)
            path += "00" + type;


        trace('loading assets/${path}.png');

        pathID = path;

        frames = FlxAtlasFrames.fromSparrow('assets/${path}.png','assets/${path}.xml');
        animation.addByPrefix('idle','idle');
        animation.addByPrefix('shidded','shidded');
        animation.addByPrefix('sleep','sleep');
        animation.addByPrefix('walk','walk');
        animation.addByPrefix('eat','eat');

        antialiasing = true;

        try
        {
            var text = Assets.getText('assets/${path}.txt');

            var data = text.split('\n');

            x += Std.parseInt(data[0]);
            y += Std.parseInt(data[1]);

            trace("New size: " + width * Std.parseFloat(data[2]));

            setGraphicSize(Std.int(width * Std.parseFloat(data[2])));

        }
        catch(e:Exception)
        {
            // nothin
        }

    }

    public function play(anim:String,?flipped:Bool = false,?offsetX:Int = 0,?offsetY:Int = 0)
    {
        animation.play(anim);
        flipX = flipped;
        offset.set(offsetX,offsetY);
    }

    var feedTimer:FlxTimer;
    var feedTime:Float = 0;

    override function update(elapsed)
    {
        super.update(elapsed);

        if (timer == null)
            return;

        var timeInSeconds = timer.elapsedTime;

        if (food >= 100)
            food = 100;

        if (timeInSeconds >= 10 || baby != 0)
        {
            feedTime = feedTimer.elapsedTime / 5;
            food -= 0.01 * feedTime;
            if (food < 80 && hp >= 20)
                hp -= 0.008 * feedTime;

            if (food < 0)
                food = 0;
            if (hp < 20)
                hp = 20;

            if (hp >= 92)
                careState = "high-care";
            else if (hp >= 50)
                careState = "neutral";
            else if (hp < 50)
                careState = "neglected";
        }

        FlxG.watch.addQuick("Current Stage", baby);
        FlxG.watch.addQuick("Current Care", careState);
        FlxG.watch.addQuick("Time alive", timeInSeconds);
        FlxG.watch.addQuick("Feed Time", feedTime);
        FlxG.watch.addQuick("Feed Time loss", 0.001 * feedTime);

    }

    public function eat()
    {
        if (animation.name != "idle")
            return;

        switch(pathID)
        {
            case "n002":
                play("eat",false,0,-100);
            default:
                play("eat");
            
        }

        new FlxTimer().start(1,function(timer:FlxTimer) {play("idle");});

        if (food + 8 >= 100)
            food = 100;
        else
            food += 8;

        switch(careState)
        {
            case "high-care":
                FlxG.sound.play("assets/sfx/high-care/3_eat.ogg");
            default:
                FlxG.sound.play("assets/sfx/neutral/2_misc1.ogg");
            case "neglected":
                FlxG.sound.play("assets/sfx/neglected/1_eat.ogg");
        }

        feedTimer.reset(60);
    }

    public function playToy()
    {
        if (animation.name != "idle")
            return;

        switch(pathID)
        {
            case "n002":
                play("eat",false,0,-100);
            default:
                play("eat");
            
        }

        new FlxTimer().start(1,function(timer:FlxTimer) {play("idle");});

        var value = hp + (4 * (food / 100));

        if (value >= 100)
            hp = 100;
        else
            hp = value;

        switch(careState)
        {
            case "high-care":
                FlxG.sound.play("assets/sfx/high-care/3_misc1.ogg");
            default:
                FlxG.sound.play("assets/sfx/neutral/2_misc1.ogg");
            case "neglected":
                FlxG.sound.play("assets/sfx/neglected/1_misc1.ogg");
        }
    }

    public function showText(string:String)
    {
        var text = new FlxText(0,0,0,string);
        text.screenCenter();
        text.y -= 250;
        text.x -= 100;
        text.updateHitbox();
        
        if (careState == "baby")
            text.x -= 145;

        text.setFormat("Chinacat",48,FlxColor.WHITE,FlxTextAlign.CENTER,FlxTextBorderStyle.OUTLINE,FlxColor.fromRGB(86,130,213));
        text.alpha = 1;

        trace(text);

        MainUI.instance.add(text);
        
        FlxTween.tween(text,{alpha:0},1.2,{onComplete: function(tween) {
            MainUI.instance.remove(text);
            text.destroy();
        }});
    }

    public function nextBaby(?timer:FlxTimer)
    {
        baby++;
        hp = 100;
        food = 100;

        if (NGio.isLoggedIn)
        {
            if (baby == 2)
            {
                switch(careState)
                {
                    case "high-care":
                        NGio.unlockMedal(64388);
                    case "neutral":
                        NGio.unlockMedal(64389);
                    case "neglected":
                        NGio.unlockMedal(64387);
                }
            }
        }
        

        FlxG.sound.music.fadeOut(0.4, 0, function(tween) {
            if (nextTrack != "" )
            {
                FlxG.sound.playMusic(nextTrack,0);
                FlxG.sound.music.fadeIn(0.4);
            }
        });

        if (baby == 3)
        {
            if (GardenSubState.pathArray.length - 1 + 1 == 40)
            {
                if (NGio.isLoggedIn)
                {
                    NGio.unlockMedal(64390);
                }
            }

            if (GardenSubState.pathArray.length - 1 + 1 <= 40)
                GardenSubState.pathArray.push(pathID);

            baby = 0;
            careState = "baby";
            tree = -1;
            x = startX;
            y = startY;
            loadFrames(0, false);
            if (GardenSubState.pathArray.length - 1 + 1 <= 40)
                showText("Sent off to the garden!");
            else
                showText("The garden is full!");
            var currentBaby = this;
            var egg = MainUI.instance.egg;
            egg.alpha = 1;
            egg.animation.play("hatching");
            egg.offset.set(6,2);
            FlxG.sound.play("assets/sfx/all/4_eggBreak.ogg");
            currentBaby.visible = true;
            currentBaby.loadFrames(0);
            currentBaby.play("idle");

            egg.animation.finishCallback = function(string)
            {
                if (string == "hatching")
                {
                    nextTrack = "assets/music/main_screen/baby_main2.ogg";
                    egg.animation.play("hatched");
                    FlxTween.tween(egg,{alpha: 0},1);
                    egg.offset.set(40,30);
                }
            }
            return;
        }

        trace(careState);

        if (careState == "baby")
            careState == "neutral";

        animation.stop();


        FlxG.sound.play("assets/music/misc/level_up.ogg");

        trace(baby + " - " + careState + " - tree " + tree);

        switch(baby)
        {
            case 1:
                loadFrames(0);
            case 2:
                switch(tree)
                {
                    case 0:
                        switch(careState)
                        {
                            case "neutral":
                                loadFrames(3);
                            case "high-care":
                                loadFrames(2);
                            case "neglected":
                                loadFrames(4);
                        }
                    case 1:
                        switch(careState)
                        {
                            case "neutral":
                                loadFrames(3);
                            case "high-care":
                                loadFrames(2);
                            case "neglected":
                                loadFrames(4);
                        }
                    case 2:
                        switch(careState)
                        {
                            case "neutral":
                                loadFrames(2);
                            case "high-care":
                                loadFrames(1);
                            case "neglected":
                                loadFrames(3);
                        }
                }
        }

        showText("Evolved!");

        animation.play("idle");
    }
    
}
