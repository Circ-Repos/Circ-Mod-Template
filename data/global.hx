public static var loadTime:Array = [false, 0];

function new(){
    FlxG.save.data.CNEAdjustablesPlayback ??= 1;
    FlxG.save.data.CNEAdjustablesScroll ??= 1;
    FlxG.save.data.CNEAdjustablesOneMiss ??= false;
    FlxG.save.data.CNEAdjustablesPractice ??= false;
    FlxG.save.data.CNEAdjustablesIReset ??= false;
    FlxG.save.data.CNEAdjustablesBotplay ??= false;
    FlxG.save.data.CNEAdjustablesUsableOutside ??= false;
}