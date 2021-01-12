##

# Adds 2/8 Up/Down control for Vertical Speed Control to existing Altitude Hold Control

# arg[0] is the elevator increment
# arg[1] is the autopilot increment
var Elevator = func {
	
    var CMDA = props.globals.getNode("/autopilot/internal/CMDA", 1);
    var VNAV = props.globals.getNode("/autopilot/internal/VNAV", 1);
    var ALT = props.globals.getNode("/autopilot/internal/VNAV-ALT", 1);
    var VS = props.globals.getNode("/autopilot/internal/VNAV-VS", 1);
		
    if (CMDA.getValue() and VNAV.getValue() and ALT.getValue()) {
        # we are in Altitude hold mode
        var node = props.globals.getNode("/autopilot/settings/target-altitude-ft", 1);
        if (node.getValue() == nil) {
            node.setValue(0.0);
        }
        node.setValue(node.getValue() + arg[1]);
        if (node.getValue() < 0.0) {
            node.setValue(0.0);
        }
    } elsif (CMDA.getValue() and VNAV.getValue() and VS.getValue()) {
        # we are in Vertcal Speed Mode
        var node = props.globals.getNode("/autopilot/settings/vertical-speed-fpm", 1);
        if (node.getValue() == nil) {
            node.setValue(0.0);
         }
        node.setValue(node.getValue() + arg[1]);
        if (node.getValue() < -3000.0) {
            node.setValue(-3000.0);
        }
				if (node.getValue() > 3000.0) {
            node.setValue(3000.0);
        }
    } else {
				
        var elevator = props.globals.getNode("/controls/flight/elevator");
        if (elevator.getValue() == nil) {
            elevator.setValue(0.0);
        }
        elevator.setValue(elevator.getValue() + arg[0]);
        if (elevator.getValue() < -1.0) {
            elevator.setValue(-1.0);
        }
        if (elevator.getValue() > 1.0) {
            elevator.setValue(1.0);
        }
    }
}




# Adds 3/9 PgUp/PgDn control for Mach Hold to existing Throttle Control

##
# arg[0] is the throttle increment
# arg[1] is the auto-throttle target speed increment

var Throttle = func {

    var CMDA = props.globals.getNode("/autopilot/internal/CMDA", 1);
    var SPD = props.globals.getNode("/autopilot/internal/SPD", 1);
    var SPEED = props.globals.getNode("/autopilot/internal/SPD-SPEED", 1);
    var LVLCHG = props.globals.getNode("/autopilot/internal/SPD-LVLCHG", 1);
    var N1 = props.globals.getNode("/autopilot/internal/SPD-N1", 1);
    var IAS = props.globals.getNode("/autopilot/internal/SPD-IAS", 1);
    var MACH = props.globals.getNode("/autopilot/internal/SPD-MACH", 1);

    var ANYSPD = SPEED.getValue() or LVLCHG.getValue() or N1.getValue();
		
    if (CMDA.getValue() and SPD.getValue() and IAS.getValue() and ANYSPD) {
    # we are in IAS mode
        var node = props.globals.getNode("/autopilot/settings/target-speed-kt", 1);
        if (node.getValue() == nil) {
            node.setValue(0.0);
        }
        node.setValue(node.getValue() + arg[1]);
        if (node.getValue() < 0.0) {
            node.setValue(0.0);
        }
				if (node.getValue() > 350.0) {
            node.setValue(350.0);
        }
    } elsif (CMDA.getValue() and SPD.getValue() and MACH.getValue() and ANYSPD) {
        var node = props.globals.getNode("/autopilot/settings/target-speed-mach", 1);
        if (node.getValue() == nil) {
            node.setValue(0.0);
        }
        node.setValue(node.getValue() + arg[0]);
        if (node.getValue() < 0.0) {
            node.setValue(0.0);
        }
				if (node.getValue() > 0.82) {
            node.setValue(0.82);
        }

    } else {				
        foreach(var e; engines) {
            if(e.selected.getValue()) {
                var node = e.controls.getNode("throttle", 1);
                var val = node.getValue() + arg[0];
                node.setValue(val < -1.0 ? -1.0 : val > 1.0 ? 1.0 : val);
            }
        }
    }
}

##
# arg[0] is the aileron increment
# arg[1] is the autopilot target heading increment

var Aileron = func {

    var CMDA = props.globals.getNode("/autopilot/internal/CMDA", 1);
    var LNAV = props.globals.getNode("/autopilot/internal/LNAV", 1);
    var LVL = props.globals.getNode("/autopilot/internal/LNAV-LVL", 1);
    var FMS = props.globals.getNode("/autopilot/internal/LNAV-FMS", 1);
    var HDG = props.globals.getNode("/autopilot/internal/LNAV-HDG", 1);
    var NAV1 = props.globals.getNode("/autopilot/internal/LNAV-NAV1", 1);
    var NAV2 = props.globals.getNode("/autopilot/internal/LNAV-NAV2", 1);

	 	var NOTHDG = NAV1.getValue() or NAV2.getValue();
		
    if (CMDA.getValue() and LNAV.getValue() and HDG.getValue()){
    # Heading Mode
        var node = props.globals.getNode("/autopilot/settings/heading-bug-deg", 1);
        if (node.getValue() == nil) {
            node.setValue(0.0);
        }
        node.setValue(node.getValue() + arg[1]);
        if (node.getValue() < 0.0) {
            node.setValue(node.getValue() + 360.0);
        }
        if (node.getValue() > 360.0) {
            node.setValue(node.getValue() - 360.0);
        }
    } elsif (CMDA.getValue() and LNAV.getValue() and FMS.getValue()){
        var node = props.globals.getNode("/autopilot/settings/true-heading-deg", 1);
        if (node.getValue() == nil) {
            node.setValue(0.0);
        }
        node.setValue(node.getValue() + arg[1]);
        if (node.getValue() < 0.0) {
            node.setValue(node.getValue() + 360.0);
        }
        if (node.getValue() > 360.0) {
            node.setValue(node.getValue() - 360.0);
        }
    } elsif (CMDA.getValue() and LNAV.getValue() and NOTHDG){
    # NAV1 or NAV2 - do nothing
    } else {
				
        var aileron = props.globals.getNode("/controls/flight/aileron");
        if (aileron.getValue() == nil) {
            aileron.setValue(0.0);
        }
        aileron.setValue(aileron.getValue() + arg[0]);
        if (aileron.getValue() < -1.0) {
            aileron.setValue(-1.0);
        }
        if (aileron.getValue() > 1.0) {
            aileron.setValue(1.0);
        }
    }
}

##
#  Parking brake with optional Announcement
#
var applyParkingBrake = func(v) {
    if (!v) { return; }
    var p = "/controls/gear/brake-parking";
    setprop(p, var i = !getprop(p));

    var pbstatus = "OFF";
    if (getprop("/controls/gear/brake-parking") == 1) { pbstatus = "ON"; }
		if (getprop("sim/co-pilot")) {
		   setprop ("/sim/messages/copilot", "Parking Brake " ~ pbstatus);
    }   


		return i;

}



##
# Initialization.
#
var engines = [];
_setlistener("/sim/signals/fdm-initialized", func {
    var sel = props.globals.getNode("/sim/input/selected", 1);
    var engs = props.globals.getNode("/controls/engines").getChildren("engine");

    foreach(var e; engs) {
        var index = e.getIndex();
        var s = sel.getChild("engine", index, 1);
        if(s.getType() == "NONE") s.setBoolValue(1);
        append(engines, { index: index, controls: e, selected: s });
    }
});

var replaySkip = func(skip_time)
{
    var t = getprop("/sim/replay/time");
    if (t != "")
    {
        t+=skip_time;
        if (t>getprop("/sim/replay/end-time"))
            t = getprop("/sim/replay/end-time");
        if (t<0)
            t=0;
        setprop("/sim/replay/time", t);
    }
}

var speedup = func(speed_up)
{
    var t = getprop("/sim/speed-up");
    if (speed_up < 0)
    {
        t = (t > 1/32) ? t/2 : 1/32;
        if ((t<1)and(0==getprop("/sim/freeze/replay-state")))
            t=1;
    }
    else
    {
        t = (t < 32) ? t*2 : 32;
    }
    setprop("/sim/speed-up", t);
}


#			setprop ("/sim/messages/copilot", "Called");
