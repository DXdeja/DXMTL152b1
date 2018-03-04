//================================================================================
// CBPBloodDrop.
//================================================================================
class CBPBloodDrop extends BloodDrop;

final simulated function V00 ()
{
	if ( Level.NetMode != 1 )
	{
		Velocity=VRand() * 100;
		DrawScale=1.00 + FRand();
		SetRotation(rotator(Velocity));
		if ( Class'GameInfo'.Default.bLowGore )
		{
			Destroy();
		}
	}
}

final simulated function V45 (Rotator VEB)
{
	if ( Level.NetMode != 1 )
	{
		Spawn(Class'CBPBloodSplat',,,Location,VEB);
		Destroy();
	}
}

simulated state Flying
{
	simulated function HitWall (Vector Z14, Actor Z88)
	{
		V45(rotator(Z14));
	}

	simulated function BeginState ()
	{
		Super(Object).BeginState();
	}

Begin:
	V00();
}

simulated function Tick (float VC5)
{
	if ( Level.NetMode == 1 )
	{
		Disable('Tick');
		return;
	}
	if ( Velocity == vect(0.00,0.00,0.00) )
	{
		V45(rot(16384,0,0));
	} else {
		SetRotation(rotator(Velocity));
	}
}

simulated function PreBeginPlay ()
{
	Super(Actor).PreBeginPlay();
}

simulated function PostBeginPlay ()
{
	Super(Fragment).PostBeginPlay();
}

defaultproperties
{
    bNetTemporary=True
    LifeSpan=5.00
    DrawScale=1.50
    ScaleGlow=2.00
    bUnlit=True
    NetUpdateFrequency=100.00
}
