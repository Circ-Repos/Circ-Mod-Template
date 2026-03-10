class Wave
{
    public var zombies:Array<ZombieType>;
    public var huge:Bool;

    public function new(zombies:Array<ZombieType>, huge:Bool=false)
    {
        this.zombies = zombies;
        this.huge = huge;
    }
}