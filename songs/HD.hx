import funkin.editors.ui.UIScaleMode;

function create(){
    FlxG.scaleMode = new UIScaleMode();
    camHUD.height = FlxG.height;
    camHUD.width = FlxG.width;
}