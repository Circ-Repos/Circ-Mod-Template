import haxe.ds.StringMap;
import flixel.util.FlxGradient;

public var charList = new StringMap();
var strumAttrs:Bool = [false, false]; // flipped strums


function create() {
    // precache chars
	for (event in events)
		if (event.name == 'Change Character Circ'){
            precacheCharacter(event.params[0],event.params[1],0);

        }
}

public function precacheCharacter(strumIndex:Int, ?charName:String, ?charIndex:Int):Character {
    trace(strumIndex);
    var strumLine:StrumLine = strumLines.members[strumIndex];
    var oldChar:Character = strumLine.characters[charIndex];

    if (!charList.exists(strumIndex))
        charList.set(strumIndex, new StringMap());

    var strumMap = charList.get(strumIndex);

    if (!strumMap.exists(charIndex))
        strumMap.set(charIndex, new StringMap());

    var indexMap = strumMap.get(charIndex);

    if (indexMap.exists(charName))
        return indexMap.get(charName);

    var newChar:Character = new Character(oldChar.x, oldChar.y, charName, oldChar.isPlayer);
    newChar.draw();
    newChar.active = false;
    stage.applyCharStuff(newChar, SONG.strumLines[strumIndex].position == null ? (switch(SONG.strumLines[strumIndex].type) {
        case 0: 'dad';
        case 1: 'boyfriend';
        case 2: 'girlfriend';
    }) : SONG.strumLines[strumIndex].position, strumIndex);
    indexMap.set(charName, newChar);
    remove(newChar);
    return indexMap.get(charName);
}

function darkenColor(color:Int, amount:Float):Int {
    var a = (color >> 24) & 0xFF;
    var r = (color >> 16) & 0xFF;
    var g = (color >> 8) & 0xFF;
    var b = color & 0xFF;

    r = Std.int(r * (1 - amount));
    g = Std.int(g * (1 - amount));
    b = Std.int(b * (1 - amount));

    return (a << 24) | (r << 16) | (g << 8) | b;
}

public function refreshHPBarColor(dadColor,bfColor){
	var dadGradient:Array<Int> = [dadColor, darkenColor(dadColor, 0.7)];
	var bfGradient:Array<Int>  = [bfColor, darkenColor(bfColor, 0.7)];

	var barWidth:Int  = Std.int(healthBarBG.width - 8);
	var barHeight:Int = Std.int(healthBarBG.height - 8);
	
	var leftGrad:FlxSprite = FlxGradient.createGradientFlxSprite(barWidth, barHeight, dadGradient, 1, 90, true);
	var rightGrad:FlxSprite = FlxGradient.createGradientFlxSprite(barWidth, barHeight, bfGradient, 1, 90, true);

	healthBar.createImageBar(leftGrad.pixels, rightGrad.pixels);
	healthBar.percent = health;
}

function getCachedChar(strumIndex:Int, charIndex:Int, charName:String):Character {
    var strumMap = charList.get(strumIndex);
    if (strumMap == null) return null;

    var indexMap = strumMap.get(charIndex);
    if (indexMap == null) return null;

    return indexMap.get(charName);
}
function onEvent(event){
    if(event.event.name != 'Change Character Circ') return;
    trace(event.event.params);
    var strumIdx:Int = event.event.params[0];
    var charName:String = event.event.params[1];
    var oldChar:Character = strumLines.members[strumIdx].characters[0];

    var newChar:Character = getCachedChar(strumIdx, 0, charName);
    if (newChar == null) {
        trace('not cached: ${charName}');
        return;
    }
    //just leaving this here cause yea
    trace('Swapping ${strumIdx} to ${newChar.curCharacter}');
    switch(strumIdx) {
        case 0: // dad
            trace('dad Swap ${newChar.curCharacter}');
            insert(members.indexOf(oldChar), newChar);
            newChar.active = true;
            dad = newChar;
            remove(oldChar);
            iconP2.setIcon(newChar.icon);
            refreshHPBarColor(newChar.iconColor,bf.iconColor);

        case 1: // bf
            trace('bf Swap ${newChar.curCharacter}');
            insert(members.indexOf(oldChar), newChar);
            newChar.active = true;
            bf = newChar;
            remove(oldChar);
            iconP1.setIcon(newChar.icon);
            refreshHPBarColor(dad.iconColor,newChar.iconColor);
        case 2: // gf
            trace('gf Swap ${newChar.curCharacter}');

            insert(members.indexOf(oldChar), newChar);
            newChar.active = true;
            gf = newChar;
            remove(oldChar);
        // default: // bfx2
        //     trace('dad default Swap ${newChar.curCharacter}');
        //     insert(members.indexOf(oldChar), newChar);
        //     newChar.active = true;
        //     dad = newChar;
        //     remove(oldChar);
        //     iconP2.setIcon(newChar.icon);
        //     refreshHPBarColor(newChar.iconColor,bf.iconColor);

    }
}