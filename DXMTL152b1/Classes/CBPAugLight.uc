//================================================================================
// CBPAugLight.
//================================================================================
class CBPAugLight extends AugLight;

var V2A Z8A;
var V2A Z8B;

replication
{
	reliable if ( bNetOwner && (Role == ROLE_Authority) )
		Z8A,Z8B;
}

final function V19 ()
{
	if ( Z8A != None )
	{
		Z8A.Destroy();
	}
	if ( Z8B != None )
	{
		Z8B.Destroy();
	}
	Z8A=None;
	Z8B=None;
}

function PreTravel ()
{
	V19();
}

function Deactivate ()
{
	Super(Augmentation).Deactivate();
	V19();
}

final simulated function V18 ()
{
	local Vector Z14;
	local Vector S30;
	local Vector Z12;
	local Vector Z15;

	if ( (Z8A != None) && (Player != None) )
	{
		Z12=Player.Location;
		Z12.Z += Player.BaseEyeHeight;
		Z15=Z12 + LevelValues[CurrentLevel] * vector(Player.ViewRotation);
		Trace(S30,Z14,Z15,Z12,True);
		if ( S30 == vect(0.00,0.00,0.00) )
		{
			S30=Z15;
		}
		Z8A.SetLocation(S30 - vector(Player.ViewRotation * 64));
		Z8A.LightRadius=FClamp(VSize(S30 - Z12) / LevelValues[CurrentLevel],0.00,1.00) * 5.12 + 4.00;
		Z8A.LightType=LT_Steady;
	}
}

final simulated function V17 ()
{
	if ( (Z8B != None) && (Player != None) )
	{
		Z8B.SetLocation(Player.Location + (vect(0.00,0.00,1.00) * Player.BaseEyeHeight) + (vect(1.00,1.00,0.00) * vector(Player.Rotation * Player.CollisionRadius * 1.50)));
	}
}

simulated state Active
{
	simulated function Tick (float VC5)
	{
		if (  !bIsActive && (Role < 4) )
		{
			GotoState('Inactive');
		} else {
			V18();
			V17();
		}
	}

	function BeginState ()
	{
		Super(Object).BeginState();
		Z8A=Spawn(Class'V2A',Player,'None',Player.Location);
		if ( Z8A != None )
		{
			AIStartEvent('Beam',EAITYPE_Visual);
			V18();
		}
		Z8B=Spawn(Class'V2A',Player,'None',Player.Location);
		if ( Z8B != None )
		{
			Z8B.LightBrightness=220;
			V17();
		}
	}

}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
}
