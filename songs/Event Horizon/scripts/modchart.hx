import modchart.Manager;
import modchart.Config;

var mngr:Manager = new Manager();

function postCreate() {
	add(mngr);
	Config.OPTIMIZE_HOLDS = true;
	Config.RENDER_ARROW_PATHS = false;
	Config.HOLDS_BEHIND_STRUM = true;
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

	mngr.addModifier('SchmovinDrunk');
	mngr.addModifier('SchmovinTipsy');
	mngr.addModifier('Radionic');
	mngr.addModifier('Beat');
	mngr.addModifier('Bounce');
	mngr.addModifier('ReceptorScroll');
	mngr.addModifier('Reverse');
	mngr.addModifier('Invert');
}
function stepHit(curStep){

	switch(curStep){
		case 75:
			mngr.setPercent('SchmovinTipsy', 1, 1);
		case 404:
			mngr.setPercent('SchmovinTipsy', 0, 1);
			mngr.setPercent('Radionic',1,1);
		case 516:
			mngr.setPercent('Radionic',0,1);
		case 532:
			mngr.setPercent('Beat',1,1);
			mngr.setPercent('Bounce',1,1);
		case 773:
			mngr.setPercent('Beat',0,1);
			mngr.setPercent('Bounce',0,1);
			mngr.setPercent('ReceptorScroll',1,1);
		case 852:
			mngr.setPercent('ReceptorScroll',0,1);
			//mngr.setPercent('Reverse',1,1);
			mngr.setPercent('SchmovinTipsy', 1, 1);

	}
}

// function update() if (curStep >= 75 && !(curStep > 404)) {
// 	mngr.setPercent('RotateZ', FlxMath.fastSin(Conductor.curBeatFloat * 0.6) * 10, 1);
// }