import openfl.display.BlendMode;
import funkin.backend.FunkinSprite;
import haxe.Json;
import sys.io.File;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.system.Conductor;
import flixel.text.FlxText;
import openfl.display.BlendMode;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import funkin.backend.utils.DiscordUtil;

var evilness:FunkinSprite;
var blackFG:FunkinSprite;

var introcc = new CustomShader('colorcorrection');

var fogshader = new CustomShader('fog epic');
var cloud_shader = new CustomShader('cloud');
var cooleffect:FunkinSprite;
var fogtuah:FunkinSprite;
var melt = new CustomShader('melt');

var snow = new CustomShader('snowfall');
var atotalElapsed:Float = 0;

var colorcorrection = new CustomShader('colorcorrection');

var rainShader:ScriptableShader;
public var rainColor = FlxColor.RED;
var time:Float = 0;

function smoothLerpPrecision(base:Float, target:Float, deltaTime:Float, duration:Float):Float
{
	if (deltaTime == 0) return base;
	if (base == target) return target;
	return lerp(target, base, Math.pow(1 / 100, deltaTime / duration));
}
function onNoteHit(event)
{
	rainTimeScale += 0.7;
}

function lerp(base:Float, target:Float, alpha:Float):Float
{
	if (alpha == 0) return base;
	if (alpha == 1) return target;
	return base + alpha * (target - base);
}

function getColorVec(color:Int):Array<Float> {
	return [
		(color >> 16 & 0xFF) / 255,
		(color >> 8 & 0xFF) / 255,
		(color & 0xFF) / 255
	];
}
function onSongStart(){
	comboGroup.x = 150;
}
function postCreate() {
	bg.alpha = 0;
	playCamOffset = [-15,17.5,-20,15];
        if (Options.gameplayShaders) {
        cloud_shader.red_amt = 0.5;
        cloud_shader.green_amt = 0.0;
        cloud_shader.blue_amt = 0.0;

        fogtuah = new FunkinSprite(-750, -400).makeGraphic(3680, 2920, FlxColor.RED);
        fogtuah.scrollFactor.set(0.7, 0.7);
        fogtuah.shader = cloud_shader;
        fogtuah.blend = BlendMode.ADD;
        fogtuah.antialiasing = true;
        add(fogtuah);
		remove(fogtuah,true);
		insert(4,fogtuah);


        colorcorrection.brightness = -0.2;
        colorcorrection.contrast = 1.1;
        colorcorrection.saturation = 0.7;
        colorcorrection.customred = 0.3;
        colorcorrection.customgreen = 0.0;
        colorcorrection.customblue = 0.0;
        FlxG.camera.addShader(colorcorrection);
        camHUD.addShader(colorcorrection);

		for(i in playerStrums.members) i.alpha = 0.75;
    }

	healthBarBG.alpha = 0;
	healthBar.alpha = 0;
	iconP1.alpha = 0;
	iconP2.alpha = 0;

    songNameText = new FunkinText(-500, 5, FlxG.width, "P-2:\nWAIT OF THE WORLD");
    songNameText.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, "center");
    songNameText.scrollFactor.set(0, 0);
	songNameText.antialiasing = false;

    songNameText.alpha = 1;
	songNameText.camera = camHUD;
	add(songNameText);

	accuracyTxt.alignment = scoreTxt.alignment = missesTxt.alignment = FlxTextAlign.LEFT;
	accuracyTxt.x = scoreTxt.x = missesTxt.x = -475;
	accuracyTxt.y = 35;

	missesTxt.y = accuracyTxt.y + accuracyTxt.height - 25;
	scoreTxt.y = missesTxt.y + missesTxt.height - 25;

	if (Options.gameplayShaders) {
		introcc.brightness = -0.5;
		introcc.contrast = 1;
		introcc.saturation = 0.65;
		introcc.customred = 0.35;
		introcc.customgreen = 0.1;
		introcc.customblue = 0.0;

		dad.shader = boyfriend.shader = gf.shader = introcc;
	}

    if(Options.gameplayShaders)
	{
		rainShader = new CustomShader('rainShaderSimple');
		rainShader.uRainColor = getColorVec(rainColor);
		camGame.addShader(rainShader);
		rainShader.uScale = FlxG.height / 200;
		rainShader.uIntensity = 0.5;
		rainShader.uTime = 0;
	}

	black = new FlxSprite(-1,-2).makeSolid(FlxG.width + 5, FlxG.height + 5, 0xFF000000);
	black.camera = camHUD;
	black.visible = true;
	add(black);
	if(PlayState.chartingMode) black.visible = false;
	relayer(black,0);
}
function relayer(fucker,num){
	remove(fucker, true);
	insert(num, fucker);
}
var bgbeat = false;
var lastBeat = 0;
function beatHit(curBeat){
	var beat = Conductor.getBeats(PlayState.instance.beatInterval, PlayState.instance.camZoomingInterval, PlayState.instance.camZoomingOffset);
	if (curBeat % PlayState.instance.camZoomingInterval == 0 && bgbeat) {
		FlxTween.cancelTweensOf(bg);
		bg.alpha = 1;
		trace(beat);
		FlxTween.tween(bg, {alpha: 0}, 0.6);
	}
	lastBeat = beat;
}
function postUpdate(){
	for (i in playerStrums.notes) {
		i.alpha = 0.45;
	} 
}
var rainTimeScale:Float = 1.0;
var totalElapsed:Float = 0;
function stepHit(){
	switch(curStep){
		case 12:
			FlxTween.tween(black, {alpha: 0}, 5);
		case 485:
			bgbeat = true;
		case 4331:
			bgbeat = false;
		case 4577://tween dad to x: 70
			FlxTween.tween(dad, {x: 70}, 1);
		case 4644: boyfriend.visible = false;
	}
}
function update(elapsed) {
	if (!Options.gameplayShaders || Options.lowMemoryMode) return;
	totalElapsed += elapsed;
	cloud_shader.iTime = totalElapsed;

    time += elapsed * rainTimeScale;
	if(rainShader != null)
	{
		rainShader.uCameraBounds = [camGame.viewLeft, camGame.viewTop, camGame.viewRight, camGame.viewBottom];
		rainShader.uTime = time;
	}
	rainTimeScale = smoothLerpPrecision(rainTimeScale, 0.02, elapsed, 1.535);
}

function onGameOver(event)
{
	if (rainShader != null) camGame.removeShader(rainShader);
}