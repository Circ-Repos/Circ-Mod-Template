function postCreate(){
    comboGroup.setPosition(200,500);
camRating = new FlxCamera();
camRating.bgColor = 0;
FlxG.cameras.add(camRating,false);

FlxG.cameras.remove(camHUD,false);
FlxG.cameras.add(camHUD,false);
}

function postUpdate() {
for(thingy in comboGroup.group.members){
thingy.camera = camRating;
}
    
camRating.angle = camHUD.angle;
camRating.zoom = camHUD.zoom;
}

function update(){
comboGroup.scale.set(CoolUtil.fpsLerp(comboGroup.scale.x,0.6,0.2),CoolUtil.fpsLerp(comboGroup.scale.y,0.6,0.2));

for(thingy in comboGroup.group.members){
thingy.velocity.x = 0;
thingy.velocity.y = 0;
thingy.acceleration.y = 0;
}

}

function onPlayerHit(e){
if(e.note.isSustainNote) return;
comboGroup.scale.set(0.75,0.75);
for(thingy in comboGroup.group.members) thingy.visible = false;
}


function onPostNoteCreation(e){
if(e.note.isSustainNote)
e.note.alpha = 1;
}