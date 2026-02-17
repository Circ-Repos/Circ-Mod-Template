notesCount = -1;
function postUpdate(){
if (notesCount != notesGroup.members.length){
for (i in notesGroup) updateNot(i,noteTypes[i.type-1]);
notesCount = notesGroup.members.length;
}
}
anims = ['purple0','blue0','green0','red0'];
function updateNot(no,type){
texture = '';
if (type == 'Ice Note') texture = 'game/notes/ice/NOTE_ASSETS';
if (texture != ''){
no.frames = Paths.getSparrowAtlas(texture);
no.animation.addByPrefix('idle',anims[no.id]);
no.animation.play('idle');
no.angle = 0;
no.offset.x += 15;
no.offset.y += 18;
}
}