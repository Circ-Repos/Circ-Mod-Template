import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.util.FlxGradient;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import funkin.backend.utils.DiscordUtil;
import flixel.util.FlxStringUtil;
import StringTools;
import funkin.backend.system.framerate.Framerate;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.system.System;
import funkin.backend.utils.MemoryUtil;
import funkin.backend.system.Main;

import haxe.Timer;
import cpp.vm.Gc;
import flixel.util.FlxStringUtil;

import openfl.display.Shape;
import openfl.display.BitmapData;

public static var camOther:FlxCamera = null;

var displayedAccuracy:Float = 0;
var displayedAccuracyB:Float = 0;
var songName:String = PlayState.SONG.meta.name.toLowerCase();
var oldHealth:Float = 1;
var ht:Int = 1;
var penis:Int = 1;
var tweenHP:Int = 1;

var swagShitMemory:Float = 0;
var swagShitMemoryPeak:Float = 0;

var psychFPS;
var times:Array<Float>;
var newRatings:Array<Array<Dynamic>> = [
	['LMAO', 101],
	['P', 100],
	['SSS', 99],
	['SS', 96],
	['S', 95],
	['A', 94],
	['B', 89],
	['C', 79],
	['D', 74],
	['NICE' , 69],
	['F', 68],
	['...', 67], //67 is not funny, Here come dat boi was
	['BRU', 66],
	['A S S', 50],
	['DIE',49],
	['N/A', 0]
];

//why did i make this a func?
function darkenColor(color:Int, amount:Float):Int {
    var a = (color >> 24) & 0xFF;
    var r = (color >> 16) & 0xFF;
    var g = (color >> 8) & 0xFF;
    var b = color & 0xFF;

    r = Std.int(r * (1 - amount));
    g = Std.int(g * (1 - amount));
    b = Std.int(b * (1 - amount));

    return (a << 24) | (r << 16) | (g << 8) | b;
}

function postCreate()
{
	camOther = new FlxCamera();
	camOther.bgColor = FlxColor.TRANSPARENT;
	camOther.alpha = 1;
	FlxG.cameras.add(camOther, false);
	gradientBarJumpscare();

	scoreTxtUpscaleMoment();
}
function scoreTxtUpscaleMoment(){
	scoreTxt.setFormat(Paths.font('VCR.ttf'), 20, FlxColor.WHITE, FlxAxes.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	missesTxt.setFormat(Paths.font('VCR.ttf'), 20, FlxColor.WHITE, FlxAxes.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	accuracyTxt.setFormat(Paths.font('VCR.ttf'), 20, FlxColor.WHITE, FlxAxes.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	accuracyTxt.x += 420;
	scoreTxt.x -= 420;
	//missesTxt.x -= 45;
	for(i in [scoreTxt, missesTxt, accuracyTxt])
	{
		i.size *= 3;
		i.pixelPerfectRender = true;
		i.scale.x /= 3;
		i.scale.y /= 3;
		i.antialiasing = false;
		i.y -= 21;
		i.borderSize *= 3;
		i.fieldWidth += 1000;
		i.x -= 1000/2;
		i.borderQuality = 100;
	}

	if(songName == 'thonk'){
		for(cams in FlxG.cameras.list){
			removeShaderFromCamera(cams);
		}
	}
}
var fillDir:String = 'RIGHT_TO_LEFT';

function gradientBarJumpscare()
{

	// Create the bar
	remove(healthBar, false);
	healthBar = new FlxBar(
		healthBarBG.x + 4,
		healthBarBG.y + 4,
		songName == 'gift' ? FlxBarFillDirection.LEFT_TO_RIGHT : FlxBarFillDirection.RIGHT_TO_LEFT,
		Std.int(healthBarBG.width - 8),
		Std.int(healthBarBG.height - 8),
		this,
		'health',
		0,
		maxHealth
	);
	healthBar.camera = camHUD;
	public var dadColor:Int = (dad != null && dad.iconColor != null) ? dad.iconColor : 0xFFFF0000;
	public var bfColor:Int  = (boyfriend != null && boyfriend.iconColor != null) ? boyfriend.iconColor : FlxColor.YELLOW;
		if(songName == 'distraught'){
		bfColor = 0xFFF6D9FF;
	}
	var dadGradient:Array<Int> = [dadColor, darkenColor(dadColor, 0.7)];
	var bfGradient:Array<Int>  = [bfColor, darkenColor(bfColor, 0.7)];
	if(songName == 'meanie'){
		dadColor = FlxColor.GRAY;

		dadGradient = [dadColor, darkenColor(dadColor, 1)];

	}

	var barWidth:Int  = Std.int(healthBarBG.width - 8);
	var barHeight:Int = Std.int(healthBarBG.height - 8);
	
	var leftGrad:FlxSprite = FlxGradient.createGradientFlxSprite(barWidth, barHeight, dadGradient, 1, 90, true);
	var rightGrad:FlxSprite = FlxGradient.createGradientFlxSprite(barWidth, barHeight, bfGradient, 1, 90, true);

	healthBar.createImageBar(leftGrad.pixels, rightGrad.pixels);
	add(healthBar);
	remove(healthBar, true);
	insert(members.indexOf(healthBarBG) + 1, healthBar);
	if(songName == 'think') healthBarBG.visible = false;
}
function update() oldHealth = healthBar.percent;
var treeTime:Bool = false;

function stepHit(curStep:Int) {
	if(songName == 'gift' && curStep == 1840){
		treeTime = true;
	}
}
var newRString:String;
function postUpdate(elapsed){
	if (health < 2)
		ht = FlxMath.lerp(ht, health, FlxMath.bound(elapsed * 20, 0, 1));
	else
		ht = 2;

	if(!healthBar.unbounded) healthBar.unbounded = true;
	tweenHP = FlxMath.lerp(tweenHP, health * 50, elapsed * 20);
	healthBar.percent = tweenHP;

	penis = 1 - (ht / 2);

	var lerpSpeed:Float = 0.15;

	var p1Target = healthBar.x + (healthBar.width * penis)	+ (150 * iconP1.scale.x - 150) / 2 - 26;

	var p2Target = healthBar.x + (healthBar.width * penis) - (150 * iconP2.scale.x) / 2	- 26 * 2;

	if (iconP1 != null) iconP1.x = FlxMath.lerp(iconP1.x, p1Target, lerpSpeed);

	if (iconP2 != null) iconP2.x = FlxMath.lerp(iconP2.x, p2Target, lerpSpeed);

	if(songName == 'meanie'){
		if(iconP1 != null) iconP1.x = healthBar.x + (healthBar.width) + (150 * iconP1.scale.x - 150) / 2 - 26;
	}

	scoreTxt.text = 'Score: ${FlxStringUtil.formatMoney(songScore, false, true)}';

	var displayedAcc = CoolUtil.quantize(accuracy * 100, 100);
	displayedAccuracy = FlxMath.lerp(displayedAccuracy, displayedAcc, 0.15);
	displayedAccuracyB = CoolUtil.quantize(displayedAccuracy, 100);

	for(i in newRatings){
		if(displayedAccuracyB <= i[1]){
			newRString = i[0];
		}
	}
	
	if(misses == 0) missesTxt.text = 'Combo: ${combo} - FC';
	if(misses != 0) missesTxt.text = 'Combo: ${combo} - Misses: ${misses}';

	accuracyTxt.text = 'Acc: ${accuracy < 0 ? "??.??%" : displayedAccuracyB + "%"} - ${newRString}';
}

function destroy(){
	if(camOther != null)
	{
		if(FlxG.cameras.list.contains(camOther))
		FlxG.cameras.remove(camOther);
		camOther.destroy();
	}

	if(songName == 'think-(og)'){
		Main.instance.removeChild(psychFPS);
		Framerate.instance.visible = true;
	}
}