public var cameraMovementStrength = 20;
public var cameraMovementEnabled = true;

function postUpdate(elapsed:Float){

    if (!cameraMovementEnabled) return null;
    else{
    var anim = strumLines.members[curCameraTarget].characters[0].getAnimName();
    switch(anim){
        case "singLEFT"|"singLEFT-alt": camFollow.x -= cameraMovementStrength;
        case "singDOWN"|"singDOWN-alt": camFollow.y += cameraMovementStrength;
        case "singUP"|"singUP-alt": camFollow.y -= cameraMovementStrength;
        case "singRIGHT"|"singRIGHT-alt": camFollow.x += cameraMovementStrength;
    }
    if(cameraMovementStrength < 20) cameraMovementStrength = 20; //if under 20 go to 20 since we dont talk about under 20....
    }
}
function cameraMovementChange(n:Float){
    cameraMovementEnabled = n;
    trace(cameraMovementStrength);
    trace(cameraMovementEnabled);
}