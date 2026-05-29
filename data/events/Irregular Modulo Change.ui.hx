import EReg;
using Lambda;
import funkin.backend.system.Logs;
import funkin.editors.charter.Charter;

var doPreview = (FlxG.save.data.charterIrregularModuloPreview == true);
var problem:Bool = false;

function generateIcon() {
    var menu = state.topMenu[3].childs;
    if ((state is Charter) && !menu.exists(item -> item?.label == "Preview Irregular Modulo"))
        menu.insert(0, {
            label: "Preview Irregular Modulo",
            icon: doPreview ? 1 : 0,
            onSelect: (t -> {
                t.icon = (FlxG.save.data.charterIrregularModuloPreview = doPreview = !doPreview) ? 1 : 0;
                for (es in state.leftEventsGroup)
                    if (es.events.exists(e->e.name=="Irregular Modulo Change"))
                        es.refreshEventIcons();
                for (es in state.rightEventsGroup)
                    if (es.events.exists(e->e.name=="Irregular Modulo Change"))
                        es.refreshEventIcons();
            })
        });
    problem = false;
    if (event.params == null || event.params[0] == null) return;
    var params = event.params.copy();
    var icoGroup = new EventIconGroup();
    var discolor:Array<FlxSprite> = [];
    icoGroup.add(generateDefaultIcon(event.name));
    if (inMenu) return icoGroup;
    var reg1 = new EReg("^(?:\\d+\\.\\d+|\\d+|\\.\\d+)(?:/(?:\\+(?:\\d+\\.\\d+|\\d+|\\.\\d+)(?:\\|\\d+)?|(?:\\d+\\.\\d+|\\d+|\\.\\d+)))*$", "");
    var reg2 = new EReg("^(?:\\d+\\.\\d+|\\d+|\\.\\d+)(?:\\|\\d+)?(?:/(?:\\d+\\.\\d+|\\d+|\\.\\d+)(?:\\|\\d+)?)*$", "");
    if (!reg1.match(params[0])) {
        generateEventIconWarning(icoGroup);
        error("Invalid Modulo Map format.");
        return icoGroup;
    }
    if (!StringTools.contains(params[0], '/')){
        generateEventIconWarning(icoGroup);
        error("You need at least 1 \"modulo\"");
        return icoGroup;
    }
    if (!reg2.match(params[2]) && params[1]) {
        generateEventIconWarning(icoGroup);
        error("Invalid Beat Strength Map format.");
        return icoGroup;
    } else if (!params[1] && !new EReg("^(?:\\d+\\.\\d+|\\d+|\\.\\d+)$", '').match(params[2])){
        generateEventIconWarning(icoGroup);
        error("Beat is not a Float." + (reg2.match(params[2]) ? " (Did you want it as a Beat Strength Map?)" : ""));
        return icoGroup;
    }
    if (!problem) {
        var modulos:Array<Float> = [];
        for (raw in params[0].split("/")) {
            var repetitions = 1;
            var value = raw;
            if (StringTools.contains(raw, "|")) {
                repetitions = Std.parseInt(raw.split("|")[1]);
                value = raw.split("|")[0];
            }
            var delta = 0.0;
            if (value.charAt(0) == '+') {
                delta = Std.parseFloat(value.substr(1));
                value = modulos[modulos.length - 1] + delta;
            } else {
                value = Std.parseFloat(value);
                delta = 0;
            }
            modulos.push(value);
            for (i in 1...repetitions) {
                modulos.push(modulos[modulos.length - 1] + delta);
            }
        }
        var beats:Array<Float> = [];
        if (!params[1]) params[2] = params[2]+'|'+(modulos.length-1);
        for (raw in params[2].split("/")) {
            var repetitions = 1;
            var value = raw;
            if (StringTools.contains(raw, "|")) {
                repetitions = Std.parseInt(raw.split("|")[1]);
                value = raw.split("|")[0];
            }
            value = Std.parseFloat(value);
            for (i in 0...repetitions) {beats.push(value);}
        }
        if (modulos.length > 2) {
            if ((beats.length+1) != modulos.length) {
                generateEventIconWarning(icoGroup);
                error("Beat Strength Map's length should be one less than Modulo Map's, as Irregular Modulo loops instantly on the end time, they're off by "+Math.abs(modulos.length-(beats.length+1))+".");
                return icoGroup;
            }
        } else {
            if (!params[1]) beats.push(beats[0]);
            if (beats.length != modulos.length) {
                generateEventIconWarning(icoGroup);
                error("When the Modulo Map has less than 3 items, it should have equal length as the Beat Strength Map. They're off by "+Math.abs(modulos.length-beats.length)+".");
                return icoGroup;
            }
            modulos.push(modulos[1]+(modulos[1]-modulos[0]));
        }
        if (doPreview) {
            var alone = false;
            var right = null;
            if (state is Charter) {
                for (es in state.leftEventsGroup)
                    if (es.events.contains(event)) {
                        right = false;
                        if (es.events.length == 1)
                            alone = true;
                        else if (es.events.length > 1 && es.events.count(e->e.name=="Irregular Modulo Change") > 1){
                            generateEventIconWarning(icoGroup);
                            if (es.events.indexOf(event) == 0) error("You can't start several modulo changes at once");
                            return icoGroup;
                        }
                    }
                for (es in state.rightEventsGroup)
                    if (es.events.contains(event)) {
                        right = true;
                        if (es.events.length == 1)
                            alone = true;
                        else if (es.events.length > 1 && es.events.count(e->e.name=="Irregular Modulo Change") > 1){
                            generateEventIconWarning(icoGroup);
                            if (es.events.indexOf(event) == 0) error("You can't start several modulo changes at once");
                            return icoGroup;
                        }
                    }
            }
            right = right ?? false; // incase the impossible happens
            if (modulos[0] == 0) {
                if (alone) {
                    icoGroup.add({
                        var num = new EventNumber(icoGroup.x+(right?40:-40), icoGroup.y+4, beats[0], null, FlxMath.MAX_VALUE_INT);
                        num.scale.add(.5,.5);
                        if (!right) num.x += -(num.digits.length - 1) * num.spacing * Math.abs(num.scale.x);
                        num;
                    });
                } else generateEventIconNumbers(icoGroup, beats[0]);
            }
            for (i=>num in modulos){
                generateEventIconDurationArrow(icoGroup, num);
                if (num < 0.55 && num > 0) icoGroup.add({
                    var arw = new FlxSprite(4, (num*40)+2);
                    arw.frames = Paths.getSparrowAtlas("editors/charter/event-icons/components/arrow-down");
                    arw.animation.addByPrefix("arrow", "arrow");
                    arw.animation.play("arrow");
                    arw;
                });
                if (i+1 >= modulos.length) {icoGroup.members.pop().destroy();break;}
                if (num == 0) continue;
                var last = CoolUtil.last(icoGroup.members);
                last.angle+=(right?90:-90);
                last.scale.y *= 4;
                last.x -= right ? last.height*last.scale.y : last.height*-last.scale.y;
                last.y -= (last.width*last.scale.x)-1;
                last.updateHitbox();
                if (alone) icoGroup.add({
                    var num = new EventNumber(last.x+(right?30:-30), last.y+8, beats[i % beats.length], null, FlxMath.MAX_VALUE_INT);
                    num.scale.add(.5,.5);
                    if (!right) num.x += -(num.digits.length - 1) * num.spacing * Math.abs(num.scale.x);
                    num;
                });
                else generateEventIconNumbers(icoGroup, beats[i % beats.length], last.x, last.y-2);
            }
        }
    }
    return icoGroup;
}
function error(txt) {
    problem = true;
    Logs.traceColored([
        Logs.logText(__script__.fileName+': ', 10),
        Logs.logText(txt, 12)
    ], 2);
}