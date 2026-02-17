function onNoteHit(e) 
    for (char in e.characters) {
        if (e.note.isSustainNote && char.lastAnimContext != "MISS") {
            e.animCancelled = true;
            char.lastHit = Conductor.songPosition;
        }
    }

function onPlayerMiss(e) 
    for (char in e.characters) {
        if (e.note.isSustainNote && char.lastAnimContext != "SING") {
            e.animCancelled = true;
            char.lastHit = Conductor.songPosition;
        }
    }