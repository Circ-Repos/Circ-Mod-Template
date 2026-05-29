import funkin.backend.MusicBeatState;
import hxvlc.flixel.FlxVideoSprite;

var ass:CustomShader;
var bloom:CustomShader;

var camVideo:FlxCamera = new FlxCamera();

var dore:FunkinSprite = new FunkinSprite(0, 0, Paths.image("the d o r e the door"));
var doorVid:FlxVideoSprite = new FlxVideoSprite();
var lyricVid:FlxVideoSprite = new FlxVideoSprite();
var bitchVid:FlxVideoSprite = new FlxVideoSprite();

var songcard:FunkinSprite = new FunkinSprite(0, 0, Paths.image("game/cards/shucks"));

introLength = 0;

MusicBeatState.skipTransIn = true;

var playerGhost:Character;
var dadGhost:Character;

var iconP3:HealthIcon = new HealthIcon("rose-shucks", true);

function create() {
    // if (FlxG.save.data.iridaSirvkoMode)
    //     vocals = FlxG.sound.load(Options.streamedVocals ? Assets.getMusic(Paths.voices(SONG.meta.name, "Sirvko")) : Paths.voices(SONG.meta.name, "Sirvko"));

    // insert(25, playerGhost = new Character(0, 0, 'marvin-shucks', false)).scale.set(1.1, 1.1);
    // playerGhost.setPosition(strumLines.members[1].characters[1].x + 445, strumLines.members[1].characters[1].y + 1090);
    // playerGhost.skew.x = 40;

    // insert(25, dadGhost = new Character(0, 0, 'detg', false)).scale.set(1.1, 1.1);
    // dadGhost.skew.x = -40;
    // dadGhost.setPosition(strumLines.members[0].characters[1].x - 850, strumLines.members[0].characters[1].y + 2224);

    // playerGhost.angle = dadGhost.angle = 180;
    // playerGhost.flipX = dadGhost.flipX = true;
    // playerGhost.alpha = dadGhost.alpha = 0;
}

function postCreate() {
    insert(0, songcard).camera = camHUD;
    songcard.antialiasing = Options.antialiasing;
    songcard.screenCenter();
    songcard.scrollFactor.set();
    songcard.alpha = songcard.zoomFactor = 0;
}

function postPostCreate() {
    FlxG.cameras.insert(camVideo, 1, false).bgColor = FlxColor.TRANSPARENT;

    // camera shit

    strumLines.members[2].characters[0].cameraOffset.set(900, 500);

    iconP1.setIcon("marvin-shucks-shadow");
    iconP2.setIcon("detg-shadow", 200, 150);

    iconP3.bump = () -> iconP3.scale.set(1, 1);
    iconP3.updateBump = () -> iconP3.scale.set(CoolUtil.fpsLerp(iconP3.scale.x, 0.8, 0.11), CoolUtil.fpsLerp(iconP3.scale.y, 0.8, 0.11));
    iconP3.alpha = 0;
    iconP3.camera = camHUD;
    iconP3.scrollFactor.set(1, 1);
    iconArray.push(iconP3);
    insert(members.indexOf(iconP1) + 1, iconP3).setPosition(1175, iconP2.y + (iconP3.camera.downscroll ? -30 : 15));
}

function postUpdate() {

    // if (playerGhost.alpha != 0) {
    //     playerGhost.playAnim(strumLines.members[1].characters[1].getAnimName(), true);
    //     playerGhost.set_globalCurFrame(strumLines.members[1].characters[1].get_globalCurFrame());
    //     playerGhost.animateAtlas.colorTransform.color = FlxColor.BLACK;
    // }

    // if (dadGhost.alpha != 0) {
    //     dadGhost.playAnim(strumLines.members[0].characters[1].getAnimName(), true);
    //     dadGhost.set_globalCurFrame(strumLines.members[0].characters[1].get_globalCurFrame());
    //     dadGhost.animateAtlas.colorTransform.color = FlxColor.BLACK;
    // }

    if (iconP3.alpha != 0 && curStep < 2384) iconP3.health = iconP1.health;
}

var roseLooking:Int;
function onCameraMove() {
    if (roseLooking != curCameraTarget) {
        roseLooking = curCameraTarget;
        strumLines.members[2].characters[0].idleSuffix = curCameraTarget == 1 ? "right" : "left";
        strumLines.members[2].characters[0].playAnim("look-" + strumLines.members[2].characters[0].idleSuffix);
    }
}

// function onStrumCreation(e)
//     e.sprite = "game/notes/shadow";

// function onNoteCreation(e)
//     if (e.note.strumTime <= Conductor.stepCrochet * 460) {
//         e.note.splash = "shadow";
//         e.noteSprite = "game/notes/shadow";
//     }

function flicker(cam:FlxCamera, d:Float, i:Float) {
    cam.visible = !cam.visible;
    lol = new FlxTimer().start(i, () -> {
        cam.visible = !cam.visible;
        if (lol.loopsLeft == 0) cam.visible = true;
    }, Std.int(d / i));
    }
