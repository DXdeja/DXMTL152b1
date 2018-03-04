//================================================================================
// CBPAmmoCrate.
//================================================================================
class CBPAmmoCrate extends ammocrate;

function PreBeginPlay ()
{
	bInvincible=Class'MTLManager'.Default.bInvincibleAmmoCrates;
	Super.PreBeginPlay();
}

function Frob (Actor VB8, Inventory VB9)
{
	local DeusExPlayer Player;
	local Inventory Z7E;

	Player=DeusExPlayer(VB8);
	if ( Player != None )
	{
		Z7E=Player.Inventory;
JL002F:
		if ( Z7E != None )
		{
			if ( Z7E.IsA('DeusExWeapon') &&  !Z7E.IsA('WeaponLAM') &&  !Z7E.IsA('WeaponEMPGrenade') &&  !Z7E.IsA('WeaponGasGrenade') )
			{
				RestockWeapon(Player,DeusExWeapon(Z7E));
			}
			Z7E=Z7E.Inventory;
			goto JL002F;
		}
		Player.ClientMessage(AmmoReceived);
		PlaySound(Sound'WeaponPickup',SLOT_None,0.50 + FRand() * 0.25,,256.00,0.95 + FRand() * 0.10);
	}
}

defaultproperties
{
    bInvincible=True
}
