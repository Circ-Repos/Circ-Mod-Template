import openfl.geom.Rectangle;
import openfl.text.TextFormat;
import flixel.text.FlxTextBorderStyle;
import flixel.ui.FlxBar;
import flixel.FlxG;

import flixel.util.FlxStringUtil;

public var timeBarBG:FlxSprite;
public var timeBar:FlxBar;
public var timeTxt:FlxText;

public var allowWech:Bool = true;
var prevHealthPerc;

function postCreate(){
    doIconBop = false;
}


function update(elapsed){
    prevHealthPerc = healthBar.percent;

    for(icon in [iconP1, iconP2]) icon.scale.set(lerp(icon.scale.x, 0.9, 0.33), lerp(icon.scale.y, 0.9, 0.33));
    if (inst != null && timeBar != null && timeBar.max != inst.length) timeBar.setRange(0, Math.max(1, inst.length));
}

function postUpdate() {
    healthBar.unbounded = true;
    healthBar.percent = CoolUtil.fpsLerp(prevHealthPerc, (health/healthBar.max) * 100, 0.1);
}



function onPlayerHit(_) iconP1.scale.set(1.1, 1.1); 

function onDadHit() iconP2.scale.set(1.1, 1.1);

function beatHit() for(icon in [iconP1, iconP2]) icon.scale.set(1.1, 1.1);