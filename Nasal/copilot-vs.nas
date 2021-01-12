setlistener("/sim/signals/fdm-initialized", func {
    copilot.init();
});

# var V1 = props.globals.initNode("/instrumentation/fmc/vspeeds/V1",140,"DOUBLE");
# var V2 = props.globals.initNode("/instrumentation/fmc/vspeeds/V2",150,"DOUBLE");
# var VR = props.globals.initNode("/instrumentation/fmc/vspeeds/VR",170,"DOUBLE");


# Copilot V-Speed announcements

var copilot = {
	init : func { 
        me.UPDATE_INTERVAL = 1.73; 
        me.loopid = 0; 
		# Initialize state variables.
		me.Eightyannounced = 0;
		me.V1announced = 0;
		me.VRannounced = 0;
		me.V2announced = 0;
		me.PRannounced = 0;
        me.reset(); 
        print("Copilot ready"); 
    }, 
	update : func {

# Calculate V Speeds

# 143000    154  155  160
# 132000    147  148  154
# 121000    140  141  148
# 110000    133  133  141
# 99000    123  133  133 
# 88000    114  114  126
# 77000    104  104  117

var grossweight = getprop("fdm/jsbsim/inertia/weight-lbs") or 0.00;
var V1 = 0;
var VR = 0;
var V2 = 0;
if (grossweight < 77000) { 
	 V1 = 104;
	 VR = 104;
	 V2 = 117;
	 } elsif ((grossweight >77000) and (grossweight <88000)) {
	 V1 = 114;
	 VR = 114;
	 V2 = 126;
	 } elsif ((grossweight >88000) and (grossweight <99000)) {
	 V1 = 123;
	 VR = 133;
	 V2 = 133;
	 } elsif ((grossweight >99000) and (grossweight <110000)) {
	 V1 = 133;
	 VR = 133;
	 V2 = 141;
	 } elsif ((grossweight >110000) and (grossweight <121000)) {
	 V1 = 140;
	 VR = 141;
	 V2 = 148;
	 } elsif ((grossweight >121000) and (grossweight <132000)) {
	 V1 = 147;
	 VR = 148;
	 V2 = 154;
	 } elsif (grossweight >132000) {
	 V1 = 154;
	 VR = 15;
	 V2 = 160;
	 } 

    setprop("/instrumentation/fmc/vspeeds/V1", V1);	 
    setprop("/instrumentation/fmc/vspeeds/VR", VR);	 
    setprop("/instrumentation/fmc/vspeeds/V2", V2);	 
	 
    var airspeed = getprop("velocities/airspeed-kt");
		var V1 = getprop("/instrumentation/fmc/vspeeds/V1");
		var VR = getprop("/instrumentation/fmc/vspeeds/VR");
		var V2 = getprop("/instrumentation/fmc/vspeeds/V2");
				
        if ((airspeed > 79) and (me.Eightyannounced == 0)) {
            me.announce("80 Knots");
			me.Eightyannounced = 1;
        } elsif ((airspeed != nil) and (V1 != nil) and (airspeed > V1) and (me.V1announced == 0)) {
            me.announce("V1");
			me.V1announced = 1;
        } elsif ((airspeed != nil) and (VR != nil) and (airspeed > VR) and (me.VRannounced == 0)) {
            me.announce("Rotate");
			me.VRannounced = 1;
        } elsif ((airspeed != nil) and (V2 != nil) and (airspeed > V2) and (me.V2announced == 0)) {
            me.announce("V2");
			me.V2announced = 1;
        } elsif ((me.V2announced == 1) and (me.PRannounced == 0) and (getprop("position/altitude-agl-ft") > 300) and (getprop("/velocities/vertical-speed-fps") > 10)) {
            me.announce("Positive Rate - Gear Up");
			me.PRannounced = 1;
        } elsif ((V1 == nil) or (V2 == nil) or (VR == nil)){
			print ("FMU Toast - Vspeeds not calculated");
		}
		
    },
	announce : func(msg) {
      if (getprop("sim/co-pilot")) {
        setprop("/sim/messages/copilot", msg);
      }
    },
    reset : func {
        me.loopid += 1;
        me._loop_(me.loopid);
    },
    _loop_ : func(id) {
        id == me.loopid or return;
        me.update();
        settimer(func { me._loop_(id); }, me.UPDATE_INTERVAL);
    }
};