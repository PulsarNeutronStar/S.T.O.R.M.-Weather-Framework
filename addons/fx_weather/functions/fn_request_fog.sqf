#include "..\script_component.hpp"

/*
* Author: Zorn
* Establishes hashMapObject which maintains a loop based on parameters inside the hmo - can be updated on the fly and will clean itself up once intensity reaches 0 again.
*
* Arguments:
*   0:  _PresetName
*   1:  _duration       in secounds
*   2:  _intensity
*
*
*
* Return Value:
* None
*
* Example:
* ["STORM_FX_Weather_Fog_Dynamic_Sandstorm", 1, 1] call Storm_fx_weather_fnc_request_fog;
*
* Public: yes
*
* GVARS
*
*
*/

#define INTERVAL 60


if (!isServer) exitWith {};

params [
    ["_presetName", "",     [""]    ],
    ["_duration",   5,      [0]     ],
    ["_intensity",  1,      [0]     ],
    ["_restore",    false,  [true]  ]
];

_intensity = _intensity max 0 min 1;
_duration = 60 * (_duration max 1);

// Check Fail conditions
if  ( _presetName isEqualTo "" ) exitWith { ZRN_LOG_MSG(failed: effectName not provided); false };
if !( toLowerANSI _presetName in (configProperties [configFile >> QGVAR(FogParams), "true", true] apply { toLowerANSI configName _x } ) ) exitWith { ZRN_LOG_MSG(failed: effectName not found); false };

private _varName = "STORM_FX_Weather_Fog_HMO";
private _hmo = missionNameSpace getVariable [_varName, "404"];
if ( _intensity == 0 && { _hmo isEqualTo "404" } ) exitWith { ZRN_LOG_MSG(failed: _intensity == 0 while no previous effect of this Type); false };


if (_hmo isEqualTo "404") then {
//    private _cfg = (configFile >> QGVAR(FogParams) >> _presetName); // not in use currently
    ZRN_LOG_MSG_1(creating new HMO,_hmo);

    private _hash = [configFile >> QGVAR(FogParams), _presetName] call PFUNC(hashFromConfig);

    _hmo = createHashMapObject [
        [
            ["isActive", true],
            ["inTransition", true],

            ["varName", _varName],
            ["presetName", _presetName],

            ["time_start", CBA_missionTime],
            ["time_end", (CBA_missionTime + _duration)],

            ["restore_willRestore", _restore],
            ["restore_previousWeather", fogParams],
            ["restore_duration", _duration],

            ["fog_value_min", _hash get "fog_value_min"],
            ["fog_value_max", _hash get "fog_value_max"],
            ["fog_decay", _hash get "fog_decay"],
            ["fog_base", _hash get "fog_base"],

            ["fog_mode", _hash get "fog_mode"],
            ["fog_useAvgASL", _hash get "fog_useAvgASL" > 0],

            ["fogParamsStart", fogParams],
            ["fogParamsTarget", [0,0,0]],

            ["intensity_Start", 0.01],
            ["intensity_Current", 0.01],
            ["intensity_Target", _intensity],

            ["interval", INTERVAL],

            ["#flags", ["noCopy","unscheduled"]],

            ["#create", {
                private _fnc_scriptName = "#create";

                _self call ["Meth_Apply"];

                ZRN_LOG_MSG(done);
            }],


            ["#delete", {
                // Handles return to pre-storm fogParams
                private _fnc_scriptName = "#delete";
                if (OGET(restore_willRestore)) then {
                    OGET(restore_duration) setFog OGET(restore_previousWeather);
                };
            }],

            // Methods
            ["Meth_Update", {
                // Updates the current
                private _fnc_scriptName = "Meth_Update";

                params ["_presetName", "_duration", "_intensity","_restore"];

                if (_restore) then {
                    OSET(restore_willRestore,_restore);
                    OSET(restore_previousWeather,fogParams);
                    OSET(restore_duration,_duraiton);
                };

                OSET(time_start,CBA_missionTime);
                OSET(time_end,CBA_missionTime + _duration);

                if (_presetName != OGET(presetName)) then {
                    ZRN_LOG_MSG_2(Different Preset - updating Data and Intensity,_presetName,_intensity);
                    private _hash = [configFile >> QGVAR(FogParams), _presetName] call PFUNC(hashFromConfig);
                    OSET(presetName,_presetName);

                    OSET(fog_value_min,_hash get "fog_value_min");
                    OSET(fog_value_max,_hash get "fog_value_max");

                    OSET(fog_decay,_hash get "fog_decay");
                    OSET(fog_base,_hash get "fog_base");

                    OSET(fog_mode,_hash get "fog_mode");
                    OSET(fog_useAvgASL,_hash get "fog_useAvgASL");
                } else {
                    ZRN_LOG_MSG_2(Same Preset - Updating Intensity,_presetName,_intensity);
                };

                OSET(intensity_Start,OGET(intensity_Current));
                OSET(intensity_Target,_intensity);

                //  OSET(isActive,true); // this shouldnt be needed i think.
                OSET(inTransition,true);
            }],

            ["Meth_CurrentIntensity", {
                // calculates and stores current intensity.
                private _fnc_scriptName = "Meth_CurrentIntensity";
                
                private _int = linearConversion [
                    OGET(time_start),
                    OGET(time_end),
                    CBA_missionTime,
                    OGET(intensity_Start),
                    OGET(intensity_Target),
                    true
                ];
                
                ZRN_LOG_1(OGET(time_start));
                ZRN_LOG_1(OGET(time_end));
                ZRN_LOG_1(CBA_missionTime);
                ZRN_LOG_1(OGET(intensity_Start));
                ZRN_LOG_1(OGET(intensity_Target));
                
                OSET(intensity_Current,_int);
                ZRN_LOG_MSG_1(result:,_int);
            }],

            ["Meth_currentFogParams", {
                // calculates and returns current target fogParams, be it "simple value" (0..1) or paramArray.
                private _fnc_scriptName = "Meth_currentFogParams";
                private _fog_mode = OGET(fog_mode);
                private _return = switch (_fog_mode) do {
                    case "STATIC": {
                        linearConversion [0,1,OGET(intensity_Current), OGET(fog_value_min), OGET(fog_value_max), true];
                        ZRN_LOG_3(OGET(intensity_Current),OGET(fog_value_min),OGET(fog_value_max));
                    };
                    /*case "DYNAMIC": {
                        private _value = linearConversion [0,1,OGET(intensity_Current), OGET(fog_value_min), OGET(fog_value_max), true];
                        private _dispersion = OGET(fog_decay);
                        private _base = switch (OGET(fog_useAvgASL)) do {
                            case 0: { OGET(fog_base) };
                            case 1: { OGET(fog_base) + [] call FUNC(get_AvgASL) };
                        };
                        [
                            _value,
                            _dispersion,
                            _base
                        ]
                    };*/
                    default { 
                        ZRN_LOG_MSG_1(failed: invalid fog_mode - fallback to 0,_fog_mode);
                        0
                    };
                };
                ZRN_LOG_1(_return);
                _return
            }],

            ["Meth_Apply", {
                private _fnc_scriptName = "Meth_Apply";

                ZRN_LOG_MSG(start);

                // if not active, stop the loop and delete the HMO
                if (!OGET(isActive)) exitWith {
                    ZRN_LOG_MSG_1(Exit: HMO reference deleted,OGET(isActive));
                    missionNamespace setVariable [OGET(varName), nil];
                };
                _self call ["Meth_CurrentIntensity"];

                private _fogParams = _self call ["Meth_currentFogParams"];

                ZRN_LOG_MSG_2(FogExecution,OGET(interval),_fogParams);
                OGET(interval) setFog _fogParams;

                // When intensity of 0 has been reached, delete the HMO
                if (OGET(intensity_Current) == 0) then {
                    OSET(isActive,false);
                    ZRN_LOG_MSG_1(isActive set to false: Intensity Current reached 0,OGET(intensity_Current));
                };
                // When intensity == target, end Transition.
                if (OGET(intensity_Current) == OGET(intensity_Target)) then {
                    OSET(inTransition,false);
                    ZRN_LOG_MSG_1(inTransition set to false: intensity_Current equals intensity_Target,OGET(intensity_Target));

                };

                [{ _this#0 call ["Meth_Apply"] }, [_self], OGET(interval)] call CBA_fnc_waitAndExecute;
            }]
        ]
    ];

    missionNamespace setVariable [_varName, _hmo];

} else {
    _hmo call ["Meth_Update", _this];
};

true


/*

For storm with long duration, it might be needed to reapply the fog after a while, or when skipTime is being used, as this will cause the environment simulation to (prepare) a new natural weatherchange.

Just re-apply the fog on an interval? Is it performance heavy?

Alternative: Implement a system that detects weather changes?


Problem 2: 
*/