import flixel.FlxObject;
var camFollow:FlxObject;
function postCreate() {
    bg.scrollFactor.x = 0; 
    bg.scrollFactor.y = 0.17;
    bg.setGraphicSize(Std.int(FlxG.width * 1.2));
    bg.updateHitbox();
    camFollow = new FlxObject(camFollow, 0, 1, 1);
    camFollow.y = bg.getGraphicMidpoint().y;
    FlxG.camera.follow(camFollow, null, 0.06);
    for(i in grpSongs) i.scrollFactor.set();
}

function update(elapsed:Float) {
    for (i in grpSongs)
    {
      camFollow.setPosition(0, i.y);
    }
}