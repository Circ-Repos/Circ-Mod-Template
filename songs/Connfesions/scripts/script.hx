import hxvlc.flixel.FlxVideoSprite;
import funkin.options.OptionsMenu;
import funkin.backend.system.framerate.Framerate;

var shaderReduce:CustomShader = new CustomShader("lowquality_0_reduce");
var shaderSharpen:CustomShader = new CustomShader("lowquality_1_sharpen");
var shaderBlockEffect:CustomShader = new CustomShader("lowquality_2_blockEffect");
var shaderMain:CustomShader = new CustomShader("lowquality_3_main");
var shaderAmplification:CustomShader = new CustomShader("lowquality_4_amplification");
var rainbowShader:CustomShader = new CustomShader("rainbow");

var video:FlxVideoSprite;
var camOther = new FlxCamera();
var transition:FlxSprite;
function create(){    
    PlayState.instance.introLength = 0;
    PlayState.instance.camGame.alpha = 0;   
    video = new FlxVideoSprite();
    video.load(Assets.getPath(Paths.video('SAWTONESONG')));
    video.camera = camHUD;
    video.play();
    video.stop();

    video.scale.set(1, 1); //kms
    video.antialiasing = true;
    video.bitmap.video.volume = 0;
    add(video);
    remove(video, true);
    insert(0, video);
    video.updateHitbox();
    FlxG.sound.volume = 0;

    FlxG.cameras.add(camOther, false);
    camOther.bgColor = 0;
    camOther.alpha = 1;
}
function destroy(){
    for (a in [shaderReduce, shaderSharpen, shaderBlockEffect, shaderMain, shaderAmplification])
        FlxG.game.removeShader(a);
    FlxG.game.removeShader(rainbowShader);
}
function postUpdate(e){
    comboGroup.forEachAlive(function(spr) if (spr.camera != camHUD) spr.camera = camHUD);
}
var itime:Float = 0;
function update(e){
    itime+=e;

    rainbowShader.iTime = itime;
}
function rainbow(){
    FlxG.game.addShader(rainbowShader);
}
function unrainbow(){
    FlxG.game.removeShader(rainbowShader);

}
function onSongStart(){
    insert(5, video);
    video.play();
    video.updateHitbox();
    for (a in [shaderReduce, shaderMain, shaderAmplification])
        FlxG.game.addShader(a);
}

function addRetro(){
    for (a in [shaderReduce, shaderSharpen, shaderBlockEffect, shaderMain, shaderAmplification])
        FlxG.game.addShader(a);
}
function removeRetro(){
    for (a in [shaderReduce, shaderSharpen, shaderBlockEffect, shaderMain, shaderAmplification])
        FlxG.game.removeShader(a);
}

function postCreate(){
    remove(iconP1);
    remove(iconP2);
    remove(healthBarBG);
    remove(healthBar);
    remove(scoreTxt);
    remove(accuracyTxt);
    remove(missesTxt);
    swagCounter = 0;
    Framerate.debugMode = 0;
}


function onSubstateOpen() if (video != null) video.pause();
function onSubstateClose() if (video != null) video.resume();
function onFocus() if (paused) onSubstateOpen(); // lil fix for when the window regains focus
function onCountdown(event) event.cancel();