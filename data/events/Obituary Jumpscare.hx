import hxvlc.flixel.FlxVideoSprite;
import funkin.backend.chart.Chart;
import openfl.display.BlendMode;


var precache = true;
var intro = false;
var thirdBG:Array<FlxSprite> = [];
var obitInst;
var obitVoices;
var obitJson = Json.parse(Assets.getText(Paths.json('obitChart')));
// var bfObitData = CoolUtil.coolTextFile(Paths.txt('testSD2'));
// var exeObitData = CoolUtil.coolTextFile(Paths.txt('testSD'));
var exeNotes = ['{ id => 2, sLen => 748.971193415653, time => 0, type => 0 },{ id => 3, sLen => 641.975308642309, time => 0, type => 0 },{ id => 0, sLen => 0, time => 888.888888888889, type => 0 },{ id => 2, sLen => 0, time => 1000, type => 0 },{ id => 3, sLen => 0, time => 1111.11111111111, type => 0 },{ id => 1, sLen => 0, time => 1222.22222222222, type => 0 },{ id => 3, sLen => 0, time => 1333.33333333333, type => 0 },{ id => 1, sLen => 0, time => 1444.44444444444, type => 0 },{ id => 0, sLen => 0, time => 1555.55555555556, type => 0 },{ id => 2, sLen => 0, time => 1666.66666666667, type => 0 },{ id => 1, sLen => 777.777777777904, time => 1777.77777777778, type => 0 },{ id => 3, sLen => 777.777777777904, time => 1777.77777777778, type => 0 },{ id => 2, sLen => 222.222222222222, time => 2666.66666666667, type => 0 },{ id => 3, sLen => 0, time => 3000, type => 0 },{ id => 1, sLen => 0, time => 3222.22222222222, type => 0 },{ id => 0, sLen => 0, time => 3333.33333333333, type => 0 },{ id => 2, sLen => 0, time => 3444.44444444444, type => 0 },{ id => 0, sLen => 777.777777777777, time => 3555.55555555556, type => 0 },{ id => 1, sLen => 777.777777777777, time => 3555.55555555556, type => 0 },{ id => 2, sLen => 777.777777777778, time => 4444.44444444444, type => 0 },{ id => 0, sLen => 0, time => 4888.88888888889, type => 1 },{ id => 0, sLen => 0, time => 5000, type => 1 },{ id => 0, sLen => 0, time => 5111.11111111111, type => 1 },{ id => 0, sLen => 0, time => 5222.22222222222, type => 1 },{ id => 1, sLen => 190.058479532177, time => 5333.33333333333, type => 0 },{ id => 2, sLen => 190.058479532177, time => 5555.55555555556, type => 0 },{ id => 0, sLen => 190.058479532151, time => 5777.77777777778, type => 0 },{ id => 3, sLen => 190.058479532152, time => 6000, type => 0 },{ id => 1, sLen => 0, time => 6222.22222222222, type => 0 },{ id => 2, sLen => 0, time => 6222.22222222222, type => 0 },{ id => 3, sLen => 0, time => 6444.44444444444, type => 0 },{ id => 2, sLen => 0, time => 6555.55555555556, type => 0 },{ id => 1, sLen => 0, time => 6666.66666666667, type => 0 },{ id => 0, sLen => 0, time => 6888.88888888889, type => 0 },{ id => 1, sLen => 0, time => 7111.11111111111, type => 0 },{ id => 3, sLen => 0, time => 7111.11111111111, type => 0 },{ id => 2, sLen => 0, time => 7333.33333333333, type => 0 },{ id => 0, sLen => 0, time => 7444.44444444444, type => 0 },{ id => 1, sLen => 0, time => 7555.55555555556, type => 0 },{ id => 2, sLen => 0, time => 7777.77777777778, type => 0 },{ id => 0, sLen => 0, time => 7888.88888888889, type => 0 },{ id => 3, sLen => 0, time => 8000, type => 0 },{ id => 0, sLen => 0, time => 8111.11111111111, type => 0 },{ id => 2, sLen => 0, time => 8222.22222222222, type => 0 },{ id => 3, sLen => 0, time => 8333.33333333333, type => 0 },{ id => 1, sLen => 0, time => 8444.44444444445, type => 0 },{ id => 3, sLen => 0, time => 8555.55555555556, type => 0 },{ id => 0, sLen => 0, time => 8666.66666666667, type => 0 },{ id => 2, sLen => 0, time => 8777.77777777778, type => 0 },{ id => 3, sLen => 0, time => 8888.88888888889, type => 0 },{ id => 1, sLen => 0, time => 9000, type => 0 },{ id => 2, sLen => 0, time => 9111.11111111111, type => 0 },{ id => 2, sLen => 0, time => 9222.22222222222, type => 0 },{ id => 3, sLen => 115.000000000009, time => 9333.33333333333, type => 0 },{ id => 0, sLen => 0, time => 9555.55555555556, type => 0 },{ id => 1, sLen => 0, time => 9666.66666666667, type => 0 },{ id => 3, sLen => 0, time => 9777.77777777778, type => 0 },{ id => 2, sLen => 0, time => 9888.88888888889, type => 0 },{ id => 3, sLen => 0, time => 10000, type => 0 },{ id => 0, sLen => 0, time => 10111.1111111111, type => 0 },{ id => 2, sLen => 0, time => 10222.2222222222, type => 0 },{ id => 0, sLen => 0, time => 10333.3333333333, type => 0 },{ id => 3, sLen => 0, time => 10444.4444444444, type => 0 },{ id => 0, sLen => 0, time => 10666.6666666667, type => 0 },{ id => 3, sLen => 0, time => 10888.8888888889, type => 0 },{ id => 0, sLen => 0, time => 11000, type => 0 },{ id => 1, sLen => 0, time => 11111.1111111111, type => 0 },{ id => 2, sLen => 0, time => 11222.2222222222, type => 0 },{ id => 3, sLen => 0, time => 11333.3333333333, type => 0 },{ id => 2, sLen => 0, time => 11555.5555555556, type => 0 },{ id => 0, sLen => 0, time => 11666.6666666667, type => 0 },{ id => 2, sLen => 0, time => 11777.7777777778, type => 0 },{ id => 1, sLen => 0, time => 11888.8888888889, type => 0 },{ id => 3, sLen => 0, time => 12000, type => 0 },{ id => 0, sLen => 0, time => 12222.2222222222, type => 0 },{ id => 1, sLen => 0, time => 12444.4444444444, type => 0 },{ id => 3, sLen => 0, time => 12666.6666666667, type => 0 },{ id => 0, sLen => 0, time => 12888.8888888889, type => 0 },{ id => 2, sLen => 0, time => 12888.8888888889, type => 0 },{ id => 1, sLen => 0, time => 13111.1111111111, type => 0 },{ id => 2, sLen => 0, time => 13333.3333333333, type => 0 },{ id => 3, sLen => 0, time => 13555.5555555556, type => 0 },{ id => 3, sLen => 0, time => 13666.6666666667, type => 0 },{ id => 1, sLen => 0, time => 13777.7777777778, type => 0 },{ id => 3, sLen => 1777.77777777778, time => 14000, type => 0 },{ id => 1, sLen => 1666.66666666669, time => 16000, type => 0 },{ id => 0, sLen => 1666.66666666667, time => 17777.7777777778, type => 0 },{ id => 2, sLen => 777.777777777854, time => 19555.5555555556, type => 0 },{ id => 3, sLen => 777.777777777752, time => 20444.4444444444, type => 0 },{ id => 1, sLen => 1666.66666666666, time => 21333.3333333333, type => 0 },{ id => 0, sLen => 1666.66666666661, time => 23111.1111111111, type => 0 },{ id => 1, sLen => 1666.66666666664, time => 24888.8888888889, type => 0 },{ id => 2, sLen => 777.777777777777, time => 26666.6666666667, type => 0 },{ id => 3, sLen => 777.777777777781, time => 27555.5555555556, type => 0 },{ id => 1, sLen => 0, time => 28444.4444444444, type => 0 },{ id => 0, sLen => 0, time => 28555.5555555556, type => 0 },{ id => 2, sLen => 0, time => 28666.6666666667, type => 0 },{ id => 0, sLen => 0, time => 28777.7777777778, type => 0 },{ id => 3, sLen => 0, time => 28888.8888888889, type => 0 },{ id => 1, sLen => 0, time => 29000, type => 0 },{ id => 2, sLen => 0, time => 29111.1111111111, type => 0 },{ id => 3, sLen => 0, time => 29222.2222222222, type => 0 },{ id => 0, sLen => 0, time => 29333.3333333333, type => 0 },{ id => 2, sLen => 0, time => 29444.4444444444, type => 0 },{ id => 1, sLen => 0, time => 29555.5555555556, type => 0 },{ id => 3, sLen => 0, time => 29666.6666666667, type => 0 },{ id => 1, sLen => 0, time => 29777.7777777778, type => 0 },{ id => 3, sLen => 0, time => 29888.8888888889, type => 0 },{ id => 0, sLen => 0, time => 30000, type => 0 },{ id => 0, sLen => 0, time => 30111.1111111111, type => 0 },{ id => 3, sLen => 0, time => 30222.2222222222, type => 0 },{ id => 2, sLen => 0, time => 30333.3333333333, type => 0 },{ id => 1, sLen => 0, time => 30444.4444444444, type => 0 },{ id => 2, sLen => 0, time => 30555.5555555556, type => 0 },{ id => 0, sLen => 0, time => 30666.6666666667, type => 0 },{ id => 1, sLen => 0, time => 30777.7777777778, type => 0 },{ id => 3, sLen => 0, time => 30888.8888888889, type => 0 },{ id => 2, sLen => 0, time => 31000, type => 0 },{ id => 0, sLen => 0, time => 31111.1111111111, type => 0 },{ id => 2, sLen => 0, time => 31222.2222222222, type => 0 },{ id => 3, sLen => 0, time => 31333.3333333333, type => 0 },{ id => 3, sLen => 0, time => 31444.4444444444, type => 0 },{ id => 1, sLen => 0, time => 31555.5555555556, type => 0 },{ id => 0, sLen => 0, time => 31666.6666666667, type => 0 },{ id => 3, sLen => 0, time => 31777.7777777778, type => 0 },{ id => 1, sLen => 0, time => 31888.8888888889, type => 0 },{ id => 2, sLen => 0, time => 32000, type => 0 },{ id => 3, sLen => 0, time => 32111.1111111111, type => 0 },{ id => 0, sLen => 0, time => 32222.2222222222, type => 0 },{ id => 2, sLen => 0, time => 32333.3333333333, type => 0 },{ id => 1, sLen => 0, time => 32444.4444444444, type => 0 },{ id => 0, sLen => 0, time => 32555.5555555556, type => 0 },{ id => 2, sLen => 0, time => 32666.6666666667, type => 0 },{ id => 3, sLen => 190.05847953225, time => 32777.7777777778, type => 0 },{ id => 1, sLen => 0, time => 33000, type => 0 },{ id => 2, sLen => 0, time => 33111.1111111111, type => 0 },{ id => 0, sLen => 0, time => 33222.2222222222, type => 0 },{ id => 2, sLen => 0, time => 33333.3333333333, type => 0 },{ id => 3, sLen => 0, time => 33444.4444444444, type => 0 },{ id => 1, sLen => 0, time => 33555.5555555556, type => 0 },{ id => 2, sLen => 0, time => 33666.6666666667, type => 0 },{ id => 0, sLen => 0, time => 33777.7777777778, type => 0 },{ id => 1, sLen => 0, time => 33888.8888888889, type => 0 },{ id => 3, sLen => 0, time => 34000, type => 0 },{ id => 1, sLen => 0, time => 34111.1111111111, type => 0 },{ id => 2, sLen => 0, time => 34222.2222222222, type => 0 },{ id => 3, sLen => 0, time => 34333.3333333333, type => 0 },{ id => 0, sLen => 0, time => 34444.4444444444, type => 0 },{ id => 2, sLen => 0, time => 34555.5555555556, type => 0 },{ id => 1, sLen => 0, time => 34666.6666666667, type => 0 },{ id => 3, sLen => 0, time => 34777.7777777778, type => 0 },{ id => 2, sLen => 0, time => 34888.8888888889, type => 0 },{ id => 0, sLen => 0, time => 35000, type => 0 },{ id => 2, sLen => 0, time => 35111.1111111111, type => 0 },{ id => 1, sLen => 0, time => 35222.2222222222, type => 0 },{ id => 3, sLen => 0, time => 35333.3333333333, type => 0 },{ id => 0, sLen => 0, time => 35444.4444444444, type => 0 },{ id => 2, sLen => 777.77777777773, time => 35555.5555555556, type => 0 },{ id => 0, sLen => 777.77777777773, time => 36444.4444444444, type => 0 },{ id => 1, sLen => 777.77777777773, time => 36444.4444444444, type => 0 },{ id => 3, sLen => 777.777777777672, time => 37333.3333333333, type => 0 },{ id => 1, sLen => 777.777777777825, time => 38222.2222222222, type => 0 },{ id => 0, sLen => 777.777777777781, time => 39111.1111111111, type => 0 },{ id => 2, sLen => 777.777777777781, time => 39111.1111111111, type => 0 },{ id => 3, sLen => 777.777777777934, time => 40000, type => 0 },{ id => 0, sLen => 777.777777777927, time => 40888.8888888889, type => 0 },{ id => 1, sLen => 777.777777777774, time => 41777.7777777778, type => 0 },{ id => 3, sLen => 777.777777777774, time => 41777.7777777778, type => 0 },{ id => 0, sLen => 0, time => 42666.6666666667, type => 0 },{ id => 2, sLen => 0, time => 42666.6666666667, type => 0 },{ id => 0, sLen => 0, time => 42888.8888888889, type => 0 },{ id => 2, sLen => 0, time => 43111.1111111111, type => 0 },{ id => 3, sLen => 0, time => 43111.1111111111, type => 0 },{ id => 3, sLen => 0, time => 43333.3333333333, type => 0 },{ id => 0, sLen => 0, time => 43555.5555555556, type => 0 },{ id => 2, sLen => 0, time => 43666.6666666667, type => 0 },{ id => 1, sLen => 0, time => 43777.7777777778, type => 0 },{ id => 3, sLen => 0, time => 43888.8888888889, type => 0 },{ id => 1, sLen => 0, time => 44000, type => 0 },{ id => 2, sLen => 0, time => 44111.1111111111, type => 0 },{ id => 3, sLen => 0, time => 44222.2222222222, type => 0 },{ id => 0, sLen => 0, time => 44333.3333333333, type => 0 },{ id => 2, sLen => 0, time => 44444.4444444444, type => 0 },{ id => 3, sLen => 0, time => 44555.5555555556, type => 0 },{ id => 1, sLen => 0, time => 44666.6666666667, type => 0 },{ id => 2, sLen => 0, time => 44777.7777777778, type => 0 },{ id => 0, sLen => 0, time => 44888.8888888889, type => 0 },{ id => 3, sLen => 0, time => 45000, type => 0 },{ id => 0, sLen => 0, time => 45111.1111111111, type => 0 },{ id => 1, sLen => 189.241486068058, time => 45222.2222222222, type => 0 },{ id => 2, sLen => 0, time => 45444.4444444444, type => 0 },{ id => 3, sLen => 0, time => 45555.5555555556, type => 0 },{ id => 0, sLen => 0, time => 45666.6666666667, type => 0 },{ id => 2, sLen => 0, time => 45777.7777777778, type => 0 },{ id => 0, sLen => 0, time => 45888.8888888889, type => 0 },{ id => 3, sLen => 0, time => 45999.1830065359, type => 0 },{ id => 2, sLen => 0, time => 46109.477124183, type => 0 },{ id => 1, sLen => 1654.41176470584, time => 46219.7712418301, type => 0 },{ id => 3, sLen => 0, time => 49749.1830065359, type => 0 },{ id => 1, sLen => 0, time => 49859.477124183, type => 0 },{ id => 2, sLen => 189.241486068117, time => 50080.0653594771, type => 0 },{ id => 1, sLen => 0, time => 50300.6535947712, type => 0 },{ id => 3, sLen => 0, time => 50410.9477124183, type => 0 },{ id => 1, sLen => 0, time => 50521.2418300654, type => 0 },{ id => 0, sLen => 0, time => 50631.5359477124, type => 0 },{ id => 2, sLen => 0, time => 50741.8300653595, type => 0 },{ id => 3, sLen => 189.241486068117, time => 50962.4183006536, type => 0 },{ id => 0, sLen => 0, time => 51183.0065359477, type => 0 },{ id => 1, sLen => 0, time => 51293.3006535948, type => 0 },{ id => 2, sLen => 0, time => 51403.5947712418, type => 0 },{ id => 3, sLen => 0, time => 51513.8888888889, type => 0 },{ id => 0, sLen => 0, time => 51624.1830065359, type => 0 },{ id => 2, sLen => 0, time => 51734.477124183, type => 0 },{ id => 1, sLen => 0, time => 51844.7712418301, type => 0 },{ id => 3, sLen => 0, time => 51955.0653594771, type => 0 },{ id => 1, sLen => 0, time => 52065.3594771242, type => 0 },{ id => 0, sLen => 0, time => 52175.6535947712, type => 0 },{ id => 2, sLen => 0, time => 52285.9477124183, type => 0 },{ id => 0, sLen => 0, time => 52396.2418300654, type => 0 },{ id => 3, sLen => 0, time => 52506.5359477124, type => 0 },{ id => 2, sLen => 0, time => 52616.8300653595, type => 0 },{ id => 1, sLen => 0, time => 52727.1241830065, type => 0 },{ id => 0, sLen => 0, time => 52837.4183006536, type => 0 },{ id => 2, sLen => 0, time => 52947.7124183007, type => 0 },{ id => 3, sLen => 0, time => 53058.0065359477, type => 0 },{ id => 1, sLen => 0, time => 53168.3006535948, type => 0 },{ id => 3, sLen => 0, time => 53278.5947712418, type => 0 },{ id => 0, sLen => 0, time => 53388.8888888889, type => 0 },{ id => 1, sLen => 189.241486068117, time => 53499.1830065359, type => 0 },{ id => 2, sLen => 0, time => 53719.7712418301, type => 0 },{ id => 3, sLen => 0, time => 53830.0653594771, type => 0 },{ id => 1, sLen => 0, time => 53940.3594771242, type => 0 },{ id => 0, sLen => 0, time => 54050.6535947712, type => 0 },{ id => 3, sLen => 189.241486068117, time => 54160.9477124183, type => 0 },{ id => 1, sLen => 0, time => 54381.5359477124, type => 0 },{ id => 2, sLen => 0, time => 54491.8300653595, type => 0 },{ id => 0, sLen => 0, time => 54602.1241830065, type => 0 },{ id => 2, sLen => 0, time => 54712.4183006536, type => 0 },{ id => 3, sLen => 0, time => 54822.7124183007, type => 0 },{ id => 1, sLen => 0, time => 54933.0065359477, type => 0 },{ id => 2, sLen => 0, time => 55043.3006535948, type => 0 },{ id => 0, sLen => 0, time => 55153.5947712418, type => 0 },{ id => 3, sLen => 189.241486068117, time => 55263.8888888889, type => 0 },{ id => 1, sLen => 0, time => 55484.477124183, type => 0 },{ id => 2, sLen => 189.241486068124, time => 55594.7712418301, type => 0 },{ id => 0, sLen => 0, time => 55815.3594771242, type => 0 },{ id => 1, sLen => 189.241486068117, time => 55925.6535947712, type => 0 },{ id => 2, sLen => 0, time => 56146.2418300654, type => 0 },{ id => 3, sLen => 0, time => 56256.5359477124, type => 0 },{ id => 0, sLen => 0, time => 56366.8300653595, type => 0 },{ id => 2, sLen => 0, time => 56477.1241830065, type => 0 },{ id => 1, sLen => 0, time => 56587.4183006536, type => 0 },{ id => 3, sLen => 0, time => 56697.7124183007, type => 0 },{ id => 2, sLen => 0, time => 56808.0065359477, type => 0 },{ id => 0, sLen => 0, time => 56918.3006535948, type => 0 },{ id => 2, sLen => 0, time => 57028.5947712418, type => 0 },{ id => 1, sLen => 0, time => 57138.8888888889, type => 0 },{ id => 3, sLen => 0, time => 57249.183006536, type => 0 },{ id => 2, sLen => 0, time => 57359.477124183, type => 0 },{ id => 0, sLen => 0, time => 57469.7712418301, type => 0 },{ id => 3, sLen => 0, time => 57580.0653594771, type => 0 },{ id => 1, sLen => 0, time => 57690.3594771242, type => 0 },{ id => 3, sLen => 0, time => 57800.6535947712, type => 0 },{ id => 0, sLen => 0, time => 57910.9477124183, type => 0 },{ id => 3, sLen => 0, time => 58021.2418300654, type => 0 },{ id => 2, sLen => 0, time => 58131.5359477124, type => 0 },{ id => 1, sLen => 0, time => 58241.8300653595, type => 0 },{ id => 0, sLen => 0, time => 58352.1241830065, type => 0 },{ id => 2, sLen => 0, time => 58462.4183006536, type => 0 },{ id => 3, sLen => 3088.23529411764, time => 58572.7124183007, type => 0 }'];
var bfNotes = ['{ id => 0, sLen => 0, time => 14222.2222222222, type => 1 },{ id => 2, sLen => 777.777777777803, time => 14222.2222222222, type => 2 },{ id => 3, sLen => 0, time => 15111.1111111111, type => 0 },{ id => 0, sLen => 0, time => 15222.2222222222, type => 0 },{ id => 2, sLen => 0, time => 15333.3333333333, type => 0 },{ id => 1, sLen => 0, time => 15444.4444444444, type => 0 },{ id => 3, sLen => 0, time => 15555.5555555556, type => 0 },{ id => 0, sLen => 0, time => 15666.6666666667, type => 0 },{ id => 2, sLen => 0, time => 15777.7777777778, type => 0 },{ id => 0, sLen => 0, time => 15888.8888888889, type => 0 },{ id => 2, sLen => 777.777777777777, time => 16000, type => 1 },{ id => 3, sLen => 777.777777777777, time => 16000, type => 2 },{ id => 0, sLen => 222.222222222248, time => 16888.8888888889, type => 2 },{ id => 1, sLen => 0, time => 17222.2222222222, type => 2 },{ id => 3, sLen => 0, time => 17222.2222222222, type => 1 },{ id => 2, sLen => 0, time => 17444.4444444444, type => 0 },{ id => 0, sLen => 0, time => 17555.5555555556, type => 0 },{ id => 3, sLen => 0, time => 17666.6666666667, type => 0 },{ id => 0, sLen => 777.777777777777, time => 17777.7777777778, type => 2 },{ id => 1, sLen => 777.777777777777, time => 17777.7777777778, type => 2 },{ id => 2, sLen => 444.444444444445, time => 18666.6666666667, type => 2 },{ id => 3, sLen => 444.444444444445, time => 18666.6666666667, type => 1 },{ id => 0, sLen => 0, time => 19222.2222222222, type => 0 },{ id => 1, sLen => 0, time => 19333.3333333333, type => 0 },{ id => 0, sLen => 0, time => 19444.4444444444, type => 0 },{ id => 3, sLen => 0, time => 19555.5555555556, type => 0 },{ id => 1, sLen => 0, time => 19666.6666666667, type => 2 },{ id => 0, sLen => 0, time => 19777.7777777778, type => 2 },{ id => 1, sLen => 0, time => 20000, type => 2 },{ id => 3, sLen => 0, time => 20222.2222222222, type => 2 },{ id => 0, sLen => 0, time => 20444.4444444444, type => 1 },{ id => 2, sLen => 0, time => 20444.4444444444, type => 2 },{ id => 3, sLen => 0, time => 20666.6666666667, type => 0 },{ id => 0, sLen => 0, time => 20777.7777777778, type => 0 },{ id => 3, sLen => 0, time => 20888.8888888889, type => 0 },{ id => 1, sLen => 0, time => 21111.1111111111, type => 0 },{ id => 2, sLen => 0, time => 21333.3333333333, type => 2 },{ id => 3, sLen => 0, time => 21333.3333333333, type => 2 },{ id => 0, sLen => 0, time => 21555.5555555556, type => 0 },{ id => 2, sLen => 0, time => 21666.6666666667, type => 0 },{ id => 1, sLen => 0, time => 21777.7777777778, type => 0 },{ id => 3, sLen => 0, time => 22000, type => 0 },{ id => 0, sLen => 0, time => 22111.1111111111, type => 0 },{ id => 1, sLen => 0, time => 22222.2222222222, type => 0 },{ id => 0, sLen => 0, time => 22333.3333333333, type => 0 },{ id => 2, sLen => 0, time => 22444.4444444444, type => 0 },{ id => 3, sLen => 0, time => 22555.5555555556, type => 0 },{ id => 0, sLen => 0, time => 22666.6666666667, type => 0 },{ id => 1, sLen => 0, time => 22777.7777777778, type => 0 },{ id => 2, sLen => 0, time => 22777.7777777778, type => 0 },{ id => 3, sLen => 0, time => 22888.8888888889, type => 0 },{ id => 0, sLen => 0, time => 23000, type => 0 },{ id => 2, sLen => 0, time => 23111.1111111111, type => 0 },{ id => 1, sLen => 0, time => 23222.2222222222, type => 0 },{ id => 3, sLen => 0, time => 23333.3333333333, type => 0 },{ id => 0, sLen => 0, time => 23444.4444444444, type => 0 },{ id => 2, sLen => 142.000000000004, time => 23555.5555555556, type => 2 },{ id => 1, sLen => 0, time => 23777.7777777778, type => 0 },{ id => 0, sLen => 0, time => 23888.8888888889, type => 0 },{ id => 2, sLen => 0, time => 24000, type => 0 },{ id => 0, sLen => 0, time => 24111.1111111111, type => 0 },{ id => 3, sLen => 0, time => 24222.2222222222, type => 0 },{ id => 1, sLen => 0, time => 24333.3333333333, type => 0 },{ id => 2, sLen => 0, time => 24444.4444444444, type => 0 },{ id => 3, sLen => 0, time => 24555.5555555556, type => 0 },{ id => 0, sLen => 142, time => 24666.6666666667, type => 2 },{ id => 3, sLen => 142, time => 24888.8888888889, type => 2 },{ id => 1, sLen => 0, time => 25111.1111111111, type => 0 },{ id => 2, sLen => 0, time => 25222.2222222222, type => 0 },{ id => 0, sLen => 0, time => 25333.3333333333, type => 0 },{ id => 2, sLen => 0, time => 25444.4444444444, type => 0 },{ id => 1, sLen => 0, time => 25555.5555555556, type => 0 },{ id => 3, sLen => 0, time => 25777.7777777778, type => 0 },{ id => 1, sLen => 0, time => 25888.8888888889, type => 0 },{ id => 2, sLen => 0, time => 26000, type => 0 },{ id => 0, sLen => 0, time => 26111.1111111111, type => 0 },{ id => 3, sLen => 0, time => 26222.2222222222, type => 0 },{ id => 0, sLen => 0, time => 26444.4444444444, type => 2 },{ id => 1, sLen => 0, time => 26444.4444444444, type => 2 },{ id => 2, sLen => 0, time => 26666.6666666667, type => 2 },{ id => 0, sLen => 0, time => 26888.8888888889, type => 2 },{ id => 2, sLen => 0, time => 27111.1111111111, type => 2 },{ id => 3, sLen => 142, time => 27111.1111111111, type => 2 },{ id => 1, sLen => 142, time => 27333.3333333333, type => 2 },{ id => 0, sLen => 0, time => 27555.5555555556, type => 2 },{ id => 3, sLen => 0, time => 27777.7777777778, type => 2 },{ id => 1, sLen => 0, time => 27888.8888888889, type => 2 },{ id => 2, sLen => 0, time => 28000, type => 2 },{ id => 0, sLen => 0, time => 28222.2222222222, type => 2 },{ id => 1, sLen => 1444.44444444442, time => 28444.4444444444, type => 2 },{ id => 3, sLen => 0, time => 28444.4444444444, type => 2 },{ id => 1, sLen => 0, time => 35555.5555555556, type => 2 },{ id => 0, sLen => 0, time => 35666.6666666667, type => 2 },{ id => 2, sLen => 0, time => 35777.7777777778, type => 2 },{ id => 0, sLen => 0, time => 35888.8888888889, type => 2 },{ id => 3, sLen => 0, time => 36000, type => 2 },{ id => 1, sLen => 0, time => 36111.1111111111, type => 2 },{ id => 2, sLen => 0, time => 36222.2222222222, type => 2 },{ id => 3, sLen => 0, time => 36333.3333333333, type => 2 },{ id => 0, sLen => 0, time => 36444.4444444444, type => 2 },{ id => 2, sLen => 0, time => 36555.5555555556, type => 2 },{ id => 1, sLen => 0, time => 36666.6666666667, type => 2 },{ id => 3, sLen => 0, time => 36777.7777777778, type => 2 },{ id => 1, sLen => 0, time => 36888.8888888889, type => 2 },{ id => 3, sLen => 0, time => 37000, type => 2 },{ id => 0, sLen => 0, time => 37111.1111111111, type => 2 },{ id => 0, sLen => 0, time => 37222.2222222222, type => 2 },{ id => 3, sLen => 0, time => 37333.3333333333, type => 2 },{ id => 2, sLen => 0, time => 37444.4444444444, type => 2 },{ id => 1, sLen => 0, time => 37555.5555555556, type => 2 },{ id => 2, sLen => 0, time => 37666.6666666667, type => 2 },{ id => 0, sLen => 0, time => 37777.7777777778, type => 2 },{ id => 1, sLen => 0, time => 37888.8888888889, type => 2 },{ id => 3, sLen => 0, time => 38000, type => 2 },{ id => 2, sLen => 0, time => 38111.1111111111, type => 2 },{ id => 0, sLen => 0, time => 38222.2222222222, type => 2 },{ id => 2, sLen => 0, time => 38333.3333333333, type => 2 },{ id => 3, sLen => 0, time => 38444.4444444444, type => 2 },{ id => 3, sLen => 0, time => 38555.5555555556, type => 2 },{ id => 1, sLen => 0, time => 38666.6666666667, type => 2 },{ id => 0, sLen => 0, time => 38777.7777777778, type => 2 },{ id => 3, sLen => 0, time => 38888.8888888889, type => 2 },{ id => 1, sLen => 0, time => 39000, type => 2 },{ id => 2, sLen => 0, time => 39111.1111111111, type => 2 },{ id => 3, sLen => 0, time => 39222.2222222222, type => 2 },{ id => 0, sLen => 0, time => 39333.3333333333, type => 2 },{ id => 2, sLen => 0, time => 39444.4444444444, type => 2 },{ id => 1, sLen => 0, time => 39555.5555555556, type => 2 },{ id => 0, sLen => 0, time => 39666.6666666667, type => 2 },{ id => 2, sLen => 0, time => 39777.7777777778, type => 2 },{ id => 3, sLen => 141.999999999978, time => 39888.8888888889, type => 2 },{ id => 1, sLen => 0, time => 40111.1111111111, type => 2 },{ id => 2, sLen => 0, time => 40222.2222222222, type => 2 },{ id => 0, sLen => 0, time => 40333.3333333333, type => 2 },{ id => 2, sLen => 0, time => 40444.4444444444, type => 2 },{ id => 3, sLen => 0, time => 40555.5555555556, type => 2 },{ id => 1, sLen => 0, time => 40666.6666666667, type => 2 },{ id => 2, sLen => 0, time => 40777.7777777778, type => 2 },{ id => 0, sLen => 0, time => 40888.8888888889, type => 2 },{ id => 1, sLen => 0, time => 41000, type => 2 },{ id => 3, sLen => 0, time => 41111.1111111111, type => 2 },{ id => 1, sLen => 0, time => 41222.2222222222, type => 2 },{ id => 2, sLen => 0, time => 41333.3333333333, type => 2 },{ id => 3, sLen => 0, time => 41444.4444444444, type => 2 },{ id => 0, sLen => 0, time => 41555.5555555556, type => 2 },{ id => 2, sLen => 0, time => 41666.6666666667, type => 2 },{ id => 1, sLen => 0, time => 41777.7777777778, type => 2 },{ id => 3, sLen => 0, time => 41888.8888888889, type => 2 },{ id => 2, sLen => 0, time => 42000, type => 2 },{ id => 0, sLen => 0, time => 42111.1111111111, type => 2 },{ id => 2, sLen => 0, time => 42222.2222222222, type => 2 },{ id => 1, sLen => 0, time => 42333.3333333333, type => 2 },{ id => 3, sLen => 0, time => 42444.4444444444, type => 2 },{ id => 0, sLen => 0, time => 42555.5555555556, type => 2 },{ id => 0, sLen => 0, time => 46219.7712418301, type => 1 },{ id => 1, sLen => 0, time => 46219.7712418301, type => 2 },{ id => 3, sLen => 0, time => 46440.3594771242, type => 0 },{ id => 3, sLen => 0, time => 46440.3594771242, type => 0 },{ id => 3, sLen => 0, time => 46440.3594771242, type => 0 },{ id => 1, sLen => 0, time => 46660.9477124183, type => 1 },{ id => 2, sLen => 0, time => 46660.9477124183, type => 2 },{ id => 0, sLen => 0, time => 46881.5359477124, type => 0 },{ id => 1, sLen => 0, time => 47102.1241830065, type => 0 },{ id => 2, sLen => 0, time => 47212.4183006536, type => 0 },{ id => 0, sLen => 0, time => 47322.7124183007, type => 0 },{ id => 2, sLen => 0, time => 47433.0065359477, type => 0 },{ id => 3, sLen => 0, time => 47543.3006535948, type => 0 },{ id => 1, sLen => 0, time => 47653.5947712418, type => 0 },{ id => 2, sLen => 0, time => 47763.8888888889, type => 0 },{ id => 0, sLen => 0, time => 47874.1830065359, type => 0 },{ id => 1, sLen => 0, time => 47984.477124183, type => 0 },{ id => 3, sLen => 0, time => 48094.7712418301, type => 0 },{ id => 0, sLen => 0, time => 48205.0653594771, type => 0 },{ id => 2, sLen => 0, time => 48315.3594771242, type => 0 },{ id => 1, sLen => 0, time => 48425.6535947712, type => 0 },{ id => 3, sLen => 0, time => 48535.9477124183, type => 0 },{ id => 2, sLen => 0, time => 48646.2418300654, type => 0 },{ id => 0, sLen => 142, time => 48756.5359477124, type => 2 },{ id => 1, sLen => 0, time => 48977.1241830065, type => 0 },{ id => 3, sLen => 0, time => 49087.4183006536, type => 0 },{ id => 2, sLen => 0, time => 49197.7124183007, type => 0 },{ id => 3, sLen => 0, time => 49308.0065359477, type => 0 },{ id => 0, sLen => 0, time => 49418.3006535948, type => 0 },{ id => 1, sLen => 0, time => 49528.5947712418, type => 0 },{ id => 2, sLen => 0, time => 49638.8888888889, type => 0 },{ id => 3, sLen => 0, time => 49749.1830065359, type => 0 },{ id => 0, sLen => 0, time => 49859.477124183, type => 0 },{ id => 2, sLen => 0, time => 49969.7712418301, type => 0 },{ id => 1, sLen => 0, time => 50080.0653594771, type => 0 },{ id => 3, sLen => 142, time => 50190.3594771242, type => 2 },{ id => 1, sLen => 0, time => 50410.9477124183, type => 0 },{ id => 0, sLen => 0, time => 50521.2418300654, type => 0 },{ id => 2, sLen => 0, time => 50631.5359477124, type => 0 },{ id => 3, sLen => 0, time => 50741.8300653595, type => 0 },{ id => 0, sLen => 0, time => 50852.1241830065, type => 0 },{ id => 1, sLen => 142, time => 51072.7124183007, type => 2 },{ id => 3, sLen => 0, time => 51293.3006535948, type => 0 },{ id => 2, sLen => 0, time => 51403.5947712418, type => 0 },{ id => 0, sLen => 0, time => 51513.8888888889, type => 0 },{ id => 1, sLen => 0, time => 51624.1830065359, type => 0 },{ id => 3, sLen => 0, time => 51734.477124183, type => 0 },{ id => 1, sLen => 0, time => 51844.7712418301, type => 0 },{ id => 2, sLen => 0, time => 51955.0653594771, type => 2 },{ id => 0, sLen => 0, time => 52065.3594771242, type => 0 },{ id => 2, sLen => 0, time => 52175.6535947712, type => 0 },{ id => 3, sLen => 0, time => 52285.9477124183, type => 0 },{ id => 1, sLen => 0, time => 52396.2418300654, type => 0 },{ id => 2, sLen => 0, time => 52506.5359477124, type => 0 },{ id => 0, sLen => 0, time => 52616.8300653595, type => 0 },{ id => 3, sLen => 0, time => 52727.1241830065, type => 0 },{ id => 0, sLen => 0, time => 52837.4183006536, type => 2 },{ id => 2, sLen => 0, time => 52947.7124183007, type => 0 },{ id => 1, sLen => 0, time => 53058.0065359477, type => 0 },{ id => 0, sLen => 0, time => 53168.3006535948, type => 0 },{ id => 2, sLen => 0, time => 53278.5947712418, type => 2 },{ id => 3, sLen => 0, time => 53388.8888888889, type => 2 },{ id => 0, sLen => 0, time => 53499.1830065359, type => 2 },{ id => 2, sLen => 0, time => 53609.477124183, type => 2 },{ id => 1, sLen => 0, time => 53719.7712418301, type => 2 },{ id => 3, sLen => 0, time => 53830.0653594771, type => 2 },{ id => 0, sLen => 0, time => 53940.3594771242, type => 2 },{ id => 1, sLen => 0, time => 54050.6535947712, type => 2 },{ id => 3, sLen => 0, time => 54160.9477124183, type => 2 },{ id => 1, sLen => 0, time => 54271.2418300654, type => 2 },{ id => 2, sLen => 0, time => 54381.5359477124, type => 2 },{ id => 0, sLen => 0, time => 54491.8300653595, type => 2 },{ id => 1, sLen => 0, time => 54602.1241830065, type => 2 },{ id => 3, sLen => 0, time => 54712.4183006536, type => 2 },{ id => 2, sLen => 0, time => 54822.7124183007, type => 2 },{ id => 1, sLen => 0, time => 54933.0065359477, type => 2 },{ id => 2, sLen => 0, time => 55043.3006535948, type => 0 },{ id => 3, sLen => 0, time => 55153.5947712418, type => 2 },{ id => 1, sLen => 0, time => 55263.8888888889, type => 2 },{ id => 0, sLen => 0, time => 55374.183006536, type => 0 },{ id => 3, sLen => 0, time => 55484.477124183, type => 2 },{ id => 1, sLen => 0, time => 55594.7712418301, type => 2 },{ id => 2, sLen => 0, time => 55705.0653594771, type => 0 },{ id => 0, sLen => 0, time => 55815.3594771242, type => 2 },{ id => 3, sLen => 0, time => 55925.6535947712, type => 2 },{ id => 2, sLen => 0, time => 56035.9477124183, type => 2 },{ id => 1, sLen => 0, time => 56146.2418300654, type => 2 },{ id => 2, sLen => 0, time => 56256.5359477124, type => 2 },{ id => 0, sLen => 0, time => 56366.8300653595, type => 2 },{ id => 3, sLen => 0, time => 56477.1241830065, type => 2 },{ id => 0, sLen => 0, time => 56587.4183006536, type => 2 },{ id => 1, sLen => 0, time => 56697.7124183007, type => 2 },{ id => 2, sLen => 0, time => 56808.0065359477, type => 2 },{ id => 3, sLen => 0, time => 57028.5947712418, type => 2 },{ id => 0, sLen => 0, time => 57138.8888888889, type => 2 },{ id => 2, sLen => 0, time => 57249.183006536, type => 2 },{ id => 1, sLen => 0, time => 57359.477124183, type => 2 },{ id => 3, sLen => 0, time => 57469.7712418301, type => 2 },{ id => 1, sLen => 0, time => 57580.0653594771, type => 2 },{ id => 2, sLen => 0, time => 57690.3594771242, type => 2 },{ id => 0, sLen => 0, time => 57800.6535947712, type => 2 },{ id => 2, sLen => 0, time => 57910.9477124183, type => 2 },{ id => 1, sLen => 0, time => 58021.2418300654, type => 2 },{ id => 2, sLen => 0, time => 58131.5359477124, type => 2 },{ id => 3, sLen => 0, time => 58241.8300653595, type => 2 },{ id => 0, sLen => 0, time => 58352.1241830065, type => 2 },{ id => 2, sLen => 0, time => 58462.4183006536, type => 2 },{ id => 3, sLen => 2095.58823529416, time => 58572.7124183007, type => 2 }'];
function setScale(f:FlxSprite,scale:Float) {
    f.scale.set(scale,scale);
    f.updateHitbox();
    return;
}

function generateGraphic(sprite:FlxSprite, width:Float,height:Float,color:FlxColor = FlxColor.WHITE):FlxSprite
{
    sprite.makeGraphic(1,1,color);
    sprite.setGraphicSize(Std.int(width),Std.int(height));
    sprite.updateHitbox();
    return sprite;
}

function graphicSize(sprite:FlxSprite, width:Float = 0, height:Float = 0, updatehitbox = true):FlxSprite
{
    if (width <= 0 && height <= 0)
        return sprite;

    var newScaleX:Float = width / sprite.frameWidth;
    var newScaleY:Float = height / sprite.frameHeight;
    sprite.scale.set(newScaleX, newScaleY);

    if (width <= 0)
        sprite.scale.x = newScaleY;
    else if (height <= 0)
        sprite.scale.y = newScaleX;

    if (updatehitbox) sprite.updateHitbox();
    return sprite;
}

function addnoteitselfect1(image:String,path:String,scale:Float,scrollF:Array<Float>,centerAxis:String,offsets:Array<Float>,isForeground:Bool,phase:Int,fps:Int) {
    var dir = 'obituary';
    if (phase == 1) dir = 'sunset'; 
    var f = new FlxSprite();
    f.frames = Paths.getSparrowAtlas('stages/' + dir + '/' + path);
    f.animation.addByPrefix('i',image,fps);
    f.animation.play('i');
    
    setScale(f,scale);
    f.scrollFactor.set(scrollF[0],scrollF[1]);
    if (centerAxis == 'x') f.screenCenter(FlxAxes.X);
    else if (centerAxis == 'y') f.screenCenter(FlxAxes.Y);
    else if (centerAxis == 'xy') f.screenCenter();
    f.x += offsets[0];
    f.y += offsets[1];
    if (isForeground) insert(999, f);
    else add(f);
    if (phase == 1) fakerBG.push(f);
    else if (phase == 2)scaryBG.push(f);
    else if (phase == 3)thirdBG.push(f);
    f.antialiasing = true;
}

var black:FlxSprite;
var braindeadBF:FlxSprite;
var monitor:FlxSprite;
var blackBars:Array<FlxSprite> = [];

var newBF:Character;
var exe:Character;
var bfparsed;
var exeparsed;
var heatShader = new CustomShader("heatShader");

function parseNotes(raw:String):Array<Dynamic> {
    var clean = raw;

    clean = StringTools.replace(clean, "[", "");
    clean = StringTools.replace(clean, "]", "");
    clean = StringTools.replace(clean, "'", "");

    var parts = clean.split("},{");

    var result:Array<Dynamic> = [];

    for (p in parts) {
        p = StringTools.replace(p, "{", "");
        p = StringTools.replace(p, "}", "");

        var noteitself:Dynamic = {};

        var fields = p.split(",");

        for (f in fields) {
            var kv = f.split("=>");
            if (kv.length < 2) continue;

            var key = StringTools.trim(kv[0]);
            var val = StringTools.trim(kv[1]);

            switch (key) {
                case "id": noteitself.id = Std.parseInt(val);
                case "time": noteitself.time = Std.parseFloat(val);
                case "type": noteitself.type = Std.parseInt(val);
                case "sLen": noteitself.sLen = Std.parseFloat(val);
            }
        }

        result.push(noteitself);
    }

    return result;
}
var bfNotesArray:Array<Notes> = [];
var exeNotesArray:Array<Notes> = [];
var fuckassOverlay:FunkinSprite;
function createtheNotes(who:Array<Notes>,strum:StrumLine){
    for (n in who) {

        var prev:Note = null;
        n.sLen = n.sLen/1;
        var sustain:Bool = n.sLen > 0.1;
        var len:Float = n.sLen;

        var noteData:ChartNote = {
            id: n.id,
            time: n.time,
            type: n.type
        };

        var mainNote = new Note(
            strum,
            noteData,
            sustain,
            n.sLen,
            0,
            if(prev != null) prev
        );

        who.push(mainNote);
        prev = mainNote;

        if (sustain && len > Conductor.stepCrochet * 0.75) {

            var curLen:Float = 0;
            var sustainOffset:Float = 0;
            while (len > 10) {

                curLen = Math.min(len, Conductor.stepCrochet);

                var tail:Note = new Note(
                    strum,
                    noteData,
                    true,
                    curLen,
                    sustainOffset,
                    prev
                );

                who.push(tail);

                // chain
                prev.sustainParent = mainNote;
                mainNote.tailCount++;

                prev = tail;

                len -= curLen;
                sustainOffset += curLen;
            }
        }
    }
}
function create() {
    camGame.zoom = 1.3;
    camOther.zoom = camHUD.zoom;
    camOther.x = camHUD.x;
    camOther.y = camHUD.y;
    camGame.zoom = 1.5;
	FlxG.cameras.add(camOther, false);
    camOther.bgColor = 0;
    camOther.alpha = 1;
}
var camOther = new FlxCamera();

function postCreate() {
    if(precache){
            bfparsed = parseNotes(bfNotes);
            exeparsed = parseNotes(exeNotes);

            var p3Offsets:Array<Float> = [100,100];

            p3Video = new FlxVideoSprite();
            p3Video.load(Assets.getPath(Paths.video('makeaGif')), [':input-repeat=65535']);
            p3Video.camera = camGame;
            p3Video.play();
            p3Video.scale.set(2,2.5);
            p3Video.y += -150;
            p3Video.x += 100;
            add(p3Video);
            p3Video.visible = false;
            addnoteitselfect1('henges3','p2/bgFiles',0.825,[0.8,0.8],'xy',[-50+p3Offsets[0],-120+p3Offsets[1]],false,3,12);

            addnoteitselfect1('Smoke1','p2/smoke',0.825,[0.7,0.7],'0',[-275,-150],false,3,24);

            addnoteitselfect1('Smoke2','p2/smoke',0.825,[0.7,0.7],'0',[1000,-125],false,3,24);


            firebgbottom = new FlxSprite();
            generateGraphic(firebgbottom,3813,767,0xFFF4260A);
            firebgbottom.scrollFactor.set(0.8,0.8);
            firebgbottom.screenCenter();
            add(firebgbottom);
            thirdBG.push(firebgbottom);

            firebgbottomL = new FlxSprite();
            generateGraphic(firebgbottomL,3813,767,0xFFF4260A);
            firebgbottomL.scrollFactor.set(0.8,0.8);
            firebgbottomL.screenCenter();
            graphicSize(firebgbottomL,1000,767);
            firebgbottomL.x += 500;
            add(firebgbottomL);
            thirdBG.push(firebgbottomL);

            fireBG = new FlxSprite();
            fireBG.frames = Paths.getSparrowAtlas('stages/obituary/p2/FireBG');
            fireBG.animation.addByPrefix('i','FIRE instancia 1',24);
            fireBG.animation.play('i');
            setScale(fireBG,0.825);
            fireBG.screenCenter();
            fireBG.scrollFactor.set(0.8,0.8);
            fireBG.y += -50;
            add(fireBG);
            thirdBG.push(fireBG);

            firebgbottom.y = fireBG.y + fireBG.height - 250;
            firebgbottomL.y = fireBG.y + fireBG.height - 350;

            addnoteitselfect1('pike1','p2/bgFiles',0.825,[0.9,0.9],'xy',[-610+p3Offsets[0],100+p3Offsets[1]],false,3,12);

            addnoteitselfect1('pike2','p2/bgFiles',0.825,[0.9,0.9],'xy',[-210+p3Offsets[0],100+p3Offsets[1]],false,3,12);

            addnoteitselfect1('pike3','p2/bgFiles',0.825,[0.9,0.9],'xy',[610+p3Offsets[0],0+p3Offsets[1]],false,3,12);

            addnoteitselfect1('floor3','p2/bgFiles',0.825,[1,1],'xy',[-50+p3Offsets[0],200+p3Offsets[1]],false,3,12);

            addnoteitselfect1('head','p2/bgFiles',0.825,[1,1],'xy',[-334+p3Offsets[0],535+p3Offsets[1]],true,3,12);

            addnoteitselfect1('fgLEFT','p2/bgFiles',0.825,[1.25,1.25],'xy',[-1200+p3Offsets[0],700+p3Offsets[1]],true,3,12);

            addnoteitselfect1('fgRIGHT','p2/bgFiles',0.825,[1.25,1.25],'xy',[1200+p3Offsets[0],600+p3Offsets[1]],true,3,12);
    
            for(i in thirdBG) i.alpha = 0;

            newBF = new Character(770, 175, 'BF-Obituary', true);
            newBF.draw();
            newBF.active = true;
            newBF.visible = false;
            stage.applyCharStuff(newBF, boyfriend);
            remove(newBF);

            exe = new Character(25, 175, 'SonicEXE-Obituary-P3', false);
            exe.draw();
            exe.active = true;
            exe.visible = false;
            stage.applyCharStuff(exe, dad);
            remove(exe);

            obituaryChart = Chart.parse('obituary', difficulty = 'hard', variation = null);
            obitInst = FlxG.sound.load(Assets.getMusic(Paths.inst('obituary', 'hard')));
            obitVoices = Paths.voices('obituary','hard');

        for (n in bfparsed) {

            var prev:Note = null;
            n.sLen = n.sLen/1;
            var sustain:Bool = n.sLen > 0.1;
            var len:Float = n.sLen;

            var noteData:ChartNote = {
                id: n.id,
                time: n.time,
                type: n.type
            };

            var mainNote = new Note(
                player,
                noteData,
                false,
                0,
                0,
                null
            );

            bfNotesArray.push(mainNote);
            prev = mainNote;

            if (sustain && len > Conductor.stepCrochet * 0.75) {

                var curLen:Float = 0;
                var sustainOffset:Float = 0;
                while (len > 10) {

                    curLen = Math.min(len, Conductor.stepCrochet);

                    var tail:Note = new Note(
                        player,
                        noteData,
                        true,
                        curLen,
                        sustainOffset,
                        prev
                    );

                    bfNotesArray.push(tail);

                    // chain
                    prev.sustainParent = mainNote;
                    mainNote.tailCount++;

                    prev = tail;

                    len -= curLen;
                    sustainOffset += curLen;
                }
            }
            }
            var i:Int = 0;

    for (n in exeparsed) {

            var prev:Note = null;
            n.sLen = n.sLen/1;
            var sustain:Bool = n.sLen > 0.1;
            var len:Float = n.sLen;
            i++;
            var noteData:ChartNote = {
                id: n.id,
                time: n.time,
                type: n.type
            };
            var mainNote = new Note(
                cpu,
                noteData,
                false,
                0,
                0,
                null
            );
            mainNote.alpha = 0;
            exeNotesArray.push(mainNote);
            prev = mainNote;

            if (sustain && len > Conductor.stepCrochet * 0.75) {

                var curLen:Float = 0;
                var sustainOffset:Float = 0;
                while (len > 10) {

                    curLen = Math.min(len, Conductor.stepCrochet);

                    var tail:Note = new Note(
                        cpu,
                        noteData,
                        true,
                        curLen,
                        sustainOffset,
                        prev
                    );
                    tail.alpha = 0;
                    exeNotesArray.push(tail);

                    // chain
                    prev.sustainParent = mainNote;
                    mainNote.tailCount++;

                    prev = tail;

                    len -= curLen;
                    sustainOffset += curLen;
                }
            }
            }

            // for (n in exeparsed) {
            //     var sustain:Bool = n.sLen > 0;
            //     var sLen:Float = n.sLen;

            //     var noteData:ChartNote = {id: n.id, time: n.time, type: n.type};

            //     var note = new Note(cpu, noteData, sustain, sLen, 0, sLen);
            //     exeNotesArray.push(note);
            // }
        }

    fuckassOverlay = new FunkinSprite(0,0,Paths.image('stages/obituary/p2/fuckassOverlay'));    
    setScale(fuckassOverlay,0.7);
    fuckassOverlay.screenCenter();
    fuckassOverlay.visible = false;
    fuckassOverlay.alpha = 0.7;
    fuckassOverlay.blend = BlendMode.ADD;
    fuckassOverlay.camera = camOther;
    add(fuckassOverlay);

    var blackBar = new FlxSprite();
    generateGraphic(blackBar,FlxG.width,65,0xFF000000);
    add(blackBar);
    blackBar.cameras = [camOther];
    blackBars.push(blackBar);

    var blackBar = new FlxSprite(0,FlxG.height-65);
    generateGraphic(blackBar,FlxG.width,65,0xFF000000);
    add(blackBar);
    blackBar.cameras = [camOther];
    blackBars.push(blackBar);

    var blackBar = new FlxSprite();
    generateGraphic(blackBar,310,FlxG.height,0xFF000000);
    add(blackBar);
    blackBar.cameras = [camOther];
    blackBars.push(blackBar);

    var blackBar = new FlxSprite(980);
    generateGraphic(blackBar,310,FlxG.height,0xFF000000);
    add(blackBar);
    blackBar.cameras = [camOther];
    blackBars.push(blackBar);

    braindeadBF = new FlxSprite();
    braindeadBF.frames = Paths.getSparrowAtlas('stages/obituary/p1/bfreflection');
    braindeadBF.animation.addByPrefix('i','braindead',24);
    braindeadBF.animation.play('i');
    braindeadBF.cameras = [camOther];
    braindeadBF.screenCenter();
    add(braindeadBF);
    braindeadBF.scale.set(0.85,0.85);

    monitor = new FlxSprite(199.9, -26.6);
    monitor.frames = Paths.getSparrowAtlas('userinterface/desktop/bgLayers');
    monitor.animation.addByPrefix('on','monitorOn instance 1',12);
    monitor.animation.addByPrefix('off','monitorOff instance 1',12);
    monitor.animation.play('on');
    add(monitor);
    monitor.cameras = [camOther];
    // camOther.zoom = 2.2;
    braindeadBF.alpha = 0;
    monitor.visible = false;
    for (i in blackBars) i.visible = false;

}
var obituarytime;
var evil:Bool = false;
var itime:Float = 0;
function update(elapsed:Float) {
    if(obituarytime) for(strum in strumLines) strum.vocals.volume = 0;
    if(evil){
    itime+=elapsed;
    heatShader.iTime = itime;
  }
}

function setZoomGame(zoom:Int){
    defaultCamZoom = zoom;
}
function camGameZoomLerp(lerp:Float){
    camGameZoomLerp = lerp;
}


function onEvent(e){
	if(e.event.name == 'Obituary Jumpscare'){
        camGame.filters = [];
        camHUD.filters = [];
        boyfriend.shader = dad.shader = null;
        defaultCamZoom = 0.75;
        FlxG.camera.zoom = 0.75;
        vocals.stop();
        vocals.volume = 0;
        Conductor.songPosition = 0;

        PlayState.SONG = obituaryChart;
        PlayState.instance.generateSong(obituaryChart);
        PlayState.curSong = 'obituary';
        PlayState.curSongID = 'obituary';
        PlayState.difficulty = 'Hard';
        Conductor.setupSong(obituaryChart);
        Conductor.songPosition = 0;
        PlayState.instance.startSong();


        iconP2.setIcon('p3');
        iconP1.setIcon('bfs');

        evil = true;
        camHUD.flash(0xFFFF0000, 0.5);
        camGame.addShader(heatShader);
        fuckassOverlay.visible = true;

        for (strumLine in strumLines.members) {
            //strumLine.notes.forEach((note) -> {
                //strumLine.notes.remove(note, true);
            //});
            strumLine.notes.preallocate(0);
        }

        playerStrums.notes.addNotes(bfNotesArray);
        cpuStrums.notes.addNotes(exeNotesArray);
        for(i in cpuStrums) i.alpha = 0;

        // playerStrums.generate('BF-Obituary', 1, bfNotes, 'boyfriend', true, 0.5);
        // trace(playerStrums.notes);
        //playerStrums.generate(obituaryChart, 0);
        // PlayState.instance.SONG.strumLines[0].notes = [];
        // PlayState.instance.SONG.strumLines[1].notes = [];

        // PlayState.instance.SONG.strumLines[0].notes = bfObitData;
        // PlayState.instance.SONG.strumLines[1].notes = exeObitData;
        //trace(PlayState.instance.SONG.strumLines[1].notes);
        // FlxG.sound.music.loadEmbedded(Paths.inst('obituary', 'hard'), false);
        // FlxG.sound.music.play();
        // //PlayState.vocals.play();
        // PlayState.vocals = obitVoices;
        for(i in stage.stageSprites) i.visible = false;
        p3Video.visible = true;
        for(i in thirdBG) i.alpha = 1;
        newBF.visible = true;
        insert(99,newBF);
        boyfriend = newBF;
        exe.visible = true;
        insert(99,exe);
        dad = exe;

        obituarytime = true;
        // remove(boyfriend, true);
        // boyfriend.active = false;
        
    }

}

function zoomOut(){
    camZooming = false;
    defaultCamZoom = 1.75;
    FlxTween.tween(FlxG.camera, {zoom: 0.65}, 6, {ease: FlxEase.quadOut, onComplete: function(v:FlxTween){
        defaultCamZoom = 0.65;
    }});
    FlxTween.tween(black, {alpha: 0}, 6, {ease: FlxEase.quadInOut, onComplete: function(v:FlxTween){
        black.visible = false;
    }});

    for(i in scaryBG) i.visible = false;
    for(i in thirdBG) i.visible = true;
    for(s in strumLines){
        for(note in cpuStrums.members)
            {
              FlxTween.tween(note, {alpha: 0}, 0.01);
            }
    }
}

function endZoom(){
                camOther.zoom = 2.2;
                monitor.visible = true;
                camGame.removeShader(heatShader);
                camGame.addShader(crtShader);

                for (i in blackBars) i.visible = true;

                FlxTween.tween(camHUD, {alpha: 0},0.3, {ease: FlxEase.sineOut});
                FlxTween.tween(camOther, {zoom: 1},1.25, {ease: FlxEase.sineOut});
                camZooming = false;
                camFollow.x = dad.getGraphicMidpoint().x + ((boyfriend.getGraphicMidpoint().x - dad.getGraphicMidpoint().x)/2);
                camZoomingInterval = 11111111;
                FlxTween.cancelTweensOf(camGame);
                FlxTween.tween(FlxG.camera, {zoom: 0.36}, 1.25, {ease: FlxEase.sineOut, onComplete: function(v:FlxTween){
                    camZooming = false;
                    defaultCamZoom = 0.36;
                    trace(camGame.zoom);                
                }});
                camZooming = false;
                FlxTween.tween(fuckassOverlay, {alpha: 0},0.5, {ease: FlxEase.sineOut});

                FlxTween.num(0, 5.0, 3.5, {ease: FlxEase.sineOut, update: function(v:FlxTween){
                    crtShader.data.warp.value = [v.value];
                }});
}
function end(){
    monitor.animation.play('off');
    black.alpha = 1;
    black.visible = true;
    FlxTween.tween(braindeadBF, {alpha: 1},0.4, {startDelay: 0.4});
    FlxTween.tween(braindeadBF, {alpha: 0},0.4, {startDelay: 5});
}

function fadeinreal(){
    black.visible = true;
    black.alpha = 0;
    FlxTween.tween(black, {alpha: 1}, 2.5, {ease: FlxEase.quadInOut}); 
}

function onNoteHit(event){
    if (event.note.noteType == "Alt Animation")
        event.animSuffix = "-alt"; //YOOOOOOOOO
    if (event.note.noteType == "No Animation") event.cancelAnim(); //2nd best line ever i think idk
} 