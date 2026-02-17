// import funkin.game.shaders.HSLColorSwap;
// import openfl.filters.ShaderFilter;
// import funkin.backend.Conductor;
// import funkin.objects.Bopper;

var evilness:FlxSprite;
var blackFG:FlxSprite;

var totalElapsed:Float = 0;
//var colorcorrection = newShader('colorcorrection');
//var introcc = newShader('colorcorrection');

//var fogshader = newShader('fog epic');
//var cloud_shader = newShader('cloud');
var cooleffect:FlxSprite;
var fogtuah:FlxSprite;
//var melt = newShader('melt');

//var snow = newShader('snowfall');

// var intro:Bool = false;
var intro = true;
var intro_camera:Bool = false;
var pov = false;

var snowStorm:Float = 0;

var bg;
var ice;
var fog;
var snow3;
var ground;
var snow2;
var evilness;
var snow1;
var fgIce;
var blackFG;
var orgh;
var fog1;
var fog2;

var bust;
var snowAtlas;

function makeSpr(x, y, name, folder) {
	var sprite = new FlxSprite(x, y);
	sprite.setFrames(Paths.getSparrowAtlas('backgrounds/exe/zeph/try-harder/' + folder));
	sprite.animation.addByPrefix(name, name, 24, false);
	sprite.animation.play(name);
	add(sprite);
	return sprite;
}

function create() {
	// if (Options.shaders) {
	// 	colorcorrection.setFloat('brightness', 0.0);
	// 	colorcorrection.setFloat('contrast', 1.35);
	// 	colorcorrection.setFloat('saturation', 0.40);
	// 	colorcorrection.setFloat('customred', 0.1);
	// 	colorcorrection.setFloat('customgreen', 0.1);
	// 	colorcorrection.setFloat('customblue', 0.15);

	// 	camGame.addShader(colorcorrection);
	// 	camHUD.addShader(colorcorrection);

	// 	fogshader.setFloat('cloudDensity', 0.85);
	// 	fogshader.setFloat('noisiness', 0.4);
	// 	fogshader.setFloat('speed', 0.03);
	// 	fogshader.setFloat('cloudHeight', 3.5);
	// 	fogshader.setFloat('customred', 0.6);
	// 	fogshader.setFloat('customgreen', 0.6);
	// 	fogshader.setFloat('customblue', 0.5);

	// 	cooleffect = new FlxSprite(-830, -350).makeGraphic(3180, 1720, FlxColor.RED);
	// 	cooleffect.scrollFactor.set(2, 2);
	// 	cooleffect.zIndex = 998;
	// 	cooleffect.angle = 180;
	// 	cooleffect.shader = fogshader;
	// 	cooleffect.blend = BlendMode.ADD;
	// 	cooleffect.zIndex = 20;
	// 	cooleffect.antialiasing = true;
		
	// 	snow.setInt('amount', 0);
	// 	snow.setFloat('intensity', 0.325);
	// }

	var bg:FlxSprite = makeSpr(-900, -1100, 'background ladders', 'try-harder-1');
	bg.zIndex = -15;
	bg.scrollFactor.set(0.42, 0.65);

	var ice:FlxSprite = makeSpr(-121, -345, 'icicles background', 'try-harder-1');
	ice.zIndex = -10;
	ice.scrollFactor.set(0.75, 1);

	var fog:FlxSprite = makeSpr(-590, -36, 'poop', 'try-harder-1');
	fog.scrollFactor.set(0.6, 0.9);
	fog.zIndex = -5;

	var ground:FlxSprite = makeSpr(-666, 96, 'main stage', 'try-harder-1');
	ground.scrollFactor.set(1, 1);
	ground.zIndex = -1;

	evilness = makeSpr(ground.x + 325, ground.y, 'spoopy main stage', 'try-harder-1');
	evilness.scrollFactor.set(1, 1);
	evilness.zIndex = 0;
	evilness.visible = false;

	if(!Options.lowQuality){
		snow1 = makeSpr(-675,85,'snow1','snow');
		snow1.zIndex  = 4;
		snow2 = makeSpr(1350,500,'snow2','snow');
		snow3 = makeSpr(-900,400,'snow3','snow');

	}


	fgIce = makeSpr( -570, -500, 'icicles foreground', 'try-harder-1');
	fgIce.scrollFactor.set(2, 2);
	fgIce.zIndex = 50;

	blackFG = new FlxSprite(-800, -400).makeGraphic(FlxG.width * 3, FlxG.height * 2.2, FlxColor.BLACK);
	blackFG.scrollFactor.set(0, 0);
	blackFG.alpha = intro ? 1 : 0;
	blackFG.zIndex = 999;
	blackFG.camera = camOther;

	orgh = makeSpr(-620, -400, 'orgh', 'try-harder-1');
	orgh.scrollFactor.set(1, 0.1);
	orgh.scale.set(2.2,2.2);
	orgh.updateHitbox();
	orgh.visible = true;
	orgh.zIndex = 998;

	fog1 = new FlxSprite(-200, 100);
	fog1.loadGraphic(Paths.image("backgrounds/exe/zeph/try-harder/fog1"));
	fog1.scrollFactor.set(1.3, 1);
	fog1.setGraphicSize(Std.int(fog1.width * 1.4));
	fog1.zIndex = 10;
	fog1.alpha = 0;

	fog2 = new FlxSprite(-1200, -350);
	fog2.loadGraphic(Paths.image("backgrounds/exe/zeph/try-harder/fog2"));
	fog2.scrollFactor.set(0.5, 0.5);
	fog2.scale.set(1.5,1);
	fog2.zIndex = -10;
	fog2.alpha = 0;

	if(!Options.lowQuality){
		snowAtlas = new Bopper(-250, -150);
		snowAtlas.loadAtlas("backgrounds/exe/zeph/try-harder/Snow");
		snowAtlas.addAnimByPrefix('Idle', 'SnowFall', 40, true);
		snowAtlas.playAnim('Idle');
		snowAtlas.scale.set(1.8,1.8);
		snowAtlas.scrollFactor.set(1.5, 1.5);
		snowAtlas.zIndex = 50;
		snowAtlas.alpha =0;
		add(snowAtlas);

		if (Options.shaders)
			add(cooleffect);


		if (Options.shaders) {
			cloud_shader.setFloat('red_amt', 0.1);
			cloud_shader.setFloat('green_amt', 0.17);
			cloud_shader.setFloat('blue_amt', 0.3);

			fogtuah = new FlxSprite(-750, -300).makeGraphic(3680, 2920, FlxColor.RED);
			fogtuah.scrollFactor.set(0.7, 0.7);
			fogtuah.zIndex = -5;
			fogtuah.shader = cloud_shader;
			fogtuah.blend = BlendMode.ADD;
			fogtuah.antialiasing = true;
			add(fogtuah);
		}

	}
	

	for (item in [bg, ice, fog, snow3, ground, snow2, evilness, snow1, fgIce, blackFG, orgh,fog1, fog2]) {
		if(item != null){
			item.antialiasing = true;
			add(item);
		}
	}

	p1 = [bg, ice, fog, ground, evilness, fgIce, orgh, fog1, fog2];

	bg2 = makeSpr(-1280,-720,'bg','try-harder-2');
	bg2.scrollFactor.set(0.1, 0.1);
	add(bg2);

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
	icefront.zIndex = 999;
	icefront.alpha = 0.8;
	add(icefront);

	for(i in [snow1,snow2,snow3]){
		if(i != null)		
			i.visible = false;
	}
	
	p2 = [bg2, iceback, plat, floor, icefront];
	for(i in p2) i.visible = false;
}

function onCreatePost() {
	initScript('data/scripts/NoteWarning');

	if(!Options.lowQuality){
		if (Options.shaders) {
			introcc.setFloat('brightness', 0.0);
			introcc.setFloat('contrast', 0.8);
			introcc.setFloat('saturation', 0.80);
			introcc.setFloat('customred', 0.0);
			introcc.setFloat('customgreen', 0.0);
			introcc.setFloat('customblue', 0.0);

			dad.shader = introcc;
			boyfriend.shader = introcc;
			gf.shader = introcc;
		}

		bust = new FlxSprite().setFrames(Paths.getSparrowAtlas('characters/BF/wolf/im boutta nust'));
		bust.animation.addByPrefix('idle', 'fucking', 25, true);
		bust.animation.play('idle');
		bust.setPosition(FlxG.width - (bust.width * 0.8), FlxG.height - (bust.height * 0.8));
		bust.camera = camHUD;
		bust.y += bust.height;
		bust.blend = BlendMode.ADD;
		bust.zIndex = 0;
		stage.add(bust);

		boyfriendGroup.zIndex = 2;
		refreshZ(stage);
	}
	
	addCharacterToList('mobian_bf_firstperson', 0);
	addCharacterToList('zeph_firstperson', 1);
	addCharacterToList('zeph_rot', 1);
	addCharacterToList('zeph_rotREAL', 1);
	addCharacterToList('zephRHYME', 1);
	if(!Options.lowQuality){
		addCharacterToList('mobian_bf_COLD', 0);
		addCharacterToList('mobian_gf_COLD', 2);

	}

	modManager.queueEase(1648, 1672, "alpha", 1, FlxEase.linear, 0);
	modManager.queueEase(1888, 1904, "alpha", 0, FlxEase.linear, 0);
	modManager.queueEase(1888, 1904, "alpha", 0, FlxEase.linear, 1);

	if (!intro) {
		defaultCamZoom = 0.6;
		changeCharacter('zeph', 1);
		triggerEventNote('BlackOut', 'false', '');
		
		return;
	}

	isCameraOnForcedPos = true;
	camFollow.setPosition(730, 100);
	FlxG.camera.snapToTarget();

	camGame.zoom = 1.5;

	camHUD.alpha = 0;

	skipCountdown = true;

	var poop = [playHUD.scoreTxt];
	if(Options.timeBarType != 'Disabled'){
		poop.push(playHUD.timeBar);
		poop.push(playHUD.timeTxt);
	}
	for (m in poop)
		m.visible = false;

	FlxTimer.wait(0.4, ()->{
		onEvent('intro', '', '');
	});
}

var current_focus:String = '';
var cam_time:Float = 3;
var newZoom:Float = 0;

function onSectionHit() {
	var play = PlayState.SONG.notes[curSection].mustHitSection;

	onMoveCamera(play ? 'boyfriend' : 'dad');
}

function onMoveCamera(focus) {
	if (focus != current_focus && intro_camera && isCameraOnForcedPos) {
		current_focus = focus;
		switch (focus) {
			case 'dad':
				FlxTween.tween(camFollow, {x: 470, y: 462}, cam_time, {ease: FlxEase.smoothStepOut});
				newZoom = 0.6;

			default:
				FlxTween.tween(camFollow, {x: 909, y: 516}, cam_time, {ease: FlxEase.smoothStepOut});
				newZoom = 0.62;
		}

		FlxTween.tween(game, {defaultCamZoom: newZoom}, cam_time, {ease: FlxEase.cubeInOut});
	}
}

var hueval:Float = 0;

function onUpdate(elapsed) {
	if (!Options.shaders || Options.lowQuality)
		return;

	totalElapsed += elapsed;
	fogshader.setFloat('iTime', totalElapsed);
	cloud_shader.setFloat('iTime', totalElapsed);
	fog2.x += 0.2 +(snowStorm *0.2);
	fog1.x += 0.1 +(snowStorm *0.3);
	snow.setFloat('time', (Conductor.songPosition / 1000));
}

function onEvent(eventName, value1, value2) {
	switch (eventName) {
		case 'intro':
			var tweenTime:Float = 17;
			if(intro)
				FlxTween.tween(camGame, {zoom: defaultCamZoom}, tweenTime, {ease: FlxEase.cubeInOut});
			FlxTween.tween(blackFG, {alpha: 0.1}, tweenTime);
			FlxTween.tween(camFollow, {y: 450}, tweenTime, {ease: FlxEase.smoothStepOut});	
		case 'Change Character':
			if(value1 == '1' && value2 == 'zeph')
			{
				dad.onAnimationFrameChange.add((name,frame,index)->{
					switch(name)
					{
						case 'idle':
							boyfriend.visible = true;
						case 'Grab':
							switch(frame){
								case 0:
									isCameraOnForcedPos = true;
									camFollow.x = dad.x+560;
									camFollow.y = dad.y+200;
									defaultCamZoom = 0.7;
								case 33:
									boyfriend.visible = false;
									callNoteTypeScript('Ice Note', 'forcebreak', []);
							}
					}
				});
			}
		case 'BlackOut':
			switch (value1) {
				case 'true':
					if(intro)
						FlxTween.tween(blackFG, {alpha: 1}, 0.9);

				case 'false':
					var poop = [playHUD.scoreTxt];
					if(Options.timeBarType != 'Disabled'){
						poop.push(playHUD.timeBar);
						poop.push(playHUD.timeTxt);
					}
					for (m in poop)
						m.visible = true;

					intro_camera = false;
					camHUD.flash();
					evilness.visible = true;
					blackFG.alpha = 0;

					isCameraOnForcedPos = false;
					if(!Options.lowQuality && Options.shaders){
						camGame.removeShader(colorcorrection);
						camHUD.removeShader(colorcorrection);
						orgh.visible = false;
						dad.shader = null;
						boyfriend.shader = null;
						gf.shader = null;
						orgh.alpha = 0;
					}
			}
		case 'Try Harder':
			switch (value1.toLowerCase()) {
				case 'cam on zeph':
					if (!intro)
					return;

					intro_camera = true;
					onMoveCamera('dad');

				case 'hud fade in':
					FlxTween.tween(camHUD, {alpha: 1}, 0.8);

				case 'grab intro':
					isCameraOnForcedPos = true;

					FlxTween.tween(camFollow, {y: getCharacterCameraPos(dad).y + 900}, 0.9, {ease: FlxEase.circIn});
					FlxTween.tween(blackFG, {alpha: 1}, 0.5);

					FlxTween.tween(blackFG, {alpha: 0}, 0.5, {startDelay: 0.5125});
					FlxTimer.wait(0.5, ()->{
						pov = true;
						gf.visible = false;
						icefront.y -= 250;
						icefront.alpha = 0;
						FlxTween.tween(icefront, {alpha: 0.8, y: icefront.y + 250}, 2.5, {ease: FlxEase.quadOut});
						for(i in p1) i.visible = false;
						for(i in p2) i.visible = true;

						changeCharacter('zeph_firstperson', 1);
						changeCharacter('mobian_bf_firstperson', 0);
						boyfriend.visible = false;

						FlxTween.cancelTweensOf(camFollow);
						snapCamToPos(getCharacterCameraPos(dad).x, getCharacterCameraPos(dad).y - 500);
						FlxTween.tween(camFollow, {y: getCharacterCameraPos(dad).y}, 0.5, {ease: FlxEase.circOut, onComplete: ()->{
							isCameraOnForcedPos = false;
							boyfriendGroup.camera = camHUD;
							boyfriendCameraOffset = [-335,-200];
							boyfriend.visible = true;
							boyfriend.y += boyfriend.height;
							FlxTween.tween(boyfriend, {y: boyfriend.y - boyfriend.height}, 1, {ease: FlxEase.circOut});			
							if(bust != null)
								FlxTween.tween(bust, {y: (FlxG.height - (bust.height * 0.8))}, 1, {ease: FlxEase.circOut});		
						}});
					});

				case 'grab end':
					isCameraOnForcedPos = true;
					FlxTween.tween(boyfriend, {y: boyfriend.y + boyfriend.height}, 1, {ease: FlxEase.circIn});
					
					if(bust != null)
						FlxTween.tween(bust, {y: (FlxG.height)}, 1, {ease: FlxEase.circIn});		

					FlxTween.tween(camFollow, {y: getCharacterCameraPos(dad).y - 900}, 0.8, {ease: FlxEase.circIn});
					FlxTween.tween(icefront, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});

					FlxTween.tween(blackFG, {alpha: 1}, 0.675);

					FlxTween.tween(blackFG, {alpha: 0}, 1, {startDelay: 1});
					FlxTimer.wait(1, ()->{
						pov = false;
						gf.visible = true;
						changeCharacter('zeph', 1);
						changeCharacter('mobian_bf', 0);
						FlxTween.cancelTweensOf(boyfriend);
						boyfriend.x = 900;
						boyfriend.y = 404;
						boyfriend.visible = true;
						for(i in p1) i.visible = true;
						for(i in p2) i.visible = false;
							
						fgIce.y -= 500;
						FlxTween.tween(fgIce, {y: fgIce.y + 500}, 1.4, {ease: FlxEase.quadOut});

						boyfriendGroup.camera = camGame;

						FlxTween.cancelTweensOf(camFollow);
						snapCamToPos(getCharacterCameraPos(dad).x, getCharacterCameraPos(dad).y - 500);
						FlxTween.tween(camFollow, {y: getCharacterCameraPos(dad).y}, 0.5, {ease: FlxEase.circOut, onComplete: ()->{
							isCameraOnForcedPos = false;
							boyfriendCameraOffset = [0,0];
						}});
					});

				case 'text 1':
					changeCharacter('zephRHYME', 1);

					if(Options.lowQuality) return;

					colorcorrection.setFloat('customred', 0.125);
					colorcorrection.setFloat('customgreen', 0.145);
					colorcorrection.setFloat('customblue', 0.20);
					colorcorrection.setFloat('saturation', 0.40);
					colorcorrection.setFloat('brightness', -0.2);
					colorcorrection.setFloat('contrast', 1.0);

					camGame.addShader(colorcorrection);
					camHUD.addShader(colorcorrection);

				case 'text 3':
					if(Options.lowQuality) return;

					changeCharacter('mobian_bf_COLD', 0);
					changeCharacter('mobian_gf_COLD', 2);

                case 'text 4':
					triggerEventNote('Camera Follow Pos', '450', '490');

					fog1.x = -250;
					fog2.x = -564;
					fog1.alpha = 1;
					fog2.alpha = 1;

					dad.playAnim("rhyme",true);
					dad.specialAnim = true;

				case 'transition tuah':
					if(snowAtlas != null)
						FlxTween.tween(snowAtlas, {alpha: 1}, 0.25, {ease: FlxEase.cubeOut});
					snowStorm = 1;
					isCameraOnForcedPos = false;
					changeCharacter('zeph', 1);
					
				case 'screen melt':
					isCameraOnForcedPos = true;

					for(i in [gf, dad, boyfriend]){
						i.pauseAnim();
						i.canDance = false;
					}
					if(snowAtlas != null) snowAtlas.pauseAnim();
					camZoomingMult = 0;

					FlxTween.tween(blackFG, {alpha: 1}, 3, {startDelay: 0.75});

					if(Options.shaders && !Options.lowQuality)
					{
						melt.setFloat('iTime', 0);
						camGame.addShader(melt);
						camHUD.addShader(melt);
						FlxTween.num(0, 0.75, 4, {onUpdate: (t)->{
							melt.setFloat('iTime', t.value);
						}});
					}

				case 'ending intro':
					for(i in [snow1,snow2,snow3]){
						if(i != null)						
							i.visible = true;
					}

					for(i in [gf, dad, boyfriend]){
						i.canDance = true;
						i.dance();
					}

					if(snowAtlas != null)
						snowAtlas.visible = false;
	
					snowStorm = 0;

					camZoomingMult = 1;
					FlxTween.tween(blackFG, {alpha: 0}, 10, {ease: FlxEase.quadIn});
					camGame.removeShader(colorcorrection);
					camHUD.removeShader(colorcorrection);
					fog1.alpha = 0;
					fog2.alpha = 0;
	
					if(orgh != null)
						orgh.alpha = 1;
	
					changeCharacter('zeph_rot', 1);
					
					defaultCamZoom = 1.6;
					FlxTween.tween(PlayState.instance, {defaultCamZoom: 0.7}, 8, {ease: FlxEase.quadInOut, onComplete: ()->{
						isCameraOnForcedPos = false;
					}});
					snapCamToPos(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y, true);
					FlxTween.tween(camHUD, {alpha: 1}, 2, {startDelay: 3});

					if(Options.lowQuality) return;

					if(Options.shaders)
					{
						melt.setFloat('iTime', 0);
						camGame.removeShader(melt);

						camGame.addShader(snow);
						snow.setInt('amount', 30);

						colorcorrection.setFloat('customred', 0.18);
						colorcorrection.setFloat('customgreen', 0.125);
						colorcorrection.setFloat('customblue', 0.20);
						colorcorrection.setFloat('saturation', 0.20);
						colorcorrection.setFloat('brightness', -0.2);
						colorcorrection.setFloat('contrast', 1.0);
						camGame.addShader(colorcorrection);
					}
						
			case 'ending get real':
					changeCharacter('zeph_rotREAL', 1);
					defaultCamZoom = 0.55;
					
					if(Options.lowQuality) return;

					tweenColorThing('saturation', 0.4, 2);
					tweenColorThing('brightness', -0.15, 2);
					tweenColorThing('contrast', 1.2, 2);

	        case 'almost ending':
					isCameraOnForcedPos = true;
					camFollow.x = dad.x+460;
					camFollow.y = dad.y+200;
                    FlxTween.tween(game,{defaultCamZoom:1.1}, 5, {ease:FlxEase.quadIn});
					FlxTween.tween(camHUD, {alpha: 0}, 3.5, {ease:FlxEase.quadIn});
            case 'song end':
					camHUD.alpha = 1;
                    camHUD.fade(FlxColor.BLACK, 0.01);
			}
	}
}

function onGameOverStart() {
	GameOverSubstate.characterName = 'mobian_bf-dead';

	mighty_gameover = new FlxSprite();
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
	FlxTween.num(colorcorrection.getFloat(variable), value, time, {onUpdate: (t)->{
		colorcorrection.setFloat(variable, t.value);
	}});
}