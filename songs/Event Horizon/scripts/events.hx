var space = new CustomShader('space');
function create(){
    bgs = new FunkinSprite(0,0);
    bgs.makeGraphic(FlxG.width*6, FlxG.height*6, FlxColor.PURPLE);
    bgs.shader = space;
    bgs.scrollFactor.set(0,0);
    add(bgs);
    bgs.screenCenter();
    remove(bgs, true);
    insert(0, bgs);
}
function stepHit(curStep){
    switch(curStep){
        case 1:
            for(i in ['bg', 'stageFront', 'stageCurtains']){
                FlxTween.tween(stage.getSprite(i).skew, {y: 43, x: 43}, 0.74, {ease: FlxEase.linear});
                FlxTween.tween(stage.getSprite(i), {angle: -43}, 0.74, {ease: FlxEase.linear});
                FlxTween.tween(stage.getSprite(i).scale, {y: 0.001}, 0.74, {ease: FlxEase.linear});

            
            }
        case 5: for(i in ['bg', 'stageFront', 'stageCurtains']){
            stage.getSprite(i).alpha = 0;
            }
        case 75:
            space.speed = 0.5;
            elapmult = 50;
            //FlxTween.tween(space, {speed: 0.5}, 0.74, {ease: FlxEase.circInOut});
    }
}
var itim:Float = 0;
var elapmult:Float = 10;
function update(elapsed:Float){
    itim += elapsed;
    space.iTime = itim;

    dad.y = Math.sin(Conductor.songPosition/-1000) * (elapmult*8);
    dad.angle -= elapsed * elapmult;

    boyfriend.y = Math.sin(Conductor.songPosition/1000) * (elapmult*8);

    boyfriend.angle += elapsed * elapmult*elapmult;
    FlxG.camera.angle += elapsed * -elapmult;
    //WHY DID YOU DO THIS TWICE
    //boyfriend.y = Math.sin(Conductor.songPosition/1000) * 200;

    gf.y = Math.sin(Conductor.songPosition/1000) * (elapmult*8);
    gf.angle -= elapsed * elapmult;
    comboGroup.angle -= elapsed * 50;

}
