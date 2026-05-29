import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextAlign;
import funkin.backend.system.Conductor;

var timeSigText:FunkinText;

function postCreate(){
    timeSigText = new FunkinText(420, 600, 0, "");
    timeSigText.text = '${Conductor.beatsPerMeasure}/${Conductor.denominator}';
	timeSigText.alignment = FlxTextAlign.CENTER;
	timeSigText.setFormat(Paths.font("VCR.ttf"), 36, FlxColor.WHITE, FlxTextAlign.center);
	timeSigText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 4);
	timeSigText.antialiasing = false;
	timeSigText.scrollFactor.set(0, 0);
	timeSigText.cameras = [camHUD];
    timeSigText.screenCenter(FlxAxes.X);
	add(timeSigText);
}
function postUpdate(elapsed:Float) {
    timeSigText.text = '${Conductor.beatsPerMeasure}/${Conductor.denominator}';
    timeSigText.angle = healthBarBG.angle;
    if(healthBar.y > FlxG.height/2){
        timeSigText.y = healthBarBG.y - 35;
    }else{
        timeSigText.y = healthBarBG.y + 15;
    }
}