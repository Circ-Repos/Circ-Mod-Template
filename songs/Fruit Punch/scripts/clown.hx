import flixel.effects.FlxFlicker;

var circleHitBox:Array<Int> = [340,940];

var clown:FlxSprite;
var circle:FlxSprite;
var backround:FlxSprite;
var balloonboys:Array<FlxSprite> = [];
var kidAmt:Int = 10;
var win:Bool = false;
var fruitPunchSound:String = 'Fruitpunch';
var boysWalk:Bool = false;
var endGame:Bool = false;
var bonusAmt:Int = 10000;
var getReadyText:FlxText;
var scoreText:FlxText;
var pressTxt:FlxText;
var diff:String = PlayState.difficulty;
var kidsCaught:Int = 0;

var lemonade:Bool = false;
function postCreate(){
    if(diff == 'lemonade-for-everyone') lemonade = true;
    if(lemonade) fruitPunchSound = 'Lemonade_2';
    if(lemonade) circleHitBox = [340,940];
    if(lemonade) bonusAmt = 5000;
    FlxG.camera.alpha = 0;
    FlxG.sound.music.play();
    FlxG.sound.music.looped = true;
    FlxG.sound.music.volume = 1;

    for(i in [boyfriend, gf, dad, iconP1,iconP2,scoreTxt,missesTxt,healthBar,healthBarBG,accuracyTxt]){
        i.alpha = 0;
        i.visible = false;
        remove(i,true);
    }

    bg = new FlxSprite(0,0,Paths.image("game/ffps/Background"));
    bg.camera = camHUD;
    bg.scrollFactor.set(0,0);
    bg.width = camHUD.width;
    bg.height = camHUD.height;
    bg.scale.set(0.69,0.69);
    bg.updateHitbox();
    bg.antialiasing = Options.antialiasing;
    add(bg);

    circle = new FlxSprite(339,0,Paths.image("game/ffps/circle"));
    circle.camera = camHUD;
    circle.scale.set(1.7,1.7);
    circle.scrollFactor.set(0,0);
    circle.screenCenter(FlxAxes.Y);
    circle.updateHitbox();
    circle.alpha = 0.2;
    circle.antialiasing = Options.antialiasing;
    add(circle);

    clown = new FlxSprite(0,0);
    if(!lemonade) clown.frames = Paths.getSparrowAtlas("game/ffps/insanity");
    if(lemonade) clown.frames = Paths.getSparrowAtlas("game/ffps/insanity2");
    clown.animation.addByPrefix("FruitPunchClown","FruitPunchClown",1,true);
    clown.animation.addByPrefix("JumpscareFruitPunchClown","JumpscareFruitPunchClown",1,true);
    clown.animation.play("FruitPunchClown");
    clown.camera = camHUD;
    clown.scale.set(0.7,0.7);
    clown.updateHitbox();
    clown.scrollFactor.set(0,0);
    clown.screenCenter();
    clown.antialiasing = Options.antialiasing;
    clown.alpha = 1;
    add(clown);

    for(i in 0...kidAmt){
        var balloonboy:FlxSprite = new FlxSprite(0,450);
        balloonboy.frames = Paths.getSparrowAtlas("game/ffps/bb");
        balloonboy.animation.addByPrefix("idle","BalloonBoyIdle",1,true);
        balloonboy.animation.addByPrefix("walk","BalloonBoyWalk",24,true);
        balloonboy.animation.addByPrefix("scare","BalloonBoyScared",24,false);
        balloonboy.animation.addByPrefix("walkFast","BalloonBoyWalk",48,true);
        balloonboy.animation.play("idle");
        balloonboy.camera = camHUD;
        balloonboy.scale.set(0.7,0.7);
        balloonboy.scrollFactor.set(0,0);
        balloonboy.x = FlxG.random.int(0,1200 - balloonboy.width);
        balloonboy.y = FlxG.random.int(450,415);
        balloonboy.updateHitbox();
        balloonboy.antialiasing = Options.antialiasing;
        balloonboys.push(balloonboy);
        add(balloonboy);
    }

    // squareL = new FlxSprite(340,0).makeGraphic(600, FlxG.height, FlxColor.BLUE);
    // squareL.updateHitbox();
    // squareL.camera = camHUD;
    // squareL.alpha = 0.5;
    // add(squareL);

    instructions = new FlxSprite(0,0,Paths.image("game/ffps/objective"));
    instructions.camera = camHUD;
    instructions.scale.set(0.8,0.8);
    instructions.scrollFactor.set(0,0);
    instructions.updateHitbox();
    instructions.screenCenter();
    instructions.y = 200;
    instructions.antialiasing = Options.antialiasing;
    add(instructions);

    new FlxTimer().start(3, (_) ->  clownStart());

    scoreText = new FlxText(1280 - 1300, FlxG.height - 100, 1280, "0");
    scoreText.setFormat(Paths.font('NotoSans.ttf'), 64, FlxColor.WHITE, "right");
    scoreText.camera = camHUD;
    scoreText.antialiasing = Options.antialiasing;
    scoreText.bold = true;
    scoreText.updateHitbox();
    add(scoreText);

    pressTxt = new FlxText(0, FlxG.height - 75, 1280, "Press Space");
    pressTxt.bold = true;
    pressTxt.setFormat(Paths.font('Times New Roman Italic'), 52, FlxColor.WHITE, "center");
    pressTxt.camera = camHUD;
    pressTxt.antialiasing = Options.antialiasing;
    add(pressTxt);
    pressTxt.screenCenter(FlxAxes.X);

    getReadyText = new FlxText(0, 100, 1280, "GET READY!");

    getReadyText.bold = true;
    getReadyText.setFormat(Paths.font('Times New Roman Italic'), 72, FlxColor.WHITE, "center");
    getReadyText.camera = camHUD;
    getReadyText.antialiasing = Options.antialiasing;
    add(getReadyText);
    getReadyText.screenCenter(FlxAxes.X);

	FlxFlicker.flicker(getReadyText, 3, 0.4, false, false);
} 

function clownStart(){
    boysWalk = true;
    instructions.visible = false;
    for(i in balloonboys) startMoving(i);
}

function startMoving(sprite:FlxSprite):Void {
    if(endGame) return;

    var speed:Float = FlxG.random.int(600, 800);
    var moveTime:Int = FlxG.random.int(1, 6);
    sprite.animation.play("walk");
    if(speed > 700) sprite.animation.play("walkFast");
    var negativeChance:Int = FlxG.random.int(0,1);
    if(negativeChance == 0) speed = speed*-1;
    sprite.velocity.set(speed,0);
    new FlxTimer().start(moveTime, function(_) {
        goIdle(sprite);
    });
}
function goIdle(sprite:FlxSprite):Void {
    if(endGame) return;

    sprite.animation.play("idle");
    sprite.velocity.set(0, 0); // Stop movement

    var idleTime:Float = FlxG.random.float(1, 5); // Random idle time between 1-5 seconds

    // Wait, then start moving again
    new FlxTimer().start(idleTime, function(_) {
        startMoving(sprite);
    });
}
function onCountdown(event) {
  event.cancel();
  PlayState.instance.startedCountdown = false;
}
function onSongEnd(e){
    if(!win) e.cancel();
}
function update(elapsed:Float) {
    scoreText.text = PlayState.instance.songScore;

    for (sprite in balloonboys)
    {
        if (sprite.x <= 0 && sprite.velocity.x < 0)
        {
            sprite.velocity.x *= -1;
        }

        if (sprite.x >= 1200 && sprite.velocity.x > 0)
        {
            sprite.velocity.x *= -1;
        }
    }

    if(FlxG.keys.justPressed.SPACE && boysWalk){
        clown.animation.play("JumpscareFruitPunchClown");
        endGame = true;
        FlxG.sound.music.stop();
        var tell:Float = FlxG.random.int(1, 1000); // Random idle time between 1-5 seconds
        if(tell == 1) fruitPunchSound = 'tell';
        var lengthofSound:Float = 2;
        if(tell == 1) lengthofSound = 7.5;
        FlxG.sound.play(Paths.sound("airhorn2"),4);
        new FlxTimer().start(3, (_) ->  FlxG.sound.play(Paths.sound(fruitPunchSound)));
        new FlxTimer().start(5, (_) ->  win = true);
        for(boy in balloonboys){
            boy.animation.play("idle");
            if(boy.x >= 300 && boy.x <= 790){
                boy.animation.play("scare");
                kidsCaught++;
                PlayState.instance.songScore += 100;
                boy.y = lerp(boy.y, 100, elapsed * 4);
            }
            if(kidsCaught == kidAmt) PlayState.instance.songScore += 10000;
        }
    }
    if(FlxG.keys.justPressed.ESCAPE){
        win = true;
        PlayState.instance.endSong();
    }

    for(i in balloonboys){
        if(i.velocity.x != 0 && endGame){
            i.velocity.set(0,0);
        }
    }
    if(win) PlayState.instance.endSong();
}