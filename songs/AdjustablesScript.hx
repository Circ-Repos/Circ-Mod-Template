import funkin.backend.system.framerate.Framerate;
import funkin.editors.charter.Charter;

var saveData = FlxG.save.data;

if(loadTime[0]) introLength = 0.001;

function onPlayerMiss(_) if(saveData.CNEAdjustablesOneMiss && !saveData.CNEAdjustablesPractice) health = 0;

function onCountdown(_) if(loadTime[0]) _.cancelled = true;

function onStartSong(){
    if(loadTime[0]){
        new FlxTimer().start(0.001, function(){
            var time = loadTime[1];

            Conductor.songPosition = time;

            for (strumLine in strumLines.members) strumLine.vocals.play(true, time);
            vocals.play(true, time);
            inst.play(true, time);

            for (strumLine in strumLines.members) for(notes in strumLine.notes) if(notes.strumTime <= loadTime[1]) notes.destroy();
            loadTime[0] = false;
        });
    }
}

function update(){
    if(saveData.CNEAdjustablesUsableOutside){
        if(FlxG.keys.justPressed.FOUR){
            saveData.CNEAdjustablesBotplay = !saveData.CNEAdjustablesBotplay;
        }
        Framerate.codenameBuildField.text = 'Adjustables Settings\nPlayback Rate: ' + saveData.CNEAdjustablesPlayback + '\nBotplay: ' + saveData.CNEAdjustablesBotplay + '\nPractice Mode: ' + saveData.CNEAdjustablesPractice;
    }
    player.cpu = saveData.CNEAdjustablesBotplay;
    
    if(FlxG.keys.justPressed.SHIFT){
        persistentUpdate = false;
        persistentDraw = true;
        if(FlxG.state is PlayState) paused = true;
        openSubState(new ModSubState('adjustables/AdjustablesState'));
    }

    if(!startingSong){
        if(FlxG.keys.justPressed.CONTROL){
            persistentUpdate = false;
            persistentDraw = true;
            paused = true;
            openSubState(new ModSubState('adjustables/SongSkipTime'));
        }
    }
}

var usingExtraDebug:Bool = false;
var playbackSetting:Float = 1;
var scrollSpeedSetting:Float = 1;

function postUpdate(elapsed){
    if(playbackSetting != saveData.CNEAdjustablesPlayback){
        inst.pitch = saveData.CNEAdjustablesPlayback;
        for (strumLine in strumLines.members) strumLine.vocals.pitch = saveData.CNEAdjustablesPlayback;
        vocals.pitch = saveData.CNEAdjustablesPlayback;
        playbackSetting = saveData.CNEAdjustablesPlayback;
    }

    if(playbackSetting != saveData.CNEAdjustablesPlayback){
        if(usingExtraDebug) return;
        FlxG.timeScale = playbackSetting = saveData.CNEAdjustablesPlayback;
        for(strumLine in strumLines.members) strumLine.vocals.pitch = saveData.CNEAdjustablesPlayback;
    }

    if(scrollSpeedSetting != saveData.CNEAdjustablesScroll){
        scrollSpeedNew = scrollSpeed * saveData.CNEAdjustablesScroll;
        for(strum in strumLines.members) for(no in strum.notes) no.scrollSpeed = scrollSpeedNew;
        scrollSpeedSetting = saveData.CNEAdjustablesScroll;
    }

    if(saveData.CNEAdjustablesUsableOutside){
        if(FlxG.keys.pressed.THREE){
            usingExtraDebug = true;
            FlxG.timeScale = 10;
        } else if(FlxG.keys.justReleased.THREE){
            usingExtraDebug = false;
            FlxG.timeScale = saveData.CNEAdjustablesPlayback;
        }

        if(!usingExtraDebug) if(FlxG.keys.justPressed.ONE || FlxG.keys.justPressed.TWO) saveData.CNEAdjustablesPlayback = FlxMath.bound(saveData.CNEAdjustablesPlayback + (FlxG.keys.justPressed.ONE ? -0.2 : 0.2), 0.1, 10);
        if(FlxG.keys.justPressed.FIVE) saveData.CNEAdjustablesPractice = !saveData.CNEAdjustablesPractice;

        if(FlxG.keys.justPressed.SEVEN && !PlayState.chartingMode) FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, null, true));
    }
}

function onGameOver(_){
    if(saveData.CNEAdjustablesPractice || saveData.CNEAdjustablesIReset){
        _.cancelled = true;
        if(!saveData.CNEAdjustablesPractice){
            registerSmoothTransition();
            FlxG.resetState();
        }
    }
}

function destroy(){
    FlxG.timeScale = 1;
}