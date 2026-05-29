import modchart.Manager;
import modchart.Config;

var mngr:Manager = new Manager();

function postCreate() {
	add(mngr);
	mngr.setPercent("alpha", 0, 0);

	Config.OPTIMIZE_HOLDS = true;
	Config.HOLD_END_SCALE = 0.5;

	// tried recreating leaked majin modchart

	// mngr.addModifier('CenterRotate');
	// mngr.setPercent('CenterRotateX', -110, 1);

	// mngr.addModifier('Skew');

	// for (i in 0...100) {
	// 	var val = (i % 2 == 0) ? 10 : -10;
	// 	mngr.ease('SkewX', i - 1, 1, val, FlxEase.smoothStepInOut, 1);
	// 	mngr.ease('y', i * 0.5, 0.5, val, FlxEase.smoothStepInOut, 1);
	// }

	// strumLines.members[1].notes.limit = 2000;

	// mngr.addModifier('OpponentSwap');
	// mngr.setPercent('OpponentSwap', 0.5, 1);
}

// i could use instance.set but e hh
function stepHit(_:Int) if (_ == 75) {
	mngr.addModifier('Rotate');

	// mngr.addModifier('ZigZag');
	// mngr.setPercent('ZigZag', 0.1, 1);

	mngr.addModifier('drunk');
	mngr.setPercent('drunk', 0.6, 1);

	mngr.addModifier('tipsy');
	mngr.setPercent('tipsy', 0.45, 1);
}

function update() if (curStep >= 75) {
	mngr.setPercent('RotateZ', FlxMath.fastSin(Conductor.curBeatFloat * 0.6) * 10, 1);
}