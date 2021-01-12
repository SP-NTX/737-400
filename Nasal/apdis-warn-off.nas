
var apdis_warn_off = func {

# Set warning off every 3 seconds

  if (getprop("autopilot/internal/apdis-warn")) {
    setprop("autopilot/internal/apdis-warn", 0);
  }


   # schedule the next call
   settimer(apdis_warn_off, 4.0);   
}
 
init = func {
   settimer(apdis_warn_off, 4.2);
}

init();


