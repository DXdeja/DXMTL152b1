//================================================================================
// CBPBloodSpurt.
//================================================================================
class CBPBloodSpurt extends BloodSpurt;

final simulated function V00 ()
{
	Velocity=vect(0.00,0.00,0.00);
	if ( Level.NetMode != 1 )
	{
		DrawScale -= FRand() * 0.50;
		PlayAnim('Spurt');
		if ( Class'GameInfo'.Default.bLowGore )
		{
			Destroy();
		}
	}
}

auto simulated state Flying
{
	simulated function AnimEnd ()
	{
		Destroy();
	}

	simulated function BeginState ()
	{
	}

Begin:
	V00();
}

simulated function PreBeginPlay ()
{
	Super(Actor).PreBeginPlay();
}

defaultproperties
{
    bNetTemporary=True
    bNetOptional=True
    LifeSpan=0.60
    DrawScale=1.50
    ScaleGlow=2.00
    bUnlit=True
}
