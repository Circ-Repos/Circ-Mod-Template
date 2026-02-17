function create() {
    var winX:Int = 3440;
    var winY:Int = 1440;
    FlxG.resizeWindow(winX,winY); //Placeholder for the window size, you can change it to whatever you want
    window.move(0,0);
    camHUD.setSize(winX, winY);
    camGame.setSize(winX, winY);

    FlxG.resizeGame(winX, winY);
    FlxG.scaleMode.width = winX;
    FlxG.scaleMode.height = winY;
    window.x = -1;
    Application.current.window.y = 0;
    window.borderless = true;
}