import GridSprite;
class Pea extends GridSprite
{
    public function new(x:Float,y:Float,row:Int)
    {
        super(x,y,row,0);
        loadGraphic(Paths.image('pvz/Pea'));
        //makeGraphic(20,20,0xFF00FF00);
    }
}