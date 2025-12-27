import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var lyrics:FlxText;
var subtitleCam:FlxCamera;

var mid:Bool = false;
var moving:Bool = false;
var targetY:Float = 600;
var fontt:String = 'VCR.ttf';
function postCreate() {
    subtitleCam = new FlxCamera();
    subtitleCam.bgColor = 0;
    FlxG.cameras.add(subtitleCam, false); // seperate cam so camHUD can fade without affecting lyrics

    lyrics = new FlxText(0, 600, 0, "");
    lyrics.setFormat(Paths.font("VCR.ttf"), 36, FlxColor.WHITE, FlxTextAlign.CENTER);
    lyrics.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 4);
    lyrics.antialiasing = false;
    lyrics.scrollFactor.set();
    lyrics.cameras = [subtitleCam];
    lyrics.alpha = 0;
    lyrics.screenCenter(FlxAxes.X);
    add(lyrics);

    if (PlayState.SONG.meta.name.toLowerCase() == 'thonk') fontt = 'Comic Sans MS.ttf';
}
//might expand upon later
function setLyricsText(text:String, size:Int, centerY:Bool) {
    lyrics.text = text;
    lyrics.setFormat(Paths.font(fontt), size, FlxColor.WHITE, FlxTextAlign.CENTER);
    if(fontt != 'VCR.ttf') lyrics.antialiasing = true;
    lyrics.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 4);
    lyrics.updateHitbox();
    lyrics.screenCenter(FlxAxes.X);
    if (centerY)
        lyrics.y = FlxG.height * 0.45;
}

function onEvent(event) {
    if (event.event.name != "Lyrics") return;

    var value1 = event.event.params[0];
    var value2 = event.event.params[1];

    // empty v1 = fade out
    if (value1 == '' || value1 == null) {
        FlxTween.tween(lyrics, {alpha: 0}, 0.5, {ease: FlxEase.linear});
        moving = false;
        return;
    }

    // mid or not
    mid = (value2 == 'mid');
    lyrics.y = mid ? 290: 590;
    targetY = mid ? 300 : 600;

    setLyricsText(value1, mid ? 72 : 36, mid);
	lyrics.alpha = 1;
    lyrics.scale.set(1.1, 1.1);
    FlxTween.tween(lyrics.scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.quadOut});

    moving = true;
}

function update(elapsed:Float) {
    if (moving) {
        // lerp my beloved
        lyrics.y = lerp(lyrics.y, targetY, elapsed * 32);
        if (Math.abs(lyrics.y - targetY) < 0.5) {
            lyrics.y = targetY;
            moving = false;
        }
    }
}
