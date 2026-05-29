import haxe.Json;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;

var songName = PlayState.SONG.meta.name;
var jsonPath = Paths.getPath('songs/$songName/lyrics.json');
json = Json.parse(Assets.getText(jsonPath));
trace(songName);
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

	poop = new FlxText();
	poop.setFormat(Paths.font('VCR.ttf'), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	poop.borderSize = 2.5;
	poop.text = "";
	poop.screenCenter(FlxAxes.X);
	poop.y = healthBar.y + (Options.downScroll ? 65 : -65);
	poop.antialiasing = Options.antialiasing;
	poop.camera = camOther;
	add(poop);

	if(songName == 'Zipperbomb'){
		poop.font = Paths.font('zip.ttf');
		poop.size -= 24;
		poop.antialiasing = false;
	}
	switch(PlayState.SONG.meta.displayName.toLowerCase()){
		case 'try harder':
			poop.font = Paths.font('Sonic Advanced 2.ttf');
			poop.size += 10;

		case 'execution':
			poop.font = Paths.font('nintendo-nes-font.ttf');
			poop.size -= 7;

		case 'accelerant':
			poop.font = Paths.font('impact.ttf');
			poop.size += 10;
		case 'zipperbomb':
			poop.font = Paths.font('zip.ttf');
	}
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
	poop.color = FlxColor.fromString(j.color);
	poop.antialiasing = Options.antialiasing;
	poop.screenCenter(FlxAxes.X);

	subtitlemark.scale.set(poop.width + 20, poop.size + 8);
	if(songName == 'Zipperbomb') subtitlemark.scale.y += 9;
	subtitlemark.updateHitbox();
	subtitlemark.x = (FlxG.width / 2) - subtitlemark.width / 2;
	subtitlemark.y = poop.y + 2;
	subtitlemark.visible = poop.text != "";
}