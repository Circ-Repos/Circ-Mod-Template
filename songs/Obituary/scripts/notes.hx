
// import sys.io.File;
// import sys.FileSystem;

// var savedNotes:String;

// function postCreate() {
//     trace(PlayState.SONG.strumLines[0].notes);
//     // for (strumLine in strumLines.members) {
//     //     for (note in strumLine.notes) trace(note.strumTime);
//     // }   
// }

// function saveTextToFile(path:String, content:String):Void
// {
//     {
//         // Ensure folder exists
//         var dir = haxe.io.Path.directory(path);
//         if (!FileSystem.exists(dir))
//             FileSystem.createDirectory(dir);

//         // Save file
//         File.saveContent(path, content);
//     }
// }
// saveTextToFile('mods/testSD.txt', PlayState.SONG.strumLines[0].notes);
// saveTextToFile('mods/testSD2.txt', PlayState.SONG.strumLines[1].notes);
