import openfl.display.BlendMode;
import funkin.backend.FunkinSprite;
import haxe.Json;
import sys.io.File;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.system.Conductor;
import flixel.text.FlxText;
import openfl.display.BlendMode;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import funkin.backend.utils.DiscordUtil;
importScript('data/scripts/NoteWarning');

var evilness:FunkinSprite;
var blackFG:FunkinSprite;

var introcc = new CustomShader('colorcorrection');

var fogshader = new CustomShader('fog epic');
var cloud_shader = new CustomShader('cloud');
var cooleffect:FunkinSprite;
var fogtuah:FunkinSprite;
var melt = new CustomShader('melt');

var snow = new CustomShader('snowfall');
var atotalElapsed:Float = 0;
var intro = true;
var intro_camera = false;
var pov = false;

var snowStorm:Float = 0;

var bg;
var ice;
var fog;
var snow3;
var ground;
var snow2;
var snow1;
var fgIce;
var orgh;
var fog1;
var fog2;

var bust;
var snowAtlas;

var iconY: Float = 0;
var textevil = new FunkinText();
var screen:Array<FunkinSprite> = [];

var displacementx:Float;
var displacementy:Float;
var displacementcam:Float;

var totalElapsed:Float = 0;

var colorcorrection = new CustomShader('colorcorrection');




function makeSpr(x, y, name, folder) {
	var sprite = new FunkinSprite(x, y);
	sprite.setFrames(Paths.getSparrowAtlas('backgrounds/exe/zeph/try-harder/' + folder));
	sprite.animation.addByPrefix(name, name, 24, false);
	sprite.animation.play(name);
	sprite.antialiasing = Options.antialiasing;

	return sprite;
}
function onCountdown(event){
    event.cancel();
}
public static var camOther:FlxCamera;
function relayer(fucker,num){
	remove(fucker, true);
	insert(num, fucker);
}
function create() {
    camOther = new FlxCamera();
    camOther.visible = true;
    camOther.alpha = 1;
	camOther.bgColor = 0;
    FlxG.cameras.add(camOther, false);

	PlayState.instance.introLength = 0.5;

	var bg:FunkinSprite = makeSpr(-900, -1100, 'background ladders', 'try-harder-1');

	bg.scrollFactor.set(0.42, 0.65);

	var ice = makeSpr(-121, -345, 'icicles background', 'try-harder-1');

	ice.scrollFactor.set(0.75, 1);

	var fog = makeSpr(-590, -36, 'poop', 'try-harder-1');
	fog.scrollFactor.set(0.6, 0.9);

	var ground = makeSpr(-666, 96, 'main stage', 'try-harder-1');
	ground.scrollFactor.set(1, 1);

	evilness = makeSpr(ground.x + 325, ground.y, 'spoopy main stage', 'try-harder-1');
	evilness.scrollFactor.set(1, 1);
	evilness.visible = false;

	if(!Options.lowMemoryMode){
		snow1 = makeSpr(-675,85,'snow1','groundSnow');
		snow2 = makeSpr(1350,500,'snow2','groundSnow');
		snow3 = makeSpr(-900,400,'snow3','groundSnow');

	}


	fgIce = makeSpr( -570, -500, 'icicles foreground', 'try-harder-1');
	fgIce.scrollFactor.set(2, 2);

	blackFG = new FunkinSprite(-800, -400).makeGraphic(FlxG.width * 3, FlxG.height * 2.2, FlxColor.BLACK);
	blackFG.scrollFactor.set(0, 0);
	blackFG.alpha = 1;

	orgh = makeSpr(-620, -400, 'orgh', 'try-harder-1');
	orgh.scrollFactor.set(1, 0.1);
	orgh.scale.set(2.2,2.2);
	orgh.updateHitbox();
	orgh.visible = true;

	fog1 = new FlxBackdrop(null, FlxAxes.XY, 0, 0);
	fog1.setPosition(-200, 100);
	fog1.screenCenter(FlxAxes.Y);
	fog1.loadGraphic(Paths.image("backgrounds/exe/zeph/try-harder/fog1"));
	fog1.scrollFactor.set(1.3, 1);
	fog1.setGraphicSize(Std.int(fog1.width * 1.4));

	fog1.alpha = 0;

	fog2 = new FlxBackdrop(null, FlxAxes.XY, 0, 0);
	fog2.setPosition(-200, 100);
	fog2.screenCenter(FlxAxes.Y);
	fog2.loadGraphic(Paths.image("backgrounds/exe/zeph/try-harder/fog2"));
	fog2.scrollFactor.set(0.5, 0.5);
	fog2.scale.set(1.5,1);
	fog2.alpha = 0;


	

	for (item in [bg, ice, fog, snow3, ground, snow2, evilness, snow1, fgIce, blackFG, orgh,fog1, fog2]) {
		if(item != null){
			add(item);
		}
	}

	p1 = [bg, ice, fog, ground, evilness, fgIce, orgh, fog1, fog2];

	bg2 = makeSpr(-1280,-720,'bg','try-harder-2');
	bg2.scrollFactor.set(0.1, 0.1);
	add(bg2);



	for(i in [snow1,snow2,snow3]){
		if(i != null)		
			i.visible = false;
	}
	
	iceback = makeSpr(-350,-720,'ice back', 'try-harder-2');
	iceback.scrollFactor.set(0.5, 0.5);
	add(iceback);

	plat = makeSpr(-1280,200,'platforms','try-harder-2');
	plat.scrollFactor.set(0.3, 0.3);
	add(plat);

	floor = makeSpr(-1280,-1280,'main','try-harder-2');
	floor.scrollFactor.set(0.8, 0.8);
	add(floor);

	icefront = makeSpr(-1280,-720, 'ice front', 'try-harder-2');
	icefront.scrollFactor.set(2,2);
	icefront.alpha = 0.8;
	add(icefront);
	p2 = [bg2, iceback, plat, floor, icefront];
	for(i in p2) i.visible = false;
}
function miscpostCreate() {
    bg = new FunkinSprite(0, 0);
	bg.loadGraphic(Paths.image("backgrounds/exe/zeph/try-harder/Transition"));
    bg.scrollFactor.set(0, 0);
    bg.setGraphicSize(Std.int(bg.width * 2.0));
    screen.push(bg);

    transition = new FunkinSprite(-200, -10);
	transition.loadGraphic(Paths.image("backgrounds/exe/zeph/try-harder/snow transition"));
    transition.scrollFactor.set(0, 0);
    transition.setGraphicSize(Std.int(transition.width * 2.0));
    transition.alpha = 0;
    add(transition);

    snowOverlay = new FunkinSprite(0, 0);
	snowOverlay.loadGraphic(Paths.image("backgrounds/exe/zeph/try-harder/snow overlay"));
    snowOverlay.scrollFactor.set(0, 0);
    snowOverlay.setGraphicSize(Std.int(snowOverlay.width * 1.10));
    snowOverlay.camera = camHUD;
    snowOverlay.alpha = 0;
    add(snowOverlay);

    addepic = new FunkinSprite(0,0).makeGraphic(1280, 720, FlxColor = 0xFF0A274F);
    addepic.scrollFactor.set(0, 0);
    addepic.setGraphicSize(Std.int(bg.width * 2.0));
    addepic.blend = BlendMode.ADD;
    addepic.alpha = 0;
    add(addepic);

	textevil.setFormat(Paths.font('Sonic Advanced 2.ttf'), 40, FlxColor = 0xFF000000, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor = 0xFFFFE100);
	textevil.borderSize = 2.5;
	textevil.antialiasing = false;
    textevil.scrollFactor.set(0, 0);
    textevil.scale.set(2, 2.2);
    textevil.text = "Breaking a sweat already..?";
    textevil.y = (720 /2)- (textevil.height/2);
    screen.push(textevil);

    for (item in screen) {
		item.antialiasing = true;
		item.visible = false;
		add(item);
    }

}
function postCreate() {

	if(!Options.lowMemoryMode){
		snowAtlas = new FlxBackdrop(null, FlxAxes.XY, -220, -200);
		snowAtlas.setPosition(-250, -150);
		snowAtlas.frames = Paths.getSparrowAtlas('backgrounds/exe/zeph/try-harder/Snow/Snowfall');
		snowAtlas.animation.addByPrefix('Snowfall', 'Snowfall', 40, true);
		snowAtlas.animation.play('Snowfall');
		snowAtlas.scale.set(1.8, 1.8);
		snowAtlas.scrollFactor.set(1.5, 1.5);
		snowAtlas.antialiasing = Options.antialiasing;
		snowAtlas.alpha = 0;
		add(snowAtlas);
		remove(snowAtlas, true);
		insert(99, snowAtlas);

		if (Options.gameplayShaders) {
			cloud_shader.red_amt = 0.1;
			cloud_shader.green_amt = 0.17;
			cloud_shader.blue_amt = 0.3;

			fogtuah = new FunkinSprite(-750, -300).makeGraphic(3680, 2920, FlxColor.RED);
			fogtuah.scrollFactor.set(0.7, 0.7);
			fogtuah.shader = cloud_shader;
			fogtuah.blend = BlendMode.ADD;
			fogtuah.antialiasing = true;
			add(fogtuah);
			remove(fogtuah);
			insert(1, fogtuah);


			colorcorrection.brightness = 0.0;
			colorcorrection.contrast = 1.35;
			colorcorrection.saturation = 0.40;
			colorcorrection.customred = 0.1;
			colorcorrection.customgreen = 0.1;
			colorcorrection.customblue = 0.15;
			FlxG.camera.addShader(colorcorrection);
			camHUD.addShader(colorcorrection);
			fogshader.cloudDensity = 0.85;
			fogshader.noisiness = 0.4;
			fogshader.speed = 0.03;
			fogshader.cloudHeight = 3.5;
			fogshader.customred = 0.6;
			fogshader.customgreen = 0.6;
			fogshader.customblue = 0.5;

			cooleffect = new FunkinSprite(-830, -350).makeGraphic(3180, 1720, FlxColor.RED);
			cooleffect.scrollFactor.set(2, 2);
			cooleffect.angle = 180;
			cooleffect.shader = fogshader;
			cooleffect.blend = BlendMode.ADD;
			cooleffect.antialiasing = true;
			snow.amount = 0;
			snow.intensity = 0.325;

		}
	}

	gf.scrollFactor.set(1,1);

	if (Options.gameplayShaders) {
		introcc.brightness = 0.0;
		introcc.contrast = 0.8;
		introcc.saturation = 0.80;
		introcc.customred = 0.0;
		introcc.customgreen = 0.0;
		introcc.customblue = 0.0;

		dad.shader = boyfriend.shader = gf.shader = introcc;
	}
	if(!Options.lowMemoryMode){
		bust = new FunkinSprite();
		bust.frames = Paths.getSparrowAtlas('characters/wolf/im boutta nust');
		bust.animation.addByPrefix('idle', 'fucking', 25, true);
		bust.animation.play('idle');
		bust.setPosition(FlxG.width - (bust.width * 0.8), FlxG.height - (bust.height * 0.8));
		bust.camera = camHUD;
		bust.y += bust.height;
		bust.blend = BlendMode.ADD;

		add(bust);
		remove(bust, true);
		insert(0, bust);
	}

	if (!intro) {
		PlayState.instance.defaultCamZoom = 0.6;		
		return;
	}

	camFollow.setPosition(730, 100);
	FlxG.camera.snapToTarget();

	camGame.zoom = 1.5;

	camHUD.alpha = 0;
	miscpostCreate();
	for (m in [scoreTxt,missesTxt,accuracyTxt]) m.visible = false;

	if (Options.gameplayShaders){
		add(cooleffect);
	}
	relayer(blackFG, 999);
	for(i in screen){
		relayer(i, 1000);
	}
	PlayState.instance.strumLines.members[1].characters[1].camera = camHUD;
	PlayState.instance.strumLines.members[1].characters[1].y += PlayState.instance.strumLines.members[1].characters[1].height;
	PlayState.instance.strumLines.members[0].characters[1].y += 160;
	PlayState.instance.strumLines.members[0].characters[3].y += 450;
}
function relayerFuckers() {
	relayer(PlayState.instance.strumLines.members[2].characters[0], members.indexOf(fgIce) - 2);
	relayer(PlayState.instance.strumLines.members[1].characters[0], members.indexOf(fgIce) - 1);
	relayer(PlayState.instance.strumLines.members[0].characters[0], members.indexOf(fgIce) - 1);
	relayer(PlayState.instance.strumLines.members[0].characters[1], members.indexOf(PlayState.instance.strumLines.members[0].characters[0]));
	relayer(PlayState.instance.strumLines.members[0].characters[2], members.indexOf(icefront) - 1);
	relayer(PlayState.instance.strumLines.members[0].characters[3], members.indexOf(PlayState.instance.strumLines.members[0].characters[0]));
	relayer(PlayState.instance.strumLines.members[0].characters[4], members.indexOf(PlayState.instance.strumLines.members[0].characters[0]));

	relayer(PlayState.instance.strumLines.members[1].characters[2], members.indexOf(PlayState.instance.strumLines.members[1].characters[0]) + 4);
	relayer(PlayState.instance.strumLines.members[2].characters[1], members.indexOf(PlayState.instance.strumLines.members[2].characters[0]) + 2);
	PlayState.instance.strumLines.members[0].characters[4].visible = PlayState.instance.strumLines.members[0].characters[3].visible = PlayState.instance.strumLines.members[0].characters[2].visible = PlayState.instance.strumLines.members[0].characters[1].visible = PlayState.instance.strumLines.members[1].characters[1].visible = PlayState.instance.strumLines.members[1].characters[2].visible = PlayState.instance.strumLines.members[2].characters[1].visible = false;


}
function onSongStart(){
	var tweenTime:Float = 17;
	if(intro)
	FlxTween.tween(camGame, {zoom: defaultCamZoom}, tweenTime, {ease: FlxEase.cubeInOut});
	FlxTween.tween(blackFG, {alpha: 0.1}, tweenTime);
	FlxTween.tween(camFollow, {y: 450}, tweenTime, {ease: FlxEase.smoothStepOut});	
	relayerFuckers();

}
function refreshhealthbarcolors(opp:Int,player:Int){
	var leftColor:Int = PlayState.instance.strumLines.members[0].characters[opp] != null && PlayState.instance.strumLines.members[0].characters[opp].iconColor != null && Options.colorHealthBar ? PlayState.instance.strumLines.members[0].characters[opp].iconColor : (opponentMode ? 0xFF66FF33 : 0xFFFF0000);
	var rightColor:Int = PlayState.instance.strumLines.members[1].characters[player] != null && PlayState.instance.strumLines.members[1].characters[player].iconColor != null && Options.colorHealthBar ? PlayState.instance.strumLines.members[1].characters[player].iconColor : (opponentMode ? 0xFFFF0000 : 0xFF66FF33);
	healthBar.createFilledBar(leftColor, rightColor);
	healthBar.percent = 49;
	healthBar.percent = health;
}
var lockCamera:Bool = false;
function stepHit(e){

    iconY = FlxG.random.float(-2, 2);

	switch(curStep){
		case 126:
			if (!intro)
			return;
			intro_camera = true;

		case 180:
			FlxTween.tween(camHUD, {alpha: 1}, 0.8);
		case 384:
			introc = false;
			FlxTween.tween(camHUD, {alpha: 0}, 2.5, {ease: FlxEase.cubeIn});
		case 392:
			FlxTween.tween(blackFG, {alpha: 1}, 0.9);
		case 463:
			iconP2.setIcon('icon-zeph', false);
			refreshhealthbarcolors(1,0);
			PlayState.instance.strumLines.members[0].characters[1].visible = true;
			PlayState.instance.strumLines.members[0].characters[0].visible = false;
			PlayState.instance.strumLines.members[0].characters[0].exists = false;
		case 464:
			blackFG.alpha = 0;
			for (m in [scoreTxt,missesTxt,accuracyTxt])	m.visible = true;
			if(!Options.lowMemoryMode){
				camGame.removeShader(colorcorrection);
				camHUD.removeShader(colorcorrection);
				orgh.visible = false;
				boyfriend.shader = dad.shader = gf.shader = null;
				orgh.alpha = 0;
			}
			introc = false;

			intro_camera = false;
			evilness.visible = true;

			camHUD.alpha = 1;
			camHUD.flash();

		case 700:
            PlayState.instance.strumLines.members[0].characters[1].playAnim('laugh', true, 'LOCK', false, 0);
		case 704:
            PlayState.instance.strumLines.members[0].characters[1].playAnim('laugh', true, 'LOCK', false, 0);
		case 708:
            PlayState.instance.strumLines.members[0].characters[1].playAnim('laugh', true, 'LOCK', false, 0);
		case 712:
            PlayState.instance.strumLines.members[0].characters[1].playAnim('laugh', true, 'LOCK', false, 0);
		case 818:
            PlayState.instance.strumLines.members[0].characters[1].playAnim('grab', true, 'LOCK', false, 0);
		case 838:
			PlayState.instance.strumLines.members[1].characters[0].visible = false;
			camFollow.x = dad.x+560;
			camFollow.y = dadCam[1];
			PlayState.instance.defaultCamZoom = 0.7;
			FlxTween.tween(camFollow, {y: dadCam[1]}, 2.5, {ease: FlxEase.circIn});
			FlxTween.tween(blackFG, {alpha: 1}, 0.5, {ease: FlxEase.linear, onComplete: ()->{
				pov = true;
				PlayState.instance.strumLines.members[2].characters[0].visible = false;
				icefront.y -= 250;
				icefront.alpha = 0;
				FlxTween.tween(icefront, {alpha: 0.8, y: icefront.y + 250}, 1.5, {ease: FlxEase.quadOut});
				for(i in p1) i.visible = false;
				for(i in p2) i.visible = true;
				PlayState.instance.strumLines.members[0].characters[2].visible = true;
				PlayState.instance.strumLines.members[1].characters[1].visible = true;


				FlxTween.cancelTweensOf(camFollow);
				snapCamToPos(dadCam[0] + 100, dadCam[1] - 500);
				FlxTween.tween(camFollow, {y: dadCam[1] - 200}, 0.5, {ease: FlxEase.circOut, onComplete: ()->{
					FlxTween.tween(PlayState.instance.strumLines.members[1].characters[1], {y: PlayState.instance.strumLines.members[1].characters[1].y - PlayState.instance.strumLines.members[1].characters[1].height}, 1, {ease: FlxEase.circOut});			
					if(bust != null) FlxTween.tween(bust, {y: (FlxG.height - (bust.height * 0.8))}, 1, {ease: FlxEase.circOut});		
				}});
			}});
			lockCamera = true;

			FlxTween.tween(blackFG, {alpha: 0}, 0.5, {startDelay: 0.5125});
		case 1360:
				FlxTween.tween(PlayState.instance.strumLines.members[1].characters[1], {y: PlayState.instance.strumLines.members[1].characters[1].y + PlayState.instance.strumLines.members[1].characters[1].height}, 1, {ease: FlxEase.circIn, onComplete: ()->{PlayState.instance.strumLines.members[1].characters[1].visible = false;}});
				
				if(bust != null) FlxTween.tween(bust, {y: (FlxG.height)}, 1, {ease: FlxEase.circIn, onComplete: ()->{bust.visible = false;}});		

				FlxTween.tween(camFollow, {y: PlayState.instance.strumLines.members[0].characters[0].y - 900}, 0.8, {ease: FlxEase.circIn});
				FlxTween.tween(icefront, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});

				FlxTween.tween(blackFG, {alpha: 1}, 0.675,{ease: FlxEase.linear, onComplete: ()->{
					pov = false;
					for(i in p1) i.visible = true;
					for(i in p2) i.visible = false;
					PlayState.instance.strumLines.members[0].characters[2].visible = false; //hide first person mightyyyy
					//zeph vis
					PlayState.instance.strumLines.members[0].characters[1].visible = true;
					//gf vis
					PlayState.instance.strumLines.members[2].characters[0].visible = true;
					//bf vis
					PlayState.instance.strumLines.members[1].characters[0].visible = true;

					fgIce.y -= 500;
					FlxTween.tween(fgIce, {y: fgIce.y + 500}, 1.4, {ease: FlxEase.quadOut});
					FlxTween.cancelTweensOf(camFollow);
					snapCamToPos(dadCam[0], dadCam[1] - 500);
					FlxTween.tween(camFollow, {y: dadCam[1]}, 0.5, {ease: FlxEase.circOut});
					lockCamera = false;
				}});
				FlxTween.tween(blackFG, {alpha: 0}, 1, {startDelay: 1});
		case 1616:
			//text "3/4"
			//hide bf, gf, and zeph
			PlayState.instance.strumLines.members[1].characters[0].visible = false;
			PlayState.instance.strumLines.members[0].characters[1].visible = false;
			PlayState.instance.strumLines.members[2].characters[0].visible = false;

			//show coldbf,coldgf, and zephRYHME
			PlayState.instance.strumLines.members[0].characters[3].visible = true;
			PlayState.instance.strumLines.members[1].characters[2].visible = true;
			PlayState.instance.strumLines.members[2].characters[1].visible = true;

			for (item in screen) {
                item.visible = true;
            }
            comboGroup.visible = false;
            textevil.text = "Breaking a sweat already..? \nhere, no need to thank me...";
                    for(i in [healthBar, healthBarBG, iconP1, iconP2, scoreTxt, missesTxt, accuracyTxt]) i.y += Options.downScroll ? -300 : 300;
        
			if(Options.lowMemoryMode) return; 
				colorcorrection.customred = 0.125;
				colorcorrection.customgreen = 0.145;
				colorcorrection.customblue = 0.20;
				colorcorrection.saturation = 0.40;
				colorcorrection.brightness = -0.2;
				colorcorrection.contrast = 1.0;

				FlxG.camera.addShader(colorcorrection);
				camHUD.addShader(colorcorrection);
		case 1632:
			var username:String = 'BOYFRIEND';
            if(DiscordUtil.user.globalName != null) username = DiscordUtil.user.globalName;
            textevil.text = "Breaking a sweat already..? \nhere, no need to thank me... \n" + username + ".";
       
		case 1647: //lyrics

            for (item in screen) {
                item.visible = false;
            }
            comboGroup.visible = true;

			camFollow.x = 450;
			camFollow.y = 490;
			FlxG.camera.snapToTarget();
			fog1.x = -200;
			fog2.x = -1000;
			fog1.alpha = 1;
			fog2.alpha = 1;
			FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.cubeOut});
			PlayState.instance.strumLines.members[0].characters[1].visible = false;
            PlayState.instance.strumLines.members[0].characters[3].playAnim('ryhme', true, 'LOCK', false, 0);
		case 1896:
			FlxTween.tween(camHUD, {alpha: 1}, 0.4, {ease: FlxEase.cubeOut});
		case 1900:
			transition.alpha = 1;
			transition.x = -4200;
			FlxTween.tween(transition, {x: 3200}, 1, {ease: FlxEase.linear});
		case 1903:
			snowStorm = 1;
			FlxTween.tween(snowOverlay, {alpha: 1}, 0.25, {ease: FlxEase.cubeOut});
			PlayState.instance.strumLines.members[0].characters[3].visible = false;
			PlayState.instance.strumLines.members[0].characters[1].visible = true;
			if(snowAtlas != null) FlxTween.tween(snowAtlas, {alpha: 1}, 0.25, {ease: FlxEase.cubeOut});
			var tween_time:Float = 0.6;
			for(i in [healthBar, healthBarBG, iconP1, iconP2, scoreTxt, missesTxt, accuracyTxt]) FlxTween.tween(i, {y: i.y + (Options.downScroll ? 300 : -300)}, tween_time, {ease: FlxEase.cubeOut});


		case 2160:
			for(i in [PlayState.instance.strumLines.members[0].characters[1], PlayState.instance.strumLines.members[1].characters[2], PlayState.instance.strumLines.members[2].characters[1]]){			
				i.debugMode = true;
			}

			FlxTween.tween(blackFG, {alpha: 1}, 3, {startDelay: 0.75});
			FlxTween.tween(camHUD, {alpha: 0}, 3, {startDelay: 0.75});

			if(Options.gameplayShaders && !Options.lowMemoryMode)
			{
				melt.iTime = 0;
				FlxG.camera.addShader(melt);
				camHUD.addShader(melt);
				FlxTween.num(0, 0.75, 4, {onUpdate: (t)->{
					melt.iTime = t.value;
				}});

			}
			if(snowAtlas != null) snowAtlas.animation.pause();
		case 2255:
			for(i in [snow1,snow2,snow3]){
				if(i != null)						
					i.visible = true;
			}

			for(i in [PlayState.instance.strumLines.members[0].characters[1], PlayState.instance.strumLines.members[1].characters[2], PlayState.instance.strumLines.members[2].characters[1]]){			
				i.debugMode = false;
			}
			if(snowAtlas != null) snowAtlas.visible = false;
			snowOverlay.alpha = 0;
			snowStorm = 0;

			camZoomingMult = 1;
			FlxTween.tween(blackFG, {alpha: 0}, 10, {ease: FlxEase.quadIn});
			camGame.removeShader(colorcorrection);
			camHUD.removeShader(colorcorrection);
			fog1.alpha = 0;
			fog2.alpha = 0;

			if(orgh != null) orgh.alpha = 1;

			PlayState.instance.strumLines.members[0].characters[1].visible = false;
			PlayState.instance.strumLines.members[0].characters[4].visible = true;
			iconP2.setIcon('icon-zephmoldy', false);
			refreshhealthbarcolors(4,0);
			defaultCamZoom = 1.6;
			FlxG.camera.zoom = 1.6;
			PlayState.instance.camZooming = true;
			
			FlxTween.tween(PlayState.instance, {defaultCamZoom: 0.7}, 8, {ease: FlxEase.quadInOut});
			snapCamToPos(gf.x, gf.y);
			FlxTween.tween(camHUD, {alpha: 1}, 6, {startDelay: 3});


			if(Options.gameplayShaders)
			{
				melt.iTime = 0;
				camGame.removeShader(melt);
				camForceZoom = false;
				snowAtlas.animation.play('Snowfall');
				camGame.addShader(snow);
				snow.amount = 30;

				colorcorrection.customred = 0.18;
				colorcorrection.customgreen = 0.125;
				colorcorrection.customblue = 0.20;
				colorcorrection.saturation = 0.20;
				colorcorrection.brightness = -0.2;
				colorcorrection.contrast = 1.0;
				camGame.addShader(colorcorrection);
			}
		case 2380:
			addepic.alpha = 0;
			snowOverlay.alpha = 0;
			PlayState.instance.camZooming = true;
		case 2896:
			mightyRotReal = true;
			PlayState.instance.defaultCamZoom = 0.55;
			
			if(Options.lowMemoryMode) return;

			tweenColorThing('saturation', 0.4, 2);
			tweenColorThing('brightness', -0.15, 2);
			tweenColorThing('contrast', 1.2, 2);
		case 3280:
			camFollow.x = dadCam[0]+460;
			camFollow.y = dadCam[1]+200;
			FlxTween.tween(PlayState.instance, {defaultCamZoom:1.1}, 5, {ease:FlxEase.quadIn});
			FlxTween.tween(camHUD, {alpha: 0}, 3.5, {ease:FlxEase.quadIn});
			colorcorrection.customred = 0.01;
			colorcorrection.customgreen = 0.007;
			colorcorrection.customblue = 0.009;
			FlxTween.tween(addepic, {alpha: 0.3}, 4.25, {ease: FlxEase.cubeOut});
			snowOverlay.color = 0xffF8E8FC;
			FlxTween.tween(snowOverlay, {alpha: 0.95}, 4.25, {ease: FlxEase.cubeOut});
			
		case 3345:
			camHUD.alpha = 1;
			camHUD.fade(FlxColor.BLACK, 0.01);
	}

}
var introc:Bool = true;
var focus:String = 'default';
var current_focus:String = '';
var cam_time:Float = 3;
var newZoom:Float = 0;
var bfCam:Array<Float> = [909, 516];
var dadCam:Array<Float> = [470, 462];
var gfCam:Array<Float> = [730, 462];
var mightyRotReal = false;
function onNoteHit(event:NoteHitEvent)
{
	if (mightyRotReal)
	{
		if (!event.player) { event.animSuffix = '-alt'; }
	}
}

// function onNoteHit(e) moveCameraOnNotes(e.character, e.direction);
// var characterDisplacementData:Array<Array<Float>> = [
//     //x  y //mighty
//     [-30, 0, //left
//     0, 30, //down
//     0, -30, //up
//     30, 0], // right

//     [-20, 0, //default (bf)
//     0, -20,
//     0, 20,
//     20, 0], 

//     [0, 0,
//     0, 0,
//     0, 0,
//     0, 0], // Z
// ];

// var characterlist:Array<Float>;
// var canMove = true;
// function getCharList(character) {
//     switch (character.curCharacter) {
//         case "mighty":
//             characterlist = mightyDisplacementData;
//         default:
//             characterlist = defaultDisplacementData;
//     }
// }
// var isDad:Bool = true;
// var displacement = new FlxPoint();
// public function moveCamera()
// {
//     var desiredPos:Null<FlxPoint> = null;
//     var curCharacter:Null<Character> = null;
//     isDad = curCameraTarget == 0 ? true : false;    
//     //shitty move cam code here
    
//     getCharList(curCharacter);    
//     camFollow.x += characterlist[0];
//     camFollow.y += characterlist[1];
    
//     //displacement.putWeak();

    
//     //desiredPos.put();
    
// }
// var mightyDisplacementData:Array<Float> = characterDisplacementData[0];
// var defaultDisplacementData:Array<Float> = characterDisplacementData[1];

// function moveCameraOnNotes(character, noteDirection) {
// 	trace(character.curCharacter);
//     getCharList(character);
//     if (!canMove) return;
//     canMove = false;
//     var _charPos = characterlist;
// 	if(curCameraTarget == 0){
//     switch (noteDirection % 4) {
//         case 0: camFollow.setPosition(dadCam[0] + _charPos[0][0], dadCam[1] + _charPos[0][1]);
//         case 1: camFollow.setPosition(dadCam[0] + _charPos[1][0], dadCam[1] + _charPos[1][1]);
//         case 2: camFollow.setPosition(dadCam[0] + _charPos[2][0], dadCam[1] + _charPos[2][1]);
//         case 3: camFollow.setPosition(dadCam[0] + _charPos[3][0], dadCam[1] + _charPos[3][1]);

//     }}
// 	else{
// 		switch (noteDirection % 4) {
// 		case 0: camFollow.setPosition(bfCam[0] + _charPos[0][0], bfCam[1] + _charPos[0][1]);
// 		case 1: camFollow.setPosition(bfCam[0] + _charPos[1][0], bfCam[1] + _charPos[1][1]);
// 		case 2: camFollow.setPosition(bfCam[0] + _charPos[2][0], bfCam[1] + _charPos[2][1]);
// 		case 3: camFollow.setPosition(bfCam[0] + _charPos[3][0], bfCam[1] + _charPos[3][1]);

// 	}}
// }
function onCameraMove(e) {
	if(intro) e.cancel();
	if(introc) e.cancel();
	switch(curCameraTarget){
		case 0:
			if(lockCamera) e.cancel();

			if(introc) FlxTween.cancelTweensOf(camFollow);
			if(introc) FlxTween.tween(camFollow, {x: dadCam[0], y: dadCam[1]}, cam_time, {ease: FlxEase.smoothStepOut});
			newZoom = 0.6;
			if(!introc && !lockCamera) camFollow.setPosition(dadCam[0], dadCam[1]);
		case 1:
			if(lockCamera) e.cancel();

			if(introc) FlxTween.cancelTweensOf(camFollow);
			if(introc) FlxTween.tween(camFollow, {x: bfCam[0], y: bfCam[1]}, cam_time, {ease: FlxEase.smoothStepOut});
			newZoom = 0.62;
			if(!introc && !lockCamera) camFollow.setPosition(bfCam[0], bfCam[1]);
		default:
			if(lockCamera) e.cancel();

			if(introc) FlxTween.cancelTweensOf(camFollow);
			if(introc) FlxTween.tween(camFollow, {x: gfCam[0], y: gfCam[1]}, cam_time, {ease: FlxEase.smoothStepOut});
			newZoom = 0.62;
			if(!introc && !lockCamera) camFollow.setPosition(gfCam[0], gfCam[1]);
	}
	if(introc) FlxTween.tween(PlayState.instance, {defaultCamZoom: newZoom}, cam_time, {ease: FlxEase.cubeInOut});
}

var hueval:Float = 0;
function snapCamToPos(x, y) {
	camFollow.setPosition(x, y);
	FlxG.camera.snapToTarget();
}
var camForceZoom:Bool = false;
var curSongPos:Float = 0;
function update(elapsed) {
	if(camForceZoom) PlayState.instance.camZooming = false;

	for(i in 0...4){
		if(PlayState.instance.strumLines.members[0].characters[i].visible == false){
			PlayState.instance.strumLines.members[0].characters[i].exists = false;
		}
		else{
			PlayState.instance.strumLines.members[0].characters[i].exists = true;
			PlayState.instance.strumLines.members[0].characters[i].shader = dad.shader;
		}
	}
	for(i in 0...3){
		if(PlayState.instance.strumLines.members[1].characters[i].visible == false){
			PlayState.instance.strumLines.members[1].characters[i].exists = false;
		}
		else{
			PlayState.instance.strumLines.members[1].characters[i].exists = true;
			PlayState.instance.strumLines.members[1].characters[i].shader = boyfriend.shader;
		}
	}
	for(i in 0...1){
		if(PlayState.instance.strumLines.members[2].characters[i].visible == false){
			PlayState.instance.strumLines.members[2].characters[i].exists = false;
		}
		else{
			PlayState.instance.strumLines.members[2].characters[i].exists = true;
			PlayState.instance.strumLines.members[2].characters[i].shader = gf.shader;
		}
	}

	if(fog2 != null) fog2.x += 0.2 +(snowStorm *0.2);
	if(fog1 != null) fog1.x += 0.1 +(snowStorm *0.3);
	if(Options.gameplayShaders) snow.time = (Conductor.songPosition / 1000);
	textevil.x = ((1280/2)-(textevil.width/2)) + iconY;

    if(Options.gameplayShaders) atotalElapsed += elapsed * -1;

    var displacementx = (0.6 * Math.sin(atotalElapsed * 55))*(elapsed*60);
    var displacementy = (0.6 * Math.sin(atotalElapsed * 55))*(elapsed*60);
    var displacementcam = (0.1 * Math.sin(atotalElapsed * 20))*(elapsed*60);

    switch (snowStorm) {
        case 0:

		case 1:
            //real part
            camGame.scroll.x = camGame.scroll.x + displacementx;
            camGame.scroll.y = camGame.scroll.y - displacementy;
            camGame.angle = displacementcam;
    }

	if (!Options.gameplayShaders || Options.lowMemoryMode) return;
	totalElapsed += elapsed;
	fogshader.iTime = totalElapsed;
	cloud_shader.iTime = totalElapsed;

}

function onGameOverStart() {
	GameOverSubstate.characterName = 'mobian_bf-dead';

	mighty_gameover = new FunkinSprite();
	mighty_gameover.frames = Paths.getSparrowAtlas('backgrounds/exe/zeph/try-harder/GAMEOVER_Mighty');
	mighty_gameover.animation.addByPrefix('idle', 'MightyGameOver', 44, true);
	mighty_gameover.animation.play('idle');
	mighty_gameover.scrollFactor.set(1, 1);
	mighty_gameover.scale.set(1.2, 1.2);
	mighty_gameover.antialiasing = true;
	GameOverSubstate.instance.add(mighty_gameover);

	mighty_gameover.alpha = 0;

	FlxTween.tween(FlxG.camera, {zoom: 0.6}, 1.3, {ease: FlxEase.quadOut});
}


function deathAnimStart() {
	mighty_gameover.setPosition(GameOverSubstate.instance.boyfriend.x - 110, GameOverSubstate.instance.boyfriend.y - 500);

	FlxTween.tween(mighty_gameover, {alpha: 1}, 1.2);
}

function onGameOverConfirm() {
	FlxTween.cancelTweensOf(mighty_gameover);
	FlxTween.tween(mighty_gameover, {alpha: 0}, 0.7);
}

function onGameOverPost() {
	GameOverSubstate.instance.camFollow.y -= 200;
}

function tweenColorThing(variable, value, time)
{
	FlxTween.num(colorcorrection.variable, value, time, {onUpdate: (t)->{
		colorcorrection.variable = t.value;
	}});
}