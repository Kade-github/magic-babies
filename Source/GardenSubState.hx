
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.debug.watch.Watch;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.graphics.frames.FlxAtlasFrames;

class GardenSubState extends FlxSubState
{

    public var doUpdate = false;
    var gardenbackground:FlxSprite;
    var bga:FlxSprite;
    var f = 0;
    var i:Int;
    var j:Int;
    public var bar:FlxBar;
    public var border:FlxSprite;
    public var background:FlxSprite;
    public static var food:FlxSprite;
    public static var game:FlxSprite;
    public static var garden:FlxSprite;
    public static var shop:FlxSprite;
    public static var toy:FlxSprite;
    var BabyList:FlxTypedGroup<FlxSprite>;
    var g:Float;
    var c:Float;
    var isInGMenu:Bool;

    public static var pathArray:Array<String> = [];


    override function create()
    {

        BabyList = new FlxTypedGroup<FlxSprite>();

        trace("garden");   
        isInGMenu = true; 

        gardenbackground = new FlxSprite(70,62).loadGraphic("assets/gardenbackground.png");
        gardenbackground.setGraphicSize(Std.int(gardenbackground.width));
        gardenbackground.alpha = 0;
        add(gardenbackground);

        bga = new FlxSprite(280, 0).loadGraphic("assets/SANCTUARY.png");
        bga.setGraphicSize(Std.int(bga.width*1.5));
        bga.alpha = 0;
        add(bga);

        FlxTween.tween(gardenbackground, {alpha: 1},0.2);
        FlxTween.tween(bga, {alpha: 1},0.2);



        for(i in pathArray)
            babies(i,FlxG.random.int(160,400),FlxG.random.int(70,200));

        
        add(BabyList);

        bar = new FlxBar(140,FlxG.height - 140,FlxBarFillDirection.LEFT_TO_RIGHT,960,25,null,"",0,560);
        bar.antialiasing = true;
        bar.alpha = 0;
        
        add(bar);

        border = new FlxSprite(0,0).loadGraphic("assets/border.png");
        add(border);

        garden = new FlxSprite(490,FlxG.height - 80);
        garden.frames = FlxAtlasFrames.fromSparrow("assets/ui/gardenbutton.png","assets/ui/gardenbutton.xml");
        garden.setGraphicSize(Std.int(garden.width * .82));
        garden.animation.addByPrefix("init","garden0",30,false);
        garden.antialiasing = true;
        add(garden);
        
        toy = new FlxSprite(732,FlxG.height -80);
        toy.frames = FlxAtlasFrames.fromSparrow("assets/ui/toybutton.png","assets/ui/toybutton.xml");
        toy.setGraphicSize(Std.int(toy.width * .82));
        toy.animation.addByPrefix("init","toys0",30,false);
        add(toy);

        food = new FlxSprite(250,FlxG.height - 80);
        food.frames = FlxAtlasFrames.fromSparrow("assets/ui/foodbutton.png","assets/ui/foodbutton.xml");
        food.setGraphicSize(Std.int(food.width * .82));
        food.animation.addByPrefix("init","food0",30,false);
        add(food);


    }

    override function update(elapsed)
    {
        super.update(elapsed);

         if (doUpdate){
            return;
         }


         if (FlxG.keys.justPressed.ESCAPE)
        {
            gardenbackground.alpha = 0;
            bga.alpha = 0;
            garden.alpha = 0;
            toy.alpha = 0;
            food.alpha = 0;
            border.destroy();
            bar.destroy();
            for (i in 0...BabyList.members.length)
            {
                BabyList.remove(BabyList.members[i]);
            }
            MainUI.inAMenu = false;
            isInGMenu = false;
            doUpdate = true;
            closeSubState();
        }

        for(m in BabyList){
            if (FlxG.mouse.overlaps(m)){
            m.setGraphicSize(Std.int(m.width * 0.5));
            //m.animation.play("idle");
            }
            if (!FlxG.mouse.overlaps(m)){
            m.setGraphicSize(Std.int(m.width * 0.28));
            //m.animation.play("idlep");
            }

        }

        if (FlxG.mouse.pressed && !FlxG.mouse.overlaps(MainUI.food) && !FlxG.mouse.overlaps(MainUI.garden) && !FlxG.mouse.overlaps(MainUI.toy))
        {
                //bear with me this is dumb
                
                if(f==0){
                    i=FlxG.mouse.x;
                    j=FlxG.mouse.y;
                }
                /*
                //trace("grabbed background");
                bga.x = bga.x + FlxG.mouse.x - i;
                bga.y = bga.y + FlxG.mouse.y - j;
                a++;
                */
                    if(f%2 == 0)
                    {
                        bga.x = FlxG.mouse.x - (i - bga.x);
                        bga.y = FlxG.mouse.y - (j - bga.y);
                        babiesMoving();
                        i=FlxG.mouse.x;
                        j=FlxG.mouse.y;
                    }
                    if(200>=bga.x){  
                            bga.x = 201;
                        }
                        if(bga.x>=400){
                            bga.x = 399;
                        }
                        if(-125>=bga.y){
                            bga.y = -124;
                        }
                        if(bga.y>=250){
                            bga.y = 249;
                        }
                    
                    f++;
                    
               
                }
        if (FlxG.mouse.justReleased)
        {
            f=0;
           
        }

    }
    public function babies(bab:String,x:Int,y:Int)
    {
    //n1,b2,h3
        trace('loading assets/${bab}.png');
        var baby = new FlxSprite(x,y);
        baby.frames = FlxAtlasFrames.fromSparrow('assets/${bab}.png','assets/${bab}.xml');
        baby.setGraphicSize(Std.int(baby.width * .28));
        baby.animation.addByPrefix('idlep','idle0000');
        baby.animation.addByPrefix('idle','idle');
        BabyList.add(baby);


    }

    public function babiesMoving(){
        for(m in BabyList.members)
        {
            m.x = FlxG.mouse.x - (i - m.x);
            m.y = FlxG.mouse.y - (j - m.y);
            g = m.x - bga.x;
            c = m.y - bga.y;
            if(200>=bga.x){  
            m.x = 201+g;
            }
            if(bga.x>=400){
            m.x = 399+g;
            }
            if(-125>=bga.y){
            m.y = -124+c;
            }
            if(bga.y>=250){
            m.y = 249+c;
            }
            

            
        }
        
    }

}