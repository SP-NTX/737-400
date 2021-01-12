
var gearpos = func {

if (getprop("sim/co-pilot")) {

# Check for gear retraction and confirm gear up

  if (getprop("/gear/gear/position-norm") == 0) {
     setprop("/sim/messages/copilot", "Confirmed - Gear Up");
  }

# Check for gear extension and confirm - then advise landing speed
	
	if (getprop("/gear/gear/position-norm") == 1) {
     setprop("/sim/messages/copilot", "Gear Down - three green");

# Calculate Recommended Landing Speeds		 

  var grossweight = getprop("fdm/jsbsim/inertia/weight-lbs") or 0.00;
   var RLS = 0;
   if (grossweight < 77000) { 
	   RLS = 111;
	 } elsif ((grossweight >77000) and (grossweight <88000)) {
	   RLS = 119;
	 } elsif ((grossweight >88000) and (grossweight <99000)) {
	   RLS = 127;
	 } elsif ((grossweight >99000) and (grossweight <110000)) {
	   RLS = 134;
	 } elsif ((grossweight >110000) and (grossweight <121000)) {
	   RLS = 141;
	 } elsif ((grossweight >121000) and (grossweight <132000)) {
	   RLS = 147;
	 } elsif (grossweight >132000) {
	   RLS = 153;
	 } 
   setprop("/sim/messages/copilot", "Gross Weight " ~ grossweight ~" - Recommend " ~ RLS ~ " Kt Touchdown @ Flaps 30");
  }

}
}


setlistener("/gear/gear/position-norm", gearpos, 0, 0);

