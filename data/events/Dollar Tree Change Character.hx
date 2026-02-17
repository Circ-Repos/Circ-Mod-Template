function dgv(alp1:Float = 1, alp2:Float = 0, alp3:Float = 0){
	if(strumLines.members[0].characters[0] != null) strumLines.members[0].characters[0].alpha = alp1;
	if(strumLines.members[0].characters[1] != null) strumLines.members[0].characters[1].alpha = alp2;
	if(strumLines.members[0].characters[2] != null) strumLines.members[0].characters[2].alpha = alp3;
}
function bgv(alp1:Float = 1, alp2:Float = 0){
	if(strumLines.members[1].characters[0] != null) strumLines.members[1].characters[0].alpha = alp1;
	if(strumLines.members[1].characters[1] != null) strumLines.members[1].characters[1].alpha = alp2;

}
function onEvent(e){
	if(e.event.name == 'Dollar Tree Change Character'){
		var value1 = e.event.params[0];
		var value2 = e.event.params[2];
		var value3 = e.event.params[4];
		var value4 = e.event.params[1];
		var value5 = e.event.params[3];
		var value6 = e.event.params[5];
		//if(value6 != 0) window.alert('Are You Fucking Stupid?', 'Theres only 5 dumbass -Circ <3');

		dgv(value1 ? 1 : 0, value2? 1 : 0, value3 ? 1 : 0);
		bgv(value4 ? 1 : 0, value5? 1 : 0);
	}
}