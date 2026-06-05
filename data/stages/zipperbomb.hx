import openfl.display.BlendMode;
import flixel.addons.display.FlxBackdrop;

graphicCache.cache(Paths.image("stages/zipperbomb/ground-crack"));

var dustBack:FlxBackdrop;
var black:FlxSprite;

function create() {
    insert(members.indexOf(boyfriend) - 1, black = new FlxSprite(-200).makeSolid(FlxG.width * 3, FlxG.height * 3, 0xFF140A0A)).alpha = 0;
}

function postCreate() {
    insert(members.indexOf(hills), dustBack = new FlxBackdrop(Paths.image("stages/zipperbomb/dust-back"), FlxAxes.X));
    dustBack.scale.set(0.7, 0.8);
    dustBack.setPosition(0, hills.y + 400);
    dustBack.scrollFactor.set(0.53, 0.53);
    dustBack.velocity.x = 320;

    sun.zoomFactor = clouds.zoomFactor = 1.3;
    mountains.zoomFactor = 1.19;
    hillsBack.zoomFactor = 1.17;
    hills.zoomFactor = 1.15;

    clouds.blend = BlendMode.ADD;
    sunOverlay.blend = BlendMode.ADD;

    dustFront.forceIsOnScreen = true;

    for (palm in [palm1, palm2]) palm.animation?.curAnim?.pause();
    for (spr in [dust, dustFront, dustBack]) spr.alpha = 0;
    remove(comboGroup);
}

function stepHit(_:Int) {
    switch (_) {
        case 552: FlxTween.tween(black, {alpha: 0.7}, (Conductor.stepCrochet * 0.001) * 34, {ease: FlxEase.smoothStepInOut});
        case 609:
            ground.loadGraphic(Paths.image("stages/zipperbomb/ground-crack"));
            for (palm in [palm1, palm2]) palm.animation?.curAnim?.play();
            for (spr in [dust, dustFront, dustBack]) FlxTween.tween(spr, {alpha: 1}, (Conductor.stepCrochet * 0.001) * 4);
            remove(black);
            insert(members.indexOf(dustBack), black);
            black.alpha = 0.3;
    }
}