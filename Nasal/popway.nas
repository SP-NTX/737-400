
var popway = func {

# Next Wapoint

  if (getprop("autopilot/internal/CMDA")) {
    if (getprop("autopilot/internal/LNAV")) {
      if (getprop("autopilot/internal/LNAV-FMS")) {
        if (getprop("autopilot/internal/eta-wp-hr") < 1) {
          if (getprop("autopilot/internal/eta-wp-min") < .2) {
				
        var curwp = getprop("autopilot/route-manager/current-wp");
        var nextwp = curwp + 1;
        setprop("autopilot/route-manager/current-wp", nextwp);
    
             }
           }
        }   
     }
  }
}

setlistener("/autopilot/route-manager/flight-time", popway, 0, 0);

