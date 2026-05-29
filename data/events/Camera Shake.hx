// coded by sillyborja, json taken and modified from another event (edited by nova!!!!)
function onEvent(e:EventGameEvent) {
	if (e.event.name != "Camera Shake") return;
    var event = e.event;
    
	// shake values
	var power:Float = event.params[1];
	var duration:Float = (Conductor.stepCrochet * 0.001) * event.params[3];
	var cam:FlxCamera = Reflect.field(this, event.params[2]);

	// tween values
	var tweenName:String = event.params[2] + "Shake";
	var tweenEase:FlxEase = CoolUtil.flxeaseFromString(event.params[4], e.event.params[5]);
    trace(tweenEase);
	var tween:FlxTween = eventsTween.get(tweenName);
	tween?.cancel();

    var intensity:Float = 0;
	if (!event.params[0]) cam.shake(power, duration, null, true);
	else {
        cam.shake(0, duration, null, true);
        eventsTween.set(tweenName, FlxTween.num(power, cam._fxShakeIntensity, duration, {ease: tweenEase}, (num:Float) -> {
            cam._fxShakeIntensity = num;
            trace(cam._fxShakeIntensity);
        }));
    }
}
