import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.text.FlxText;
var lyricTimer = new FlxTimer();
var box:FlxSprite;
var lines = [];
var boxin:FlxTween;

function create()
{
    box = new FlxSprite(0, 570).makeGraphic(FlxG.width / 2, 60, FlxColor.TRANSPARENT);
    box.cameras = [camHUD];
    box.screenCenter();
    box.alpha = 0;
    add(box);

    lyricTimer = new FlxTimer();
}

/*
function onEvent(eventEvent) {
    if(eventEvent.event.name != "Lyrics") return;
    // trace(eventEvent.event.params);
    switch(eventEvent.event.params[0]) {
        case "Add Text":
            addText(eventEvent.event.params[1]);*/

function onEvent(eventEvent)
{
    if(eventEvent.event.name != "Source Subtitles") return;
    if(!lyricTimer.active)
        box.height = 0;

    trace(eventEvent.event.params[0] + ' V1'); //OH MY GOD V1 ULTRAKILL!?
    trace(eventEvent.event.params[1] + ' V2'); //OH MYGod V2 ULTRAKILL!?
    var value1 = eventEvent.event.params[0];
    var value2 = eventEvent.event.params[1];
    if(value1 == null){
        value1 = 'Bro forgot text';
        trace('Bro forgot text');
    }
    if(value2 == null){
        value2 = '99';
        trace('Bro forgot timer');

    }

    if(value2 == ''){
        value2 = '99';
    }
    if(value1 == ''){
        value2 = '0.1';
        FlxTween.completeTweensOf(lyricTimer);
    }
    if (box.alpha == 0)
        FlxTween.tween(box, {alpha: 0.5}, 0.3, {ease: FlxEase.expoOut});

    var lyric = new FlxText(box.x + 10, 570, box.width - 10, value1, 28);
    lyric.font = Paths.font("trebuc.ttf");
    lyric.cameras = [camHUD];

    if (lyric.textField.numLines > 1)
        lyric.y -= 15 * lyric.textField.numLines;
   
    
    lyric.alpha = 0;
    FlxTween.tween(lyric, {alpha: 1}, 0.4, {ease: FlxEase.expoOut});

    lines.push(lyric);
    add(lyric);

    var totalHeight = lyric.height;

    // stupid fucking solution but IDK ANYTHING ELSE THAT IS WORKIN RIGHT :upside_down:
    while (lines.length > 4)
    {
        remove(lines[0]);
        lines.remove(lines[0]);
    }

    remove(lyric, false);
    insert(99, lyric);
    
    for (i in 0...lines.length - 1)
    {
        var curLine = lines[i];
        FlxTween.cancelTweensOf(curLine);

        FlxTween.tween(curLine, {y: curLine.y - lyric.height}, 0.01, {ease: FlxEase.expoOut});
        totalHeight += curLine.height;
    }

    FlxTween.completeTweensOf(box);

    var scaling = box.height;

    box.y = lines[0].y;

    if (lines.length > 1)
        box.y -= lyric.height;

    box.makeGraphic(box.width, totalHeight, FlxColor.TRANSPARENT);
    box.origin.set(0, box.height);
    scaling /= box.height;
    FlxTween.tween(box.scale, {y: 1}, 0.4, {ease: FlxEase.expoOut});

    box.scale.set(1, scaling);

    //if (lyricTimer.active)
    lyricTimer.cancel();

    lyricTimer.start(value2, ()->
    {
        FlxTween.tween(box.scale, {y: 0}, 0.6, {ease: FlxEase.backIn});



        var i = 0;
        for (line in lines)
        {
            FlxTween.tween(line, {alpha: 0}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.08 * i,
                onComplete: ()->
                {
                    remove(line);
                    lines.remove(line);
                }});
        }
        i++;
    });
}

function update(dt)
{
    /*if (lines.length == 0)
        box.alpha = 0;
*/
    FlxSpriteUtil.drawRoundRect(box, 0, 0, box.width, box.height, 20, 20, 0xFF000000);
}