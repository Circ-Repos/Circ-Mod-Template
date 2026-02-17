

// import funkin.scripting.PluginsManager;
// import funkin.api.DiscordClient;


// var colorcorrection = new CustomShader('colorcorrection');

// function postCreate() {

//     // refreshZ(stage);
// }
// function stepHit(curStep:Int) {
//     switch(curStep){
//         case 1616:
//             for (item in screen) {
//                 item.visible = true;
//             }
//             comboGroup.visible = false;
//             textevil.text = "Breaking a sweat already..? \nhere, no need to thank me...";
//         case 1632:
//             var username:String = 'BOYFRIEND';
//             if(DiscordUtil.user.globalName != null) username = DiscordUtil.user.globalName;
//             textevil.text = "Breaking a sweat already..? \nhere, no need to thank me... \n" + username + ".";
//         case 1647:


//             //for(i in [healthBar, iconP1, iconP2, scoreTxt,missesTxt,accuracyTxt]) i.y += 300;

//     }
// }
// function coolEvent(eventName, value1, value2) {
// 	switch (eventName) {
// 		case 'Try Harder':
// 			switch (value1.toLowerCase()) {

//                 case 'transition':
//                     transition.alpha = 1;
//                     transition.x = -4200;
//                     FlxTween.tween(transition, {x: 3200}, 1, {ease: FlxEase.linear});
//                 case 'transition tuah':
//                     defaultCamZoom = 0.55;
//                     FlxTween.tween(addepic, {alpha: 1}, 0.25, {ease: FlxEase.cubeOut});
//                     FlxTween.tween(snowOverlay, {alpha: 1}, 0.25, {ease: FlxEase.cubeOut});
//                     snowStorm = 1;

//                     var tween_time:Float = 0.6;
//                     for(i in [playHUD.healthBar, playHUD.iconP1, playHUD.iconP2, playHUD.scoreTxt]) FlxTween.tween(i, {y: i.y + (ClientPrefs.downScroll ? 300 : -300)}, tween_time, {ease: FlxEase.cubeOut});
//                     for(i in [playHUD.timeBar, playHUD.timeTxt, botplayTxt]) FlxTween.tween(i, {y: i.y + (ClientPrefs.downScroll ? -300 : 300)}, tween_time, {ease: FlxEase.cubeOut});

//                 case 'screen melt':
//                     snowStorm = 0;
//                 case 'ending intro':
//                     addepic.alpha = 0;
//                     snowOverlay.alpha = 0;
//                 case 'ending get real':
//                     colorcorrection.customred = 0.01;
// 	                colorcorrection.customgreen = 0.007;
// 	                colorcorrection.customblue = 0.009;
//                     FlxTween.tween(addepic, {alpha: 0.3}, 4.25, {ease: FlxEase.cubeOut});
//                     snowOverlay.color = 0xffF8E8FC;
//                     FlxTween.tween(snowOverlay, {alpha: 0.95}, 4.25, {ease: FlxEase.cubeOut});
                    
//             }
//         }
//     }

// function update(elapsed){

// }

// function stepHit(){
// }

            