var shaderAmplification:CustomShader;
var shaderMain:CustomShader;
var shaderBlockEffect:CustomShader;
var shaderSharpen:CustomShader;
var shaderReduce:CustomShader;

function create(){
    shaderAmplification = new CustomShader("amplificationShader");
    shaderMain = new CustomShader("mainShader");
    shaderBlockEffect = new CustomShader("blockEffectShader");
    shaderSharpen = new CustomShader("sharpenShader");
    shaderReduce = new CustomShader("reduceShader");

}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.F9) {
    FlxG.game.addShader(shaderReduce);
    FlxG.game.addShader(shaderSharpen);
    FlxG.game.addShader(shaderBlockEffect);
    FlxG.game.addShader(shaderMain);
    FlxG.game.addShader(shaderAmplification);
    }
    if (FlxG.keys.justPressed.F10) {
    FlxG.game.removeShader(shaderReduce);
    FlxG.game.removeShader(shaderSharpen);
    FlxG.game.removeShader(shaderBlockEffect);
    FlxG.game.removeShader(shaderMain);
    FlxG.game.removeShader(shaderAmplification);
    }
}