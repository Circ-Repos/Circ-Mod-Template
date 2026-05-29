import flixel.addons.effects.FlxTrail;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;

var __timer:Float = 0;
var trail:FlxTrail;
var trailPos = [];

function create()
{	
	knight = new FunkinSprite(0,0,Paths.image('roaring-knight'));
	knight.animation.addByPrefix('idle', 'roaringknight_idle', 1, true);
	knight.animation.addByPrefix('ball', 'roaringknight_ball_fly', 12, true);
	knight.animation.addByPrefix('hurt', 'roaringknight_hurt', 12, false);
	knight.animation.addByPrefix('ldown', 'roaringknight_look_down_full', 1, false);
	knight.animation.addByPrefix('appear', 'roaringknight_sword_appear', 12, false);
	knight.animation.addByPrefix('auraturn', 'roaringknight_faceaway_turning', 6, false);
	knight.animation.addByPrefix('aurafarm', 'roaringknight_faceaway_turning0000', 0, false);
	knight.animation.addByPrefix('swoon', 'roaringknight_attack_ol_center', 12, false);
	knight.animation.addByPrefix('front', 'roaringknight_front', 1, false);
	knight.animation.play('idle');
	knight.antialiasing = false;
	knight.updateHitbox();
	knight.screenCenter();
	knight.scale.set(3,3);
	add(knight);
	ogPlacement = [knight.x, knight.y];
	//new(target:FlxSprite, ?graphic:Null<FlxGraphicAsset>, length:Int = 10, delay:Int = 3, alpha:Float = 0.4, diff:Float = 0.05)
	trail = new FlxTrail(knight, null, 120, 15, 0.5, 0.08);
	insert(members.indexOf(knight), trail);
	trail.visible = true;
	trail.velocity.set(40,0);


	mathTextStatus = new FlxText(0, 0, 0, "Automatic Movement: " + usingtheMath);
	mathTextStatus.setFormat(Paths.font("VCR.ttf"), 16, FlxColor.WHITE, FlxTextAlign.LEFT);
	mathTextStatus.antialiasing = false;
	mathTextStatus.updateHitbox();
	mathTextStatus.scrollFactor.set();
	add(mathTextStatus);
}

var ogPlacement = [0, 0];
var doNotUpdate:Bool = false;
var ball:Bool = false;
var hurt:Bool = false;
var looking:Bool = false;
var frontlook:Bool = false;
var usingtheMath:Bool = true;
function postUpdate(elapsed:Float) {
	if(usingtheMath){
		final positions = Reflect.field(trail, "_recentPositions");
		final scales = Reflect.field(trail, "_recentScales");

		for (pos in positions) {
			if(!frontlook){
				pos.x += 320 * elapsed;
			}
		}
		for(scale in scales){
			if(frontlook){
				scale.x += 3.5 * elapsed;
				scale.y += 3.5 * elapsed;
			}
		}
	}
	mathTextStatus.text = 'Automatic Movement: ${usingtheMath}';
}
function destroy() {
	FlxG.drawFramerate = Options.framerate;
}
function defaultValues(){
	looking = false;
	frontlook = false;
	ball = false;
}
function update(elapsed:Float) {

    if(knight.animation.curAnim.finished){
		if(knight.animation.curAnim.name == 'hurt'){
			defaultValues();
			knight.animation.play('idle', true);
			knight.updateHitbox();
		}
    }

	if(usingtheMath){
		__timer += elapsed;
		knight.y = (300 + (50 * Math.cos(__timer)));
	}

	if(FlxG.keys.justPressed.ESCAPE){
		FlxG.switchState(new MainMenuState());
	}
	if(FlxG.keys.justPressed.SPACE){
		if(!ball){
			defaultValues();
			ball = true;
			knight.animation.play('ball', true);
			knight.updateHitbox();
		}
		else{
			ball = false;
			defaultValues();
			knight.animation.play('idle', true);
			knight.updateHitbox();

		}
	}

	if(FlxG.keys.justPressed.H){
		defaultValues();

		knight.animation.play('hurt', false);
			knight.updateHitbox();
	}

	if(FlxG.keys.justPressed.M){
		
		usingtheMath = !usingtheMath;
	}
	if(FlxG.keys.justPressed.A){
		defaultValues();

		knight.animation.play('appear', false);
			knight.updateHitbox();

	}
	if(FlxG.keys.justPressed.W){
		defaultValues();

		knight.animation.play('auraturn', false);
			knight.updateHitbox();

	}
	if(FlxG.keys.justPressed.E){
		defaultValues();

		knight.animation.play('aurafarm', false);
			knight.updateHitbox();

	}
	if(FlxG.keys.justPressed.S){
		defaultValues();

		knight.animation.play('swoon', false);
			knight.updateHitbox();

	}
	if(FlxG.keys.justPressed.L){
		if(!looking){
			looking = true;
			knight.animation.play('ldown', false);
			knight.updateHitbox();

		}
		else{
			defaultValues();

			looking = false;
			knight.animation.play('idle', false);
			knight.updateHitbox();

		}
	}
	if(FlxG.keys.justPressed.D){

		if(!looking){
			defaultValues();

			frontlook = true;
			knight.animation.play('front', false);
			knight.updateHitbox();

		}
		else{
			defaultValues();

			frontlook = false;
			knight.animation.play('idle', false);
			knight.updateHitbox();

		}
	}
	if(!doNotUpdate){
		ogPlacement = [FlxG.mouse.screenX - knight.x, FlxG.mouse.screenY - knight.y];
	}

	if(FlxG.mouse.overlaps(knight)){
		if(FlxG.mouse.pressed){
			usingtheMath = false;
			knight.setPosition(FlxG.mouse.screenX - ogPlacement[0], FlxG.mouse.screenY - ogPlacement[1]);
			doNotUpdate = true;
		}
		else{
			doNotUpdate = false;
			usingtheMath = true;
		}
	}
}