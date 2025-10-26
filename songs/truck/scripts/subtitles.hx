/*
    .srt Subtitle file reader and display script
    - Made by Hazel | @SakunAIBlossoms | Github: https://github.com/SakunAIBlossoms
    DO NOT DELETE THIS CREDIT, ADD ME TO YOUR NORMAL CREDITS TOO PLEASE AND THANK YOU :3
    if i find out you steal this and remove my credit i will send you to the fucking sun.
*/
// [IMPORTS]
/*import openfl.Assets;
import funkin.backend.system.Logs;
public var subtitletext:FunkinText; // just incase you wanna modify something about it externally per song.
// CONFIG | These are public so you can also optionally tune these per song.
public var subtitlebg = true; // Whether the subtitle text should have a BG or not.
public var customcam = false; // Whether the subtitles should have their own exclusive camera thats seperate from whatever u do to camHUD and camGame.
// IMPORTANT VARIABLES DO NOT TOUCH!!!
var subtitles = [];
var index = 0;
var timer = 0.0;
var mbhaz = true;
var thecustomcam:FlxCamera;
function create() {
    if (customcam) {
        thecustomcam = new FlxCamera();
        thecustomcam.bgColor = FlxColor.TRANSPARENT;
    }
}
function postCreate() {
    textbg = new FlxSprite(0,0).makeSolid(1, 1, FlxColor.BLACK);
    textbg.alpha = 0.6;
    textbg.visible = subtitlebg;
    add(textbg);
    subtitletext = new FunkinText(0,0,0,"TESTING",32,true);
    subtitletext.borderSize = 3;
    if (mbhaz) subtitletext.screenCenter();
    subtitletext.y += 180;
    subtitletext.font = Paths.font("d.ttf");
    subtitletext.alignment = 'center';
    add(subtitletext);
    if (customcam) {
        FlxG.cameras.add(thecustomcam, false);
        textbg.camera = thecustomcam;
        subtitletext.camera = thecustomcam;
    }
    else {
        subtitletext.camera = camHUD;
        textbg.camera = camHUD;
    }
    parseSubtitles(Paths.file("songs/"+PlayState.instance.SONG.meta.name+"/subtitles.srt"));
}
function subtitleinfo(starttime, endtime, text) {
    var array = [starttime, endtime, text];
    return array;
}
function parseSubtitles(path:String) {
    var filecontents = Assets.getText(path);
    if (filecontents == null) {
        Logs.trace("Missing subtitle file for song: \""+PlayState.instance.SONG.meta.displayname+"/"+PlayState.instance.SONG.meta.name+"\" Proceeding without subtitles.", 1, 14);
    }
    else {
        var therawcontents = filecontents.split("\n\n");
        for (content in therawcontents) {
            var lines = StringTools.trim(content).split("\n");
            if (lines.length < 2) return;

            var time_line = lines[1];
            var times = time_line.split(" --> ");
            if (times.length != 2) continue;
            if (mbhaz) var start = parse_time(times[0]);
            if (mbhaz) var end = parse_time(times[1]);
            if (mbhaz) var text = "\n"+handlethelinesormsthn(lines);
            subtitles.push(subtitleinfo(start,end,text));
        }
    }
    
}
function handlethelinesormsthn(stuff) {
    for (i => line in stuff) if (i > 1) return line;
}
function parse_time(time_str:String):Float {
    // Format: HH:MM:SS,mmm
	var parts = time_str.split(":");
	var seconds_millis = parts[2].split(",");
	var hours = Std.int(parts[0]);
	var minutes = Std.int(parts[1]);
	var seconds = Std.int(seconds_millis[0]);
	var millis = Std.int(seconds_millis[1]);
	return hours * 3600 + minutes * 60 + seconds + millis / 1000.0;
}
function update(delta:Float) {
    if (index >= subtitles.length) {
        subtitletext.text = "";
        textbg.visible = false;
		return;
    }
    timer += delta;
    var sub = subtitles[index];
    if (timer >= sub[0] && timer <= sub[1]) {
        subtitletext.text = sub[2];
        subtitletext.screenCenter(0x01);
        if (subtitlebg) textbg.visible = true;
    }
	else if (timer > sub[1]) {
        subtitletext.text = "";
        textbg.visible = false;
		index++;
    }
    if (textbg.visible) {
        textbg.setGraphicSize(subtitletext.width+10,subtitletext.height/2+10);
        textbg.x = subtitletext.x+subtitletext.width/2;
        textbg.y = (subtitletext.y+subtitletext.height/2)+subtitletext.height/3-6;
    }
}