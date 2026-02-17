function postCreate()
{
    //if (FlxG.save.data.note_underlay <= 0) return;

    for (strumLine in strumLines)
    {
        var underlay:FlxSprite = new FlxSprite(strumLine.members[0].x, 0);
        underlay.makeSolid((strumLine.members[0].width * 2 + 70), FlxG.height, FlxColor.BLACK);
        underlay.scrollFactor.set();
        underlay.cameras = [camHUD];
        underlay.alpha = 0.6;
        insert(0, underlay);
    }
}