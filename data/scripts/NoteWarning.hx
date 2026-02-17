import funkin.backend.system.Conductor;

var noteWarning = new FlxSpriteGroup();
var warning;
var decoyNote;
var char = 'mighty';
var note = 'ice/NOTE_assets';
var sSize = curStep;
var delay = 1;
var camWarn = new FlxCamera();
function create() {
	camWarn = new FlxCamera();
    camWarn.visible = true;
    camWarn.alpha = 1;
	camWarn.bgColor = 0;
    FlxG.cameras.add(camWarn, false);
}
function postCreate() {
	
	char = getChar();
	note = getNote();
	delay = getDelay();

	noteWarning.setPosition((FlxG.width / 2) + 50, FlxG.height - 275);
	noteWarning.alpha = 0;
	noteWarning.camera = camWarn;
	add(noteWarning);

	warning = new FlxSprite();
	warning.frames = Paths.getSparrowAtlas('game/NoteWarnings');
	warning.animation.addByPrefix(char, char, 24, true);
	warning.animation.play(char);
	warning.updateHitbox();

	decoyNote = new FlxSprite();
	decoyNote.frames = Paths.getSparrowAtlas('game/notes/' + note);
	decoyNote.animation.addByPrefix('idle', 'green', 24, true);
	decoyNote.animation.play('idle');
	decoyNote.updateHitbox();

	decoyNote.setPosition((warning.width - decoyNote.width) / 2, warning.y);
	decoyNote.y += 100;
	decoyNote.alpha = 0;

	noteWarning.add(decoyNote);
	noteWarning.add(warning);

	noteWarning.y += warning.height;
}

function getChar() {
	var fuck = '';
	fuck = 'mighty';

	return fuck;
}

function getNote() {
	var fuck = '';
	switch (char) {
		case 'mighty':
			fuck = 'ice/NOTE_assets';
	}
	fuck = 'ice/NOTE_assets';
	return fuck;
}

function getDelay() {
	var del = 0;

	switch (char) {
		case 'mighty':
			del = 26;
	}
	del = 26;
	return del;
}

function onSongStart() {
	
	new FlxTimer().start(delay, function(_) {

		var targetY = Options.downScroll ? 0 : FlxG.height - 275;

		FlxTween.tween(decoyNote,
			{ y: targetY, alpha: 1 },
			0.6,
			{ startDelay: 0.125, ease: FlxEase.circOut }
		);

		FlxTween.tween(warning,
			{ y: targetY, alpha: 1 },
			0.6,
			{ ease: FlxEase.circOut }
		);

		new FlxTimer().start(sSize * 24, function(_) {

			FlxTween.tween(warning, { alpha: 0 }, 3);
			FlxTween.tween(decoyNote, { alpha: 0 }, 3);

			new FlxTimer().start(6, function(_) {
				if (warning != null) warning.destroy();
				if (decoyNote != null) decoyNote.destroy();
			});

		});

	});

}
