import flixel.addons.display.FlxBackdrop;

var jacko:FlxBackdrop;
//step 197 btw
function postCreate(){
    dad.alpha = 0;
    iconP2.alpha = 0;
    jacko = new FlxBackdrop(null, FlxAxes.X, 40, 33333);
    jacko.frames = Paths.getSparrowAtlas('jacko');
    jacko.animation.addByPrefix('jacko', 'jacko', 12, true);
    jacko.animation.play('jacko');
    jacko.antialiasing = false;
    jacko.velocity.set(-45, 0);
    jacko.scale.set(4,4);
    jacko.updateHitbox();
    jacko.y = FlxG.height - jacko.height;
    jacko.camera = camHUD;
    jacko.alpha = 0;
    add(jacko);
}
function stepHit(curStep:Int) {
    switch(curStep){
        case 197:
            FlxTween.tween(jacko, {alpha: 1}, 1);
    }
}