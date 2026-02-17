var snowgrave:FlxSprite;
var iceReceptors:Array<FlxSprite> = [];
var frozenCounter = 0;
var controls = Options.controls;
var iceshake:Int = 0;
var randomx:Int = 0;
var boyx:Int = 0;
var chunkY:Int = 0;
var keycooldown:Int = 0;
var icechunks = new FlxSpriteGroup();
var floor:FlxSprite;
var black;
var leftReceptor;
var rightReceptor;

function postCreate() {
	floor = new FlxSprite(-2000, (boyfriend.y + boyfriend.height) + 150).makeGraphic(5000, 500, FlxColor.RED);
	floor.updateHitbox();
	floor.immovable = true;
	add(floor);
	remove(floor, true);
	insert(28, floor);
	floor.alpha = 0;
	FlxG.worldBounds.set(floor.x, floor.y, floor.width * 3, floor.height * 3);

	snowgrave = new FlxSprite(boyfriend.x - 80, boyfriend.y + 100);
	snowgrave.frames = Paths.getSparrowAtlas('characters/wolf/BF_Ice');
	snowgrave.animation.addByPrefix('idle', 'Ice', 0, false);
	snowgrave.animation.play('idle');
	boyx = boyfriend.x;


	//icechunks.zIndex = snowgrave.zIndex;
	add(icechunks);

	snowgrave.visible = false;
	snowgrave.animation.play('idle');
	add(snowgrave);

	black = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
	black.camera = camHUD;
	black.alpha = 0;
	add(black);

	leftReceptor = new FlxSprite().setFrames(Paths.getSparrowAtlas('game/notes/ice/NOTE_assets'));
	leftReceptor.animation.addByPrefix('idle', 'purple', 24, true);
	leftReceptor.animation.play('idle');
	leftReceptor.camera = camHUD;
	leftReceptor.screenCenter();
	leftReceptor.x -= FlxG.width / 8;
	leftReceptor.color = FlxColor.WHITE;
	add(leftReceptor);
	iceReceptors.push(leftReceptor);

	rightReceptor = new FlxSprite().setFrames(Paths.getSparrowAtlas('game/notes/ice/NOTE_assets'));
	rightReceptor.animation.addByPrefix('idle', 'red', 24, true);
	rightReceptor.animation.play('idle');
	rightReceptor.camera = camHUD;
	rightReceptor.screenCenter();
	rightReceptor.x += FlxG.width / 8;
	rightReceptor.color = 0xFF4a4a4a;
	add(rightReceptor);
	iceReceptors.push(rightReceptor);

	for (i in iceReceptors)
		i.visible = false;
}

var isFrozen = false;
function onPlayerMiss(e){
	if(isFrozen) e.cancelAnim();
	if(e.noteType == "Ice Note") e.cancel();
}
function onNoteCreation(event) { 
    if (event.noteType == "Ice Note") { 
        event.noteSprite = "game/notes/ice/NOTE_assets"; 
    }
}
function onNoteHit(e) {
	if (e.noteType == 'Ice Note' && !isFrozen) {
		if(player.cpu) return;
		keycooldown = 10;
		isFrozen = true;
		frozenCounter = 0;

		boyfriend.stunned = true;
		snowgrave.visible = true;

		black.alpha = 0.75;
		 for (i in iceReceptors)
		 	i.visible = true;

		leftReceptor.color = FlxColor.WHITE;
		rightReceptor.color = 0xFF4a4a4a;

		FlxG.sound.play(Paths.sound('ice/freeze'));
	}
}

function struggle() {
	FlxG.sound.play(Paths.sound('ice/struggle'));
	frozenCounter += 1;
	iceshake = 1;
	for (i in 0...FlxG.random.int(2, 4)) makeIceChunk();
}


function forcebreak()
{
	if(isFrozen)
		breakout();
	new FlxTimer().start(5, function(_) {
		for(chunk in icechunks.members){
			if(chunk.visible) chunk.visible = false;
		}
	});		
}

function breakout() {
	FlxG.camera.shake(0.015, 0.125);
	isFrozen = false;
	frozenCounter = 0;

	snowgrave.visible = false;
	boyfriend.stunned = false;
	boyfriend.dance();

	black.alpha = 0;
	for (i in iceReceptors)
		i.visible = false;

	makeIceChunk();

	FlxG.sound.play(Paths.sound('ice/breakout'));
}
function onPlayerHit(e){
	if(isFrozen){
		health -= 0.025;
		if(strumLines.members[1].characters[0].visible) strumLines.members[1].characters[0].playAnim('frozen', true, 'LOCK', false, 0);
		if(strumLines.members[1].characters[2].visible) strumLines.members[1].characters[2].playAnim('frozen', true, 'LOCK', false, 0);
		e.cancel();
		e.countScore = false;
		e.forceAnim = false;
		e.preventAnim();
		e.preventSustainClip();
		e.preventDeletion();
		e.cancelAnim();
		e.preventVocalsUnmute();
		e.cancelLastSustainHit();
		e.cancelStrumGlow();
	}
}
function onInputUpdate(e){
	if (isFrozen && keycooldown == 0) {
		if (frozenCounter % 2 == 0 && e.justPressed[0])
			struggle();
		else if (e.justPressed[3])
			struggle();

		leftReceptor.color = frozenCounter % 2 == 0 ? FlxColor.WHITE : 0xFF4a4a4a;
		rightReceptor.color = frozenCounter % 2 == 0 ? 0xFF4a4a4a : FlxColor.WHITE;

		if (frozenCounter >= 5)
			breakout();
	}
	e.strumLine.forEachAlive((note) -> {
		if (note.noteType == 'Ice Note' && note.mustPress && isFrozen) {
			note.cancelAnim();
			note.cancel();
		}
	});
}
function update(elapsed) {
	if(curStep == 844) forcebreak();
	if(curStep == 383) forcebreak();
	if(curStep == 1647) forcebreak();

	if (iceshake <= 0) {
		iceshake = 0;
	}
	if (iceshake > 0) {
		iceshake -= (0.04) * (elapsed * 60);
	}
	snowgrave.x = (boyfriend.x - 80) + randomx;
	snowgrave.animation.curAnim.curFrame = frozenCounter;
	boyfriend.x = (boyx + randomx);
	randomx = (FlxG.random.float(iceshake * -20, iceshake * 20)) * (elapsed * 60);
	if (keycooldown > 0) {
		keycooldown -= (1 * (elapsed * 60));
		if (keycooldown <= 0) 
			keycooldown = 0;
	}
	for (i in icechunks.members) {
		FlxG.collide(i, floor, () -> {
			i.ID -= 300;
			if (i.ID >= 0) {
				i.velocity.y = i.velocity.y - (800 * (i.ID / 1000));
				i.drag.y = 300;
				var delay = 3 / (50 * (i.ID / 1000));
				new FlxTimer().start(delay, function(_) {
					FlxTween.tween(i.velocity,
						{ y: i.velocity.y * -1 },
						0.325 + (i.ID / 1000),
						{ ease: FlxEase.quadInOut }
					);
					i.drag.y = -300;
					if (i.velocity.x < 0)
						i.velocity.x -= 100;
					else
						i.velocity.x += 100;
				});

			}
		});
	}
}

function makeIceChunk() {
	var dir = FlxG.random.bool(50) ? 1 : -1;

	chunkY = (FlxG.random.int(snowgrave.y, snowgrave.y + snowgrave.height));
	var icechunk = new FlxSprite(dir == 1 ? snowgrave.x + snowgrave.width + 400 : snowgrave.x, chunkY);
	icechunk.frames = Paths.getSparrowAtlas('characters/wolf/BF_Ice');
	icechunk.animation.addByPrefix('idle', 'ChunkIce', 0, false);
	icechunk.animation.play('idle');
	icechunk.animation.curAnim.curFrame = FlxG.random.int(0, 3);
	icechunk.velocity.x = 300 * dir * (FlxG.random.float(0.8, 1.2));
	icechunk.velocity.y = 1000;
	icechunk.drag.x = 200;

	switch (frozenCounter) {
		case 5:
			icechunk.animation.curAnim.curFrame = 4;
	}
	icechunk.angularVelocity = 1500;
	icechunk.angularDrag = 450;
	icechunk.angle = FlxG.random.int(0, 360);
	icechunk.ID = 1000;
	icechunk.updateHitbox();
	icechunks.add(icechunk);

	new FlxTimer().start(5, function(_) {
		FlxTween.tween(icechunk, { alpha: 0 }, 2, {
			onComplete: function(twn) {
				icechunk.visible = false;
				icechunk.kill();
			}
		});
	});

}
