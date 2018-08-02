#include "macros.hpp"
/*
    JK Biohazard

    Author: joko // Jonas

    Description:


    Parameter(s):
    None

    Returns:
    None
*/
GVAR(isProtected) = false;
GVAR(hasDetection) = false;
GVAR(debugMarker) = [];
private _stateMachine = call CFUNC(createStatemachine);
[_stateMachine, "init", {
    GVAR(index) = 0;
    GVAR(soundIsPlaying) = false;
    "checkArea"
}] call CFUNC(addStatemachineState);


[_stateMachine, "checkArea", {
    private _allVars = [GVAR(namespace),QGVAR(allVariables)] call CFUNC(allVariables);
    private _zone = _allVars select GVAR(index);
    GVAR(index) = (GVAR(index) + 1) mod (count _allVars);
    private _data = GVAR(namespace) getVariable [_zone, ["", 0, [[0,0,0], 0, 0, 0, false, -1]]];
    _data params [["_damage", 0], ["_isDetectable", true], "_zoneData"];
    if (CLib_Player inArea _zoneData) then {
        if !(GVAR(isProtected)) then {
            [QGVAR(addDamage), _damage] call CFUNC(localEvent);
        };
        if (GVAR(hasDetection) && _isDetectable) then {
            if !(GVAR(soundIsPlaying)) then {
                GVAR(soundIsPlaying) = true;
                playSound "JK_BioHazard_Sound";
                DUMP("Playing Sound");
                [{
                    GVAR(soundIsPlaying) = false;
                }, 1] call CFUNC(wait);
            };
        };
    };
    "checkArea"
}] call CFUNC(addStatemachineState);

[_stateMachine, "init", getNumber (missionConfigFile >> "CfgHazard" >> "tickRate")] call CFUNC(startStatemachine);

DFUNC(checkGear) = {
    private _gear = CLib_Player call CFUNC(getAllGear);
    private _items = [];

    {
        private _item = _x;
        if (_item isEqualType []) then {
            {
                private _item = _x;
                if (_item isEqualType "") then {
                    _items pushBackUnique (toLower _item);
                };
                nil
            } count _item;
        } else {
            if (_item isEqualType "") then {
                _items pushBackUnique (toLower _item);
            };
        };
        nil
    } count _gear;

    scopeName "LoopHole";
    GVAR(isProtected) = false;
    {
        GVAR(isProtected) = _x in _items;
        if (GVAR(isProtected)) then {breakTo "LoopHole";};
        nil
    } count GVAR(protectionGear);

    {
        GVAR(hasDetection) = _x in _items;
        if (GVAR(hasDetection)) then {breakTo "LoopHole";};
        nil
    } count GVAR(detectionGear);
};

["playerInventoryChanged", {
    call FUNC(checkGear);
}] call CFUNC(addEventhandler);

call DFUNC(checkGear);

[QGVAR(addDamage), {
    (_this select 0) params ["_damage"];
    DUMP("Apply Damage!");
    if (isNil "ace_medical_fnc_addDamageToUnit") then {
        CLib_Player setDamage ((damage CLib_Player) + _damage);
    } else {
        [CLib_Player, _damage, "body", ""] call ace_medical_fnc_addDamageToUnit;
    };
}] call CFUNC(addEventhandler);

if ((isClass (configFile >> "CfgPatches" >> "achilles_functions_f_achilles")) && (isClass (configFile >> "CfgPatches" >> "achilles_functions_f_ares"))) then {
    call FUNC(Modules);
};
