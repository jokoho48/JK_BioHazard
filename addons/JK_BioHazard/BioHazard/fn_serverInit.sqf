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
GVAR(protectionGear) = getArray (missionConfigFile >> "CfgHazard" >> "ProtectionGear");
GVAR(detectionGear) = getArray (missionConfigFile >> "CfgHazard" >> "DetectionGear");
GVAR(protectionGear) = GVAR(protectionGear) apply {toLower _x};
GVAR(detectionGear) = GVAR(detectionGear) apply {toLower _x};


GVAR(namespace) = true call CFUNC(createNamespace);
{
    private _markerName = configName _x;
    _markerName setMarkerAlpha 0;
    private _damage = getNumber (_x >> "damage");
    private _isDetectable = getNumber (_x >> "isDetectable");
    private _zoneData =
        [
            getMarkerPos _markerName,
            getMarkerSize _markerName select 0,
            getMarkerSize _markerName select 1,
            markerDir _markerName,
            markerShape _markerName isEqualTo "RECTANGLE"
        ];
    [GVAR(namespace), configName _x, [_damage, _isDetectable isEqualTo 1, _zoneData], QGVAR(allVariables), true] call CFUNC(setVariable);
} count configProperties [missionConfigFile >> "CfgHazard" >> "Regions", "isClass _x", true];
publicVariable QGVAR(namespace);
publicVariable QGVAR(protectionGear);
publicVariable QGVAR(detectionGear);
