function postCreate(){
    camS = new FlxCamera();
    camS.bgColor = 0;
    FlxG.cameras.add(camS, false); // seperate cam so camHUD can fade without affecting lyrics


    skeleton = new FunkinSprite(0,0);
    skeleton.frames = Paths.getSparrowAtlas('game/skeleton');
    skeleton.animation.addByPrefix('run','s',24,false);
    skeleton.camera = camS;
    skeleton.antialiasing = false;
    skeleton.scale.set(4,4);
    skeleton.updateHitbox();
    skeleton.screenCenter();
    add(skeleton);
}
function update(){
    if(FlxG.keys.justPressed.S){
        brdurdurdurnrrr();
    }
}
function brdurdurdurnrrr(){
    skeleton.animation.play('run');
    FlxG.sound.play(Paths.sound('secrets/skeleton'),0.45);
}
function beatHit(){
    if(FlxG.random.int(0,3333) == 33){
        brdurdurdurnrrr();
    }
}