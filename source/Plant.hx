import GridSprite;

class Plant extends GridSprite
{
    public var type:String = "peashooter";
    public var sunTimer:Float = 0;
    public var shootTimer:Float = 0;
    public var health:Int = 300;
    public var attacker = false;
    public var generator = false;

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
                attacker = true;
                x-=20;
            case "sunflower":
                loadGraphic(Paths.image('pvz/sunflower'));
                attacker = false;
                generator = true;
                sunTimer = 8;
            case "wallnut":
                loadGraphic(Paths.image('pvz/wallnut')); 
                health = 4000;
                attacker = false;
            default:
                trace('error in types');
                makeGraphic(80, 80, FlxColor.GRAY);
                attacker = false;
                generator = false;
                health = 100;
        }

    }
}