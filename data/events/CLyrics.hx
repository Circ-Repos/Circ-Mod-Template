import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;

var subtitles:FlxText;

function onSongStart() {

	subtitles = new FlxText(0, 600, 0, "");
	subtitles.alignment = FlxTextAlign.CENTER;
	subtitles.setFormat(Paths.font("VCR.ttf"), 36, FlxColor.WHITE, FlxTextAlign.center);
	subtitles.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 4);
	
	subtitles.antialiasing = false;
	subtitles.scrollFactor.set(0, 0);
	subtitles.cameras = [camHUD];
	add(subtitles);
	remove(subtitles,true);
	insert(99, subtitles);
    subtitles.screenCenter(FlxAxes.X);
	    for (i in subtitles) {
        i.size *= 3;
		i.pixelPerfectRender = true;
        i.scale.x /= 3;
        i.scale.y /= 3;
        i.antialiasing = true;
        i.y -= 21;
        i.borderSize *= 3;
        i.fieldWidth += 1000;
        i.x -= 1000/2;
        i.borderQuality = 100;
    }
}

function onEvent(event)
{
	trace(event);
	if(event.event.name != "CLyrics") return;

	var value1 = event.event.params[0];
    var value2 = event.event.params[1];
	if(value2 != 'mid' && subtitles.y != 600){
		subtitles.x = 0;
		subtitles.y = 600;
		subtitles.setFormat(Paths.font("VCR.ttf"), 36, FlxColor.WHITE, FlxTextAlign.center);
	}
    if (event.event.name == 'CLyrics' && value1 != '')
    {
		remove(subtitles,true);
		insert(99, subtitles);	
		subtitles.alpha = 1;
		subtitles.text = value1;
    }
	switch(value2){
		default:
			subtitles.screenCenter(FlxAxes.X);
		case 'mid':
			subtitles.screenCenter();
			subtitles.setFormat(Paths.font("VCR.ttf"), 72, FlxColor.WHITE, FlxTextAlign.center);

	}
	if(value1 == '') FlxTween.tween(subtitles, {alpha: 0},0.8, {ease: FlxEase.linear});
}
