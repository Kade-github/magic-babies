package;
import flixel.ui.FlxBar;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIState;
import flixel.FlxG;


class MainUI extends FlxUIState
{
    public static var instance:MainUI;
    public static var currentBaby:Baby;  

    public var border:FlxSprite;
    public var background:FlxSprite;

    //menu buttons
    public static var food:FlxSprite;
    public static var game:FlxSprite;
    public static var garden:FlxSprite;
    public static var shop:FlxSprite;
    public static var toy:FlxSprite;

    public var blackSprite:FlxSprite;

    public static var inAMenu:Bool = true;
    public var menu:String = "";

    public var fuck:FlxText;
    public var fuckYou:FlxText;

    public var egg:FlxSprite;

    public var foodHolding:FlxSprite;
    public var toyHolding:FlxSprite;
    public var bar:FlxBar;

    override function create()
    {
        FlxG.sound.music.stop();
                
        transIn = FlxTransitionableState.defaultTransIn;
        transOut = FlxTransitionableState.defaultTransOut;
        instance = this;
        destroySubStates = true;

        //var mockupUI:FlxSprite = new FlxSprite(0,0).loadGraphic("assets/mockUp.png");
        //add(mockupUI);

        FlxG.sound.playMusic("assets/music/main_screen/egg_main.ogg",1,false);

        persistentUpdate = true;
        persistentDraw = true;

        background = new FlxSprite(0,0).loadGraphic("assets/background.png");
        add(background);

        currentBaby = new Baby((1280/2) - 145,720/2 + 100);
        currentBaby.visible = false;
        add(currentBaby);

        egg = new FlxSprite((1280/2) - 95,720/2 - 35);
        egg.frames = FlxAtlasFrames.fromSparrow("assets/egg.png","assets/egg.xml");
        egg.animation.addByPrefix("idle","idle");
        egg.animation.addByPrefix("hatching","hatching",30,false);
        egg.animation.addByPrefix("hatched","hatched",30,false);
        egg.antialiasing = true;

        egg.setGraphicSize(Std.int(egg.width * 1.38));

        egg.animation.play("idle");

        add(egg);



        
        bar = new FlxBar(140,FlxG.height - 140,FlxBarFillDirection.LEFT_TO_RIGHT,960,25,null,"",0,560);
        bar.antialiasing = true;
        bar.alpha = 0;
        
        add(bar);

        border = new FlxSprite(0,0).loadGraphic("assets/border.png");
        add(border);

        food = new FlxSprite(250,FlxG.height - 80);
        food.frames = FlxAtlasFrames.fromSparrow("assets/ui/foodbutton.png","assets/ui/foodbutton.xml");
        food.setGraphicSize(Std.int(food.width * .82));
        food.animation.addByPrefix("init","food0",30,false);
        food.animation.addByPrefix("pressed","foodpressed",30,false);
        food.antialiasing = true;
        add(food);

        var iconFood:FlxSprite = new FlxSprite(55,40).loadGraphic("assets/ui/food_icon.png");
        iconFood.antialiasing = true;
        iconFood.setGraphicSize(Std.int(iconFood.width * 0.4));
        add(iconFood);

        fuck = new FlxText(170,95,0,currentBaby.food + "");
        fuck.setFormat("Chinacat",18,FlxColor.WHITE,FlxTextAlign.CENTER,FlxTextBorderStyle.OUTLINE,FlxColor.fromRGB(86,130,213));
        fuck.borderSize = 2;
        fuck.borderQuality = 2;
        add(fuck);

            
        var iconHealth:FlxSprite = new FlxSprite(60,110).loadGraphic("assets/ui/heart_icon.png");
        iconHealth.antialiasing = true;
        iconHealth.setGraphicSize(Std.int(iconHealth.width * 0.4));
        add(iconHealth);

        fuckYou = new FlxText(170,165,0,currentBaby.hp + "");
        fuckYou.setFormat("Chinacat",18,FlxColor.WHITE,FlxTextAlign.CENTER,FlxTextBorderStyle.OUTLINE,FlxColor.fromRGB(86,130,213));
        fuckYou.borderSize = 2;
        fuckYou.borderQuality = 2;
        add(fuckYou);


        garden = new FlxSprite(490,FlxG.height - 80);
        garden.frames = FlxAtlasFrames.fromSparrow("assets/ui/gardenbutton.png","assets/ui/gardenbutton.xml");
        garden.setGraphicSize(Std.int(food.width * .82));
        garden.animation.addByPrefix("init","garden0",30,false);
        garden.animation.addByPrefix("pressed","gardenpressed",30,false);
        garden.antialiasing = true;
        add(garden);

        toy = new FlxSprite(732,FlxG.height -80);
        toy.frames = FlxAtlasFrames.fromSparrow("assets/ui/toybutton.png","assets/ui/toybutton.xml");
        toy.setGraphicSize(Std.int(toy.width * .82));
        toy.animation.addByPrefix("init","toys0",30,false);
        toy.animation.addByPrefix("pressed","toyspressed",30,false);
        toy.antialiasing = true;
        add(toy);


        food.alpha = 0;
        garden.alpha = 0;
        toy.alpha = 0;
        border.alpha = 0;
        fuckYou.alpha = 0;
        fuck.alpha = 0;
        iconFood.alpha = 0;
        iconHealth.alpha = 0;
        new FlxTimer().start(7,function(timer) {
            FlxG.sound.music.fadeOut(0.2);
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
                    FlxG.sound.playMusic("assets/music/main_screen/baby_main2.ogg");
                    egg.animation.play("hatched");
                    egg.offset.set(40,30);
                    inAMenu = false;
                    FlxTween.tween(egg, {alpha: 0}, 2);
                    FlxTween.tween(food, {alpha: 1}, 2);
                    FlxTween.tween(garden, {alpha: 1}, 2);
                    FlxTween.tween(toy, {alpha: 1}, 2);
                    FlxTween.tween(border, {alpha: 1}, 2);
                    FlxTween.tween(fuckYou, {alpha: 1}, 2);
                    FlxTween.tween(fuck, {alpha: 1}, 2);
                    FlxTween.tween(iconFood, {alpha: 1}, 2);
                    FlxTween.tween(iconHealth, {alpha: 1}, 2);
                }
            }
        });



        blackSprite = new FlxSprite(0,0).makeGraphic(1280,720,FlxColor.BLACK);
        blackSprite.alpha = 0.99;
        FlxTween.tween(blackSprite,{alpha: 0}, 8);
        add(blackSprite);
    }
    
    public function addFood(sprite:FlxSprite)
    {
        foodHolding = sprite;
        add(foodHolding);
    }

        
    public function addToy(sprite:FlxSprite)
    {
        toyHolding = sprite;
        add(toyHolding);
    }


    override function update(elapsed) 
    {
        super.update(elapsed);
        
        if (currentBaby.timer != null)
            bar.value = Math.round(currentBaby.timer.elapsedTime);
        else
            bar.value = 0;

        fuck.text = Std.int(currentBaby.food) + "";
        fuckYou.text = Std.int(currentBaby.hp) + "";

        if (FlxG.keys.justPressed.ALT) // little cheat code for the boys
            bar.alpha = bar.alpha != 0.2 ? 0.2 : 0;

        #if debug
        if (FlxG.keys.justPressed.ONE)
            currentBaby.nextBaby();
        if (FlxG.keys.justPressed.TWO)
            currentBaby.careState = "high-care";
        if (FlxG.keys.justPressed.THREE)
            currentBaby.careState = "neutral";
        if (FlxG.keys.justPressed.FOUR)
            currentBaby.careState = "neglected";
        #end

        if (FlxG.mouse.pressed)
        {
            if (foodHolding != null)
            {
                foodHolding.x = FlxG.mouse.x - (foodHolding.width / 2);
                foodHolding.y = FlxG.mouse.y - (foodHolding.height / 2);
            }
            if (toyHolding != null)
            {
                toyHolding.x = FlxG.mouse.x - (toyHolding.width / 2);
                toyHolding.y = FlxG.mouse.y - (toyHolding.height / 2);
            }
        }

        if (FlxG.mouse.justReleased)
        {
            if (foodHolding != null)
            {
                trace("released food");
                if (FlxG.mouse.overlaps(currentBaby))
                    currentBaby.eat();
                remove(foodHolding);
                foodHolding.destroy();
                foodHolding = null;
            }
            if (toyHolding != null)
            {
                trace("released toy");
                if (FlxG.mouse.overlaps(currentBaby))
                    currentBaby.playToy();
                remove(toyHolding);
                toyHolding.destroy();
                toyHolding = null;
            }
        }

        if (FlxG.mouse.justPressed)
        {
            if (!inAMenu)
            {
                if (FlxG.mouse.overlaps(food))
                {
                    food.animation.play("pressed");
                    food.offset.set(11,130);

                    FlxG.sound.play("assets/sfx/all/4_select1.ogg");

                    inAMenu = true;
                
                    food.animation.finishCallback = function(string:String)
                    {
                        if (string == "pressed")
                        {
                            openSubState(new FoodSubState());
                            //trace("staph");
                            food.animation.play("init");
                            food.animation.pause();
                            food.offset.set(0,0);
                        }
                    }
                }
                else if (FlxG.mouse.overlaps(garden))
                    {
                        garden.animation.play("pressed");
                        garden.offset.set(-10,65);
    
                        FlxG.sound.play("assets/sfx/all/4_select1.ogg");
                        inAMenu = true;
                        
                        garden.animation.finishCallback = function(string:String)
                        {
                            if (string == "pressed")
                            {
                                openSubState(new GardenSubState());
                                garden.animation.play("init");
                                garden.animation.pause();
                                garden.offset.set(0,0);
                            }
                        }
                    }
              
                else if (FlxG.mouse.overlaps(toy))
                        {
                            toy.animation.play("pressed");
                            toy.offset.set(-5,115);
            
                            FlxG.sound.play("assets/sfx/all/4_select1.ogg");

                            toy.animation.finishCallback = function(string:String)
                            {
                                if (string == "pressed")
                                {
                                    openSubState(new ToysSubState());
                                    //trace("staph");
                                    toy.animation.play("init");
                                    toy.animation.pause();
                                    toy.offset.set(0,0);
                                }
                            }
                        }
        
               
            }
            else
            {
            }   
        }
    }
}
