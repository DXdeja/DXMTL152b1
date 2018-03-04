//================================================================================
// CBPWeaponGEPGun.
//================================================================================
class CBPWeaponGEPGun extends WeaponGEPGun;

var private float Z7F;
var private float Z80;

final simulated function V04 ()
{
	Class'V34'.static.V0A(self,Z7F,Z80,1.60);
}

simulated function Tick (float VC5)
{
	if ( IsInState('DownWeapon') || IsInState('SimDownweapon') )
	{
		Z7F += VC5;
	}
	Super.Tick(VC5);
}

function CycleAmmo ()
{
	if (  !IsInState('Reload') )
	{
		Super.CycleAmmo();
	}
}

simulated function ClientReload ()
{
	if (  !IsInState('SimReload') )
	{
		Super.ClientReload();
	}
}

function ReloadAmmo ()
{
	Class'V34'.static.V0B(self);
}

simulated state SimDownweapon
{
	simulated function BeginState ()
	{
		RefreshScopeDisplay(DeusExPlayer(Owner),False,False);
		Super.BeginState();
	}

}

state DownWeapon
{
	ignores  AltFire, Fire;

Begin:
	Class'V34'.static.V0C(self);
	FinishAnim();
	bOnlyOwnerSee=False;
	if ( Pawn(Owner) != None )
	{
		Pawn(Owner).ChangedWeapon();
	}
}

state Active
{
	function BeginState ()
	{
		V04();
		Super.BeginState();
	}

}

simulated state SimActive
{
	simulated function BeginState ()
	{
		V04();
		SimClipCount=ClipCount;
	}

}
