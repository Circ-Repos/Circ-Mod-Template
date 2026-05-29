import flixel.FlxObject;

public var dadCam:Array<Float> = [0, 0];
public var bfCam:Array<Float> = [0, 0];
public var gfCam:Array<Float> = [0, 0];
public var zoomingShit:Array<Float> = [0, 0, 0]; // 0=BF, 1=DAD, 2=GF
public var camTargetX:Float = 0;
public var camTargetY:Float = 0;

// camera displacement
public var camDisplaceX:Float = 0;
public var camDisplaceY:Float = 0;
public var camDisplaceXTarget:Float = 0;
public var camDisplaceYTarget:Float = 0;
public var camStrength:Float = 1;
public var baseCamX:Float = 0;
public var baseCamY:Float = 0;
public var angleLerp:Float = 0;
public var angleGoal:Float = 0;
public var startingPosition = [0,0];
public var playCamOffset = [-30,25,-40,30]; //left X, down Y, up Y, right Y

public var gfCamOffset = [-30,25,-40,30];

public var opponentCamOffset = [-30,25,-40,30];
public var camFollowINSTANT:FlxObject;

public var doAngle:Bool = true;
var songName = PlayState.SONG.meta.displayName;

function postCreate(){
    doAngle = true;
    if(doAngle){
        angleLerp = FlxG.camera.angle = 0;
    }
    camFollowINSTANT = new FlxObject(0, 0, 2, 2);
    add(camFollowINSTANT);
    switch(songName.toLowerCase()){
        case 'foxed':
            baseCamX = camTargetX = camFollow.x = 600;
            baseCamY = camTargetY = camFollow.y = -300;
            startingPosition = [600, -300];
            camFollowINSTANT.setPosition(startingPosition[0], startingPosition[1]);
            FlxG.camera.focusOn(camFollowINSTANT.getPosition());
            FlxG.camera.snapToTarget();
        }
    camFollowINSTANT.setPosition(camFollow.x, camFollow.y);

    if(startingPosition == [0,0]) startingPositon = dadCam;

}
function onSongStart(){
    if(startingPosition[0] != 0) {
        baseCamX = camTargetX = camFollow.x = FlxG.camera.scroll.x = startingPosition[0];
        baseCamY = camTargetY = camFollow.y = FlxG.camera.scroll.y = startingPosition[1];
        camFollow.x = baseCamX;
        if(doAngle) FlxG.camera.angle = 0;
        camFollow.y = baseCamY;
        camFollowINSTANT.setPosition(startingPosition[0], startingPosition[1]);
        FlxG.camera.focusOn(camFollowINSTANT.getPosition());
        FlxG.camera.snapToTarget(camFollowINSTANT);
	    camGame.snapToTarget();

    }
}
function onEvent(_) {
    if (_.event.name == "Camera Movement" || _.event.name == "Camera Position")
        _.cancelled = true;

    switch (_.event.name) {

        case "Camera Position":

            var useMiddle:Bool = (_.event.params[0] == "middle" || _.event.params[1] == "middle");

            if (useMiddle) {

                var dadX = (dadCam[0] == 0) ? dad.getCameraPosition().x : dadCam[0];
                var bfX = (bfCam[0] == 0) ? boyfriend.getCameraPosition().x : bfCam[0];
                baseCamX = camTargetX = (dadX + bfX) / 2;

                var dadY = (dadCam[1] == 0) ? dad.getCameraPosition().y : dadCam[1];
                var bfY = (bfCam[1] == 0) ? boyfriend.getCameraPosition().y : bfCam[1];
                baseCamY = camTargetY = (dadY + bfY) / 2;

            } else {

                baseCamX = camTargetX = Std.parseFloat(_.event.params[0]);
                baseCamY = camTargetY = Std.parseFloat(_.event.params[1]);

            }

            var targetName:String = _.event.params[6];
            var zoomIndex = (targetName == "GF") ? 2 : (targetName == "Dad") ? 1 : 0;

            if (zoomingShit[zoomIndex] != null && zoomingShit[zoomIndex] != 0)
                defaultCamZoom = zoomingShit[zoomIndex];

            switch (targetName) {
                case "Dad": curCameraTarget = 0;
                case "BF": curCameraTarget = 1;
                case "GF": curCameraTarget = 2;
                default: curCameraTarget = 2;
            }

            cancelTween("cameraMovement");
            baseCamX = camTargetX;
            baseCamY = camTargetY;

            applyCameraTween(_.event.params[4], _.event.params[3], _.event.params[2], _.event.params[5]);


        case "Camera Movement":

            curCameraTarget = Std.int(_.event.params[0]);

            var baseCam:Array<Float>;

            switch (curCameraTarget) {
                case 0: baseCam = dadCam;
                case 1: baseCam = bfCam;
                case 2: baseCam = gfCam;
                default: baseCam = gfCam;
            }

            if(curCameraTarget == null) curCameraTarget = 1;

            var defaultChar = PlayState.instance.strumLines.members[curCameraTarget].characters[0];

            baseCamX = camTargetX = ((baseCam[0] == 0) ? defaultChar.getCameraPosition().x : baseCam[0]) + (_.event.params[1] ?? 0);
            baseCamY = camTargetY = ((baseCam[1] == 0) ? defaultChar.getCameraPosition().y : baseCam[1]) + (_.event.params[2] ?? 0);

            cancelTween("cameraMovement");

            baseCamX = camTargetX;
            baseCamY = camTargetY;

            applyCameraTween(_.event.params[5], _.event.params[4], _.event.params[3], _.event.params[6]);
    }
}

function onCameraMove(event) {

    if (zoomingShit[curCameraTarget] != 0)
        defaultCamZoom = zoomingShit[curCameraTarget];

    event.cancelled = true;

}

function cancelTween(key:String) {

    var tween = eventsTween.get(key);

    if (tween != null) {

        if (tween.onComplete != null)
            tween.onComplete(tween);

        tween.cancel();
    }
}

function applyCameraTween(mode:String, beatSync:Bool, duration:Float, ease:String) {

    switch (mode) {

        case "CLASSIC":
            return;

        case "INSTANT":
            camFollow.x = baseCamX;
            camFollow.y = baseCamY;
            FlxG.camera.focusOn(camFollowINSTANT.getPosition());
            FlxG.camera.snapToTarget();
        default:

            var time = beatSync
                ? ((60 / Conductor.bpm) * 16) * duration
                : (Conductor.stepCrochet / 1000) * duration;

            eventsTween.set("cameraMovement",
                FlxTween.tween(
                    FlxG.camera.scroll,
                    {
                        x: baseCamX - FlxG.camera.width * 0.5,
                        y: baseCamY - FlxG.camera.height * 0.5
                    },
                    time,
                    { ease: CoolUtil.flxeaseFromString(mode, ease) }
                )
            );
    }
}
function onNoteHit(event)
{
    var char = event.characters[0];
    var anim = event.direction;
    var offsets;

    if(event.strumLineID == 1)
        offsets = playCamOffset;
    else if(char == gf)
        offsets = gfCamOffset;
    else
        offsets = opponentCamOffset;

    var value = offsets[anim];
    if(value == null) return;

    camDisplaceXTarget = (anim == 0 || anim == 3) ? value : 0;
    camDisplaceYTarget = (anim == 1 || anim == 2) ? value : 0;
    if(doAngle){
        switch(anim){
            case 0:
                angleGoal = 1;

            case 3:
                angleGoal = -1;
        }
    }
    camStrength = 1;
}
var angleDecay:Float = 0;
var angleRateScale:Float = 0;

function smoothLerpPrecision(base:Float, target:Float, deltaTime:Float, duration:Float):Float
{
	if (deltaTime == 0) return base;
	if (base == target) return target;
	return lerp(target, base, Math.pow(1 / 100, deltaTime / duration));
}

function postUpdate(elapsed:Float)
{
    if(doAngle)
    {
        angleGoal = lerp(angleGoal, 0, elapsed * 2);
        angleLerp = lerp(angleLerp, angleGoal, elapsed * 4);
        FlxG.camera.angle = angleLerp;
    }

    camDisplaceX = lerp(camDisplaceX, camDisplaceXTarget, elapsed * 8);
    camDisplaceY = lerp(camDisplaceY, camDisplaceYTarget, elapsed * 8);

    camDisplaceXTarget = lerp(camDisplaceXTarget, 0, elapsed * 4);
    camDisplaceYTarget = lerp(camDisplaceYTarget, 0, elapsed * 4);

    camFollowINSTANT.setPosition(baseCamX, baseCamY);

    camFollow.x = baseCamX + camDisplaceX;
    camFollow.y = baseCamY + camDisplaceY;
}


function lerp(a:Float, b:Float, t:Float)
{
    return a + (b - a) * t;
}
