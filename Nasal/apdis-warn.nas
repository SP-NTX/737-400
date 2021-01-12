
var apdis_warn = func {

# IF AP turns Off set warning property

  if (!getprop("autopilot/internal/CMDA")) {
    setprop("autopilot/internal/apdis-warn", 1);
  }

}

setlistener("/autopilot/internal/CMDA", apdis_warn, 0, 0);

