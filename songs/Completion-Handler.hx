
import funkin.menus.FreeplayState.FreeplaySonglist;

var songs = FreeplaySonglist.get(true).songs; // eugh...
var songName:String = PlayState.SONG.meta.name.toLowerCase();

function onSongEnd()
{
// deleting your save fixes the issue, but i'm still keeping this here commented
//	if(Application.current.meta.get('version') == '1.0.1')
//		validScore = false; // temp band-aid fix

	if(FlxG.save.data.songsBeaten == null) FlxG.save.data.songsBeaten = [];
	if(!FlxG.save.data.songsBeaten.contains(songName)) FlxG.save.data.songsBeaten.push(songName);

	if(PlayState.isStoryMode)
	{
		if(songName == 'grace') FlxG.save.data.weeksBeaten.push('overthrone');
		if(songName == 'gift') FlxG.save.data.weeksBeaten.push('volume 1');
	}

	//please let there be a better way
	if(FlxG.save.data.songsBeaten.length >= songs.length) // unless you can find a more optimized way to do this
		FlxG.save.data.allSongsBeaten = true; // ...nope  - DM
	else
		FlxG.save.data.allSongsBeaten = false;
}