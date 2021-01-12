
var flappos = func {

# Report Flap Setting

  if (getprop("sim/co-pilot")) {

    var flapval= getprop("/controls/flight/flaps");

    if (flapval == 0) { var flapdeg="Up";	}
    if (flapval == 0.125) { var flapdeg="One";	}
    if (flapval == 0.250) { var flapdeg="Two";	}
    if (flapval == 0.375) { var flapdeg="Five";	}
    if (flapval == 0.500) { var flapdeg="Ten";	}
    if (flapval == 0.625) { var flapdeg="Fifteen";	}
    if (flapval == 0.750) { var flapdeg="Twenty-Five";	}
    if (flapval == 0.875) { var flapdeg="Thirty";	}
    if (flapval == 1.000) { var flapdeg="Forty";	}

    setprop("/sim/messages/copilot", "Flaps " ~ flapdeg);
  }
}

setlistener("/controls/flight/flaps", flappos, 0, 0);

