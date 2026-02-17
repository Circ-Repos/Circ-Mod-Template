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

			if (!sustainActive.exists(char) || !sustainActive.get(char)) {
				if (StringTools.startsWith(anim, "sing") && !StringTools.endsWith(anim, "-end") && char.animation.curAnim.finished && !finishedSing.exists(char)) {
					finishedSing.set(char, true);
					var endAnim = anim + "-end";
					if (char.hasAnimation(endAnim))
						char.playAnim(endAnim);
					else
						return;
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
