# Controls systems that depend on the air-ground sensor
# (also called "squat-switch") position.  This assumes
# the airplane always starts on the ground (just like the
# real airplane).
#

INAIR = "false";
REJECT = "false";
LANDED = "false";

call_airground = func {
   WOW = getprop("/gear/gear/wow");
   GROUNDSPEED = getprop("/velocities/uBody-fps") * 0.593;  
 
   if (WOW == 1) {
      # nose gear strut is compressed

     if (INAIR == "false") {
             
        if ((getprop("/controls/gear/autobrakes") == 5) and (REJECT=="false")) {
          if (getprop("/controls/engines/engine[0]/throttle") < 0.1) { 
            if (GROUNDSPEED > 60.0) {
              REJECT = "true";
              print ("Rejecting Takeoff at ", GROUNDSPEED, " kts ground speed");
							gui.popupTip("Rejecting Takeoff at " ~ int(GROUNDSPEED) ~ " kts ground speed",10);
            }
          }
        }

        if (REJECT == "true") {
          if (GROUNDSPEED < 2.0) {
            REJECT = "false";
            setprop("/controls/gear/autobrakes", 5);
            setprop("/controls/gear/brake-left", 0.0);
            setprop("/controls/gear/brake-right", 0.0);
						setprop("/controls/flight/speedbrake", 0.0);
            setprop("/controls/flight/spoilers", 0.0);
						setprop("/controls/flight/autospeedbrakes-armed", 1);
          } else {
            setprop("/controls/gear/brake-left", 1.0);
            setprop("/controls/gear/brake-right", 1.0);
            setprop("/controls/flight/speedbrake", 1.0);
            setprop("/controls/flight/spoilers", 1.0);
          } 
        }

        if (LANDED == "true") {
	        if (GROUNDSPEED < 130.0){
            #Go-Aound
            if (getprop("/controls/engines/engine[0]/throttle") > 0.5) {
						  if (getprop("/controls/engines/engine[0]/reverser") == 0) { 
               LANDED = "false";
               setprop("/controls/flight/speedbrake", 0.0);
               setprop("/controls/flight/spoilers", 0.0);
               setprop("/controls/gear/autobrakes", 0);
               setprop("/controls/gear/brake-left", 0.0);
               setprop("/controls/gear/brake-right", 0.0);
             }
					 }
           if (GROUNDSPEED < 30.0) {
            LANDED = "false";
						setprop("/controls/flight/speedbrake", 0.0);
	  			  setprop("/controls/flight/spoilers", 0.0);
            setprop("/controls/gear/autobrakes", 5);
            setprop("/controls/gear/brake-left", 0.0);
            setprop("/controls/gear/brake-right", 0.0);
	  			  setprop("/controls/flight/autospeedbrakes-armed", 1);
           }
         }
       }	
     } else {
       # we have touched down
       INAIR = "false";
       LANDED = "true";

        var SETTING = getprop("/controls/gear/autobrakes");

        if (SETTING == 0) {
          # autobrakes are off, so do nothing here
        }
        elsif (SETTING == 1) {
      	  if (getprop("/controls/flight/autospeedbrakes-armed") == 1) {
            # autobrakes set to level 1
            setprop("/controls/gear/brake-left", 0.2);
            setprop("/controls/gear/brake-right", 0.2);
	  			  setprop("/controls/flight/speedbrake", 1.0);
	  			  setprop("/controls/flight/spoilers", 1.0);
	  			  setprop("/controls/flight/autospeedbrakes-armed", 0);
          }
	      }
        elsif (SETTING == 2) {
	        if (getprop("/controls/flight/autospeedbrakes-armed") == 1) {
            # autobrakes set to level 2
            setprop("/controls/gear/brake-left", 0.4);
            setprop("/controls/gear/brake-right", 0.4);
	  			  setprop("/controls/flight/speedbrake", 1.0);
	  			  setprop("/controls/flight/spoilers", 1.0);
	  			  setprop("/controls/flight/autospeedbrakes-armed", 0);
          }
	      }
        elsif (SETTING == 3) {
	        if (getprop("/controls/flight/autospeedbrakes-armed") == 1) {
            # autobrakes set to level 3
            setprop("/controls/gear/brake-left", 0.8);
            setprop("/controls/gear/brake-right", 0.8);
	  			  setprop("/controls/flight/speedbrake", 1.0);
	  			  setprop("/controls/flight/spoilers", 1.0);
	  			  setprop("/controls/flight/autospeedbrakes-armed", 0);
          }
	      }
        elsif (SETTING == 4) {
	        if (getprop("/controls/flight/autospeedbrakes-armed") == 1) {
            # autobrakes set to level MAX
            setprop("/controls/gear/brake-left", 1.0);
            setprop("/controls/gear/brake-right", 1.0);
	  			  setprop("/controls/flight/speedbrake", 1.0);
	  			  setprop("/controls/flight/spoilers", 1.0);
	  			  setprop("/controls/flight/autospeedbrakes-armed", 0);         
          } 
        }
        else {
          # autobrakes mistakenly set to wrong value
          setprop("/controls/gear/autobrakes", 0);
        }
      }

   } else {
      # nose gear is not compressed
      INAIR = "true";
			if (getprop("/controls/gear/autobrakes") == 5) {
				setprop("/controls/gear/autobrakes", 0.0);
			}
      LANDED = "false";
   }

   # schedule the next call
   settimer(call_airground, 0.2);   
}
 
init = func {
   settimer(call_airground, 0.0);
}

init();
  