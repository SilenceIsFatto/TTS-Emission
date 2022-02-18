/*
	Author: TheTimidShade

	Description:
		Creates sound source object near and above local player and plays given sound

	Parameters:
		0: STRING - Name of sound to play on source
		
	Returns:
		NONE
*/

if (!hasInterface) exitWith {}; // don't run sounds or particles on dedi or HC

params ["_sound"];

private _source = "Sign_Sphere10cm_F" createVehicleLocal [0,0,0];
_source hideObject true;
private _direction = round random 360;
private _sourcePos = (positionCameraToWorld [0,0,0]) getPos [50 + (random 50), _direction];
private _playerHeight = (getPosASL player)#2;
_source setPosASL [_sourcePos#0, _sourcePos#1, ((positionCameraToWorld [0,0,0])#2) + 30];

_source say3D [_sound, 1200, 1, false];

sleep 30;

deleteVehicle _source;