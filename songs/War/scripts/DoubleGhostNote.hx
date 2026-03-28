public var disableGhosts:Bool = false;

var data:Map<Int, {lastNote:{time:Float, id:Int}}> = [];


function postCreate() {
	for (sl in strumLines.members)
		data[strumLines.members.indexOf(sl)] = {
			lastNote: {
				time: -9999,
				id: -1
			}
		};
}

function onNoteHit(event:NoteHitEvent) {
	if (event.note.isSustainNote) return;

	var target = data[strumLines.members.indexOf(event.note.strumLine)];
	var doDouble = (event.note.strumTime - target.lastNote.time) <= 2 && event.note.noteData != target.lastNote.id;
	target.lastNote.time = event.note.strumTime;
	target.lastNote.id = event.note.noteData;

	if(doDouble && !disableGhosts)
		for (character in event.characters)
			if (character.visible) doGhostAnim(character, event);
}

function doGhostAnim(char:Character, e:NoteHitEvent) {
	var trail:Character = new Character(char.x, char.y, char.curCharacter, char.isPlayer);
	trail.color = char.iconColor;
    trail.alpha = char.alpha * 0.85;
    trail.scale.set(char.scale.x, char.scale.y);
	trail.flipX = char.flipX;
	trail.visible = char.visible;
	insert(members.indexOf(char), trail);
    trail.playAnim(char.getAnimName(), false, 'LOCK');
	FlxTween.tween(trail, {alpha: 0}, 2).onComplete = function() {
		trail.kill();
		remove(trail, true);
	};
    switch(e.note.noteData)
    {
        case 0: FlxTween.tween(trail, {x: char.x + 120}, 3.1, {ease: FlxEase.sineOut});
        case 1: FlxTween.tween(trail, {y: char.y - 120, x: char.x + 120}, 1.1, {ease: FlxEase.sineOut});
        case 2: FlxTween.tween(trail, {y: char.y - 120}, 3.1, {ease: FlxEase.sineOut});
        case 3: FlxTween.tween(trail, {x: char.x - 120}, 3.1, {ease: FlxEase.sineOut});
    }
    trail.holdTime = 9999999;
	return trail;
}