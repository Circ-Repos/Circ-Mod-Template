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

var fullTitle:String = "PRIME // FIRST";
var fullSubtitle:String = "SOUL SURVIVOR";
var titleIndex:Int = 0;
var subtitleIndex:Int = 0;

var titleTimer:FlxTimer = new FlxTimer();
var subtitleTimer:FlxTimer = new FlxTimer();
var fadeOutTimer:FlxTimer = new FlxTimer();
var letterTimer:FlxTimer = new FlxTimer();
var fadeOutTimer:FlxTimer = new FlxTimer();
function createSplash():Void {
    titleText = new FlxText(0, FlxG.height / 2 - 80, FlxG.width, "");
    titleText.setFormat(Paths.font("vcr.ttf"), 72, FlxColor.WHITE, "center");
    titleText.scrollFactor.set(0, 0);
    titleText.alpha = 1;
	titleText.camera = camHUD;
    add(titleText);

    subtitleText = new FlxText(0, FlxG.height / 2 + 10, FlxG.width, "");
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
        delayTimer.start(0.3, function(_) {
            subtitleTimer.start(0.05, function(_) typeSubtitle(), fullSubtitle.length);
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

function postCreate() {
    sky = new FlxBackdrop(Paths.image("stages/hill/evilassBackground"), 0x01);
	sky.velocity.set(-25, 0);
	sky.y = -456;
    sky.scale.set(3,3);
    clouds = new FlxBackdrop(Paths.image("titlescreen/sky"), 0x01);
	clouds.velocity.set(-40, 0);
	clouds.y = -416;
    clouds.scale.set(3,3);
    clouds.color = FlxColor.GRAY;

	mountains = new FlxBackdrop(0, 0x01);
	mountains.frames = Paths.getFrames("titlescreen/mountains");
	mountains.animation.addByPrefix("mountains", "mountains", 6, true);
	mountains.animation.play("mountains");
	mountains.y = -124;
    mountains.scale.set(3,3);

	water = new FlxBackdrop(0, 0x01);
	water.frames = Paths.getFrames("titlescreen/water");
	water.animation.addByPrefix("water", "water", 12, true);
	water.animation.play("water");
	water.updateHitbox();
	water.y = 150;
    water.scale.set(3,3);

    ground = new FlxBackdrop(0, 0x01);
    ground.loadGraphic(Paths.image('stages/hill/hillGround'));
    ground.scale.set(6,6);
    ground.y = 700;
    insert(0, sky);
    insert(1, clouds);
    insert(2, mountains);
    insert(3, water);
    insert(4, ground);
    iconP1.alpha = 0.5;
}
function update(elapsed:Float) {
    healthBar.percent = 0;
    health = 0.01;
	iconP1.health = 1;
	iconP2.health = 1;

}
function onCameraMove(e) {
	switch (curCameraTarget){
		case 0: e.position.set(bfX, bfY);
		case 1: e.position.set(bfX, bfY);
		case 2: e.position.set(bfX, bfY);
	}
}