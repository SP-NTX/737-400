# 737-400 Flashing Lights Init
#




strobe_switch = props.globals.getNode("controls/lighting/strobe", 1);
aircraft.light.new("sim/model/Boeing-737-400/lighting/strobe", [0.005, 1.4], strobe_switch);
beacon_switch = props.globals.getNode("controls/lighting/beacon", 1);
aircraft.light.new("sim/model/Boeing-737-400/lighting/beacon", [0.025, 1.5], beacon_switch);
