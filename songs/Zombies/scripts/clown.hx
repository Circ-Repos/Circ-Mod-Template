import flixel.text.FlxText;
import flixel.math.FlxRandom;
import Plant;
import Zombie;
import Pea;
import GridSprite;
import SeedPacket;
//img = 260 85
var gridWidth = 9;
var gridHeight = 6;
var tileSize = 80;
var lawnX = 260;
var lawnY = 200;

var grid:Array<Array<Plant>> = [];

var plants:Array<Plant> = [];
var zombies:Array<Zombie> = [];
var peas:Array<Pea> = [];
var suns:Array<FlxSprite> = [];
var mowers:Array<GridSprite> = [];
introLength = 99999; //song intro aka base game bs

var spawnTimer:Float = 0;

var sun:Int = 150;
var sunTxt:FlxText;

var selectedPlant:String = "peashooter";

var gameOver:Bool = false;
var lawnCam = new FlxCamera();
var gameUI = new FlxCamera();
var seedPackets:Array<SeedPacket> = [];

function postCreate()
{
    FlxG.mouse.visible = true;
    FlxG.camera.alpha = 0;
    camHUD.alpha = 0;
    FlxG.camera.alpha = 0;
    FlxG.cameras.add(lawnCam, false);
    lawnCam.bgColor = FlxColor.TRANSPARENT;
    lawnCam.alpha = 1;
    bg = new FlxSprite(0,0,Paths.image("pvz/dayBG"));
    bg.y = FlxG.height - bg.height;
    bg.camera = lawnCam;
    add(bg);
    FlxG.cameras.add(gameUI, false);
    gameUI.bgColor = FlxColor.TRANSPARENT;
    gameUI.alpha = 1;
    for(i in [dad,bf,gf]) i.visible = false;

    createSeedPacket(50, 15, "peashooter", 100);
    createSeedPacket(150, 15, "sunflower", 50);
    createSeedPacket(250, 15, "wallnut", 50);
    
    for(y in 0...gridHeight)
    {
        grid[y] = [];
        for(x in 0...gridWidth)
            grid[y][x] = null;
    }

    
    for(y in 0...gridHeight)
    for(x in 0...gridWidth)
    {
        var tile = new FlxSprite(lawnX + x*tileSize, lawnY + y*tileSize);
        tile.makeGraphic(tileSize-4,tileSize-4,0x3300FF00);
        tile.cameras=[lawnCam];
        add(tile);
    }

    
    sunTxt = new FlxText(FlxG.width - 300 ,40,0,"SUN: "+sun,32);
    sunTxt.cameras=[gameUI];
    sunTxt.antialiasing = Options.antialiasing;
    sunTxt.setFormat("Arial", 24, FlxColor.WHITE, "left");
    add(sunTxt);

    
    for(row in 0...gridHeight)
    {
        var mower = new GridSprite(lawnX-100,lawnY+row*tileSize,row,0);
        //mower.makeGraphic(80,80,0xFFFF0000);
        mower.loadGraphic(Paths.image('pvz/mower'));
        mower.active=false;
        mower.camera = lawnCam;
        add(mower);
        mowers.push(mower);
    }
}

function update(elapsed:Float)
{
    if(gameOver) return;

    updateInput();
    updatePlants(elapsed);
    updatePeas(elapsed);
    updateZombies(elapsed);
    updateSun();
    updateSpawning(elapsed);
    updateSeedPackets();
}
function getPlantCost(type:String):Int
{
    switch(type)
    {
        case "peashooter": return 100;
        case "sunflower": return 50;
        case "wallnut": return 50;
    }

    return 0;
}
function updateSeedPackets()
{
    for(packet in seedPackets)
    {
        if(FlxG.mouse.overlaps(packet) && FlxG.mouse.justPressed) selectedPlant = packet.plantType;
        packet.selected = (packet.plantType == selectedPlant);
        packet.updateHighlight();
    }
}
function updateInput()
{
    // if(FlxG.keys.justPressed.ONE) selectedPlant="peashooter";
    // if(FlxG.keys.justPressed.TWO) selectedPlant="sunflower";
    // if(FlxG.keys.justPressed.THREE) selectedPlant="wallnut";
    if(FlxG.keys.justPressed.S) sun += 500;

    if(FlxG.keys.justPressed.R) loseGame();

    if(FlxG.mouse.justPressed) tryPlacePlant();
}

function createSeedPacket(x:Float,y:Float,type:String,cost:Int)
{
    var packet = new SeedPacket(x,y,type,cost);
    packet.cameras = [gameUI];

    add(packet);
    seedPackets.push(packet);
}

function tryPlacePlant()
{
    var mouse = FlxG.mouse.getWorldPosition(lawnCam);
    var gx = Math.floor((mouse.x-lawnX)/tileSize);
    var gy = Math.floor((mouse.y-lawnY)/tileSize);

    if(gx<0||gy<0||gx>=gridWidth||gy>=gridHeight)
        return;

    if(grid[gy][gx]!=null)
        return;
    var cost = getPlantCost(selectedPlant);

    if(sun >= cost)
    {
        sun -= cost;
        createPlant(selectedPlant, gx, gy);
    }
}

function createPlant(type:String,gx:Int,gy:Int)
{
    var px = lawnX + gx*tileSize;
    var py = lawnY + gy*tileSize;

    var plant = new Plant(px,py,gy,gx,type);
    plant.type = type;
    if(type=="sunflower") plant.sunTimer=6;
    plant.camera = lawnCam;
    add(plant);

    plants.push(plant);
    grid[gy][gx]=plant;
}

function updatePlants(elapsed:Float)
{
    for(p in plants)
    {
        if(p.type=="peashooter")
        {
            p.shootTimer-=elapsed;

            if(p.shootTimer<=0)
            {
                spawnPea(p);
                p.shootTimer=1.4;
                FlxG.sound.play(Paths.sound('pvz/Throw' + FlxG.random.int(1, 2)),0.5);
            }
        }

        if(p.type=="sunflower")
        {
            p.sunTimer-=elapsed;

            if(p.sunTimer<=0)
            {
                spawnSun(p.x,p.y);
                p.sunTimer=8;
            }
        }
    }
}

function spawnPea(p:Plant)
{
    var pea = new Pea(p.x+70,p.y+30,p.row);
    pea.camera = lawnCam;
    add(pea);
    peas.push(pea);
}

function updatePeas(elapsed:Float)
{
    for(pea in peas.copy())
    {
        pea.x += 300 * elapsed;

        if(pea.x > FlxG.width)
        {
            remove(pea,true);
            peas.remove(pea);
            continue;
        }

        for(z in zombies.copy())
        {
            if(z.row != pea.row) continue;

            if(pea.overlaps(z))
            {
                FlxG.sound.play(Paths.sound('pvz/Splat' + FlxG.random.int(1, 3)),0.5);
                z.takeDamage(1);

                remove(pea, true);
                peas.remove(pea);

                if(z.isDead())
                {
                    remove(z,true);
                    zombies.remove(z);
                }

                break;
            }
        }
    }
}

function updateZombies(elapsed:Float)
{
    for(z in zombies.copy())
    {
        //is we eatin good tonight?
        var plantAhead:Plant = null;

        for(p in plants)
        {
            if(p.row == z.row && z.x <= p.x + p.width && z.x + z.width >= p.x && p.col > z.col)
            {
                plantAhead = p;
                break;
            }
        }

        if(plantAhead != null)
        {
            // WE EATIN GOOD LADS!
            z.eating = true;
            z.eatTimer -= elapsed;

            if(z.eatTimer <= 0)
            {
                plantAhead.takeDamage(1);
                z.eatTimer = 0.89; // zombie eats every s
            }

            // fucking die plant
            if(plantAhead.isDead())
            {
                remove(plantAhead,true);
                plants.remove(plantAhead);
                grid[plantAhead.row][plantAhead.col] = null;
                z.eating = false;
            }
        }
        else
        {
            z.eating = false;
            z.x -= 10 * elapsed;
        }

        if(z.x < lawnX - 120)
            loseGame();

        //mmmmmmmmmmmmmmmm
        for(m in mowers)
        {
            if(!m.active && z.row == m.row && z.x < m.x + 40)
                m.active = true;

            if(m.active)
            {
                m.x += 600 * elapsed;

                if(m.overlaps(z))
                {
                    remove(z,true);
                    zombies.remove(z);
                }
            }
        }
    }
}
function updateSun()
{
    sunTxt.text="SUN: "+sun;

    for(s in suns.copy())
    {
        if(s.overlapsPoint(FlxG.mouse.getWorldPosition(lawnCam)) && FlxG.mouse.justPressed)
        {
            sun+=25;

            remove(s,true);
            suns.remove(s);
        }
    }
}

function spawnSun(x:Float,y:Float)
{
    var s = new FlxSprite(x,y);
    s.scale.set(0.4,0.4);
    FlxTween.tween(s, {y: y+FlxG.random.int(0,20), x: x+FlxG.random.int(0,40)}, 1, {ease: FlxEase.circOut});
    FlxTween.tween(s.scale, {y: 1, x: 1}, 1, {ease: FlxEase.circOut});
    
    //s.makeGraphic(40,40,0xFFFFFF00);
    s.loadGraphic(Paths.image('pvz/sun'));
    s.camera = lawnCam;
    add(s);
    suns.push(s);
}

function updateSpawning(elapsed:Float)
{
    spawnTimer+=elapsed;

    if(spawnTimer>4)
    {
        spawnTimer=0;

        var row = Std.random(gridHeight);
        spawnZombie(row);
    }
}

function spawnZombie(row:Int)
{
    var zombie = new Zombie(FlxG.width+50,lawnY+row*tileSize,row);
    zombie.camera = lawnCam;
    add(zombie);
    zombies.push(zombie);
}

function loseGame()
{
    gameOver=true;
    gameUI.alpha = 0;
    FlxTween.tween(lawnCam.scroll, {x: -400}, 2, {ease: FlxEase.linear});
    trace('The Zombies Ate Your Brains!');
}