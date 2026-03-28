import haxe.Json;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import funkin.backend.FunkinText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;

var songName = PlayState.SONG.meta.name;
var jsonPath = Paths.getPath('songs/$songName/lyrics.json');
json = Json.parse(Assets.getText(jsonPath));

var data = [];
function postCreate() {
	camOther = new FlxCamera();
	camOther.bgColor = 0;
	FlxG.cameras.add(camOther, false);
	
	data = json.stuff;

	for (j in data) j.triggered = false;

	subtitlemark = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	subtitlemark.visible = false;
	subtitlemark.alpha = 0.5;
	subtitlemark.camera = camOther;
	add(subtitlemark);

	poop = new FunkinText(0,65,0,"",1);
	poop.setFormat(Paths.font('VCR.ttf'), 32, FlxColor.fromString('0xFFFFFF00'), FlxTextAlign.CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT);
	poop.borderSize = 2.5;
	poop.text = "";
	poop.antialiasing = false;
	poop.screenCenter(FlxAxes.X);
	poop.y = healthBar.y + (Options.downScroll ? 65 : -65);
	poop.antialiasing = Options.antialiasing;
	poop.camera = camOther;
	add(poop);
}

function update(elapsed) {
	for (j in data) {
		if (!j.triggered && curStep >= j.timestamp) {
			j.triggered = true;
			showLyric(j);
		}
	}

}

function showLyric(j) {
	poop.text = StringTools.replace(j.lyric, "'", "");
		poop.applyMarkup(poop.text,
		[
				new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "*")
		]
	);
	//poop.color = FlxColor.fromString(j.color);


	poop.screenCenter(FlxAxes.X);
	subtitlemark.scale.set(poop.width + 20, poop.size + 2);
	subtitlemark.updateHitbox();
	subtitlemark.x = (FlxG.width / 2) - subtitlemark.width / 2;
	subtitlemark.y = poop.y + 2;
	subtitlemark.visible = poop.text != "";
}