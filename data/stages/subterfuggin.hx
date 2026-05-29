// please move to stage .hx file when one exists - zzshu
//hey zz you smell like balls - circ, i stole your script for no reason lol
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.tweens.misc.ColorTween;

var borderCam = null;
var border:FlxSprite;
var fire:FlxSprite;
var mrsubterfuge:FlxSprite;

function create(){
  FlxG.cameras.add(borderCam = new HudCamera(), false);
  borderCam.bgColor = 0;
}

function killBFfromFNF(v:String){
    dad.alpha = v;
    boyfriend.alpha = v;
}

function addSubterBeast(){
    //tween lore
    mrsubterfuge.visible = true;
    FlxTween.tween(mrsubterfuge, {y: 0}, 0.9, {ease: FlxEase.circOut});
}

function postCreate() {
    //hide most hud shit
    healthBar.alpha = healthBarBG.alpha = iconP1.alpha = iconP2.alpha = 0;
    //scoreTxt.alpha = missesTxt.alpha = accuracyTxt.alpha = 0;
	//HUD & Fire
    mrsubterfuge = new FlxSprite(0, 900, Paths.image("stages/subterfuggin/2017Xphase3"));
	mrsubterfuge.scale.set(1, 1);
	mrsubterfuge.camera = camHUD;
	add(mrsubterfuge);

    remove(mrsubterfuge, true);
    insert(0, mrsubterfuge);

    border = new FlxSprite(0, 0, Paths.image("stages/subterfuggin/vignette"));
	border.scale.set(1, 1);
	border.camera = borderCam;
	border.alpha = 1;
	add(border);
    border.color = FlxColor.BLACK;

    fire = new FlxSprite();
    fire.frames = Paths.getFrames('stages/subterfuggin/cieloburn');
    fire.animation.addByPrefix('idle','cieloburn', 24);
    fire.scale.set(2, 2);
    fire.animation.play('idle');
    fire.alpha = 0;
    fire.screenCenter();
    fire.scrollFactor.set();
    fire.color = FlxColor.RED;
    add(fire);

    remove(fire, true);
    insert(4, fire);
}

function killCamGameFast(){
    camGame.alpha = 0;
}

function thefunctiontoendyoursubterfuge(){
    remove(mrsubterfuge, false);
    remove(border, false);
    remove(fire, false);

}

function bg1VisTog(v:String) FlxTween.tween(bg1, {alpha: 0}, 1, {ease: FlxEase.quadOut});

function changeAlpha(v:String) FlxTween.tween(border, {alpha: v}, 1, {ease: FlxEase.quadOut});

function fireAlpha(v:String){
     FlxTween.tween(fire, {alpha: v}, 0.7, {ease: FlxEase.quadOut});
     border.color = FlxColor.RED;
}

function camGameAlpha(v:String){
    FlxTween.tween(camGame, {alpha: v}, 1, {ease: FlxEase.quadOut});

}
function hideSexArrows(v:String){
    //tween lore
    for (e in strumLines.members[0]) {
		e.alpha = v;
        FlxTween.tween(e, {alpha: v}, 1, {ease: FlxEase.quadOut});
  	}
    FlxTween.tween(camHUD, {alpha: v}, 1, {ease: FlxEase.quadOut});
    FlxTween.tween(borderCam, {alpha: v}, 1, {ease: FlxEase.quadOut});

}