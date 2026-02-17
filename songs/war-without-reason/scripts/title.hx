import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.WindowUtils;
import funkin.backend.system.framerate.Framerate;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

var dadX:Float = -385;
var dadY:Float = 22;
var dadZoom:Float = 0.6;

var bfX:Float = 280;
var bfY:Float = 22;
var bfZoom:Float = 0.6;

var gfX:Float = -80;
var gfY:Float = 22;
var gfZoom:Float = 0.5;

var titleText:FlxText;
var subtitleText:FlxText;

var fullTitle:String = "VIOLENCE // CLIMAX";
var fullSubtitle:String = "...LIKE ATTENAS TO HEAVEN";
var titleIndex:Int = 0;
var subtitleIndex:Int = 0;

var titleTimer:FlxTimer = new FlxTimer();
var subtitleTimer:FlxTimer = new FlxTimer();
var fadeOutTimer:FlxTimer = new FlxTimer();
var letterTimer:FlxTimer = new FlxTimer();
var fadeOutTimer:FlxTimer = new FlxTimer();

function createSplash():Void {
    titleText = new FlxText(0, 80, FlxG.width, "");
    titleText.setFormat(Paths.font("vcr.ttf"), 72, FlxColor.WHITE, "center");
    titleText.scrollFactor.set(0, 0);
    titleText.alpha = 1;
	titleText.camera = camHUD;
    add(titleText);

    subtitleText = new FlxText(0, 140, FlxG.width, "");
    subtitleText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.LIGHTGRAY, "center");
    subtitleText.scrollFactor.set(0, 0);
    subtitleText.alpha = 1;
	subtitleText.camera = camHUD;
	add(subtitleText);


    typeNextLetter();
}

function typeTitle() {
    titleText.text += fullTitle.charAt(titleIndex);
    titleIndex++;

    if (titleIndex >= fullTitle.length) {
        var delayTimer = new FlxTimer();
        delayTimer.start(0.01, function(_) {
            subtitleTimer.start(0.01, function(_) typeSubtitle(), fullSubtitle.length);
        });
    }
}

function typeSubtitle() {
    subtitleText.text += fullSubtitle.charAt(subtitleIndex);
    subtitleIndex++;

    if (subtitleIndex >= fullSubtitle.length) {
        fadeOutTimer.start(2, function(_) {
            FlxTween.tween(titleText, {alpha: 0}, 0.6);
            FlxTween.tween(subtitleText, {alpha: 0}, 0.6);
        });
    }
}


function typeNextLetter():Void {
    if (titleIndex < fullTitle.length) {
        titleText.text += fullTitle.charAt(titleIndex);
        titleIndex++;
        letterTimer.start(0.05, function(_) typeNextLetter());
    } else if (subtitleIndex < fullSubtitle.length) {
        subtitleText.text += fullSubtitle.charAt(subtitleIndex);
        subtitleIndex++;
        letterTimer.start(0.05, function(_) typeNextLetter());
    } else {
        // Done typing both lines — fade out after delay
        fadeOutTimer.start(2, function(_) {
            FlxTween.tween(titleText, {alpha: 0}, 0.6);
            FlxTween.tween(subtitleText, {alpha: 0}, 0.6);
        });
    }
}
function onSongStart(){
    createSplash();
}
