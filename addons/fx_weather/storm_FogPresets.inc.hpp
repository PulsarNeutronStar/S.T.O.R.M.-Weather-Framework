class GVAR(FogParams)
{
    class GVAR(Fog_Default)
    {
        fog_value_min = 0;                              // 0..1   - Minimum Fog, even with 1% intensity                              
        fog_value_max = 0;                              // 0..1   - Maximum Fog Level at 100% intensity
        fog_decay = 0;                                  // 0..1   - Recommend to stay within 0 .. 0.1 - Additional Info: fogDecay - how much the fog density decays with altitude. 0 = constant density, 0.0049333 = density halves every 500m
        fog_base = 0;                                   // number - meters +/- above Sea Level
        fog_mode = "STATIC";                            // 
        fog_useAvgASL = 0;                              // 
    };

    class GVAR(Fog_Clear) : GVAR(Fog_Default)
    {
        fog_value_min = 0;                              // 0..1   - Minimum Fog, even with 1% intensity                              
        fog_value_max = 0;                              // 0..1   - Maximum Fog Level at 100% intensity
        fog_decay = 0;                                  // 0..1   - Recommend to stay within 0 .. 0.1 - Additional Info: fogDecay - how much the fog density decays with altitude. 0 = constant density, 0.0049333 = density halves every 500m
        fog_base = 0;                                   // number - meters +/- above Sea Level
        fog_mode = "STATIC";                            // Fogmode: 0 - apply setFog with param once, ideal for static fog params.  | 1 - Gets Players Average ASL once and adds that to the fog_base Value. | 2 - Continously adapts fogbase based on player AvgAVL.
        fog_useAvgASL = 0;                              // 
    };

    // MODE 0 PRESETS

    // STATIC FOG
    // Static Fog Presets have a decay value of 0, meaning they will be exactly the same, no matter the base or ASL.
    // With Decay/Dispersion set to 0, Base will have no effect, therefore fog_useAvgASL will have no effect.

    class GVAR(Fog_Static_100): GVAR(Fog_Default) { fog_value_max = 1.0; };
    class GVAR(Fog_Static_90) : GVAR(Fog_Default) { fog_value_max = 0.9; };
    class GVAR(Fog_Static_80) : GVAR(Fog_Default) { fog_value_max = 0.8; };
    class GVAR(Fog_Static_70) : GVAR(Fog_Default) { fog_value_max = 0.7; };
    class GVAR(Fog_Static_60) : GVAR(Fog_Default) { fog_value_max = 0.6; };
    class GVAR(Fog_Static_50) : GVAR(Fog_Default) { fog_value_max = 0.5; };
    class GVAR(Fog_Static_40) : GVAR(Fog_Default) { fog_value_max = 0.4; };
    class GVAR(Fog_Static_30) : GVAR(Fog_Default) { fog_value_max = 0.3; };
    class GVAR(Fog_Static_20) : GVAR(Fog_Default) { fog_value_max = 0.2; };
    class GVAR(Fog_Static_10) : GVAR(Fog_Default) { fog_value_max = 0.1; };



    // DYNAMIC FOG
    // Dynamic Fog Presets take use of  decay and fogbase.
    // Can take advantage of useAvgASL

    class GVAR(Fog_Dynamic_Sandstorm) : GVAR(Fog_Default)
    {
        fog_value_min = 0.01;                            // 0..1   - Minimum Fog, even with 1% intensity                              
        fog_value_max = 0.4;                            // 0..1   - Maximum Fog Level at 100% intensity
        fog_decay = 0.013;                              // 0..1   - Recommend to stay within 0 .. 0.1 - Additional Info: fogDecay - how much the fog density decays with altitude. 0 = constant density, 0.0049333 = density halves every 500m
        fog_base = 180;                                 // number - meters +/- above Sea Level
        fog_mode = "DYNAMIC";                                   // Fogmode: 0 - apply setFog with param once, nothing else fancy going on - fogDecay of 0 recommended! | 1 - Gets Players Average ASL once and adds that to the fog_base Value. | 2 - Continously adapts fogbase based on player AvgAVL.
        fog_useAvgASL = 1;                              // 
    };

    class GVAR(Fog_Dynamic_lessFog) : GVAR(Fog_Dynamic_Sandstorm)
    {
        fog_value_max = 0.2;
    };

    class GVAR(Fog_Dynamic_Test) : GVAR(Fog_Default)
    {
        fog_value_min = 0.01;                            // 0..1   - Minimum Fog, even with 1% intensity                              
        fog_value_max = 0.4;                            // 0..1   - Maximum Fog Level at 100% intensity
        fog_decay = 0.015;                              // 0..1   - Recommend to stay within 0 .. 0.1 - Additional Info: fogDecay - how much the fog density decays with altitude. 0 = constant density, 0.0049333 = density halves every 500m
        fog_base = 50;                                  // number - meters +/- above Sea Level
        fog_mode = "DYNAMIC";                                   // Fogmode: 0 - apply setFog with param once, nothing else fancy going on.  | 1 - Gets Players Average ASL once and adds that to the fog_base Value. | 2 - Continously adapts fogbase based on player AvgAVL.
    };
};