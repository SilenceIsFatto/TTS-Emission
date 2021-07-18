/*
	Author: TheTimidShade

	Description:
		Handles blowout wave on client side

	Parameters:
		NONE
		
	Returns:
		NONE
*/

if (!hasInterface) exitWith {}; // don't run effects on server or hc

private _particleSpacing = 80;

private _wavePos = getPos player;
_wavePos = [_wavePos#0, (_wavePos#1) + (missionNamespace getVariable ["tts_emission_wave_distance", 800])]; // get position to player's north 800m

private _waveObject = "Sign_Sphere25cm_F" createVehicleLocal _wavePos;
private _dropper = "Sign_Sphere25cm_F" createVehicleLocal _wavePos;
_waveObject hideObject true;
_dropper hideObject true;

_waveObject spawn { // handle sound
	while {alive _this} do {
		_this say3D ["blowout_particle_wave", 3000, 1, false];
		sleep 22;
	};
};

[_waveObject, 1400] spawn { // handle cam shake
	params ["_waveObject", "_distance"];
	enableCamShake true;
	while {alive _waveObject} do {
		private _shakeCoef = 1-((player distance _waveObject)/_distance); // shake intensifies as wave approaches
		addCamShake [3*(_shakeCoef^2), 2, 10];
		sleep 0.2;
	};
};

// while the wave is active, update position using distance passed by server
while {!tts_emission_wave_finished} do {
	_wavePos = getPos player;
	_waveDist = missionNamespace getVariable ["tts_emission_wave_distance", 800];
	_wavePos set [1, _wavePos#1 + _waveDist];
	
	_waveObject setPos _wavePos;

	for "_dst" from 0 to 20 do { // spawn single wave of particles
		private _offsetX = ((random 3) - 6);
		private _offsetY = ((random 12) - 24);
		private _sizeMod = random 40;
		
		private _dropPos = [_wavePos#0 + ((_dst-10)*_particleSpacing) + ((random _particleSpacing) - _particleSpacing/2), _wavePos#1, random 10];
		if (getTerrainHeightASL _dropPos <= 0) then {
			_dropper setPosASL _dropPos;
		} else {
			_dropper setPosATL _dropPos;
		};

		drop [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 4, [_offsetX, _offsetY, 0], [0, 0, 0], 0, 10, 7.6, 0, [60+_sizeMod,40+_sizeMod], [[1,1,1,0.3],[1,1,1,0]], [0.08], 1, 0, "", "", _dropper, 0, true];
		
		// sometimes add smaller sub particle
		if (selectRandom [true,false]) then {
			drop [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 4, [_offsetX, _offsetY*2, 0], [0, 0, 0], 0, 10, 7.6, 0, [50+_sizeMod,40+_sizeMod], [[0,0.5,0.5,0.8],[0,0.5,0.5,0]], [0.08], 1, 0, "", "", _dropper, 0, true];
		};
	};

	// when the wave gets close handle player damage
	if (abs _waveDist < 20) then {
		[] spawn tts_emission_fnc_damagePlayer; // handle effects on player
	};

	sleep 0.1;
};

// cleanup
deleteVehicle _waveObject;
deleteVehicle _dropper;
