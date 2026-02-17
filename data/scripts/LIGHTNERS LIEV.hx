import openfl.text.TextFormat;
import flixel.text.FlxTextBorderStyle;
importScript('data/scripts/sustainAnim');

function postCreate() {
    healthBar.visible = false;
    healthBarBG.visible = false;

    scoreTxt.font = accuracyTxt.font = missesTxt.font = Paths.font("Pixel_NES.ttf");
    scoreTxt.borderSize = accuracyTxt.borderSize = missesTxt.borderSize = 2;
    scoreTxt.antialiasing = accuracyTxt.antialiasing = missesTxt.antialiasing = false;

    scoreTxt.size = accuracyTxt.size = missesTxt.size = 12;
    scoreTxt.x += 20;
    accuracyTxt.x -= 20;
    missesTxt.x += 40;
    accuracyTxt.y = 650;
    scoreTxt.y = 650;
    missesTxt.y = 650;
    iconP1.alpha = iconP2.alpha = 0;

    for(i in playerStrums.members){
        if(i.ID == 2)  i.alpha = 0;
        if(i.ID == 3)  i.alpha = 0;
    }

}

function postUpdate() {
    iconP1.x = 920;
    iconP1.y = 545;
    iconP1.scale.set(0.8, 0.8);
    iconP2.x = 210;
    iconP2.y = 540;
    iconP2.scale.set(0.8, 0.8);
    doIconBop = false;

    var accuracyDisplay = accuracy < 0 ? "-" : CoolUtil.quantize(accuracy * 100, 100);
    accuracyTxt.text = "ACCURACY: " + accuracyDisplay + " % - " + curRating.rating;
    scoreTxt.text = "POINTs: " + songScore;
    missesTxt.text = "MISSED NOTES: " + misses;
    accFormat.format.color = 0xFFFFFFFF;
}