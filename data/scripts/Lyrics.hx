import haxe.Json;
import funkin.backend.system.Conductor;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;

var songName = PlayState.SONG.meta.name;
function loadJson() {
	var rawJson = '{
	"stuff": [
	{"lyric": "HOW DO YOU LIKE MY GAME OF HIDE AND SEEK?", "timestamp": 1728, "color": "0xFFFFFF"},
	{"lyric": "ITS THE CULMINATION OF THE MAN YOU USED TO BE.", "timestamp": 1744, "color": "0xFFFFFF"},
	{"lyric": "WHO USED TO BELIEVE...", "timestamp": 1770, "color": "0xFFFFFF"},
	{"lyric": "TRICKS GROWING OLD", "timestamp": 1792, "color": "0xFFFFFF"},
	{"lyric": "MEMORIES FROM LONG BEFORE", "timestamp": 1798, "color": "0xFFFFFF"},
	{"lyric": "WONT YOU TELL ME TRULY", "timestamp": 1808, "color": "0xFFFFFF"},
	{"lyric": "DID YOU LIKE WHAT I HAD IN STORE?", "timestamp": 1814, "color": "0xFFFFFF"},
	{"lyric": "OR DID YOU WANT MORE?", "timestamp": 1834, "color": "0xFFFFFF"},
	{"lyric": "TIMES", "timestamp": 1856, "color": "0xFF2800"},
	{"lyric": "ARE CHANGING", "timestamp": 1868, "color": "0xFFFFFF"},
	{"lyric": "RE-", "timestamp": 1888, "color": "0xFFFFFF"},
	{"lyric": "RE-ARR-", "timestamp": 1900, "color": "0xFFFFFF"},
	{"lyric": "RE-ARRANGING", "timestamp": 1904, "color": "0xFFFFFF"},
	{"lyric": "IF", "timestamp": 1920, "color": "0xFFFFFF"},
	{"lyric": "IF YOU", "timestamp": 1926, "color": "0xFFFFFF"},
	{"lyric": "IF YOU LOOK", "timestamp": 1932, "color": "0xFFFFFF"},
	{"lyric": "IF YOU LOOK BACK", "timestamp": 1936, "color": "0xFF2800"},
	{"lyric": "BATHED", "timestamp": 1942.5, "color": "0xFFFFFF"},
	{"lyric": "BATHED IN", "timestamp": 1948, "color": "0xFFFFFF"},
	{"lyric": "BATHED IN BLACK", "timestamp": 1952, "color": "0X473E3D"},
	{"lyric": "ARE YOU AGING?", "timestamp": 1958, "color": "0xFFFFFF"},
	{"lyric": "AND WHEN I SEE YOU", "timestamp": 1988, "color": "0xFFFFFF"},
	{"lyric": "YOURE STILL", "timestamp": 2008, "color": "0xFFFFFF"},
	{"lyric": "GRASPING FOR DEAR LIFE", "timestamp": 2016, "color": "0xFFFFFF"},
	{"lyric": "DO YOU THINK YOURE SMARTER?", "timestamp": 2046, "color": "0xFFFFFF"},
	{"lyric": "SUCH A MARTYR", "timestamp": 2056, "color": "0xFFFFFF"},
	{"lyric": "JUST", "timestamp": 2064, "color": "0xFFFFFF"},
	{"lyric": "LOOK IN THE MIRROR", "timestamp": 2068, "color": "0xFFFFFF"},
	{"lyric": "YOURE", "timestamp": 2076, "color": "0xFFFFFF"},
	{"lyric": "STILL", "timestamp": 2080, "color": "0xFFC5C2"},
	{"lyric": "LIVING THAT", "timestamp": 2086, "color": "0xFF6C66"},
	{"lyric": "LIE.", "timestamp": 2096, "color": "0xFF2800"},
	{"lyric": "OH, ILL-", "timestamp": 2108, "color": "0xFFFFFF"},
	{"lyric": "COME AND FIND YOU", "timestamp": 2112, "color": "0xFFFFFF"},
	{"lyric": "RIGHT BEHIND YOU", "timestamp": 2120, "color": "0xFFFFFF"},
	{"lyric": "TAKE YOUR FAITH", "timestamp": 2128, "color": "0xFFFFFF"},
	{"lyric": "AND LET IT BLIND YOU", "timestamp": 2134.5, "color": "0xFFFFFF"},
	{"lyric": "THEN WELL DANCE OUR LAST", "timestamp": 2144, "color": "0xFFFFFF"},
	{"lyric": "ONE FINAL BOUT", "timestamp": 2164, "color": "0xFFFFFF"},
	{"lyric": "A TOAST, TO THE PAST", "timestamp": 2180, "color": "0xFFFFFF"},
	{"lyric": "THAT ENDS IN", "timestamp": 2196, "color": "0xFFFFFF"},
	{"lyric": "DROUGHT...", "timestamp": 2206, "color": "0xFF2800"},
	{"lyric": "NO DOUBT...", "timestamp": 2220, "color": "0xFF2800"},
	{"lyric": "ALL TOGETHER NOW!", "timestamp": 2233, "color": "0xFFFFFF"},
	{"lyric": "", "timestamp": 2247, "color": "0xFFFFFF"},
	{"lyric": "ONCE YOURE SURROUNDED IN DESPAIR...", "timestamp": 2258, "color": "0xFFFFFF"},
	{"lyric": "JUST CLOSE YOUR EYES AND ILL BE THERE.", "timestamp": 2290, "color": "0xFFFFFF"},
	{"lyric": "NO, DONT YOU STRUGGLE, DONT YOU FIGHT..", "timestamp": 2322, "color": "0xFFFFFF"},
	{"lyric": "AS I BID YOU", "timestamp": 2348, "color": "0xFFFFFF"},
	{"lyric": "AS I BID YOU YOUR LAST", "timestamp": 2358, "color": "0xFFFFFF"},
	{"lyric": "GOOD-", "timestamp": 2364.7, "color": "0xFFFFFF"},
	{"lyric": "GOODNIGHT.", "timestamp": 2368, "color": "0xFF2800"},
	{"lyric": "", "timestamp": 2390, "color": "0xFF2800"}
	]
	}';

	return Json.parse(rawJson);
}

var lyricalCam:FlxCamera;
var poop:FlxText;
var subtitlemark:FlxSprite;

var json = loadJson();
var data = [];

function create() {
	lyricalCam = new FlxCamera();
	lyricalCam.bgColor = 0;
	FlxG.cameras.add(lyricalCam, false);

	data = json.stuff;

	for (j in data) j.triggered = false;

	subtitlemark = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	subtitlemark.visible = false;
	subtitlemark.alpha = 0.5;
	subtitlemark.camera = lyricalCam;
	add(subtitlemark);

	poop = new FlxText();
	poop.setFormat(Paths.font('Pixim.otf'), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	poop.borderSize = 2.5;
	poop.text = "";
	poop.screenCenter(FlxAxes.X);
	poop.y = FlxG.height * 0.9 + (Options.downScroll ? 65 : -65);
	poop.antialiasing = true;
	poop.camera = lyricalCam;
	add(poop);

	switch(songName.toLowerCase()) {
		case 'try harder':
			poop.font = Paths.font('Sonic Advanced 2.ttf');
			poop.size += 10;

		case 'execution':
			poop.font = Paths.font('nintendo-nes-font.ttf');
			poop.size -= 7;

		case 'accelerant':
			poop.font = Paths.font('impact.ttf');
			poop.size += 10;
	}
}

function update(elapsed) {
	var stepFloat = Conductor.songPosition / Conductor.stepCrochet;

	for (j in data) {
		if (!j.triggered && curStep >= j.timestamp) {
			j.triggered = true;
			showLyric(j);
		}
	}

}

function showLyric(j) {
	poop.text = StringTools.replace(j.lyric, "'", "");
	poop.color = FlxColor.fromString(j.color);
	poop.antialiasing = false;
	poop.screenCenter(FlxAxes.X);

	subtitlemark.scale.set(poop.width + 20, poop.size + 8);
	subtitlemark.updateHitbox();
	subtitlemark.x = (FlxG.width / 2) - subtitlemark.width / 2;
	subtitlemark.y = poop.y + 2;
	subtitlemark.visible = poop.text != "";

	if (songName.toLowerCase() == "execution") {
		subtitlemark.y -= 6;
	}

}
