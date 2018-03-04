//================================================================================
// CBPWeaponRifle.
//================================================================================
class CBPWeaponRifle extends WeaponRifle;

var private float Z7F;
var private float Z80;

final simulated function V04 ()
{
	Class'V34'.static.V0A(self,Z7F,Z80,reloadTime);
}

final simulated function float V5E (float Z81)
{
	return Z81 * (1.00 - Z80);
}

simulated function Tick (float VC5)
{
	if ( IsInState('DownWeapon') || IsInState('SimDownweapon') )
	{
		Z7F += VC5;
	}
	Super.Tick(VC5);
}

simulated function MuzzleFlashLight ()
{
	if ( Pawn(Owner) != None )
	{
		Super.MuzzleFlashLight();
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

function ScopeOn ()
{
	if ( bHasScope &&  !bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer') )
	{
		bZoomed=True;
		if ( IsInState('Reload') )
		{
			ClipCount=0;
		}
		RefreshScopeDisplay(DeusExPlayer(Owner),False,bZoomed);
		if (  !IsInState('V01') )
		{
			GotoState('V01');
		}
	}
}

simulated function RefreshScopeDisplay (DeusExPlayer Z5F, bool Z82, bool Z84)
{
	if ( (Z5F == None) || (Z5F.RootWindow == None) )
	{
		return;
	}
	if ( Z84 )
	{
		DeusExRootWindow(Z5F.RootWindow).scopeView.ActivateView(ScopeFOV,False,Z82);
		if (  !IsInState('V01') )
		{
			GotoState('V01');
		}
	} else {
		DeusExRootWindow(Z5F.RootWindow).scopeView.DeactivateView();
	}
}

simulated state V01
{
	ignores  ClientReFire, ClientFire, AltFire, Fire;

Begin:
	Sleep(0.04);
	if ( Level.NetMode == 3 )
	{
		GotoState('SimIdle');
	} else {
		GotoState('Idle');
	}
}

simulated state V05
{
	ignores  ClientReFire, ClientFire, AltFire, Fire;

Begin:
	ScopeOn();
}

state Reload
{
	function float GetReloadTime ()
	{
		return V5E(Super.GetReloadTime());
	}

	function EndState ()
	{
		Z80=0.00;
		Super.EndState();
	}

}

simulated state SimReload
{
	simulated function float GetSimReloadTime ()
	{
		return V5E(Super.GetSimReloadTime());
	}

	simulated function EndState ()
	{
		Z80=0.00;
		Super.EndState();
	}

Begin:
	if ( bWasInFiring )
	{
		if ( bHasMuzzleFlash )
		{
			EraseMuzzleFlashTexture();
		}
		FinishAnim();
	}
	bInProcess=False;
	bFiring=False;
	bWasZoomed=bZoomed;
	if ( bWasZoomed )
	{
		ScopeOff();
	}
	Owner.PlaySound(CockingSound,SLOT_None,,,1024.00);
	PlayAnim('ReloadBegin');
	FinishAnim();
	LoopAnim('Reload');
	Sleep(GetSimReloadTime());
	Owner.PlaySound(AltFireSound,SLOT_None,,,1024.00);
	ServerDoneReloading();
	PlayAnim('ReloadEnd');
	FinishAnim();
	if ( bWasZoomed )
	{
		GotoState('V05');
	}
	GotoState('SimIdle');
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
