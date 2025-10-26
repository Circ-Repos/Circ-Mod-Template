import funkin.editors.charter.Charter;
import funkin.game.PlayState;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import flixel.math.FlxBasePoint;
import flixel.util.FlxColor;
import funkin.backend.utils.DiscordUtil;

import funkin.backend.system.framerate.SystemInfo;
var botplayTxts:Array<FlxText> = [];
static var curBotplay:Bool = false;
static var devControlBotplay:Bool = true;

var instructions:FlxText;
var xSpeed:Float = 150;
var ySpeed:Float = 100;
var systemInfoText:FlxText;
var theSysBool:Bool = false;
//free cam movement
var camFreeMoving:Bool = false;
//camera dedicated for any debug info
var camOther = new FlxCamera();
public var botplayTxt:FlxText;
var toggleFast:Bool = false;
var initialPlayback:Float = 1;
var playback:Float = 1;
var wasChartingMode:Bool = PlayState.chartingMode;

function create(){
    FlxG.cameras.add(camOther, false);
    camOther.bgColor = 0;
    camOther.alpha = 1;
}


function onSubstateClose() if (paused) setPlayback(initialPlayback);
function onGamePause() setPlayback(1);
function destroy() setPlayback(1);

function postCreate() {
	if (Charter.playtestInfo != null) initialPlayback = Charter.playtestInfo.playbackSpeed;
	setPlayback(initialPlayback);

    botplayTxt = new FlxText(125, 125, null, 'BOTPLAY', 32);
    botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    botplayTxt.visible = false;
    botplayTxt.borderSize = 1.25;
    botplayTxt.camera = camOther;
    add(botplayTxt);
    changeLogoColor(); // initial color

    instructions = new FlxText(20, 20, 1280,  "Buttons to Press:\n\n  4: Enable Botplay\n  5: Charting Menu\n  I: Debug Info\n  Arrow Keys: Move The Camera In CamGame Around\n  |: Reset Camera \n  Y: Fast Forward (While held Down)\n (Will be adding more as time goes on)", 32);
    instructions.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    instructions.borderSize = 1.25;
    instructions.antialiasing = false;
    instructions.camera = camOther;
    instructions.alpha = 0;
    add(instructions);
    new FlxTimer().start(5, () -> FlxTween.tween(instructions, {alpha: 0}, 3));
    //trace(SystemInfo.__formattedSysText);

}

function onCameraMove(event){
    //trace(event.position);
    if(camFreeMoving) event.cancel();
}
function onNoteHit(event){
    if(player.cpu && event.character.curCharacter == boyfriend.curCharacter && !event.note.isSustainNote){
        event.countAsCombo = true;
        event.accuracy = 1;
        event.countScore = true;
        health += 0.02;
        songScore += 300;
        goodNoteHit(event);
        updateRating();
        displayRating(event.rating, event);
        if(combo > 9) displayCombo(event);
        event.showSplash = true;
        splashHandler.showSplash(event.note.splash, event.note.__strum);
    }
}

function setPlayback(p:Float) {
	FlxG.timeScale = playback = p;
	//inst.pitch = vocals.pitch = p;
	//for (strline in strumLines.members) strline.vocals.pitch = p;
}

function update(elapsed:Float) {

	if (FlxG.keys.pressed.Y) {
		if (!toggleFast) {
			toggleFast = true;
			setPlayback(10);
		}
	}
	else if (toggleFast) {
		toggleFast = false;
		setPlayback(1);
	}

    var hitX = false;
    var hitY = false;
    if (startingSong || !canPause || paused || health <= 0) return;
    if (FlxG.keys.justPressed.FIVE) FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, true));
    if (FlxG.keys.justPressed.LEFT){
        camZooming = false;
        camFreeMoving = true;
        camFollow.setPosition(camFollow.x - 10, camFollow.y);
    } 
    if (FlxG.keys.justPressed.DOWN){
        camZooming = false;
        camFreeMoving = true;
        camFollow.setPosition(camFollow.x, camFollow.y + 10);
    } 
    if (FlxG.keys.justPressed.UP){
        camZooming = false;
        camFreeMoving = true;
        camFollow.setPosition(camFollow.x, camFollow.y - 10);
    } 
    if (FlxG.keys.justPressed.RIGHT){
        camZooming = false;
        camFreeMoving = true;
        camFollow.setPosition(camFollow.x + 10, camFollow.y);
    } 
    if (FlxG.keys.justPressed.BACKSLASH){
        camZooming = true;
        camFreeMoving = false;
    }
    updateBotplay(elapsed);
    
    if(FlxG.keys.justPressed.I) {
        if (systemInfoText.alpha = 0) {
            popupInfo(true);
        }
        else {
            popupInfo(false);
        }
    }
    if(player.cpu){
                // Move botplayTxt
        botplayTxt.x += xSpeed * elapsed;
        botplayTxt.y += ySpeed * elapsed;

        // Bounce off left/right edges
        if (botplayTxt.x <= 0) {
            botplayTxt.x = 0;
            xSpeed *= -1;
            hitX = true;
        } else if (botplayTxt.x + botplayTxt.width >= FlxG.width) {
            botplayTxt.x = FlxG.width - botplayTxt.width;
            xSpeed *= -1;
            hitX = true;

        }

        // Bounce off top/bottom edges
        if (botplayTxt.y <= 0) {
            botplayTxt.y = 0;
            ySpeed *= -1;
            hitY = true;
        } else if (botplayTxt.y + botplayTxt.height >= FlxG.height) {
            botplayTxt.y = FlxG.height - botplayTxt.height;
            ySpeed *= -1;
            hitY = true;
 
        }
        if (hitX || hitY) {
            changeLogoColor();
        }
    }
}

function changeLogoColor():Void {
    var randColor:Int = FlxColor.fromRGB(FlxG.random.int(50, 255), FlxG.random.int(50, 255), FlxG.random.int(50, 255));
    botplayTxt.color = randColor;
}
function popupInfo(theBool:Bool){
    if(theSysBool == false){
        FlxTween.tween(systemInfoText, {alpha: 1}, 0.7);

        theSysBool = true;
    }
    else{
        FlxTween.tween(systemInfoText, {alpha: 0}, 0.7);

        theSysBool = false;

    }
}

var leAlpha:Float = 0;
function setBotplayTxtsAlpha(input:Float) {
	botplayTxt.alpha = 0;
}

public var botplaySine:Float = 0;
function updateBotplay(elapsed:Float) {
	if (FlxG.keys.justPressed.FOUR) curBotplay = !curBotplay;
    for(strumLine in strumLines){
    if (!strumLine.opponentSide) {
        strumLine.cpu = FlxG.keys.pressed.FIVE || curBotplay;
        botplayTxt.visible = curBotplay;
    }
    }

		// stole from cne source lmao
		var pos = new FlxBasePoint();
		var scale = new FlxBasePoint();
		var r = 0;
		if (r > 0) {
			scale.x /= r;
			scale.y /= r;
			botplayTxt.scale.set(scale.x * 1.43, scale.y * 1.43);

		}
		pos.put();
		scale.put();
	if (curBotplay) {
		botplaySine += 180 * elapsed;
		leAlpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		setBotplayTxtsAlpha(leAlpha);
	}
    if (!curBotplay){
        leAlpha = 0;
        botplayTxt.alpha = 0;
    }
    
}