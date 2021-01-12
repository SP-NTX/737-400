# 737-400 systems
#


## Initialise Variables

baro =0.0;
inhg = 0;
kpa= 0;
rev1 = nil;
r1 = nil;
r2 = nil;
v1 = nil;
cl = 0.0;
c2 = 0.0;
hpsi = 0.0;
pph1=0.0;
pph2=0.0;
fuel_density=0.0;
n_offset=0;
nm_calc=0.0;
spdbrake=0.0;
et_base=0.0;
et_hr=0.0;
et_min=0.0;
et_min_start=0.0;



strobe_switch = props.globals.getNode("controls/switches/strobe", 1);
aircraft.light.new("sim/model/Boeing-737-400/lighting/strobe", [0.015, 1.2], strobe_switch);
beacon_switch = props.globals.getNode("controls/switches/beacon", 1);
aircraft.light.new("sim/model/Boeing-737-400/lighting/beacon", [0.025, 1.5], beacon_switch);


# doors ============================================================
frontDoorLeft= aircraft.door.new( "/sim/model/door-positions/frontDoorLeft", 1, 0 );
frontDoorRight= aircraft.door.new( "/sim/model/door-positions/frontDoorRight", 1, 0 );

init_controls = func {
    setprop("/instrumentation/efis/baro",0.0);
    setprop("/instrumentation/efis/inhg",0);
    setprop("/instrumentation/efis/kpa",0);
    setprop("/instrumentation/efis/stab",0);
    setprop("//instrumentation/mk-viii/serviceable","true");
    setprop("//instrumentation/mk-viii/configuration-module/category-1","254");
    setprop("/instrumentation/gps/wp/wp/waypoint-type","airport");
    setprop("/instrumentation/gps/wp/wp/ID",getprop("/sim/tower/airport-id"));
    setprop("/instrumentation/gps/serviceable","true");
    setprop("/engines/engine[0]/fuel-flow_pph",0.0);
    setprop("/engines/engine[1]/fuel-flow_pph",0.0);
    setprop("/instrumentation/efis/baro-mode",0.0);
    setprop("/instrumentation/efis/fixed-temp",0.0);
    setprop("/instrumentation/efis/fixed-stab",0.0);
    setprop("/instrumentation/efis/fixed-pitch",0.0);
    setprop("/instrumentation/efis/fixed-vs",0.0);
    setprop("/instrumentation/efis/alt-mode",0.0);
    setprop("/controls/engines/reverser-position",0.0);
    setprop("/environment/turbulence/use-cloud-turbulence","true");
    setprop("/sim/current-view/field-of-view",60.0);
    setprop("/controls/gear/brake-parking",1.0);
    setprop("/instrumentation/annunciator/master-caution",0.0);
    setprop("/systems/hydraulic/pump-psi[0]",0.0);
    setprop("/systems/hydraulic/pump-psi[1]",0.0);
    
    fuel_density=getprop("consumables/fuel/tank[0]/density-ppg");
    
    setprop("/surface-positions/speedbrake-pos-norm",0.0);
    setprop("/instrumentation/clock/ET-min",0);
    setprop("/instrumentation/clock/ET-hr",0);
    
    reset_et();
    print("Aircraft systems initialized");
}

settimer(init_controls, 0);

## Reset Elapsed Time
reset_et = func{
    et_base = getprop("/sim/time/elapsed-sec");
    et_min_start = et_base;
    et_hr=0.0;
    et_min=0.0;
}


# ESTIMATED TIME CALCULATIONS 

update_radar = func{
    true_heading = getprop("/orientation/heading-deg");
    ai_craft = props.globals.getNode("/ai/models").getChildren("aircraft");
    for(i=0; i<size(ai_craft);i=i+1){
        
        tgt_offset=getprop("/ai/models/aircraft[" ~ i ~ "]/radar/bearing-deg");
        
        if(tgt_offset == nil)
        {
            tgt_offset = 0.0;
        }
        
        tgt_offset -= true_heading;
        
        if (tgt_offset < -180)
        {
            tgt_offset +=360;
        }
        
        if (tgt_offset > 180)
        {
            tgt_offset -=360;
        }

        setprop("/instrumentation/radar/ai[" ~ i ~ "]/brg-offset",tgt_offset);
        test_dist=getprop("/instrumentation/radar/range");
        
        test1_dist = getprop("/ai/models/aircraft[" ~ i ~ "]/radar/range-nm");
        if(test1_dist == nil)
        {
            test1_dist=0.0;
        }
        
        norm_dist= (1 / test_dist) * test1_dist;
        setprop("/instrumentation/radar/ai[" ~ i ~ "]/norm-dist", norm_dist);
    }

    mp_craft = props.globals.getNode("/ai/models").getChildren("multiplayer");
    for(i=0; i<size(mp_craft);i=i+1){
        tgt_offset=getprop("/ai/models/multiplayer[" ~ i ~ "]/radar/bearing-deg");

        if(tgt_offset == nil)
        {
            tgt_offset = 0.0;
        }

        tgt_offset -= true_heading;
        
        if (tgt_offset < -180)
        {
            tgt_offset +=360;
        }
        
        if (tgt_offset > 180)
        {
            tgt_offset -=360;
        }
        
        setprop("/instrumentation/radar/mp[" ~ i ~ "]/brg-offset",tgt_offset);
        test_dist=getprop("/instrumentation/radar/range");
        test1_dist = getprop("/ai/models/multiplayer[" ~ i ~ "]/radar/range-nm");
        
        if(test1_dist == nil)
        {
            test1_dist=0.0;
        }
        
        norm_dist= (1 / test_dist) * test1_dist;
        setprop("/instrumentation/radar/mp[" ~ i ~ "]/norm-dist", norm_dist);
	}
} 


update_clock = func{
    sec = getprop("/sim/time/elapsed-sec") - et_min_start;
    if(sec >= 60.0){
        et_min += 1;
        et_min_start = getprop("/sim/time/elapsed-sec");
    }

    if(et_min ==60)
    {
        et_min = 0; et_hr += 1;
    }

    etmin = props.globals.getNode("/instrumentation/clock/ET-min");
    etmin.setIntValue(et_min);
    ethr = props.globals.getNode("/instrumentation/clock/ET-hr");
    ethr.setIntValue(et_hr);
}

## Toggle Thrust Reverser Function

togglereverser = func {
    r1 = "/controls/engines/engine"; 
    r2 = "/controls/engines/engine[1]"; 
    rv1 = "/surface-positions/reverser-pos-norm"; 

    val = getprop(rv1);
    if (val == 0 or val == nil) {
        interpolate(rv1, 1.0, 1.4);  
        setprop(r1,"reverser","true");
        setprop(r2,"reverser", "true");
    } else {
        if (val == 1.0){
            interpolate(rv1, 0.0, 1.4);  
            setprop(r1,"reverser",0);
            setprop(r2,"reverser",0);
        }
    }
}

update_systems = func {
    update_clock();
    update_radar();
    baro = getprop("/instrumentation/altimeter/setting-inhg");
    setprop("/instrumentation/efis/inhg",baro * 100);
    setprop("/instrumentation/efis/kpa",baro * 33.8637526);
    setprop("/instrumentation/efis/stab",getprop("/controls/flight/elevator-trim") * 15);

    if(getprop("/instrumentation/efis/baro-mode")== 0){
        setprop("/instrumentation/efis/baro", baro * 100);
    }else{
        setprop("/instrumentation/efis/baro",baro * 33.8637526);
    }

    test = getprop("/environment/temperature-degc");
    if(test < 0.00)
    {
        test = -1 * test;
    }
    
    setprop("/instrumentation/efis/fixed-temp",test);

    test = getprop("/controls/flight/elevator-trim");
    
    if(test < 0.00)
    {
        test = -1 * test;
    }

    setprop("/instrumentation/efis/fixed-stab",test);

    test = getprop("/orientation/pitch-deg");
    
    if(test < 0.00)
    {
        test = -1 * test;
    }
    
    setprop("/instrumentation/efis/fixed-pitch",test);

    test = getprop("/autopilot/settings/vertical-speed-fpm");

    if(test == nil ){
        test=0.0;
    }

    if(test < 0.00)
    {
        test = -1 * test;
    }

    setprop("/instrumentation/efis/fixed-vs",test);


    force = getprop("/accelerations/pilot-g");

    if(force == nil) 
    {
        force = 1.0;
    }
    
    eyepoint = (getprop("sim/view/config/y-offset-m") - (force * 0.01));

    if(getprop("/sim/current-view/view-number") < 1){
        setprop("/sim/current-view/y-offset-m",eyepoint);
    }

    hpsi = getprop("/engines/engine[0]/n2");

    if(hpsi == nil)
    {
        hpsi =0.0;
    }

    if(hpsi > 30.0)
    {
        setprop("/systems/hydraulic/pump-psi[0]",60.0);
    } else {
        setprop("/systems/hydraulic/pump-psi[0]",hpsi * 2);
    }

    hpsi = getprop("/engines/engine[1]/n2");

    if(hpsi == nil)
    {
        hpsi =0.0;
    }

    if(hpsi > 30.0)
    {
        setprop("/systems/hydraulic/pump-psi[1]",60.0);
    } else {
        setprop("/systems/hydraulic/pump-psi[1]",hpsi * 2);
    }

    pph1=getprop("/engines/engine[0]/fuel-flow-gph");
    
    if(pph1 == nil)
    {
        pph1 = 0.0
    };

    pph2=getprop("/engines/engine[1]/fuel-flow-gph");
    
    if(pph2 == nil)
    {
        pph2 = 0.0
    };

    setprop("engines/engine[0]/fuel-flow_pph",pph1* fuel_density);
    setprop("engines/engine[1]/fuel-flow_pph",pph2* fuel_density);

    #if(getprop("/controls/flight/speedbrake")== 1){
    #interpolate("surface-positions/speedbrake-pos-norm", 1.0, 5.0);
    #interpolate("controls/flight/spoilers", 1.0, 5.0);
    #}
    #if(getprop("/controls/flight/speedbrake")== 0){
    #interpolate("surface-positions/speedbrake-pos-norm", 0.0, 5.0);
    #interpolate("controls/flight/spoilers", 0.0, 5.0);
    #}

    settimer(update_systems,0);
}

settimer(update_systems,0);
