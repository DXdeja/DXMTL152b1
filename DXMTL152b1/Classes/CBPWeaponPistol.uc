//================================================================================
// CBPWeaponPistol.
//================================================================================
class CBPWeaponPistol extends WeaponPistol;

simulated function MuzzleFlashLight ()
{
	if ( Pawn(Owner) != None )
	{
		Super.MuzzleFlashLight();
	}
}

defaultproperties
{
    mpPickupAmmoCount=9
    PickupAmmoCount=9
}
