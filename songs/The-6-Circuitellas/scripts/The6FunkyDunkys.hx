var the6humansouls:Bool = false;
var obey:Bool = false;
var the6FunkyDunks:Array<String> = ['Gabriel-true','SIX_DT_Icons','intruder','Mark-Normal','Ceaser-Gift','Mork'];
var centerX = (FlxG.width / 2) - 50;
var centerY = FlxG.height / 2 - 50;
var radius = 150; // distance from center
var soulColors = [FlxColor.CYAN, FlxColor.YELLOW, FlxColor.BROWN, FlxColor.BLUE, FlxColor.MAGENTA, FlxColor.CYAN];
var souls:Array<HealthIcon> = [];
var theHumanSoul:HealthIcon;
function create() {
    PlayState.instance.introLength = 0.5;
    PlayState.instance.doIconBop = false;
}
function onCountdown(event){
    event.cancel();
}
function postCreate() {
    
    FlxG.camera.alpha = healthBar.alpha = healthBarBG.alpha = iconP1.alpha = scoreTxt.alpha = missesTxt.alpha = accuracyTxt.alpha = iconP2.alpha = 0;
    var circuitella = new HealthIcon('Circuitella', true);
    circuitella.scale.set(0.6,0.6);
    circuitella.updateHitbox();
    circuitella.x = centerX;
    circuitella.y = centerY;
    circuitella.flipX = true;
    circuitella.antialiasing = false;
    circuitella.camera = camHUD;
    add(circuitella);
    remove(circuitella, true);
    insert(0, circuitella);
}
function onNoteHit(event){
    if(player.cpu && event.character.curCharacter == boyfriend.curCharacter && !event.note.isSustainNote){
        event.countAsCombo = true;
        event.accuracy = 1;
        event.countScore = true;
        health += 0.02;
        songScore += 300;
        goodNoteHit(event);
        updateRating();
        displayRating(event.rating, event);
        if(combo > 9) displayCombo(event);
        event.showSplash = true;
        splashHandler.showSplash(event.note.splash, event.note.__strum);
    }
}
function onSongStart(){
        for(i in 0...6){
            // create soul at center
            //var soul = new FlxSprite(centerX, centerY, Paths.image('dumb/soul'));
            var soul = new HealthIcon('Circuitella', true);
            soul.scale.set(0.6,0.6);
            soul.updateHitbox();
            soul.x = centerX;
            soul.y = centerY;
            soul.flipX = true;
            soul.color = soulColors[i];
            soul.alpha = 0;
            soul.antialiasing = false;


            souls.push(soul);
            soul.camera = camHUD;
            add(soul);
            remove(soul, true);
            insert(0, soul);


            // calculate circle position
            var angle = Math.PI * 2 / 6 * i; // divide circle into 6 parts
            var targetX = centerX + radius * Math.cos(angle);
            var targetY = centerY + radius * Math.sin(angle);

            // tween to target position
            if(i == 0){
            FlxTween.tween(soul, {x: targetX, y: targetY, alpha:1}, 2.5, {ease: FlxEase.quadOut, delay: 2.5*1});
            }
            else{
                FlxTween.tween(soul, {x: targetX, y: targetY, alpha:1}, 2.5*i, {ease: FlxEase.quadOut, delay: 2.5*i});
            }

        }

}
var moveSpeedFormula:Int = 16;
function stepHit(curStep:Int) {
    switch(curStep){
        case 64:
            moveSpeedFormula = 16;
            the6humansouls = true;
            obey = false;
        case 128:
            moveSpeedFormula = 126;
            the6humansouls = true;
            obey = false;
    }
}
var time = 0;
function postUpdate(elapsed:Float) {
    health = 1;
}
function update(elapsed:Float) {
    if(the6humansouls && !obey){
		for(i in 0...souls.length){
			var soul = souls[i];
			var angleOffset = Math.PI * 2 / 6 * i; // initial angle
			time += elapsed / (Options.framerate/moveSpeedFormula); // seconds
			soul.x = centerX + radius * Math.cos(time + angleOffset);
			soul.y = centerY + radius * Math.sin(time + angleOffset);
		}
	}
}