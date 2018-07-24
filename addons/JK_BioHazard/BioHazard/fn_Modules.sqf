#include "macros.hpp"
/*
    FK Framework

    Author: joko // Jonas

    Description:


    Parameter(s):
    None

    Returns:
    None
*/

DFUNC(changeDamage) = {
    private _allVars = [GVAR(namespace), QGVAR(allVariables)] call CFUNC(allVariables);
    private _allAreaNames = _allVars apply { format ["%1 %2", _x, getMarkerPos _x] };
    private _dialogResult =
    [
        "Change Area Damage",
        [
            [ "Zone", _allAreaNames, 0],
            [ "Damage", "", "0.001"],
            [ "is Detectable", ["Activate", "Deactivate"], 0]
        ]
    ] call Ares_fnc_ShowChooseDialog;
    if (_dialogResult isEqualTo []) exitWith { ["Aborted"] call Achilles_fnc_showZeusErrorMessage };
    _dialogResult params ["_zoneId", "_damage", "_detectable"];
    private _zone = _allVars select _zoneId;
    [GVAR(namespace), _zone, [parseNumber _damage, _detectable isEqualTo 0], QGVAR(allVariables), true] call CFUNC(setVariable);
    playSound "ClickSoft";
};
["FK Bio Hazard", "Change Area Damage", {
    call FUNC(changeDamage);
}] call Ares_fnc_RegisterCustomModule;

DFUNC(deleteArea) = {
    private _allVars = [GVAR(namespace), QGVAR(allVariables)] call CFUNC(allVariables);
    private _allAreaNames = _allVars apply { format ["%1 %2", _x, getMarkerPos _x] };
    private _dialogResult =
    [
        "Delete Area",
        [
            [ "Zone", _allAreaNames, 0]
        ]
    ] call Ares_fnc_ShowChooseDialog;
    if (_dialogResult isEqualTo []) exitWith { ["Aborted"] call Achilles_fnc_showZeusErrorMessage };
    _dialogResult params ["_zoneId"];
    private _zone = _allVars select _zoneId;
    [GVAR(namespace), _zone, nil, QGVAR(allVariables), true] call CFUNC(setVariable);
    playSound "ClickSoft";
};

["FK Bio Hazard", "Delete Area", {
    call FUNC(deleteArea);
}] call Ares_fnc_RegisterCustomModule;

DFUNC(addArea) = {
    params ["_module_position"];
    private _allVars = [GVAR(namespace), QGVAR(allVariables)] call CFUNC(allVariables);
    private _dialogResult1 =
    [
        "Create Bio Hazard Zone",
        [
            ["Name", "", "Name_Must_Be_Unique_and_without_spaces" + str(count _allVars)],
            ["Shape", ["RECTANGLE", "ELLIPSE"], 1],
            ["SizeA", "", "100"],
            ["SizeB", "", "200"],
            ["Dir (-1 = current Camera Direction)", "", "-1"]
        ]
    ] call Ares_fnc_ShowChooseDialog;
    if (_dialogResult1 isEqualTo []) exitWith { ["Aborted"] call Achilles_fnc_showZeusErrorMessage };
    _dialogResult1 params ["_zone", "_shape", "_a", "_b", "_dir"];
    if (_dir == "-1") then {
        _dir = str ((positionCameraToWorld [0, 0, 0]) getDir (positionCameraToWorld [1, 0, 0]));
    };
    if (_zone in _allVars) exitWith {
        DUMP("Zone name Already used");
        [format ["Zone name Already used: %1", _zone]] call Achilles_fnc_showZeusErrorMessage;
    };

    private _zoneData = [_module_position, parseNumber _a, parseNumber _b, parseNumber _dir, _shape == 0, 0];

    private _dialogResult2 =
    [
        "Change Damage of Area",
        [
            [ "Damage", "", "0.001"],
            [ "is Detectable", ["Activate", "Deactivate"], 0]
        ]
    ] call Ares_fnc_ShowChooseDialog;

    if (_dialogResult2 isEqualTo []) exitWith { deleteMarker _zone; DUMP("2nd Settings Failed"); };
    _dialogResult2 params ["_damage", "_detectable"];

    [GVAR(namespace), _zone, [(parseNumber _damage), _detectable isEqualTo 0, _zoneData], QGVAR(allVariables), true] call CFUNC(setVariable);
    playSound "ClickSoft";
};

["FK Bio Hazard", "Add Area", {
    _this call FUNC(addArea);
}] call Ares_fnc_RegisterCustomModule;

DFUNC(toggleDebug) = {
    private _dialogResult =
    [
        "Debug",
        [
            [ "Debug", ["Deactivate", "Activate"], 0]
        ]
    ] call Ares_fnc_ShowChooseDialog;
    if (_dialogResult isEqualTo []) exitWith { ["Aborted"] call Achilles_fnc_showZeusErrorMessage };
    _dialogResult params ["_debug"];
    private _allVars = [GVAR(namespace), QGVAR(allVariables)] call CFUNC(allVariables);

    {
        deleteMarkerLocal _x;
        nil
    } count GVAR(debugMarker);
    GVAR(debugMarker) = [];

    if (_debug == 1) then {
        {
            ((GVAR(namespace) getVariable _x) select 2) params ["_center", "_a", "_b", "_angle", "_isRectangle"];
            private _zone = createMarkerLocal [_x + "local", _center];
            _zone setMarkerDirLocal _angle;
            _zone setMarkerSizeLocal [_a, _b];
            _zone setMarkerShapeLocal (["ELLIPSE", "RECTANGLE"] select _isRectangle);
            _zone setMarkerBrushLocal "Solid";
            _zone setMarkerAlphaLocal 1;
            GVAR(debugMarker) pushBack _zone;
            nil
        } count _allVars;
    };
    playSound "ClickSoft";
};

["FK Bio Hazard", "Toggle Debug", {
    call FUNC(toggleDebug);
}] call Ares_fnc_RegisterCustomModule;
