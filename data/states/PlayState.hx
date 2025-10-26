import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.util.FlxGradient;
import openfl.text.TextFormat;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;

public static var camOther:FlxCamera = null;

public var intendedScore:Int = 0;
public var lerpScore:Int = 0;
public var gradientHealthBar:FlxBar;
var displayedAccuracy:Float = 0;
var songName:String = PlayState.SONG.meta.name.toLowerCase();
var oldHealth:Float = 1;
var ht:Int = 1;
var penis:Int = 1;
var tweenHP:Int = 1;
// Helper function: darken a color by a percent (0.0 = no change, 1.0 = black)
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
	camOther.bgColor = 0;
	camOther.alpha = 1;
	FlxG.cameras.add(camOther, false);
	gradientBarJumpscare();

	scoreTxtUpscaleMoment();

	if(songName == "think"){
		remove(gradientHealthBar);
		insert(members.indexOf(healthBarBG) + 1, gradientHealthBar);
	}
}
function scoreTxtUpscaleMoment(){
	scoreTxt.setFormat(Paths.font('VCR.ttf'), 20, FlxColor.WHITE, FlxAxes.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	missesTxt.setFormat(Paths.font('VCR.ttf'), 20, FlxColor.WHITE, FlxAxes.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	accuracyTxt.setFormat(Paths.font('VCR.ttf'), 20, FlxColor.WHITE, FlxAxes.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	accuracyTxt.x += 330;
	scoreTxt.x -= 420;
	missesTxt.x -= 45;
	for(i in [scoreTxt, missesTxt, accuracyTxt])
	{
		i.size *= 3;
		i.pixelPerfectRender = true;
		i.scale.x /= 3;
		i.scale.y /= 3;
		i.antialiasing = true;
		i.y -= 21;
		i.borderSize *= 3;
		i.fieldWidth += 1000;
		i.x -= 1000/2;
		i.borderQuality = 100;
	}
}
function gradientBarJumpscare()
{

	// Create the bar
	gradientHealthBar = new FlxBar(
		healthBarBG.x + 4,
		healthBarBG.y + 4,
		FlxBarFillDirection.RIGHT_TO_LEFT,
		Std.int(healthBarBG.width - 8),
		Std.int(healthBarBG.height - 8),
		this,
		'health',
		0,
		maxHealth
	);
	gradientHealthBar.camera = camHUD;
	var dadColor:Int = (dad != null && dad.iconColor != null) ? dad.iconColor : 0xFFFF0000;
	var bfColor:Int  = (boyfriend != null && boyfriend.iconColor != null) ? boyfriend.iconColor : 0xFF66FF33;

	var dadGradient:Array<Int> = [dadColor, darkenColor(dadColor, 0.7)];
	var bfGradient:Array<Int>  = [bfColor, darkenColor(bfColor, 0.7)];

	var barWidth:Int  = Std.int(healthBarBG.width - 8);
	var barHeight:Int = Std.int(healthBarBG.height - 8);
	
	var leftGrad:FlxSprite = FlxGradient.createGradientFlxSprite(barWidth, barHeight, dadGradient, 1, 90, true);
	var rightGrad:FlxSprite = FlxGradient.createGradientFlxSprite(barWidth, barHeight, bfGradient, 1, 90, true);
	gradientHealthBar.createImageBar(leftGrad.pixels, rightGrad.pixels);

	add(gradientHealthBar);
	remove(gradientHealthBar, true);
	insert(members.indexOf(healthBarBG) + 2, gradientHealthBar);
	gradientHealthBar.scale.set(healthBar.scale.x, healthBar.scale.y);
}
function update() oldHealth = gradientHealthBar.percent;


function postUpdate(elapsed)
{	

	if (health < 2)
		ht = FlxMath.lerp(ht, health, FlxMath.bound(elapsed * 20, 0, 1));
	else
		ht = 2;

	gradientHealthBar.unbounded = true;
	tweenHP = FlxMath.lerp(tweenHP, health * 50, elapsed * 20);
	gradientHealthBar.percent = tweenHP;

	penis = 1 - (ht / 2);

	if(iconP1 != null) iconP1.x = gradientHealthBar.x + (gradientHealthBar.width * penis) + (150 * iconP1.scale.x - 150) / 2 - 26;
	if(iconP2 != null)iconP2.x = gradientHealthBar.x + (gradientHealthBar.width * penis) - (150 * iconP2.scale.x) / 2 - 26 * 2;



	intendedScore = songScore;
	lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 24)));
	scoreTxt.text = 'Score: ' + lerpScore;
	gradientHealthBar.camera = healthBar.camera;

	gradientHealthBar.angle = healthBar.angle;
	gradientHealthBar.alpha = healthBarBG.alpha;
	gradientHealthBar.x = healthBar.x;
	gradientHealthBar.y = healthBar.y;
	gradientHealthBar.scale.set(healthBar.scale.x, healthBar.scale.y);
	// Smoothly do acc
	displayedAccuracy = FlxMath.lerp(displayedAccuracy, accuracy, 0.15);
	displayedAccuracy = FlxMath.bound(displayedAccuracy, 0, 100); // makes it so you arent 167% Sure

	// Round to two decimal places
	var roundedAcc:Float = Math.round(displayedAccuracy * 100) / 1;
	if(accuracy == 0) accuracyTxt.text = 'Accuracy:0 -% - ' + curRating.rating;
	else accuracyTxt.text = 'Accuracy:' + roundedAcc + '% - ' + curRating.rating;
}

function destroy()
{
	if(camOther != null)
	{
		if(FlxG.cameras.list.contains(camOther))
		FlxG.cameras.remove(camOther);
		camOther.destroy();
	}
}