
var apdis = func {




# Disengage A/P if < 300 AGL 

  if (getprop("autopilot/internal/CMDA")) {
      var curagl = getprop("position/altitude-agl-ft");
			  if (curagl < 300) {
          if (curagl != 0) {

          setprop("autopilot/internal/CMDA", 0);
          setprop("autopilot/internal/CMDB", 0);

					  if (getprop("/gear/gear/wow")) {
				      setprop("sim/messages/copilot", "On the Ground Cannot Engage");
					  } else {
				      setprop("sim/messages/copilot", "Auto-Pilot Disengaged");
					  }
			  }
		 }	
  }
}

setlistener("/instrumentation/clock/indicated-sec", apdis, 0, 0);

