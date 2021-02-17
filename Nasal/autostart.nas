# 737-400 auto Start&Shutdown


# Autostart #

var autostart = func {

	setprop("/sim/input/selected/engine[0]",1);
	setprop("/sim/input/selected/engine[1]",1);
  
	setprop("/controls/electric/battery-switch",1);
	setprop("/controls/electric/apugen1",1);
	setprop("/controls/electric/apugen2",1);

	setprop("/systems/electrical/on",1);
	
	setprop("/controls/fuel/tank[0]/pump-aft",1);
	setprop("/controls/fuel/tank[0]/pump-fwd",1);
	setprop("/controls/fuel/tank[1]/pump-aft",1);
	setprop("/controls/fuel/tank[1]/pump-fwd",1);
	setprop("/controls/fuel/tank[2]/pump-left",1);
	setprop("/controls/fuel/tank[2]/pump-right",1);

  setprop("/controls/engines/engine[0]/starter",1);
	setprop("/controls/engines/engine[1]/starter",1);
	setprop("/controls/engines/engine[0]/cutoff",1);
	setprop("/controls/engines/engine[1]/cutoff",1);

	if (getprop("/engines/engine[0]/n2") > 25) {
		setprop("/controls/engines/engine[0]/cutoff",0);
		setprop("/controls/engines/engine[1]/cutoff",0);
		setprop("/controls/engines/autostart",0);
	}
	if (getprop("/engines/engine[0]/n2") < 25) settimer(autostart,0);
}

# Shutdown #

var shutdown = func {

  	setprop("/controls/engines/engine[0]/cutoff",1);
	  setprop("/controls/engines/engine[1]/cutoff",1);
	  setprop("/controls/electric/battery-switch",0);
	  setprop("/controls/electric/apugen1",0);
	  setprop("/controls/electric/apugen2",0);
    setprop("/controls/engines/engine[0]/starter",0);
	  setprop("/controls/engines/engine[1]/starter",0);

  	setprop("/controls/fuel/tank[0]/pump-aft",0);
	  setprop("/controls/fuel/tank[0]/pump-fwd",0);
	  setprop("/controls/fuel/tank[1]/pump-aft",0);
	  setprop("/controls/fuel/tank[1]/pump-fwd",0);
	  setprop("/controls/fuel/tank[2]/pump-left",0);
	  setprop("/controls/fuel/tank[2]/pump-right",0);

  	setprop("/systems/electrical/on",0);
    setprop("systems/electrical/on", 0);
    setprop("systems/electrical/outputs/avionics-fan", 0);
    setprop("systems/electrical/outputs/gps-mfd", 0);
    setprop("systems/electrical/outputs/gps", 0);
    setprop("systems/electrical/outputs/hsi", 0);
    setprop("systems/electrical/outputs/comm", 0);
    setprop("systems/electrical/outputs/comm[1]", 0);
    setprop("systems/electrical/outputs/nav", 0);
    setprop("systems/electrical/outputs/nav[1]", 0);
    setprop("systems/electrical/outputs/dme", 0);
    setprop("systems/electrical/outputs/dme[1]", 0);
    setprop("systems/electrical/outputs/adf", 0);
    setprop("systems/electrical/outputs/adf[1]", 0);
    setprop("systems/electrical/outputs/mk-viii", 0);
    setprop("systems/electrical/outputs/tacan", 0);
    setprop("systems/electrical/outputs/turn-coordinator", 0);
    setprop("systems/electrical/outputs/audio-panel", 0);
    setprop("systems/electrical/outputs/audio-panel[1]", 0);
    setprop("systems/electrical/outputs/transponder", 0);


#	  setprop("/controls/engines/autostart",1);
}

