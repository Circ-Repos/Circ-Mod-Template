import GridSprite;

enum ZombieType
{
    NORMAL;
    CONE;
    BUCKET;
}

class Zombie extends GridSprite
{
    public var row:Int;
    public var health:Float;
    public var eating:Bool = false;
    public var eatTimer:Float = 0.5;
    public var type:ZombieType = 'NORMAL';
    public function new(x:Float, y:Float, row:Int)
    {
        super(x, y);
        this.row = row;
        this.health = 200; 
        this.type = type;
        switch(type){
            case 'NORMAL' | 0:
                loadGraphic(Paths.image('pvz/teto')); 
                health = 200;
                eatTimer = 1;
            case 'CONE' | 1:
                loadGraphic(Paths.image('pvz/neru')); 
                health = 300;
                eatTimer = 1;
            case 'BUCKET' | 2:
                loadGraphic(Paths.image('pvz/miku')); 
                health = 400;
                eatTimer = 1;
            default:
                makeGraphic(80, 80, FlxColor.RED);

                health = 1;
                eatTimer = -1;
                trace('error in Zombie Type');
        }
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