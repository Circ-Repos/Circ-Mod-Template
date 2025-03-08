import openfl.geom.Rectangle;
import openfl.text.TextFormat;
import flixel.text.FlxTextBorderStyle;
import flixel.ui.FlxBar;
import flixel.FlxG;

import flixel.util.FlxStringUtil;

var prevHealthPerc;
var gfexists:Bool = false;

function postCreate(){
    if(gf!=null) gfexists = true;
    if(gfexists){
        doIconBop = false;
    }
}


function update(elapsed){
    prevHealthPerc = healthBar.percent;
    if(gfexists){

    for(icon in [iconP1, iconP2]) icon.scale.set(lerp(icon.scale.x, 0.9, 0.33), lerp(icon.scale.y, 0.9, 0.33));
}
}

function postUpdate() {
    healthBar.unbounded = true;
    healthBar.percent = CoolUtil.fpsLerp(prevHealthPerc, (health/healthBar.max) * 100, 0.1);
}



function onPlayerHit(){
    if(gfexists){
        iconP1.scale.set(1.1, 1.1); 
    }
}

function onDadHit(){
    if(gfexists){
     iconP2.scale.set(1.1, 1.1);
    }
}
function beatHit(){
    if(gfexists){
     for(icon in [iconP1, iconP2]) icon.scale.set(1.1, 1.1);
}
}