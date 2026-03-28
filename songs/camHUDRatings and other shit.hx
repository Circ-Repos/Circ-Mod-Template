import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.WindowUtils;

public var ratingScaleDiff:Float = 0.1;

introLength = 0;

var baseTitle:String = 'Circuitella Mod pack';
var nullfix:Bool = false;

function onSongStart(){
	WindowUtils.set_title(baseTitle);
	WindowUtils.set_suffix(' - ${PlayState.SONG.meta.displayName}');
	
	Framerate.codenameBuildField.text = 'Codename Engine v' + Application.current.meta.get('version') + '\nCircuitella Mod Pack v' + Flags.VERSION + ' - ' + PlayState.SONG.meta.name;

}
function postCreate()
{
	comboGroup.x = 560;
	comboGroup.y = 290;
}

function onPostNoteHit(e) comboGroup.cameras = [camHUD];

function onNoteHit(event)
{
	event.numScale -= ratingScaleDiff;
	event.ratingScale -= ratingScaleDiff;
}