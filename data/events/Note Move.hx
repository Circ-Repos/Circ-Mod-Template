import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import funkin.backend.system.Conductor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import modchart.Manager;
import modchart.engine.PlayField;
import flixel.tweens.FlxTweenType;

function numericForInterval(start, end, interval, func){
    var index = start;
    while(index < end){
        func(index);
        index += interval;
    }
}

function tr(deg)
{
    return deg * (3.141592653595 / 180);
}

var originalPositions:Array<Float> = [];

function postCreate() {
    // manager = new Manager();
    // state.add(manager);

	// p = manager.playfields[0];

    // for (strum in cpuStrums) originalPositions.push(strum.x);
    // for (strum in playerStrums) originalPositions.push(strum.x);


    // // DONT EVEN ASK WHY IT HERE IT DOES NOT WORK IN FUNCTION FOR SOME REASON
    // var poop = 1;

    // var counter = -1;

    // p.addModifier("Transform");
    // p.addModifier("OpponentSwap");
    // p.addModifier("Stealth");
    // p.addModifier("Confusion");
    // p.addModifier("Drunk");
    // p.addModifier("Tipsy");
    // p.addModifier("LocalRotate");
    // p.addModifier("CenterRotate");
    // p.addModifier("Zoom");
    // p.addModifier("Scale");
    // p.addModifier("Reverse");
    // p.addModifier("Skew");
    // p.addModifier("ReceptorScroll");
    // p.addModifier("Beat");
}
function beatHit() {
    if (beatStrum) {
        for (strum in strumLines.members[1]) {
            strum.scale.set(1.4, 1.4);
            FlxTween.tween(strum.scale, {x: 0.7, y: 0.7}, 0.1);
        }
    }
}

var scroll:Bool = false;
var origPos:Bool = false;
var beatStrum:Bool = false;
function postUpdate(elapsed:Float) {
    var index = 0;
    
    for (strum in cpuStrums) {
        if (scroll) {
            strum.x += 325 * elapsed;
            
            if (strum.x > FlxG.width) strum.x = -strum.width;
        }
        else {
            if (origPos) {
                var targetX = originalPositions[index];
                strum.x = lerp(strum.x, targetX, 200 * elapsed / 10);
            }
        }
        index++;
    }
    
    for (strum in playerStrums) {
        if (scroll) {
            strum.x += 325 * elapsed;
            
            if (strum.x > FlxG.width) strum.x = -strum.width;
        }
        else {
            if (origPos) {
                var targetX = originalPositions[index];
                strum.x = lerp(strum.x, targetX, 200 * elapsed / 10);
            }
        }
        index++;
    }
}
var currStep;
function stepHit(curStep:Int) {
    currStep = curStep;
}
function onEvent(event){
    if (event.event.name != "Note Move") return;

    var whereTo = event.event.params[0];
    var moveSpeed = event.event.params[1];
    beatStrum = event.event.params[2];
    
    trace(whereTo);
    trace(moveSpeed);

    switch(whereTo){
        // case "Swap (Left To Right)":
        //     trace("Swapping Notes Left To Right");
        //     p.ease("OpponentSwap", curStep, 0.75, 1, FlxEase.backInOut);

        // case "Swap (Right To Left)":
        //     p.ease("OpponentSwap", curStep, 0.25, 1, FlxEase.backInOut);
        // case "To Middlescroll":
        //     trace("Moving Notes To Middlescroll");
        // case "Middlescroll (Edges)":
        //     for(i in playerStrums.members) trace('aa');
        case "Downscroll":

            for(s in PlayState.instance.strumLines.members) for(sl in s.members){
                sl.noteAngle = 180;
                FlxTween.tween(sl,{y: FlxG.height - sl.height - 50, angle: 360}, moveSpeed, {ease: FlxEase.circOut, startDelay: 0.05*sl.ID});
            }

			FlxTween.tween(healthBar, {y: 100, angle: 360}, 0.7, {ease: FlxEase.circOut});
			FlxTween.tween(camHUD, {angle: 360}, 0.7, {ease: FlxEase.circOut});

			FlxTween.tween(healthBarBG, {y: 95, angle: 360}, 0.7, {ease: FlxEase.circOut});
			FlxTween.tween(comboGroup, {angle: 360}, 0.7, {ease: FlxEase.circOut});
			for(i in [iconP1, iconP2]){
				FlxTween.tween(i, {y: 40, angle: 360}, 0.7, {ease: FlxEase.circOut});
			}
			for(i in [scoreTxt, missesTxt, accuracyTxt]){
				FlxTween.tween(i, {y: 45, angle: 360}, 0.7, {ease: FlxEase.circOut});
			}
            
        }
    }
