import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.atlas.FlxAtlas;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.FlxSprite;

class ToysSubState extends FlxSubState
{
    var blackThing:FlxSprite;

    var toys:FlxTypedGroup<FlxSprite>;
    public var selected:FlxSprite;

    override function create()
    {
        blackThing = new FlxSprite(70,62).makeGraphic(1138,557,FlxColor.BLACK);
        blackThing.alpha = 0;
        add(blackThing);

        toys = new FlxTypedGroup<FlxSprite>();

        toys.add(createToy("ball",80,80));
        toys.add(createToy("game",241,70));
        toys.add(createToy("mouse",402,80));

        for(i in toys.members)
            i.alpha = 0;

        add(toys);

        FlxTween.tween(blackThing,{alpha: 0.5},0.2,{onComplete: function(tween:FlxTween) {
            for(i in toys.members)
                FlxTween.tween(i, {alpha: 1},0.1);
        }});
    }

    function createToy(toy:String,x,y):FlxSprite
    {
        var sprite = new FlxSprite(x,y);

        sprite.frames = FlxAtlasFrames.fromSparrow("assets/toys.png","assets/toys.xml");
        sprite.animation.addByPrefix("toy",toy);
        sprite.animation.play("toy");

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
            for(i in toys.members)
                i.alpha = 0;
            MainUI.inAMenu = false;
            doUpdate = true;
            closeSubState();
        }

        if (FlxG.mouse.justPressed)
        {
            for(i in toys.members)
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
                MainUI.instance.addToy(selected);

                FlxTween.tween(blackThing,{alpha: 0},0.01);
                for(i in 0...toys.members.length)
                {
                    toys.remove(toys.members[i]);
                }
                MainUI.inAMenu = false;
                doUpdate = true;
                closeSubState();
            }
        }
    }
}