import hxvlc.flixel.FlxVideoSprite;

var vidCam:FlxCamera = new FlxCamera();
var deathVid:FlxVideoSprite = new FlxVideoSprite();

function create(e) {
    e.cancel();
    FlxG.cameras.add(vidCam, false);

    add(deathVid).load(Assets.getPath(Paths.file('videos/zipbombber.mkv')));
    deathVid.bitmap.onEndReached.add(() -> selectOption(true));
    deathVid.camera = vidCam;
    deathVid.play();
}

function update() {
    if (controls.ACCEPT || controls.BACK) selectOption(controls.ACCEPT);
}

function selectOption(retry:Bool) {
    FlxG.cameras.remove(vidCam);
    deathVid.destroy();
    FlxG.switchState(retry ? new PlayState() : new MainMenuState());
}