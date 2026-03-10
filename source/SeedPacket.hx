import flixel.FlxSprite;
import flixel.FlxG;

class SeedPacket extends FlxSprite
{
    public var plantType:String;
    public var cost:Int;
    public var selected:Bool = false;
    public var currentSun:Int;
    public function new(x:Float, y:Float, plant:String, cost:Int)
    {
        super(x,y);

        plantType = plant;
        this.cost = cost;

        loadGraphic(Paths.image("pvz/packets/" + plant));
        scale.set(0.8,0.8);
        updateHitbox();
        scrollFactor.set();

        updateHighlight();
    }

    public function updateHighlight()
    {
        if(cost <= currentSun)
            alpha = 1;
        else
            alpha = 0.6;
    }
}