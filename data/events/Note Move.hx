import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
/*
            for(i in playerStrums.members){
            if(i.ID == 0)  FlxTween.tween(i, {x: 50}, 0.7, {ease: FlxEase.circOut});
            if(i.ID == 1)  FlxTween.tween(i, {x: 200}, 0.7, {ease: FlxEase.circOut});
            if(i.ID == 2)  FlxTween.tween(i, {x: 950}, 0.7, {ease: FlxEase.circOut});
            if(i.ID == 3)  FlxTween.tween(i, {x: 1100}, 0.7, {ease: FlxEase.circOut});
            FlxTween.tween(i, {angle: 360}, 0.7, {ease: FlxEase.circOut});
            //trace(i.ID);
            
            }*/
function onEvent(event){
    if (event.event.name != "Note Move") return;

    var whereTo = event.event.params[0];
    var moveSpeed = event.event.params[1];
    trace(whereTo);
    trace(moveSpeed);

    switch(whereTo){
        case "Swap (Left To Right)":
            trace("Swapping Notes Left To Right");
        case "Swap (Right To Left)":
            trace("Swapping Notes Right To Left");
        case "To Middlescroll":
            trace("Moving Notes To Middlescroll");
        case "Middlescroll (Edges)":
            for(i in playerStrums.members){
            if(i.ID == 0)  FlxTween.tween(i, {x: 50}, moveSpeed, {ease: FlxEase.circOut});
            if(i.ID == 1)  FlxTween.tween(i, {x: 200}, moveSpeed, {ease: FlxEase.circOut});
            if(i.ID == 2)  FlxTween.tween(i, {x: 950}, moveSpeed, {ease: FlxEase.circOut});
            if(i.ID == 3)  FlxTween.tween(i, {x: 1100}, moveSpeed, {ease: FlxEase.circOut});
            FlxTween.tween(i, {angle: 360}, moveSpeed, {ease: FlxEase.circOut});
            //trace(i.ID);
            
            }
    }
}
