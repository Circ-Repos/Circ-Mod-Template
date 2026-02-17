import funkin.menus.ui.Alphabet;
import funkin.backend.system.framerate.Framerate;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextFormat;

import funkin.backend.utils.FunkinParentDisabler;

var options:FlxTypedGroup;
var optionsExtra:FlxTypedGroup;
var adjustables:Array<Array<Dynamic>> = [
	['Playback Rate', 'CNEAdjustablesPlayback', 'num', [0.1, 10], 'Change the Playback Rate of the gameplay.\n<(Default: 1 | Vallue Range: 0.1 - 10)<', 'Debug'],
    ['Scroll Speed Mult', 'CNEAdjustablesScroll', 'num', [0.1, 5], 'Change the Scroll Speed Multiplier of the gameplay.\n<(Default: 1 | Value Range: 0.1 - 5)<', 'Gameplay'],
    ['Botplay Mode', 'CNEAdjustablesBotplay', 'bool', null, 'When checked, botplay will be enabled!\n<(Default: OFF)<', 'Gameplay'],
	['Practice Mode', 'CNEAdjustablesPractice', 'bool', null, 'When checked, you will never be able to game over. *Warning: Your save data will not be saved!*\n<(Default: OFF)<', 'Gameplay'],
    ['One Hit Mode', 'CNEAdjustablesOneMiss', 'bool', null, 'When checked, if you miss even a single note, you will instantly game over.\n<(Default: OFF)<', 'Gameplay'],
    ['Instant Reset', 'CNEAdjustablesIReset', 'bool', null, 'When checked, the song will restart instantly, skipping the death animation.\n<(Default: OFF)<', 'Gameplay'],
    ['Use Options Outside', 'CNEAdjustablesUsableOutside', 'bool', null, 'When checked, use these options in game! *[1: -PBR | 2: +PBR | 3: x10 PBR | 4: Botplay | 5: Practice]*\n<(Default: OFF)< >IF ON, THESE OPTIONS WILL BE VIEWABLE ON THE FPS COUNTER>', 'Debug']
];
var curOption:Int = 0;
var holdTime:Float = 0;

var offsets = [
    ['true', 'Check Box Selected Static0', 23, -32],
    ['false', 'Check Box unselected0', 0, -70],
    ['trueing', 'Check Box selecting animation0', 35, 29],
    ['falseing', 'Check Box deselect animation0', 25, -12]
];

var oldTimeScale:Float = 0;
function create(){
    FlxG.timeScale = 1;
    if(FlxG.state is PlayState) add(parentDisabler = new FunkinParentDisabler());

    Framerate.offset.y = 75;
    camera = subCam = new FlxCamera();
	subCam.bgColor = 0;
	FlxG.cameras.add(subCam, false);

    bg = new FlxSprite(0, 0).makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
    bg.alpha = 0;
    add(bg);
    FlxTween.tween(bg, {alpha: 0.75}, 0.25, {ease: FlxEase.cubeOut});

    options = new FlxTypedGroup();
    optionsExtra = new FlxTypedGroup();
    for(i in adjustables){
        var texts = new Alphabet(0, 0, i[0] + '' + ((i[2] != "bool") ? ':' : ''), true);
		texts.alpha = 0.5;
        texts.isMenuItem = true;
		options.add(texts);
        switch(i[2]){
			case 'num':
				var numberTxt = new Alphabet(0, 0, Reflect.getProperty(FlxG.save.data, i[1]), true);
				optionsExtra.add(numberTxt);
            case 'bool':
                var checkBox = new FunkinSprite(0, 0).loadSprite(Paths.image('menus/options/checkboxThingie'));
                for(o in offsets){
                    checkBox.addAnim(o[0], o[1], 24, false);
                    checkBox.addOffset(o[0], o[2], o[3]);
                    checkBox.playAnim(Reflect.getProperty(FlxG.save.data, i[1]));
                }
                checkBox.scale.set(0.75, 0.75);
                checkBox.updateHitbox();
				optionsExtra.add(checkBox);
		}
    }
    add(options);
    add(optionsExtra);

    desc = new FlxSprite(0, 0).makeSolid(FlxG.width, 75, FlxColor.BLACK);
    desc.alpha = 0;
    add(desc);
    FlxTween.tween(desc, {alpha: 0.75}, 0.25, {ease: FlxEase.cubeOut});

    optionType = new FlxText(0, 0, FlxG.width, 'Type: Debug', 30);
	optionType.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, 'left');
    optionType.alpha = 0;
    add(optionType);
    FlxTween.tween(optionType, {alpha: 1}, 0.25, {ease: FlxEase.cubeOut});

    flavorText = new FlxText(0, 30, FlxG.width, '', 30);
	flavorText.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, 'left');
    flavorText.alpha = 0;
    add(flavorText);
    FlxTween.tween(flavorText, {alpha: 1}, 0.25, {ease: FlxEase.cubeOut});

    chooseSelection(0);

    Framerate.codenameBuildField.text = '';
}

function update(elapsed){
    if(controls.UP_P || controls.DOWN_P){
        chooseSelection(controls.UP_P ? -1 : 1);
    }

    for(o=>option in options.members){
        option.targetY = (o - curOption) + ((FlxG.state is FreeplayState) ? 0.5 : 0);
    }

    for(o=>ov in optionsExtra.members){
        switch(adjustables[o][2]){
            case 'num': ov.y = options.members[o].y;
            case 'bool': ov.y = options.members[o].y - 50;
                if (ov.animation.curAnim != null) {
                }
        }
        ov.x = options.members[o].x + options.members[o].width + 70;
    }

    switch(adjustables[curOption][2]){
        case 'num':
            var value = Reflect.getProperty(FlxG.save.data, adjustables[curOption][1]);
            if(controls.LEFT_P || controls.RIGHT_P || controls.UP_P || controls.DOWN_P){
                holdTime = 0;
                if(controls.UP_P || controls.DOWN_P) return;
                value = FlxMath.bound(value + (controls.LEFT_P ? -0.05 : 0.05), adjustables[curOption][3][0], adjustables[curOption][3][1]);
                Reflect.setProperty(FlxG.save.data, adjustables[curOption][1], FlxMath.roundDecimal(value, 2));
                optionsExtra.members[curOption].text = FlxMath.roundDecimal(value, 2);
            }
            if(controls.LEFT || controls.RIGHT){
                holdTime += elapsed * 30;
                if(holdTime >= 30){
                    value = FlxMath.bound(value + (controls.LEFT ? -0.05 : 0.05), adjustables[curOption][3][0], adjustables[curOption][3][1]);
                    Reflect.setProperty(FlxG.save.data, adjustables[curOption][1], FlxMath.roundDecimal(value, 2));
                    optionsExtra.members[curOption].text = FlxMath.roundDecimal(value, 2);
                }
                trace(holdTime);
            }
        case 'bool':
            if(controls.ACCEPT){
                var value = Reflect.setProperty(FlxG.save.data, adjustables[curOption][1], !Reflect.getProperty(FlxG.save.data, adjustables[curOption][1]));
                optionsExtra.members[curOption].playAnim(Reflect.getProperty(FlxG.save.data, adjustables[curOption][1]) + 'ing');
            }
    }

    if(optionsExtra.members[curOption].text == '0') optionsExtra.members[curOption].text = 'Disabled';

    if(controls.BACK){
        Framerate.offset.y = 0;
        close();
    }
}

function chooseSelection(f){
    curOption = FlxMath.wrap(curOption + f, 0, options.length - 1);

    for(option in options.members) option.alpha = 0.6;
    for(ov in optionsExtra.members)ov.alpha = 0.6;

    optionType.text = 'Type: ' + adjustables[curOption][5];

    options.members[curOption].alpha = 1;
    optionsExtra.members[curOption].alpha = 1;

    flavorText.applyMarkup(adjustables[curOption][4], [new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF4444), "*"), new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFD111), "<"), new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00FFFF), ">")]);
}

function destroy(){
    if (FlxG.cameras.list.contains(subCam)) FlxG.cameras.remove(subCam);
}