import GridSprite;
class Zombie extends GridSprite
{
    public var row:Int;
    public var health:Float;
    public var eating:Bool = false;
    public var eatTimer:Float = 0.5;
    
    public function new(x:Float, y:Float, row:Int)
    {
        super(x, y);
        this.row = row;
        this.health = 3; 
        loadGraphic(Paths.image('pvz/teto')); 
    }

    public function takeDamage(dmg:Float)
    {
        health -= dmg;
    }

    public function isDead():Bool
    {
        return health <= 0;
    }
}