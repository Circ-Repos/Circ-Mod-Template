import funkin.game.PlayState;

var boingySproingy:Bool = true;

/*function postCreate(){
  healthBar.alpha = healthBarBG.alpha = iconP1.alpha = iconP2.alpha = 0;

}*/

function stepHit(curStep:Int) {

    if (boingySproingy){
      if (curStep % 4 == 0) {
          FlxTween.tween(boyfriend, {y: 120}, Conductor.stepCrochet * 0.002, {ease: FlxEase.quadOut});
          iconP1.scale.set(1.15, 0.9);
          boyfriend.scale.set(1.15, 0.9);
          iconP2.scale.set(1.15, 0.9);
          boyfriend.flipX = false;
          iconP1.flipX = false;
          FlxTween.tween(iconP1.scale, {x: 1, y: 1}, Conductor.stepCrochet * 0.002, {ease: FlxEase.quadOut});
          FlxTween.tween(iconP2.scale, {x: 1, y: 1}, Conductor.stepCrochet * 0.002, {ease: FlxEase.quadOut});

          FlxTween.tween(boyfriend.scale, {x: 1, y: 1}, Conductor.stepCrochet * 0.002, {ease: FlxEase.quadOut});
      }
      if (curStep % 4 == 4) {
          FlxTween.tween(boyfriend, {y: 155}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
      }
      if (curStep % 8 == 0) {
        boyfriend.flipX = true;
        iconP1.flipX = true;

    }
    }
}

function update(){
    iconP2.flipX = iconP1.flipX;
    dad.y = boyfriend.y -15;
    dad.scale.set(boyfriend.scale.x, boyfriend.scale.y);
    //dad.flipX = boyfriend.flipX;
    if(boyfriend.animation.curAnim.name != "idle") dad.playAnim(boyfriend.animation.curAnim.name);

}
/*
function beatHit(curBeat){
    camHUD.zoom += 0.06;
    camGame.zoom += 0.03;
}*/