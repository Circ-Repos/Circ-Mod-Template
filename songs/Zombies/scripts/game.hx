import funkin.menus.FreeplayState;
import flixel.text.FlxText;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import flixel.input.mouse.FlxMouse;

import Plant;
import Zombie;
import Pea;
import GridSprite;
import SeedPacket;
import Wave;

var gridWidth = 9;
var gridHeight = 6;
var tileSize = 80;
var lawnX = 260;
var lawnY = 200;

var curSelected = 0;
var grid:Array<Array<Plant>> = [];

var plants:Array<Plant> = [];
var zombies:Array<Zombie> = [];
var peas:Array<Pea> = [];
var suns:Array<FlxSprite> = [];
var fallingsuns:Array<FlxSprite> = [];

var mowers:Array<GridSprite> = [];

var spawnTimer:Float = 0;

var sun:Int = 50;
var sunTxt:FlxText;

var shovelMode:Bool = false;
var shovelIcon:FlxSprite;

var waves:Array<Wave> = [
    new Wave(['NORMAL','NORMAL','NORMAL'],false),
    new Wave(['NORMAL','NORMAL','NORMAL','NORMAL'],false),
    new Wave(['NORMAL','NORMAL','CONE'],false),
    new Wave(['NORMAL','NORMAL','NORMAL','NORMAL','CONE'],false),
    new Wave(['NORMAL','NORMAL','NORMAL','BUCKET','BUCKET','CONE'], true)
];

var currentWave:Int = 0;
var zombiesSpawned:Int = 0;
var waveActive:Bool = false;

var selectedPlant:String = "peashooter";

var gameOver:Bool = false;

var seedPackets:Array<SeedPacket> = [];

var lawnCam = new FlxCamera();
var gameUI = new FlxCamera();
var gameFG = new FlxCamera();

function onCountdown(e){
    if (e.scale == 0.6) e.scale = 1;
}
function onPostCountdown(e) { //stole from V-Slice Modpack :>
	var spr = e.sprite;
	if (spr != null) spr.camera = gameUI;

	var props = e.spriteTween?._propertyInfos;
	if (props != null) for (info in props)
		if (info.field == "y") e.spriteTween._propertyInfos.remove(info);
}
function postCreate()
{
	FlxG.mouse.useSystemCursor = true;
	FlxG.mouse.visible = true;
	Mouse.cursor = 'arrow';
        FlxG.sound.music.looped = true;
	comboGroup.setPosition(560, 290);
    camHUD.alpha = 0;
    FlxG.cameras.add(lawnCam,false);
    lawnCam.bgColor = FlxColor.TRANSPARENT;

    FlxG.cameras.add(gameUI,false);
    gameUI.bgColor = FlxColor.TRANSPARENT;

    FlxG.cameras.add(gameFG,false);
    gameFG.bgColor = FlxColor.TRANSPARENT;
	comboGroup.cameras = [gameUI];

    bg = new FlxSprite(0,0,Paths.image("pvz/dayBG"));
    bg.y = FlxG.height - bg.height;
    bg.camera = lawnCam;
    add(bg);

    for(i in [dad,bf,gf]) i.visible = false;

    deadBG = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,0xFF000000);
    deadBG.alpha = 0;
    deadBG.cameras=[gameFG];
    add(deadBG);

    atebrains = new FlxSprite(0,0,Paths.image('pvz/brain'));
    atebrains.cameras=[gameFG];
    atebrains.screenCenter();
    atebrains.scale.set(0.01,0.01);
    atebrains.visible=false;
    add(atebrains);

    createSeedPacket(200,5,"peashooter",100);
    createSeedPacket(280,5,"sunflower",50);
    createSeedPacket(360,5,"wallnut",50);

    shovelIcon = new FlxSprite(0,5).makeGraphic(100,100,0xFFFF0000);
    shovelIcon.cameras=[gameUI];
    shovelIcon.scale.set(0.8,0.8);
    shovelIcon.updateHitbox();
    shovelIcon.x = FlxG.width - shovelIcon.width - 100;
    add(shovelIcon);

    for(y in 0...gridHeight)
    {
        grid[y] = [];
        for(x in 0...gridWidth)
            grid[y][x] = null;
    }

    for(y in 0...gridHeight)
    for(x in 0...gridWidth)
    {
        var tile = new FlxSprite(lawnX + x*tileSize,lawnY + y*tileSize);
        tile.makeGraphic(tileSize-4,tileSize-4,0x3300FF00);
        tile.cameras=[lawnCam];
        add(tile);
    }

    sunTxt = new FlxText(100,40,0,"SUN: "+sun,32);
    sunTxt.cameras=[gameUI];
    sunTxt.setFormat("Arial",24,FlxColor.WHITE,"left");
    add(sunTxt);

    for(row in 0...gridHeight)
    {
        var mower = new GridSprite(lawnX-100,lawnY+row*tileSize,row,0);
        mower.loadGraphic(Paths.image('pvz/mower'));
        mower.active=false;
        mower.camera=lawnCam;
        add(mower);
        mowers.push(mower);
    }

}

var sunSpawnable=false;

function onSongStart()
{
    sunSpawnable=true;

    new FlxTimer().start(20,function(t)
    {
        FlxG.sound.play(Paths.sound('pvz/Zombies-Coming'),0.7);
        startNextWave();
    });
    //FlxG.sound.music.volume = 0;

}

function update(elapsed:Float)
{
    if(!gameOver)
    {
        updateInput();
        updatePlants(elapsed);
        updatePeas(elapsed);
        updateZombies(elapsed);
        updateSun();
        updateSpawning(elapsed);
        updateSeedPackets();
        updateMowers(elapsed);
        if(FlxG.mouse.overlaps(shovelIcon) && FlxG.mouse.justPressed)
        {
            shovelMode = !shovelMode;
            selectedPlant="";
        }
    }
}

function updateMowers(elapsed:Float)
{
    for(m in mowers)
    {
        if(m.active)
        {
            m.x += 600 * elapsed;


            for(z in zombies.copy())
            {
                if(m.overlaps(z))
                {
                    remove(z,true);
                    zombies.remove(z);
                }
            }
        }
    }
}

function updateSeedPackets()
{
    for(packet in seedPackets)
    {
        if(FlxG.mouse.overlaps(packet)){ Mouse.cursor = MouseCursor.ARROW;
        }else{ Mouse.cursor = MouseCursor.ARROW;}
        if(FlxG.mouse.overlaps(packet) && FlxG.mouse.justPressed)
        {
            selectedPlant = packet.plantType;
            curSelected = seedPackets.indexOf(packet);
            shovelMode=false;
            FlxG.sound.play(Paths.sound('pvz/seedlift'),0.5);
        }
        packet.selected = (packet.plantType == selectedPlant);
        packet.currentSun = sun;
        packet.updateHighlight();
    }
}

function updateInput()
{
    // if(FlxG.keys.justPressed.S) sun+=500;
    // if(FlxG.keys.justPressed.W) win();

    shovelIcon.color = shovelMode ? 0xFF00FF00 : 0xFFFFFFFF;
    if(FlxG.keys.justPressed.R) loseGame();
    if(FlxG.mouse.justPressed) tryPlacePlant();
}

function createSeedPacket(x:Float,y:Float,type:String,cost:Int)
{
    var packet = new SeedPacket(x,y,type,cost);
    packet.cameras=[gameUI];
    packet.currentSun=sun;
    add(packet);
    seedPackets.push(packet);
}

function tryPlacePlant()
{
    for(packet in seedPackets){
        if(FlxG.mouse.overlaps(packet)) return;

        var mouse = FlxG.mouse.getWorldPosition(lawnCam);

        var gx = Math.floor((mouse.x-lawnX)/tileSize);
        var gy = Math.floor((mouse.y-lawnY)/tileSize);

        if(gx<0||gy<0||gx>=gridWidth||gy>=gridHeight) return;
        if(shovelMode)
        {
            if(grid[gy][gx]!=null)
            {
                var plant=grid[gy][gx];

                remove(plant,true);
                plants.remove(plant);
                grid[gy][gx]=null;
                FlxG.sound.play(Paths.sound('pvz/plant1'));
            }

            return;
        }

        if(selectedPlant=="") return;

        var cost = seedPackets[curSelected].cost;

        if(sun < cost) return;
        if(grid[gy][gx]!=null) return;

        sun-=cost;

        FlxG.sound.play(Paths.sound('pvz/plant'+FlxG.random.int(1,2)),0.5);

        createPlant(selectedPlant,gx,gy);

        selectedPlant="";
    }
}

function createPlant(type:String,gx:Int,gy:Int)
{
    var px = lawnX + gx*tileSize;
    var py = lawnY + gy*tileSize;

    var plant = new Plant(px,py,gy,gx,type);
    plant.camera=lawnCam;
    add(plant);

    plants.push(plant);
    grid[gy][gx]=plant;
}

function updatePlants(elapsed:Float)
{
    for(p in plants)
    {
        if(p.attacker)
        {
        var zombieAhead=false;


            for(z in zombies)
                if(z.row==p.row && z.x>p.x)
                    zombieAhead=true;

            if(!zombieAhead)
                p.shootTimer=1.4;

            if(zombieAhead)
            {
                p.shootTimer-=elapsed;

                if(p.shootTimer<=0)
                {
                    spawnPea(p);
                    p.shootTimer=1.4;
                    FlxG.sound.play(Paths.sound('pvz/Throw'+FlxG.random.int(1,2)),0.5);
                }
            }
    }
    else if(p.generator)
    {
        p.sunTimer-=elapsed;

        if(p.sunTimer<=0)
        {
            spawnSun(p.x,p.y,false);
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
        }

        for(z in zombies.copy())
        {
            if(pea.overlaps(z))
            {
                FlxG.sound.play(Paths.sound('pvz/Splat'+FlxG.random.int(1,3)),0.5);

                z.takeDamage(20);

                remove(pea,true);
                peas.remove(pea);

                if(z.isDead())
                {
                    remove(z,true);
                    zombies.remove(z);
                }
            }
        }
    }


}

function updateZombies(elapsed:Float)
{
    for(z in zombies.copy())
    {
        var plantAhead:Plant = null;


        for(p in plants)
        {
            if(p.row == z.row && Math.abs(z.x-p.x) < 15 && p.y == z.y)
            {
                plantAhead=p;
                break;
            }
        }

        if(plantAhead!=null && z.row == plantAhead.row && z.col == plantAhead.col < 2)
        {
            z.eating = true;
            z.eatTimer -= elapsed;

            if(z.eatTimer<=0)
            {
                plantAhead.takeDamage(270);
                z.eatTimer = 0.89;
            }

            if(plantAhead.isDead())
            {
                remove(plantAhead,true);
                plants.remove(plantAhead);
                grid[plantAhead.row][plantAhead.col] = null;
                z.eating=false;
                plantAhead=null;
            }
        }
        else
        {
            z.eating = false;
            z.x -=10*elapsed;
        }

        if(z.x < lawnX-120)
            loseGame();

        for(m in mowers)
            if(!m.active && z.row==m.row && z.x<=lawnX)
            {
                m.active=true;
            }
    }


}

function updateSun()
{
    sunTxt.text="SUN: " + sun;


    for(s in suns.copy())
    {
        if(!shovelMode && s.overlapsPoint(FlxG.mouse.getWorldPosition(lawnCam))){
            Mouse.cursor = MouseCursor.BUTTON; 

        }
        else{
            Mouse.cursor = MouseCursor.ARROW;
        }
        if(!shovelMode && s.overlapsPoint(FlxG.mouse.getWorldPosition(lawnCam)) && FlxG.mouse.justPressed)
        {
            sun += 25;
            FlxG.sound.play(Paths.sound('pvz/points'),0.5);
            remove(s,true);
            suns.remove(s);
        }
    }

    for(s in fallingsuns.copy())
    {
        if(!shovelMode && s.overlapsPoint(FlxG.mouse.getWorldPosition(lawnCam)) && FlxG.mouse.justPressed)
        {
            sun += 25;
            FlxG.sound.play(Paths.sound('pvz/points'),0.5);
            remove(s,true);
            fallingsuns.remove(s);
        }
    }


}

function spawnSun(x:Float,y:Float,falling:Bool)
{
    var s=new FlxSprite(x,y);

    s.scale.set(0.4,0.4);

    FlxTween.tween(s,{y:y+FlxG.random.int(0,20),x:x+FlxG.random.int(0,40)},1,{ease:FlxEase.circOut});
    FlxTween.tween(s.scale,{x:1,y:1},1,{ease:FlxEase.circOut});

    s.loadGraphic(Paths.image('pvz/sun'));
    s.camera=lawnCam;

    add(s);

    if(!falling) suns.push(s);
    if(falling) fallingsuns.push(s);

}

var sunSpawnTimer:Float=0;
var winYet:Bool=false;

function onSongEnd(e)
{
    if(!winYet) e.cancel();
}

function win()
{
    FlxG.sound.music.volume = 0;
    FlxG.sound.play(Paths.sound('pvz/winmusic'),1);
    new FlxTimer().start(5,function(t){});

    var packet = new FlxSprite(FlxG.random.int(lawnX, FlxG.width - 100),FlxG.height * 0.5,Paths.image('pvz/packets/template'));
    packet.camera = lawnCam;
    packet.scale.set(0.5,0.5);
    add(packet);

    FlxTween.tween(packet.scale,{y:2,x:2},3,{ease:FlxEase.circOut,onUpdate: () ->  packet.updateHitbox()});
    FlxTween.tween(packet,{y:FlxG.height/2 - packet.height/2, x:FlxG.width/2 - packet.width/2},3,{ease:FlxEase.circOut});
    new FlxTimer().start(3,function(t){
        gameFG.fade(0xFFDBFBE8,1,false,function()
        {
            new FlxTimer().start(2,function(t){
                FlxG.switchState(new FreeplayState());
            });
        });
    });
}

function startNextWave()
{
    if(currentWave>=waves.length)
    {
        win();
        return;
    }

    zombiesSpawned=0;
    spawnTimer=0;
    waveActive=true;
    if(waves[currentWave].huge)
        FlxG.sound.play(Paths.sound('pvz/hugewave'));
    currentWave++;
}

function updateSpawning(elapsed:Float)
{
    if(waveActive)
    {
        spawnTimer+=elapsed;


        if(spawnTimer>2)
        {
            spawnTimer=0;
            var wave=waves[currentWave-1];

            if(zombiesSpawned < wave.zombies.length)
            {
                var type=wave.zombies[zombiesSpawned];
                var row=Std.random(gridHeight);
                spawnZombie(row,type);
                zombiesSpawned++;
            }
        }

        var wave=waves[currentWave-1];

        if(zombiesSpawned>=wave.zombies.length && zombies.length==0)
        {
            waveActive=false;
            new FlxTimer().start(5,function(t){startNextWave();});
        }
    }

    if(sunSpawnable)
    {
        sunSpawnTimer+=elapsed;
        if(sunSpawnTimer>6)
        {
            sunSpawnTimer=0;
            spawnSun(lawnX+FlxG.random.int(0,gridWidth*tileSize),lawnY-50,true);
        }
    }


}

function spawnZombie(row:Int,type:ZombieType)
{
    var zombie=new Zombie(FlxG.width+50,lawnY+row*tileSize,row);
    zombie.type=type;
    zombie.camera=lawnCam;
    add(zombie);

    zombies.push(zombie);


}

function loseGame()
{
    gameOver=true;
    gameUI.alpha=0;

    FlxTween.tween(lawnCam.scroll,{x:-400},2);
    FlxG.sound.music.volume=0;
    FlxG.sound.play(Paths.sound('pvz/losemusic'),1);

    new FlxTimer().start(6,function(t)
    {
        gameFG.shake(0.01,2.5);
        FlxG.sound.play(Paths.sound('pvz/scream'),1);
        atebrains.visible=true;
        FlxTween.tween(atebrains.scale,{x:1,y:1},1);
        FlxTween.tween(deadBG,{alpha:0.85},0.85);
    });

    new FlxTimer().start(10,function()
    {
        FlxG.switchState(new FreeplayState());
    });

}
