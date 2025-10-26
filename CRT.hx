//shaders
var crtShader:CustomShader;
var crtBlur:CustomShader;
var static:CustomShader;
var vhs1:CustomShader;
var fishEye:CustomShader;
// var bloomwave:CustomShader;
// var staticshader:CustomShader;
// var chromaticAberration:CustomShader;
// var beautifyShader:CustomShader;
// var cutsShader:CustomShader;
// var crtblue:CustomShader;

function create() {
    // crtShader = new CustomShader("CRT");
	// camGame.addShader(crtShader);
	fishEye = new CustomShader("fisheye");
	camHUD.addShader(fishEye);
	// bloomwave = new CustomShader("bloomwave");
	// camGame.addShader(bloomwave);
	// staticshader = new CustomShader("static");
	// camGame.addShader(staticshader);
	// chromaticAberration = new CustomShader("chromaticAberration");
	// camGame.addShader(chromaticAberration);

	// beautifyShader = new CustomShader("beautifyBG");
	// //camGame.addShader(beautifyShader);

	// cutsShader = new CustomShader("cuts");
	// camGame.addShader(cutsShader);
	// bloomwave.intensity = 6;
	// bloomwave.bloom = 0.1;
	// crtBlue = new CustomShader("crtblue");
	// camHUD.addShader(crtBlue);
	// vhs1 = new CustomShader("vhs1");
	// camGame.addShader(vhs1);
	// crtBlur = new CustomShader("needleBlur");
	// camGame.addShader(crtBlur);
	// crtShader = new CustomShader("needleVCR");
	//camGame.addShader(crtShader);

}

var itimef:Float = 0;
var itime:Float = 0;
function update(elapsed:Float) {
	itimef += elapsed;
	itime += itimef;
	// crtShader.itime += itimef;
	// vhs1.itime += itimef;
	// bloomwave.iTime = itime;
	// staticshader.iTime = itime;
	// chromaticAberration.iTime = itime;
	//beautifyShader.iTime = itime;
}
function destroy() {
	// camGame.removeShader(crtBlur);
	// camGame.removeShader(crtShader);
	//camGame.removeShader(fishEye);
	// camGame.removeShader(bloomwave);
	// camGame.removeShader(staticshader);
	// camGame.removeShader(chromaticAberration);
	// //camGame.removeShader(beautifyShader);
	// camGame.removeShader(cutsShader);
	// camHUD.removeShader(crtBlue);
}

