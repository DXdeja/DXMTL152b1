//================================================================================
// CBPWeaponShuriken.
//================================================================================
class CBPWeaponShuriken extends WeaponShuriken;

function ServerHandleNotify (bool S45, Class<Projectile> ProjClass, float projSpeed, bool bWarn)
{
	if ( AmmoType.UseAmmo(1) )
	{
		ProjectileFire(ProjectileClass,ProjectileSpeed,bWarnTarget);
	}
	if ( (AmmoType.AmmoAmount <= 0) &&  !Class'MTLManager'.Default.bKnife_KeepPlaceholder )
	{
		Destroy();
	}
}

simulated function HandToHandAttack ()
{
	if ( AmmoType.AmmoAmount > 0 )
	{
		if ( DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn()) )
		{
			ServerHandleNotify(False,None,0.00,False);
		}
	}
}

simulated function OwnerHandToHandAttack ()
{
}

simulated function bool ClientFire (float Z85)
{
	local bool bWaitOnAnim;

	if ( Owner == None )
	{
		GotoState('SimIdle');
		return False;
	}
	if ( Region.Zone.bWaterZone )
	{
		if ( Pawn(Owner) != None )
		{
			Pawn(Owner).ClientMessage(msgNotWorking);
		}
		return False;
	}
	if (  !bLooping )
	{
		bWaitOnAnim=IsAnimating() && ((AnimSequence == 'Select') || (AnimSequence == 'Shoot') || (AnimSequence == 'ReloadBegin') || (AnimSequence == 'Reload') || (AnimSequence == 'ReloadEnd') || (AnimSequence == 'Down'));
	} else {
		bWaitOnAnim=False;
		bLooping=False;
	}
	if ( Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).NintendoImmunityTimeLeft > 0.01) ||  !bClientReadyToFire || bInProcess || bWaitOnAnim )
	{
		DeusExPlayer(Owner).bJustFired=False;
		bPointing=False;
		bFiring=False;
		return False;
	}
	ServerForceFire();
	if ( AmmoType.AmmoAmount <= 0 )
	{
		GotoState('SimIdle');
		return False;
	}
	bClientReadyToFire=False;
	bInProcess=True;
	GotoState('ClientFiring');
	bPointing=True;
	if ( PlayerPawn(Owner) != None )
	{
		PlayerPawn(Owner).PlayFiring();
	}
	PlaySelectiveFiring();
	PlayFiringSound();
	return True;
}

function Fire (float Z85)
{
	local bool bListenClient;

	if ( Owner == None )
	{
		GotoState('Idle');
		return;
	}
	bListenClient=Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient();
	if ( Level.NetMode != 0 )
	{
		if ( Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).NintendoImmunityTimeLeft > 0.01) ||  !bClientReady &&  !bListenClient )
		{
			DeusExPlayer(Owner).bJustFired=False;
			bReadyToFire=True;
			bPointing=False;
			bFiring=False;
			return;
		}
	}
	if ( Region.Zone.bWaterZone )
	{
		if ( Pawn(Owner) != None )
		{
			Pawn(Owner).ClientMessage(msgNotWorking);
		}
		GotoState('Idle');
		return;
	}
	if ( AmmoType.AmmoAmount <= 0 )
	{
		GotoState('Idle');
		return;
	}
	if ( (Level.NetMode != 0) &&  !bListenClient )
	{
		bClientReady=False;
	}
	bReadyToFire=False;
	GotoState('NormalFire');
	bPointing=True;
	if ( Owner.IsA('PlayerPawn') )
	{
		PlayerPawn(Owner).PlayFiring();
	}
	PlaySelectiveFiring();
	PlayFiringSound();
	if ( DeusExPlayer(Owner) != None )
	{
		DeusExPlayer(Owner).UpdateBeltText(self);
	}
}

state NormalFire
{
	function AnimEnd ()
	{
		if ( AmmoType.AmmoAmount <= 0 )
		{
			GotoState('Idle');
		}
	}

}

defaultproperties
{
    ProjectileClass=Class'CBPShuriken'
}
