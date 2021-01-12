togglereverser = func {
  throttle1 = "/controls/engines/engine/throttle";
  angle1 = "/fdm/jsbsim/propulsion/engine";
  angle2 = "/fdm/jsbsim/propulsion/engine[1]";
  control1 = "/controls/engines/engine"; 
  control2 = "/controls/engines/engine[1]"; 
  engselect = "/sim/input/selected";
  pos1 = "/engines/engine/reverser-pos-norm"; 
  pos2 = "/engines/engine[1]/reverser-pos-norm"; 

  # The reverse can only be actuated while the engine is idling
  if (getprop(throttle1) < 0.01) {
    val = getprop(pos1);
    if (val == 0 or val == nil) {
      interpolate(pos1, 1.0, 1.4); 
      interpolate(pos2, 1.0, 1.4);  
      setprop(angle1,"reverser-angle-rad","2.35619");
      setprop(angle2,"reverser-angle-rad","2.35619");
      setprop(control1,"reverser", "true");
      setprop(control2,"reverser", "true");
      setprop(engselect,"engine", "true");
      setprop(engselect,"engine[1]", "true");
    } else {
      if (val == 1.0){
        interpolate(pos1, 0.0, 1.4);
        interpolate(pos2, 0.0, 1.4);   
        setprop(angle1,"reverser-angle-rad",0);
        setprop(angle2,"reverser-angle-rad",0);
        setprop(control1,"reverser",0);
        setprop(control2,"reverser",0);
        setprop(engselect,"engine", "true");
        setprop(engselect,"engine[1]", "true");
      }
    }
  }
}
