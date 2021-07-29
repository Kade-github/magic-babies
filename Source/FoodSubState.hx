import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.atlas.FlxAtlas;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.FlxSprite;

class FoodSubState extends FlxSubState
{
    var blackThing:FlxSprite;

    var food:FlxTypedGroup<FlxSprite>;
    public var selected:FlxSprite;

    override function create()
    {
        blackThing = new FlxSprite(70,62).makeGraphic(1138,557,FlxColor.BLACK);
        blackThing.alpha = 0;
        add(blackThing);

        food = new FlxTypedGroup<FlxSprite>();

        food.add(createFood("apple",80,80));
        food.add(createFood("cupcake",255,70));
        food.add(createFood("orange",430,80));
        food.add(createFood("roll", 605,80));

        for(i in food.members)
            i.alpha = 0;

        add(food);

        FlxTween.tween(blackThing,{alpha: 0.5},0.2,{onComplete: function(tween:FlxTween) {
            for(i in food.members)
                FlxTween.tween(i, {alpha: 1},0.1);
        }});
    }

    function createFood(food:String,x,y):FlxSprite
    {
        var sprite = new FlxSprite(x,y);

        sprite.frames = FlxAtlasFrames.fromSparrow("assets/food.png","assets/food.xml");
        sprite.animation.addByPrefix("food",food);
        sprite.animation.play("food");

        sprite.setGraphicSize(Std.int(sprite.width * 0.6));
        
        return sprite;
    }

    public var doUpdate = false;

    override function update(elapsed)
    {
        super.update(elapsed);

        if (doUpdate)
            return;

        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxTween.globalManager.clear();
            blackThing.alpha = 0;
            for(i in food.members)
                i.alpha = 0;
            MainUI.inAMenu = false;
            doUpdate = true;
            closeSubState();
        }

        if (FlxG.mouse.justPressed)
        {
            for(i in food.members)
            {
                if (FlxG.mouse.overlaps(i))
                {
                    selected = i;
                    break;
                }
            }

            if (selected != null)
            {
                FlxG.sound.play("assets/sfx/all/4_select2.ogg");
                selected.graphic.destroyOnNoUse = false;
                selected.graphic.persist = true;
                MainUI.instance.addFood(selected);

                trace("pog " + MainUI.instance.foodHolding);

                FlxTween.tween(blackThing,{alpha: 0},0.01);
                for(i in 0...food.members.length)
                {
                    food.remove(food.members[i]);
                }
                MainUI.inAMenu = false;
                doUpdate = true;
                closeSubState();
            }
        }
    }
}