function update(){
    for(i in iconArray){
        if(songInstPlaying && i.alpha == 1) i.updateBump();
        bg.scale.x = bg.scale.y = lerp(bg.scale.x, 1, 0.015);

    }
}
function beatHit(){
    for(i in iconArray){
        if(songInstPlaying && i.alpha == 1) i.bump();
        bg.scale.x = bg.scale.y += 0.005;
    }
}