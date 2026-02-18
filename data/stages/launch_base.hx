//import openfl.filters.ShaderFilter;
//import funkin.utils.WindowUtil;
//import funkin.objects.Bopper;
import openfl.display.BlendMode;
import flixel.text.FlxText;
// import funkin.RatingInfo;
//import funkin.backend.Difficulty;
import flixel.math.FlxMath;
import openfl.display.BlendMode;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;

importScript('data/scripts/Lyrics');
var chud_shader = new CustomShader('colorcorrection');
var cloud_shader = new CustomShader('cloud');
var glitch = new CustomShader('glitch');
var illegaleffect = new CustomShader('illegal');
var hudGlitch = new CustomShader('glitch');
var stageshit:Int = 0;
var totalElapsed:Float = 0;
var fakebg:Array<FunkinSprite> = [];
var realbg:Array<FunkinSprite> = [];
var fire;
var dadCam = [515.25, 386.5];
var bfCam = [1000.75, 450.25];
var firecolor;
var kadeTime = true;

var diff = ['easy', 'normal', 'hard'];
var displacementx:Float;
var displacementy:Float;
var displacementcam:Float;
var bro:Float;
var totalElapsed:Float = 0;
var fucked_up:Bool = true;
var fucked_up_icons:Bool = true;

function onCountdown(event){
    event.cancel();
}

function relayer(fucker,num){
	remove(fucker, true);
	insert(num, fucker);
}
function postUpdate() {
	if(kadeTime){
		if(PlayState.instance.accuracy < 0) PlayState.instance.scoreTxt.text = "Score: " + PlayState.instance.songScore + " | Combo Breaks: " + PlayState.instance.misses + " | Accuracy: ??? | " + PlayState.instance.curRating.rating;
		if(PlayState.instance.accuracy > 0) PlayState.instance.scoreTxt.text = "Score: " + PlayState.instance.songScore + " | Combo Breaks: " + PlayState.instance.misses + " | Accuracy: " + CoolUtil.quantize(PlayState.instance.accuracy * 100, 100) + " %" + " | " + PlayState.instance.curRating.rating;
		PlayState.instance.scoreTxt.screenCenter(FlxAxes.X);
	}
	for(thingy in comboGroup.group.members){
		thingy.camera = camHUD;
	}
	if(!kadeTime){
		comboGroup.scale.set(CoolUtil.fpsLerp(comboGroup.scale.x,0.6,0.2),CoolUtil.fpsLerp(comboGroup.scale.y,0.6,0.2));

		for(thingy in comboGroup.group.members){
			thingy.velocity.x = 0;
			thingy.velocity.y = 0;
			thingy.acceleration.y = 0;
		}
	}
}

function onCameraMove(e) {
	e.cancel();
	switch(curCameraTarget){
		case 0:
			defaultCamZoom = 0.6;
			camFollow.setPosition(dadCam[0], dadCam[1]);
		case 1:
			camFollow.setPosition(bfCam[0], bfCam[1]);
			defaultCamZoom = 0.65;

		default:
			camFollow.setPosition(bfCam[0], bfCam[1]);
	}
}

function onPlayerHit(_){
	if(!kadeTime){
		if(_.note.isSustainNote) return;
		comboGroup.scale.set(0.75,0.75);
		for(thingy in comboGroup.group.members) thingy.visible = false;
	}
	if(kadeTime){
		_.showSplash = false;
		helpStep = Conductor.curStep + 1;
	}
}

function onPlayerMiss(_){ 
    if(kadeTime) helpStep = Conductor.curStep + 4;
} 

function onDadHit(_) if(kadeTime) _.strumGlowCancelled = true;

function onNoteHit(event){
	if(kadeTime){
		event.enableCamZooming = false;
		if(!kadeTime) kadeTime = true;
	}
}
function weirdLetterRating(misses, bads, shits, goods) {
	var ranking:String = '';

	// THIS CODE IS DIRECTLY COPIED FROM KADE ENGINE -- PLEASE DONT KILL ME FOR THIS STAIRCASE
	// Signed, Campbell

	if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
		ranking = "(MFC)";
	else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
		ranking = "(GFC)";
	else if (misses == 0) // Regular FC
		ranking = "(FC)";
	else if (misses < 10) // Single Digit Combo Breaks
		ranking = "(SDCB)";
	else
		ranking = "(Clear)";

	ranking += ' ';

	if (songScore == 0)
		ranking = '';

	return ranking;
}

function otherLetterRating(acc) {
	// this staircase is also ripped right from kade engine. There's GOTTA be a better way to do this but for the soul of kade engine ill leave it like this :P
	// Signed, Campbell
	var rating = 'N/A';

	if (acc >= 99.9935)
		rating = 'AAAAA'
	else if (acc >= 99.97)
		rating = 'AAAA';
	else if (acc >= 99.7)
		rating = 'AAA';
	else if (acc >= 93)
		rating = 'AA';
	else if (acc >= 85)
		rating = 'A';
	else if (acc >= 70)
		rating = 'B';
	else if (acc >= 60)
		rating = 'C';
	else if (acc < 60 && acc > 0)
		rating = 'D';
	else if (acc == 0)
		rating = 'N/A';

	return rating;
}

var rating = 'N/A';
function beatHit() {
	if(kadeTime){
		if (!fucked_up)
			return;

		for (icon in [iconP1, iconP2]) {
			icon.setGraphicSize(Std.int(icon.width + 30));
			icon.updateHitbox();
		}
	}
}
var cameraState:Int = 0;
public static var camOther:FlxCamera;

function create() {
	PlayState.instance.introLength = 0.5;
	gf.x -= 600;

    camOther = new FlxCamera();
    camOther.visible = true;
    camOther.alpha = 1;
	camOther.bgColor = 0;
    FlxG.cameras.add(camOther, false);
	PlayState.instance.introLength = 0.5;

	fucked_up = true;
	fucked_up_icons = true;

	illegal = new FlxSprite(0,0).makeGraphic(4980, 4020, FlxColor.BLUE);
	illegal.alpha = 0.001;
	//illegal.zIndex = 998;
	illegal.blend = BlendMode.MULTIPLY;
	illegal.cameras = [camHUD];
	illegal.updateHitbox();
	illegal.screenCenter();
	//illegal.visible = false;
	add(illegal);

	illegaltext = new FlxSprite(700, 600);
	illegaltext.loadGraphic(Paths.image("backgrounds/exe/execution/illegalinstruction"));
	illegaltext.setGraphicSize(Std.int(illegaltext.width * 1.5));
	illegaltext.cameras = [camOther];
	illegaltext.antialiasing = false;
	illegaltext.alpha = 0.001;
	illegaltext.blend = BlendMode.ADD;
	add(illegaltext);

	bg1 = new FunkinSprite(-800, -500);
	bg1.loadGraphic(Paths.image("backgrounds/exe/execution/execbg"));
	bg1.scrollFactor.set(1, 1);
	bg1.setGraphicSize(Std.int(bg1.width * 1.0));
	bg2 = new FunkinSprite(1300, 500);
	bg2.loadGraphic(Paths.image("backgrounds/exe/execution/execspikes"));
	bg2.scrollFactor.set(1, 1);
	bg2.setGraphicSize(Std.int(bg2.width * 0.9));

	fakebg.push(bg1);

	if(!Options.lowMemoryMode)
	{
		meat1 = new FunkinSprite(1375, -385);
		meat1.frames = Paths.getSparrowAtlas('backgrounds/exe/execution/trees/trees');
		meat1.animation.addByPrefix('idle', 'BG/BG1', 28, true);
		meat1.animation.play('idle');
		meat1.scale.set(0.9, 0.9);
		meat2 = new FunkinSprite(-885, -385);
		meat2.frames = Paths.getSparrowAtlas('backgrounds/exe/execution/trees/trees');
		meat2.animation.addByPrefix('idle', 'BG/BG2', 28, true);
		meat2.animation.play('idle');
		meat2.scale.set(0.9, 0.9);

		fire = new FunkinSprite(-140, -100);
		fire.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/awesome fire");
		fire.animation.addByPrefix('idle', 'awesome fire', 24, true);
		fire.animation.play('idle');
		fire.scrollFactor.set(0, 0);
		fire.setGraphicSize(2400, 1100);
		fire.blend = BlendMode.ADD;
		fire.alpha = 0.001;

		firecolor = new FunkinSprite(-550, -300).makeGraphic(2500, 1500, 0xFF663C33);
		firecolor.scrollFactor.set(0, 0);
		firecolor.blend = BlendMode.MULTIPLY;

		illegal1 = new FunkinSprite(-500,-500).makeGraphic(4980, 4020, 0xFF000000);
		illegal1.scrollFactor.set(0, 0);
		illegal1.alpha = 0.5;
		illegal1.visible = false;

		illegal2 = new FunkinSprite(-500,-500).makeGraphic(4980, 4020, 0xFF1500FF);
		illegal2.scrollFactor.set(0, 0);
		illegal2.blend = BlendMode.MULTIPLY;
		illegal2.visible = false;

		fakebg.push(meat1);
		fakebg.push(meat2);
		fakebg.push(fire);
		fakebg.push(firecolor);
		fakebg.push(illegal1);
		fakebg.push(illegal2);
		fakebg.push(bg2);

		
	}
	for (item in fakebg) add(item);

	PlayState.instance.strumLines.members[2].characters[0].scrollFactor.set(1,1);
	PlayState.instance.strumLines.members[2].characters[1].scrollFactor.set(1,1);
	PlayState.instance.strumLines.members[2].characters[1].y += 100;
	relayer(PlayState.instance.strumLines.members[2].characters[0], 16);
	relayer(PlayState.instance.strumLines.members[0].characters[0], 16);
	relayer(PlayState.instance.strumLines.members[1].characters[0], 16);

	floor = new FunkinSprite(-597, 312);
	floor.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/Floor"));
	floor.scrollFactor.set(1, 1);
	floor.setGraphicSize(Std.int(floor.width * 1.0));
	floor.shader = hudGlitch;
	realbg.push(floor);

	spikes = new FunkinSprite(1258, 886);
	spikes.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/Spikes"));
	spikes.scrollFactor.set(1, 1);
	spikes.setGraphicSize(Std.int(spikes.width * 1.0));
	spikes.shader = hudGlitch;
	realbg.push(spikes);

	if(!Options.lowMemoryMode){
		bushes = new FunkinSprite(-674, 97);
		bushes.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Bushes");
		bushes.animation.addByPrefix('idle', 'Bushes', 24, true);
		bushes.animation.play('idle');
		bushes.scrollFactor.set(0.8, 0.8);
		bushes.setGraphicSize(Std.int(bushes.width * 1.0));
		bushes.shader = hudGlitch;
		realbg.push(bushes);


		tube1 = new FunkinSprite(-401, -467);
		tube1.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Tree1");
		tube1.animation.addByPrefix('idle', 'Tree1', 24, true);
		tube1.animation.play('idle');
		tube1.scrollFactor.set(1, 1);
		tube1.setGraphicSize(Std.int(tube1.width * 1.0));
		tube1.shader = hudGlitch;
		realbg.push(tube1);

		tube2 = new FunkinSprite(1432, -431);
		tube2.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Tree2");
		tube2.animation.addByPrefix('idle', 'Tree2', 24, true);
		tube2.animation.play('idle');
		tube2.scrollFactor.set(1, 1);
		tube2.setGraphicSize(Std.int(tube2.width * 1.0));
		tube2.shader = hudGlitch;
		realbg.push(tube2);


	}


	deathegg = new FunkinSprite(-189, -419);
	deathegg.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/DeathEgg"));
	deathegg.scrollFactor.set(0.4, 0.4);
	deathegg.setGraphicSize(Std.int(deathegg.width * 1.0));
	deathegg.shader = hudGlitch;
	realbg.push(deathegg);

	ocean = new FunkinSprite(-659, 29);
	ocean.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Ocean");
	ocean.animation.addByPrefix('idle', 'Ocean', 24, true);
	ocean.animation.play('idle');
	ocean.scrollFactor.set(0.38, 0.38);
	ocean.setGraphicSize(Std.int(ocean.width * 1.0));
	ocean.shader = hudGlitch;
	realbg.push(ocean);


	mountain = new FunkinSprite(-752, -286);
	mountain.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/Mountains"));
	mountain.scrollFactor.set(0.2, 0.2);
	mountain.setGraphicSize(Std.int(mountain.width * 1.0));
	mountain.shader = hudGlitch;
	realbg.push(mountain);

	cloud = new FunkinSprite(-461, -461);
	cloud.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Clouds");
	cloud.animation.addByPrefix('idle', 'Clouds', 24, true);
	cloud.animation.play('idle');
	cloud.scrollFactor.set(0.28, 0.28);
	cloud.setGraphicSize(Std.int(cloud.width * 1.0));

	cloud.shader = hudGlitch;
	realbg.push(cloud);

	sky = new FunkinSprite(-901, -415);
	sky.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/Sky"));
	sky.scrollFactor.set(0.1, 0.1);
	sky.setGraphicSize(Std.int(mountain.width * 1.0));
	sky.shader = glitch;
	realbg.push(sky);


	tailscorpse = new FunkinSprite(-605, 251);
	tailscorpse.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Corpses");
	tailscorpse.animation.addByPrefix('idle', 'TailsIdle', 24, true);
	tailscorpse.animation.addByPrefix('turn', 'TailsTurn', 15, false);
	tailscorpse.animation.play('idle');
	tailscorpse.scrollFactor.set(1, 1);
	tailscorpse.setGraphicSize(Std.int(tailscorpse.width * 0.78));
	tailscorpse.shader = hudGlitch;
	realbg.push(tailscorpse);

	amycorpse = new FunkinSprite(1425, 551);
	amycorpse.frames = Paths.getSparrowAtlas("backgrounds/exe/execution/RealBG/Corpses");
	amycorpse.animation.addByPrefix('idle', 'AmyIdle', 24, true);
	amycorpse.animation.addByPrefix('turn', 'AmyTurn', 15, false);
	amycorpse.animation.play('idle');
	amycorpse.scrollFactor.set(1, 1);
	amycorpse.setGraphicSize(Std.int(amycorpse.width * 0.9));
	amycorpse.shader = hudGlitch;
	realbg.push(amycorpse);

	orgh = new FunkinSprite(0, 0);
	orgh.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/orgh"));
	orgh.scrollFactor.set(0.1, 0.1);
	orgh.setGraphicSize(Std.int(orgh.width * 1.0));
	orgh.cameras = [camHUD];
	orgh.blend = BlendMode.OVERLAY;
	realbg.push(orgh);

	orgh2 = new FunkinSprite(0, 0);
	orgh2.loadGraphic(Paths.image("backgrounds/exe/execution/RealBG/orgh"));
	orgh2.scrollFactor.set(0.1, 0.1);
	orgh2.setGraphicSize(Std.int(orgh2.width * 1.0));
	orgh2.cameras = [camHUD];
	orgh2.alpha = 0.7;
	realbg.push(orgh2);

	cooleffect = new FunkinSprite(-700, -300).makeGraphic(3680, 2920, FlxColor=0xFFFF0000);
	cooleffect.scrollFactor.set(2, 2);
	cooleffect.blend = BlendMode.ADD;
	realbg.push(cooleffect);

	cooleffect2 = new FunkinSprite(-700, -300).makeGraphic(3680, 2920, 0x5F9EA0FF);
	cooleffect2.scrollFactor.set(2, 2);
	cooleffect2.blend = BlendMode.MULTIPLY;
	realbg.push(cooleffect2);
	cooleffect.shader = cloud_shader;

	for (item in realbg) {
		item.visible = false;
		item.antialiasing = Options.antialiasing;
		add(item);
		relayer(item, 0);
	}
	for(chud in [bushes, floor, spikes, tube1, tube2]) relayer(chud, 40);
	// relayer(bushes, 39);
	// relayer(tube1, 42);

}
function refreshhealthbarcolors(opp:Int,player:Int){
	var leftColor:Int = PlayState.instance.strumLines.members[0].characters[opp].iconColor;
	var rightColor:Int = PlayState.instance.strumLines.members[1].characters[player].iconColor;
	healthBar.createFilledBar(leftColor, rightColor);
	healthBar.percent = 49;
	healthBar.percent = health;
}
var songName = 'sexecution';
function postCreate() {
	for(i in [healthBarBG, healthBar, iconP1, iconP2, scoreTxt]){
		relayer(i, 2);
	}
	relayer(healthBarBG, 0);
	relayer(healthBar, 1);

	PlayState.instance.missesTxt.alpha = PlayState.instance.accuracyTxt.alpha = 0;
	songName = switch(SONG.meta.name) {
		case "Too Slow (Legacy)": 'too-slow - Hard';
		case "Endless (Legacy)": 'endless - Hard';
		case "Execution (Legacy)": 'execution - Hard';
		default: SONG.meta.name + " - " + PlayState.difficulty + " | KE 1.5.4";
	}
	PlayState.instance.strumLines.members[1].characters[0].holdTime = 2.2;

	refreshhealthbarcolors(0,0);
	// new FlxTimer.start(22 -> {
	//  	defaultCamZoom += 0.1;
	// 	FlxTween.tween(camGame, {zoom: defaultCamZoom}, 0.2, {ease: FlxEase.quadIn});
	// });
	// modManager.queueFuncOnce(22, (s, s2) -> {

	// });

	chud_shader.brightness = 0.0;
	chud_shader.contrast = 1.35;
	chud_shader.saturation = 0.40;

	chud_shader.customred = 0.15;
	chud_shader.customgreen = 0.05;
	chud_shader.customblue = 0.05;

	cloud_shader.red_amt = 0.26;
	cloud_shader.green_amt = 0.05;
	cloud_shader.blue_amt = 0.1;

	glitch.glitchAmount = 0.0001;
	hudGlitch.glitchAmount = 0.00005;
	//swapNoteskin('exe');

	// death = new FunkinVideoSprite();
	// death.onFormat(()->{
	// 	death.camera = camOther;
	// 	death.screenCenter();
	// });
	// death.load(Paths.video('execution game over'));
	// death.onEnd(FlxG.resetState);
	// add(death);

	songInfo = new FlxText(4, healthBarBG.y + 50, 0, songName, 20);
	songInfo.y = FlxG.height - songInfo.height;
	songInfo.camera = camHUD;
	songInfo.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
	insert(99, songInfo);

	executionBG = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
	executionBG.cameras = [camOther];
	add(executionBG);

	executionCircle = new FlxSprite(1280, 0).loadGraphic(Paths.image('game/exe/CircleExecution'));
	executionCircle.cameras = [camOther];
	add(executionCircle);

	executionTxt = new FlxSprite(-1280, 0).loadGraphic(Paths.image('game/exe/TextExectution'));
	executionTxt.cameras = [camOther];
	add(executionTxt);

	    new FlxTimer().start(0.6, function(tmr:FlxTimer)
        {
            FlxTween.tween(executionCircle, {x: 0}, 0.5);
            FlxTween.tween(executionTxt, {x: 0}, 0.5);
        });

        new FlxTimer().start(1.9, function(tmr:FlxTimer)
        {
            FlxTween.tween(executionCircle, {alpha: 0}, 1);
            FlxTween.tween(executionTxt, {alpha: 0}, 1);
            FlxTween.tween(executionBG, {alpha: 0}, 1);
        });
}
//function onPostStrumCreation(_){ for(i in 0...4){ cpuStrums.members[i].x = 50 + i * 113; playerStrums.members[i].x = 700 + i * 113; }}

function stepHit(){
	switch(curStep){
		case 575:
			if(Options.lowMemoryMode) return;
			FlxTween.tween(fire, {alpha: 1}, 30, {ease: FlxEase.quintOut});
			cameraState = 2;
			bro = 4;
			defaultCamZoom= 0.55;
		case 832:
			if(Options.lowMemoryMode) return;
			cameraState= 0;
			bro = 0;
			FlxTween.cancelTweensOf(fire);
			FlxTween.tween(fire, {alpha: 0}, 7, {ease: FlxEase.quintOut});
		case 1581:
			PlayState.instance.strumLines.members[0].characters[0].playAnim('Transform1', true, 'LOCK', false, 0);
			PlayState.instance.camZooming = false;
		case 1600:
			for (i in fakebg) {
				if (i.frames != null)
					i.animation.pause();
			}

			var poop = Options.lowMemoryMode ? [bg1, bg2] : [bg1,bg2, meat1, meat2, boyfriend, gf];
			for (fat in poop) fat.shader = illegaleffect;
			camHUD.addShader(illegaleffect);

			PlayState.instance.strumLines.members[1].characters[0].visible = false;
			PlayState.instance.strumLines.members[2].characters[0].visible = false;

			// notes.forEachAlive((note) -> {
			// 	note.canMiss = true;
			// 	note.reloadNote();
			// });

			PlayState.instance.strumLines.members[0].characters[0].playAnim('Transform2', true, 'LOCK', false, 0);
			bro = 5;
			cameraState = 2;
			PlayState.instance.camZooming = false;
			//PlayState.instance.defaultCamZoom= 0.66;
			//PlayState.instance.camZoomingMult = 0;
			//cameraSpeed = 1.4;
			if(!Options.lowMemoryMode){
				illegal1.visible = true;
				illegal2.visible = true;
			}
			//snapCamToPos(326, 375, true);
			relayer(illegal, 999);
			illegal.alpha = 1;
			if(!Options.lowMemoryMode)
				illegaltext.alpha = 1;
			relayer(illegal, 999);
			//dadGroup.zIndex = 10;
			relayer(PlayState.instance.strumLines.members[0].characters[0], 999);
		case 1632:
			songInfo.visible = false;
			for(i in 0...4){ 
				cpuStrums.members[i].x = 75 + (i * 113); 
				playerStrums.members[i].x = 725 + (i * 113); 
			}

			kadeTime = false;
			scoreTxt.x = PlayState.instance.healthBarBG.x + 50;
			scoreTxt.text = 'Score: ' + PlayState.instance.songScore;
			glitch.glitchAmount = 4;
			dad.shader = glitch;
			camHUD.filters = [];
			PlayState.instance.health = 1;
			var poop = Options.lowMemoryMode ? [bg1, bg2, boyfriend, gf] : [bg1,bg2, meat1, meat2, boyfriend, gf];
			for (fat in poop) 
				fat.shader = null;


				stageshit = 1;
				camGame.addShader(chud_shader);

				for (item in fakebg) item.visible = false;
				
				for (item in realbg) item.visible = true;

				PlayState.instance.strumLines.members[0].characters[0].visible = false;
				PlayState.instance.strumLines.members[0].characters[1].visible = true;
				PlayState.instance.strumLines.members[1].characters[1].visible = true;
				PlayState.instance.strumLines.members[2].characters[1].visible = true;
				PlayState.instance.strumLines.members[0].characters[1].shader = PlayState.instance.strumLines.members[1].characters[1].shader = PlayState.instance.strumLines.members[2].characters[1].shader = dad.shader;
				PlayState.instance.strumLines.members[1].characters[1].x += 135;
				PlayState.instance.strumLines.members[1].characters[1].y += 45;

				PlayState.instance.strumLines.members[0].characters[1].x += 220;
				PlayState.instance.strumLines.members[2].characters[1].x += 220;

				PlayState.instance.strumLines.members[0].characters[1].y += 55;
				// PlayState.instance.strumLines.members[1].characters[1].x = 1080;
				// PlayState.instance.strumLines.members[1].characters[1].y = 450;

				// PlayState.instance.strumLines.members[1].characters[1].x = 800;
				// PlayState.instance.strumLines.members[1].characters[1].y = 290;
				relayer(PlayState.instance.strumLines.members[2].characters[1], 60);
				relayer(PlayState.instance.strumLines.members[0].characters[1], 60);
				relayer(PlayState.instance.strumLines.members[1].characters[1], 60);
				fucked_up_icons = false;
				bro = 2;
				cameraState = 2;
				for (m in [PlayState.instance.scoreTxt, PlayState.instance.missesTxt, PlayState.instance.accuracyTxt, PlayState.instance.healthBar,PlayState.instance.healthBarBG,iconP1,iconP2]) m.alpha = 0;

				illegal.color = FlxColor.BLACK;
				if(!Options.lowMemoryMode) illegaltext.visible = false;
				iconP1.setIcon('icon-bfmobian');
				iconP2.setIcon('icon-dordx');
				refreshhealthbarcolors(1,1);

			case 1648:
				FlxG.camera.zoom = 2.4;
				PlayState.instance.defaultCamZoom = 2.4;
				illegal1.visible = illegal2.visible = false;
				illegal.visible = true;
				FlxTween.tween(PlayState.instance,{defaultCamZoom:0.6}, 12.5, {ease:FlxEase.quadOut});
				FlxTween.tween(FlxG.camera,{zoom:0.6}, 12.5, {ease:FlxEase.quadOut});

				PlayState.instance.camZooming = false;

				FlxTween.color(illegal, 8, illegal.color, FlxColor.BLUE);
				FlxTween.tween(illegal, {alpha:0}, 16, {ease:FlxEase.quintInOut});
				FlxTween.num(4, 0.000001, 12, {
					onUpdate: (t) -> {
						glitch.glitchAmount = t.value;
					}
				});

				FlxTween.num(1.6, 0.000001, 10, {
					startDelay: 3,
					onUpdate: (t) -> {
						hudGlitch.glitchAmount = t.value;
					}
				});
			case 1728:
				bro = 1;
				for (m in [PlayState.instance.scoreTxt, PlayState.instance.missesTxt, PlayState.instance.accuracyTxt, PlayState.instance.healthBar,PlayState.instance.healthBarBG,iconP1,iconP2]) FlxTween.tween(m,{alpha: 1}, 1, {ease:FlxEase.quadOut});

				cameraState = 1;
				camZoomingMult = 1;
			case 2240:
				tailscorpse.animation.play('turn');
			case 2304:
				amycorpse.animation.play('turn');
			case 2368:
				cameraState = 2;
				defaultCamZoom = 0.6;
				FlxTween.tween(PlayState.instance,{defaultCamZoom:0.57}, 5, {ease:FlxEase.quadInOut});
				bro = 3;
			case 2373:
				camHUD.fade(FlxColor.BLACK, 5);
	}
}
// function onEvent(eventName, value1, value2) {
// 	switch (eventName) {
// 		case 'Execution Events':
// 			switch (value1.toLowerCase()) {

// 				case 'aura loss':
// 					if(Options.lowMemoryMode) return;
				
// 					FlxTween.cancelTweensOf(fire);
// 					FlxTween.tween(fire, {alpha: 0}, 7, {ease: FlxEase.quintOut});

// 				case 'he transforms':


// 				case 'error':


// 				case 'real intro':

// 				case 'real intro fade':


// 				case 'bg':


// 					swapNoteskin('default');

// 				case 'tails':
// 					

// 				case 'amy':
// 					
// 			}
// 	}
// }

// function swapNoteskin(newSkin:String) {
// 	PlayState.SONG.arrowSkin = newSkin;
// 	noteskinLoading(newSkin);
// 	initNoteSkinning(newSkin);

// 	notes.forEachAlive((note) -> {
// 		note.texture = note.mustPress ? PlayState.noteSkin.data.playerSkin : PlayState.noteSkin.data.opponentSkin;
// 		note.reloadNote();
// 	});

// 	// for (j in playFields.members) {
// 	// 	for (i in j.members) {
// 	// 		i.texture = NoteSkinHelper.arrowSkins[i.player];
// 	// 		i.reloadNote();
// 	// 		i.handleColors('static');
// 	// 	}
// 	// }
// }

// function onSpawnNote(note) {
// 	note.reloadNote();
// }

function update(elapsed) {
	totalElapsed += elapsed;
	cloud_shader.iTime = totalElapsed;

	if(Options.lowMemoryMode) return;
	firecolor.alpha = fire.alpha;
	if(kadeTime){
		var iconScale:Float = 1;

		if (!fucked_up){		
			return;
		}


		if(fucked_up_icons){
			for (icon in [iconP1, iconP2]) {
				icon.setGraphicSize(Std.int(FlxMath.lerp(150, icon.width, 0.50)));
				icon.updateHitbox();
			}
		}

	}
	totalElapsed += elapsed * -1;

	var displacementx = ((2.5 * Math.sin(totalElapsed * 0.45)) + (FlxG.random.float(-5, 5) * 0.07))*(elapsed*60);
	var displacementy = ((2.5 * Math.sin(totalElapsed * 0.25)) + (FlxG.random.float(-5, 5) * 0.07))*(elapsed*60);
	var displacementcam = (0.4 * Math.sin(totalElapsed * 0.55))*(elapsed*60);

	switch (bro) {
		case 0:
			//nothing ever happens
			//isCameraOnForcedPos = false;
		
		case 1:
			//real part
			camGame.scroll.x = camGame.scroll.x;
			camGame.scroll.y = camGame.scroll.y;
			camGame.angle = displacementcam;
			//isCameraOnForcedPos = false;

		case 2:
			//real part intro
			//isCameraOnForcedPos = true;
			FlxTween.tween(camFollow,{x: 830, y: 475}, 1);
		
		case 3:
			//real part ending
			camGame.scroll.x = camGame.scroll.x;
			camGame.scroll.y = camGame.scroll.y;
			camGame.angle = displacementcam;
			//isCameraOnForcedPos = true;
			FlxTween.tween(camFollow,{x: 830, y: 475}, 1);

		case 4:
			//aura
			//isCameraOnForcedPos = true;
			FlxTween.tween(camFollow,{x: 626, y: 375}, 1);

		case 5:
			//pibby
			//isCameraOnForcedPos = true;
			FlxTween.tween(camFollow,{x: 326, y: 375}, 1);
	}
}

function destroy() {
	FlxG.game.setFilters();
}

var can = true;
// function onGameOver()
// {
// 	if(can)
// 	{
// 		can = false;
// 		volumeMult = 0;

// 		death.play();
// 	}
// }