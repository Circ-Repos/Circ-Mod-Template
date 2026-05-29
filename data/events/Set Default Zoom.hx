function onEvent(e) {
    if (e.event.name != "Set Default Zoom") return;

    // making this an array so finalZoom isnt that long
    var prams:Array = e.event.params;

    var cam:String = prams[1];
    var finalZoom:Float = Std.parseFloat(prams[0]) * (prams[2] == "direct" ? FlxCamera.defaultZoom : stage.defaultZoom);

    if (prams[3]) finalZoom *= cam.zoom;

    // using cam + for backwards compatibility, not added in 1.0.1 afaik
    // also making it a separate function to not waste too much space here
    cancelTwn(cam + ".zoom");

    if (cam == "camGame")
        defaultCamZoom = finalZoom;
    else
        defaultHudZoom = finalZoom;
}

function cancelTwn(string:String)
{
    var tween:FlxTween = eventsTween.get(string);
    
    if (tween != null) {
        if (tween.onComplete != null) tween.onComplete(tween);
        tween.cancel();
    }
}