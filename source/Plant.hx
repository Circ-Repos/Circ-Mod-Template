import GridSprite;

class Plant extends GridSprite
{
    public var type:String = "peashooter";
    public var sunTimer:Float = 0;
    public var shootTimer:Float = 0;
    public var health:Int = 5;

    public function takeDamage(amount:Int):Void
    {
        health -= amount;
    }

    public function isDead():Bool
    {
        return health <= 0;
    }
    public function new(x:Float, y:Float, row:Int, col:Int,type:String)
    {
        super(x, y, row, col, type);
        switch(type)
        {
            case "peashooter":
                loadGraphic(Paths.image('pvz/peashooter')); 
                updateHitbox();
                x-=20;
            case "sunflower":
                loadGraphic(Paths.image('pvz/sunflower'));
            case "wallnut":
                loadGraphic(Paths.image('pvz/wallnut')); 
                health = 15;
                sunTimer = -1;
                shootTimer = -1;
            default:
                makeGraphic(80, 80, FlxColor.GRAY);
        }

    }
}