var beatBars:Array<FunkinSprite> = [];

function postCreate()
{
    //if (!FlxG.save.data.beat_seperator) return;

    for (strumLine in strumLines)
    {
        for (i in 0...Conductor.getTimeInBeats(FlxG.sound.music.length, 0))
        {
            if (getBarByBeat(i) != null) return;

            makeBeatBar(Conductor.getBeatsInTime(i, 0), strumLine);
        }
        makeBeatBar(Conductor.getBeatsInTime(FlxG.sound.music.length, 0), strumLine);
    }
}

function update()
{
    if (beatBars.length <= 0) return;
    for (bar in beatBars)
    {
        if (bar.extra["pos"] < Conductor.songPosition + (3600 * bar.extra["strumLine"].members[0].getScrollSpeed(null))) bar.visible = bar.active = true;
        //else return;

        bar.y = ((bar.extra["pos"] - Conductor.songPosition) * (0.45 * bar.extra["strumLine"].members[0].getScrollSpeed(null)));
        if (bar.extra["pos"] < Conductor.songPosition - 200)
        {
            bar.kill();
			beatBars.remove(bar, true);
			bar.destroy();
        }
    }
}

function makeBeatBar(pos:Float, strumLine:StrumLine)
{
    var bar = new FunkinSprite(strumLine.members[0].x, 0);
    bar.makeSolid((strumLine.members[0].width * 2 + 70), 5, FlxColor.WHITE);
    bar.extra.set("pos", pos);
    bar.extra.set("strumLine", strumLine);
    bar.cameras = [camHUD];
    bar.offset.y = -100;
    //bar.extra.set("speed", );
    insert(0, bar);
    bar.alpha = 0.3;
    var time = Conductor.getTimeInBeats(bar.extra["pos"], 0) % Conductor.beatsPerMeasure;
    if (time <= 0.1 || time >= 3.9) bar.alpha = 0.8;
    if (pos >= FlxG.sound.music.length) {bar.alpha = 0.8; trace("hi length");}
    bar.visible = bar.active = false;
    beatBars.push(bar);
}

function getBarByBeat(beat:Float)
{
    for (bar in beatBars)
    {
        if (Conductor.getBeatsInTime(bar.extra["pos"], 0) == beat)
        {
            return null;
            break;
        }
    }
    return null;
}