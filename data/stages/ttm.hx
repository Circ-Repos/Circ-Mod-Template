import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import funkin.backend.system.Conductor;

// var downscrollTweening = false;
// function tweenDownscroll(toDown:Bool, duration:Float = 1)
// {
//     if (downscrollTweening) return;
//     downscrollTweening = true;

//     // Set the global flag (so future spawns use the new direction)
//     downScroll = toDown;                       // global variable used by spawner
//     FlxG.save.data.downScroll = toDown;        // persist

//     var ps = PlayState.instance;
//     var targetY = toDown ? (FlxG.height - 150) : 50;

//     // Tween strumline arrows
//     for (s in player.members)
//     {
//         if (s == null) continue;
// 		player.members[s].angle = 0;

//         FlxTween.tween(s, { y: targetY }, duration, { ease: FlxEase.sineInOut });
//         FlxTween.tween(s, { angle: 360 }, duration, { ease: FlxEase.sineInOut });
	
//     }
//     for(i in player.notes.members) i.noteAngle = 180;
//     // Tween active notes safely (use FlxTween.num to avoid direct-field issues)
//     for (n in player.notes)
//     {
//         if (n == null || !n.exists) continue;

//         var desiredY = toDown ? (FlxG.height - n.distance) : n.distance;
//         // capture local ref for closure
//         var localN = n;
//         FlxTween.num(localN.y, desiredY, duration, {
//             ease: FlxEase.sineInOut,
//             onUpdate: function(val:Float) { localN.y = val; }
//         });
//     }

//     // End tween bookkeeping
//     FlxTween.num(0, 1, duration, {
//         onComplete: function(_)
//         {
//             downscrollTweening = false;
//         }
//     });
// }
// function update(elapsed:Float) {
// 	if(curStep > 744){
// 		for(i in 0...player.length) player.members[i].noteAngle = 180;

// 	}
// }

function stepHit(curStep:Int) {
	switch(curStep){
		case 744:
			FlxTween.tween(boyfriend, {y: -1400}, 0.9, {ease: FlxEase.circOut});
			FlxTween.tween(boyfriend, {angle: 180}, 1, {ease: FlxEase.circOut});
			FlxTween.tween(FlxG.camera, {angle: 180}, 0.7, {ease: FlxEase.circOut});
            // for(i in playerStrums.members){
            // if(i.ID == 0)  FlxTween.tween(i, {x: 50}, 0.7, {ease: FlxEase.circOut});
            // if(i.ID == 1)  FlxTween.tween(i, {x: 200}, 0.7, {ease: FlxEase.circOut});
            // if(i.ID == 2)  FlxTween.tween(i, {x: 950}, 0.7, {ease: FlxEase.circOut});
            // if(i.ID == 3)  FlxTween.tween(i, {x: 1100}, 0.7, {ease: FlxEase.circOut});
            // FlxTween.tween(i, {angle: 360}, 0.7, {ease: FlxEase.circOut});
            // //trace(i.ID);
            
            // }
		}
		
}