import funkin.backend.utils.NativeAPI;
import openfl.system.Capabilities;
import funkin.backend.utils.NdllUtil;
import lime.graphics.Image;
import funkin.backend.MusicBeatState;
import funkin.backend.system.MainState;
import funkin.options.Options;

static var initialized:Bool = false;


function destroy() {
    FlxG.mouse.useSystemCursor = true;
    FlxG.mouse.unload();
}

function new(){
    FlxG.mouse.useSystemCursor = false;
    FlxG.mouse.load(Paths.image("cursor"));
    if (FlxG.save.data.antialiasing == true) {
        FlxG.save.data.antialiasing = false;
        Options.antialiasing = false;
        trace('mods Fuck This Guys Antialiasing Up');
        }

    window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('icon16'))));
    window.title = "Friday Night Funkin': Vs Sammy - WIP As Fuck Codename Port"; //not sure if we doin demo but thats what i heard so ye
    MainState.betaWarningShown = true;

}

static var redirectStates:Map<FlxState, String> = [
    TitleState => "customStates/menus/Title",
    FreeplayState => "customStates/menus/Freeplay",
    MainMenuState => "customStates/menus/MainMenu",
    StoryMenuState => "customStates/menus/StoryMenu",

];

function update(elapsed) {
    if (FlxG.keys.justPressed.F6)
        NativeAPI.allocConsole();
    if (FlxG.keys.justPressed.F5)
        FlxG.resetState();
    if (FlxG.keys.justPressed.F7)
        FlxG.switchState(new TitleState());
    if (FlxG.keys.justPressed.F8)
        FlxG.switchState(new MainMenuState());
}

    function preStateSwitch() {
        for (redirectState in redirectStates.keys())
            if (FlxG.game._requestedState is redirectState)
                FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
    }