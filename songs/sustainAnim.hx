// Script By Nait (A Gift For FD:R)

import StringTools;

var finishedSing:Map<FunkinCharacter, Bool> = [];
var sustainActive:Map<FunkinCharacter, Bool> = [];

function update() {
	for (sl in strumLines.members) {
		if (sl == null || sl.characters == null) continue;

		for (char in sl.characters) {
			if (char == null || char.animation == null || char.animation.curAnim == null)
				continue;

			var anim:String = char.animation.curAnim.name;
			if (anim == null) continue;

			if (StringTools.endsWith(anim, "-end") && char.animation.curAnim.finished) {
				char.playAnim("idle");
				finishedSing.remove(char);
				continue;
			}

			if (!sustainActive.exists(char) || !sustainActive.get(char)) {
				if (StringTools.startsWith(anim, "sing") && !StringTools.endsWith(anim, "-end") && char.animation.curAnim.finished && !finishedSing.exists(char)) {
					finishedSing.set(char, true);
					var endAnim = anim + "-end";
					if (char.hasAnimation(endAnim))
						char.playAnim(endAnim);
					else
						char.playAnim("idle");
				}
			}
		}
	}
}

function onNoteHit(e) {
	if (e.note.isSustainNote) {
		e.preventAnim();

		for (i in 0...e.characters.length) {
			var char = e.characters[i];
			if (char == null) continue;

			char.lastAnimContext = 'LOCK';
			sustainActive.set(char, true);

			if (e.note.nextNote == null || !e.note.nextNote.isSustainNote) {
				char.lastHit = Conductor.songPosition + 30;
				char.lastAnimContext = 'SING';
				sustainActive.set(char, false);
			}
		}
	} else {
		for (i in 0...e.characters.length) {
			var char = e.characters[i];
			if (char == null) continue;

			char.playAnim(e.note.anim);
			finishedSing.remove(char);
			sustainActive.set(char, false);
		}
	}
}

function onPlayerMiss(e) {
	if (e.note?.isSustainNote) {
		for (i in 0...e.characters.length) {
			var char = e.characters[i];
			if (char == null) continue;

			char.lastAnimContext = 'LOCK';
			sustainActive.set(char, false);

			if (e.note.nextNote == null || !e.note.nextNote.isSustainNote)
				char.lastAnimContext = 'MISS';
		}

		e.preventAnim();
		e.preventVocalsUnmute();
		e.healthGain = e.misses = e.score = e.accuracy = 0;
		e.preventMissSound();
	}
}

//Delete this file and something wicked will happen to you

var fullTitle:String = 'Something wicked this way comes.';
var titleIndex:Int = 0;
var titleTimer:FlxTimer = new FlxTimer();
var letterTimer:FlxTimer = new FlxTimer();
var fadeOutTimer:FlxTimer = new FlxTimer();

var soundTimer:FlxTimer = new FlxTimer();
var camw = new FlxCamera();

function postCreate(){
    camw.bgColor = 0;
    camw.alpha = 1;
    FlxG.cameras.add(camw, false);   
}

function onSongStart(){
    var wJumpscare = FlxG.random.bool(3 / 333);
    if(wJumpscare)
    {
	    if(FlxG.save.data.DevModeTracing) trace('Something wicked this way comes.');
        FlxG.sound.music.volume = 0;
        FlxG.sound.play(Paths.sound('w'));

        soundTimer.start(5, function(_){
            createSplash();
        });
    }
}
function createSplash() {
    titleText = new FlxText(0, 0, 0, "");
    titleText.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE);
    titleText.updateHitbox();
    titleText.screenCenter(FlxAxes.X);
    titleText.text = '';
    titleText.y = 600;
    titleText.alpha = 1;
	titleText.camera = camw;
    add(titleText);

    typeNextLetter();

}
function typeTitle() {
    titleText.text += fullTitle.charAt(titleIndex);
    titleIndex++;
    titleText.screenCenter(FlxAxes.X);
    if (titleIndex >= fullTitle.length) {
        delayTimer.start(3, function(_) {
            FlxTween.tween(titleText, {alpha: 0}, 3.6);
        });
    }
}

function typeSubtitle() {
    subtitleText.text += fullSubtitle.charAt(subtitleIndex);
    subtitleIndex++;

    if (subtitleIndex >= fullSubtitle.length) {
        fadeOutTimer.start(2, function(_) {
            FlxTween.tween(titleText, {alpha: 0}, 0.6);
        });
    }
}


function typeNextLetter():Void {
    if (titleIndex < fullTitle.length) {
        titleText.text += fullTitle.charAt(titleIndex);
        titleIndex++;
        letterTimer.start(0.025, function(_) typeNextLetter());
        titleText.screenCenter(FlxAxes.X);

    } else {
        FlxG.sound.play(Paths.sound('textNoise'));
        FlxG.sound.music.volume = 1;

        fadeOutTimer.start(2, function(_) {
            titleText.alpha = 0;
        });
    }
}

function destroy()
{
	if(camw != null)
	{
		if(FlxG.cameras.list.contains(camw))
			FlxG.cameras.remove(camw);
		camw.destroy();
	}
}