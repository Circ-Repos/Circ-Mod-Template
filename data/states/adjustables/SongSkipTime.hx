import flixel.util.FlxStringUtil;
import funkin.menus.ui.Alphabet;
import funkin.backend.utils.FunkinParentDisabler;
import flixel.FlxCamera.FlxCameraFollowStyle;

import funkin.editors.charter.Charter;

var options:FlxTypedGroup;
var optionsExtra:FlxTypedGroup;
var settings:Array<Array<Dynamic>> = [
	['SKIP TO:', 'time'],
    ['CAMERA DEBUG', 'standard'],
    ['ENTER CHARTER', 'standard'],
    ['SAVE & EXIT SONG', 'standard']
];
var curOption:Int = 0;
var oldTime:Float = PlayState.instance.inst.time;
var newTime:Float = PlayState.instance.inst.time;

function create(){
    add(parentDisabler = new FunkinParentDisabler());
    camera = subCam = new FlxCamera();
	subCam.bgColor = 0;
	FlxG.cameras.add(subCam, false);

    bg = new FlxSprite(0, 0).makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
    bg.alpha = 0;
    add(bg);
    FlxTween.tween(bg, {alpha: 0.75}, 0.25, {ease: FlxEase.cubeOut});

    camFollowDebug = new FlxSprite(0, 0).makeSolid(2, 2, FlxColor.TRANSPARENT);
    camFollowDebug.screenCenter();
    add(camFollowDebug);

    options = new FlxTypedGroup();
    optionsExtra = new FlxTypedGroup();
    for(i in settings){
        var texts = new Alphabet(0, 0, i[0], true);
		texts.alpha = 0.5;
        texts.isMenuItem = true;
		options.add(texts);
        switch(i[1]){
			case 'time':
				var numberTxt = new Alphabet(0, 0, FlxStringUtil.formatTime((PlayState.instance.inst.time) * 0.001, false) + '/' + FlxStringUtil.formatTime((PlayState.instance.inst.length) * 0.001, false), true);
				optionsExtra.add(numberTxt);
        }
    }

    add(options);
    add(optionsExtra);

    chooseSelection(0);
}

var holdTime:Float = 0;
var doCamDebug:Bool = false;

function update(elapsed){
    if(!doCamDebug){
        if(controls.UP_P || controls.DOWN_P){
            chooseSelection(controls.UP_P ? -1 : 1);
        }

        for(o=>option in options.members){
            option.targetY = (o - curOption);
        }

        for(o=>ov in optionsExtra.members){
            switch(settings[o][1]){
                case 'time': ov.y = options.members[o].y;

            }
            ov.x = options.members[o].x + options.members[o].width + 70;
        }

        switch(settings[curOption][1]){
            case 'time':
                if(controls.LEFT_P || controls.RIGHT_P){
                    holdTime = 0;
                    newTime = FlxMath.wrap(newTime + (controls.LEFT_P ? -1000 : 1000), 0, PlayState.instance.inst.length);
                }

                if(controls.LEFT || controls.RIGHT){
                    holdTime += elapsed;

                    if(holdTime >= 0.5){
                        newTime = FlxMath.wrap(newTime + (controls.LEFT ? -20000 : 20000) * elapsed, 0, PlayState.instance.inst.length);
                    }
                }

                optionsExtra.members[curOption].text = FlxStringUtil.formatTime((newTime) * 0.001, false) + '/' + FlxStringUtil.formatTime((PlayState.instance.inst.length) * 0.001, false);

                if(controls.ACCEPT){
                    if(oldTime <= newTime){
                        PlayState.instance.inst.time = newTime;
                        Conductor.songPosition = newTime;
                        for (strumLine in PlayState.instance.strumLines.members){
                            for(notes in strumLine.notes){
                                if(notes.strumTime <= newTime){
                                    notes.destroy();
                                }
                            }
                        }
                        close();
                    } else {
                        loadTime = [true, newTime];
                        parentDisabler.reset();
                        PlayState.instance.registerSmoothTransition();
                        FlxG.resetState();
                    }
                }
            case 'standard':
                if(controls.ACCEPT){
                    switch(curOption){
                        case 1: 
                            for(o=>ov in optionsExtra.members) ov.visible = false;
                            for(o=>ov in options.members) ov.visible = false;
                            for(i in FlxG.cameras.list) if(i != FlxG.camera) i.visible = false;
                            bg.visible = false;
                            doCamDebug = true;
                        case 2: FlxG.switchState(new Charter(PlayState.SONG.meta.name, 'normal', null, true));
                        case 3:
                            PlayState.chartingMode = false;
                            PlayState.instance.endSong();
                    }
                }
        }
        if(controls.BACK) close();
    } else {
        if(controls.LEFT || controls.RIGHT) FlxG.camera.scroll.x += (controls.LEFT ? -3 : 3) * (FlxG.keys.pressed.SHIFT ? 7 : 1) * (elapsed * 60);
        if(controls.UP || controls.DOWN) FlxG.camera.scroll.y += (controls.UP ? -3 : 3) * (FlxG.keys.pressed.SHIFT ? 7 : 1) * (elapsed * 60);
        if(FlxG.keys.pressed.Q || FlxG.keys.pressed.E){
            FlxG.camera.zoom += (FlxG.keys.pressed.Q ? -0.03 : 0.03) * (FlxG.keys.pressed.SHIFT ? 2 : 1) * (elapsed * 60);
            if(FlxG.camera.zoom < 0.3) FlxG.camera.zoom = 0.3;
            else if(FlxG.camera.zoom > 5) FlxG.camera.zoom = 5;
        }

        if(controls.BACK){
            for(o=>ov in optionsExtra.members) ov.visible = true;
            for(o=>ov in options.members) ov.visible = true;
            for(i in FlxG.cameras.list) if(i != FlxG.camera) i.visible = true;
            bg.visible = true;
            doCamDebug = false;
        }
    }
}

function chooseSelection(f){
    curOption = FlxMath.wrap(curOption + f, 0, options.length - 1);
    for(option in options.members){
        option.alpha = 0.6;
    }

    options.members[curOption].alpha = 1;

    for(ov in optionsExtra.members){
        ov.alpha = 0.6;
    }

    options.members[curOption].alpha = 1;
    if(optionsExtra.members[curOption] != null) optionsExtra.members[curOption].alpha = 1;
}

function destroy(){
    if (FlxG.cameras.list.contains(subCam)) FlxG.cameras.remove(subCam);
}