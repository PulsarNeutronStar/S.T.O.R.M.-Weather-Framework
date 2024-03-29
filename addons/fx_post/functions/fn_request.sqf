#include "..\script_component.hpp"

/*
 * Author: Zorn
 * Creates, Adjusts and ppEffects over time with intensity. 
 *
 * Arguments:
 * 0: _effectName    <STRING> Name of Post Process Preset - Capitalisation needs to be exact!
 * 1: _duration          <NUMBER> in Minutes for the duration to be applied.
 * 2: _intensity         <NUMBER> 0..1 Factor of Intensity for the PP Effect 
 *
 * Return Value:
 * _pp_effect_JIP_handle  <STRING>
 *
 * Example:
 * ["CVO_CC_Alias", 5, 0.5] call storm_fxPost_fnc_request;
 * 
 * Public: No
 */

 
if (!isServer) exitWith { _this remoteExecCall [ QFUNC(request), 2, false]; };

 params [
    ["_effectName",     "", [""]],
    ["_duration",       1,  [0] ],
    ["_intensity",      0,  [0] ]
 ];


if  (_effectName isEqualTo "")                                                                               exitWith { ZRN_LOG_MSG(failed: effectName not provided); false};
if !(_effectName in (configProperties [configFile >> QGVAR(Presets), "true", true] apply { configName _x })) exitWith { ZRN_LOG_MSG(failed: effectName not found);    false};

private _configPath = (configFile >> QGVAR(Presets) >> _effectName ); 
private _ppEffectType = getText (_configPath >> "ppEffectType");
private _layer = getNumber (_configPath >> "layer");
private _jipHandle = QGVAR_3(_ppEffectType,_layer,jip_handle);

_intensity = _intensity max 0 min 1;

// Check fail when _intensity == 0 while no Prev effect

if ( _intensity == 0 && { isNil QGVAR(activeJIPs) || { !(_jipHandle in GVAR(activeJIPs))} } ) exitWith {   ZRN_LOG_MSG(failed: _intensity == 0 while no previous effect of this Type); false };

if (isNil QGVAR(activeJIPs)) then {
    GVAR(activeJIPs) = createHashMap;
} else { if ( GVAR(activeJIPs) getOrDefault [_jipHandle, false] ) exitWith { ZRN_LOG_MSG(failed: This Type and Layer is currently in Transition!); false }; };

_duration = (1 max _duration) * 60;

private "_resultArray";
private _effectArray = [_effectName] call FUNC(getConfig);


// Check if given Class is Default (Parent)
if (configName inheritsFrom _configPath isEqualTo "") then {
    // i dont remember why i made this but i guess it has a reason lol
    // Default Class -> ignore Intensity
    _resultArray = _effectArray;
} else {

    // Non Default Class -> Apply Intensity based of _effectArray and _baseArray (Parent: Default)
    private   _baseArray = getArray (_configPath >> "baseArray");

    if (_effectArray isEqualTo false) exitWith {false};
    if !( _baseArray isEqualType [] ) exitWith {false};

    _resultArray = [_effectArray, _intensity, _baseArray] call FUNC(convertIntensity);

};

/////////////////////////////////////////////////////////////////////////////
// RemoteExec the request

private _jipHandle = [_effectName, _resultArray, _duration, _intensity] remoteExecCall [QFUNC(remote), [0,2] select isDedicated, _jipHandle];
if (isNil "_jipHandle") exitWith { ZRN_LOG_MSG(failed: remoteExec failed);    false };

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

// Sets Transition to false post Transition
[{ GVAR(activeJIPs) set [_this#0, false]; }, [_jipHandle], _duration] call CBA_fnc_waitAndExecute;

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

// Handles Cleanup of JIP in case of decaying(transition-> 0) Effect once transition to 0 is completed.
if (_intensity == 0) then {
    [{
        remoteExec ["", _this#0];
        GVAR(activeJIPs) deleteAt _this#0;

    }, [_jipHandle], _duration] call CBA_fnc_waitAndExecute;

} else {
    // true for _inTransition;
    GVAR(activeJIPs) set [_jipHandle, true];
};
true