function create() {
    PlayState.instance.introLength = 0.01;
    PlayState.instance.doIconBop = false;
}
function onCountdown(event) event.cancel();
function onCameraMove(e) e.cancel();
function postCreate() {
	camFollow.x = 155;
	camFollow.y = 100;
}