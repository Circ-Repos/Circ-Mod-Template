import flixel.tweens.FlxTweenManager;

var thefuckassBaby:FlxSprite;
var drainActive:Bool = false;
var shakeTween:FlxTween;
var angleTween:FlxTween;

function postCreate() {
    FlxG.camera.alpha = 0;

    thefuckassBaby = new FlxSprite(1280, -300);
    thefuckassBaby.loadGraphic(Paths.image("game/mechanics/HPGremlin"));
    thefuckassBaby.camera = camHUD;
    thefuckassBaby.scale.set(0.15,0.15);
    thefuckassBaby.updateHitbox();
    thefuckassBaby.antialiasing = Options.antialiasing;
    add(thefuckassBaby);
    thefuckassBaby.angle = -15;
    angleTween = FlxTween.tween(thefuckassBaby, {angle: 5}, 0.2, {ease: FlxEase.bounceInOut, type: FlxTween.PINGPONG, loopDelay: 0.01});
    shakeTween = FlxTween.shake(thefuckassBaby, 0.03, 2, FlxAxes.XY, { ease: FlxEase.bounceInOut, type: FlxTween.PINGPONG });

    remove(thefuckassBaby, true);
    insert(members.indexOf(iconP1) + 1, thefuckassBaby);

}

function update(elapsed:Float) {
    if(drainActive) {
        health -= 0.001 * elapsed * 42; 
        thefuckassBaby.y = lerp(thefuckassBaby.y, iconP1.y - 52, 0.045);
        thefuckassBaby.x = lerp(thefuckassBaby.x, iconP1.x + 35, 0.045);
    }
    if(!drainActive){
        thefuckassBaby.x = lerp(thefuckassBaby.x, 1280, 0.05);
        thefuckassBaby.y = lerp(thefuckassBaby.y, -300, 0.05);
    }
}
function killthefuckingchild(){
    drainActive = false;
}

function releaseTheBaby(){
    drainActive = true;
}