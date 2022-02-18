/*
	Author: TheTimidShade

	Description:
		Checks if the unit is safe from the emission

	Parameters:
		0: OBJECT - Unit to check status for
		
	Returns:
		BOOL - Whether or not unit is safe from emission (deep enough underwater or has a roof within 30m above their head)
*/

params [
	["_unit", objNull, [objNull]]
];

if (isNull _unit) exitWith {false};
if ([_unit] call tts_emission_fnc_isImmune) exitWith {true}; // if the unit is immune they are safe
if (isPlayer _unit && tts_emission_playerEffect in [2,3]) exitWith {false}; // The player cannot be sheltered when the 'Knockout all'/'Kill all' parameter is selected
if (!isPlayer _unit && tts_emission_aiEffect in [2,3]) exitWith {false}; // The AI cannot be sheltered when the 'Knockout all'/'Kill all' parameter is selected
if (((getPosASL _unit)#2) <= -2) exitWith {true}; // if unit is more than 2m underwater, they are safe

private _isSafe = false;

private _eyePos = eyePos _unit;
private _endPos = [_eyePos#0, _eyePos#1, _eyePos#2+30];

private _intersectObjects = lineIntersectsWith [_eyePos, _endPos, _unit, objNull, true]; // check if there are any objects above player's head for 5m

{
	if (_x call tts_emission_fnc_isSafeType) exitWith {_isSafe = true;}; // check if there is an object which is considered shelter above player
} forEach _intersectObjects;

_isSafe