import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.display.BlendMode;

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

    lyrics = new FlxText(FlxG.width, 600, 0, "");
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
function setLyricsText(text:String, size:Int, centerY:Bool, color:Int = 0xFFFFFFFF, font:String = 'VCR.ttf') {
    lyrics.text = text;
    var curFont = lyrics.font;

    if(curFont != font) {
        lyrics.setFormat(Paths.font(font), size, color, FlxTextAlign.CENTER);
        if(font != 'VCR.ttf') lyrics.antialiasing = true;
        if(font == 'Sonic Advanced 2.ttf') lyrics.antialiasing = false;
        lyrics.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 4);

    }


    lyrics.updateHitbox();
    lyrics.screenCenter(FlxAxes.X);
    if (centerY && moving)
        lyrics.y = FlxG.height * 0.45;
    if(centerY && !moving)
        lyrics.y = FlxG.height * 0.5;
    lyrics.camera = subtitleCam;
    lyrics.shader = null;

    
}
function onEvent(event) {
    if (event.event.name != "Lyrics") return;

    var value1 = event.event.params[0];
    var centerBool = event.event.params[1]; // whether to center
    var fontValue = event.event.params[2]; // font subsitute
    var animate = event.event.params[3]; // do the tween or nah?
    var color = event.event.params[4];
    if(fontValue != '' && fontValue != null) fontt = fontValue;
    // trace('Text: ' + value1);
    // trace('Center: ' + centerBool);
    // trace('font: ' + fontValue);
    // trace('Animate: ' + animate);
    // trace('color: ' + color);

    // empty v1 = fade out
    if (value1 == '' || value1 == null) {
        FlxTween.tween(lyrics, {alpha: 0}, 0.5, {ease: FlxEase.linear});
        moving = false;
        return;
    }
    // mid or not
    mid = centerBool;
    lyrics.y = mid ? 290: 590;
    targetY = mid ? 300 : 600;

    setLyricsText(value1, mid ? 72 : 36, mid, color, fontValue);
	lyrics.alpha = 1;
    

    if(animate){
        lyrics.scale.set(1.1, 1.1);
        FlxTween.tween(lyrics.scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.quadOut});
        moving = true;
    }
    if(!animate){
        lyrics.y = targetY;
    }
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
