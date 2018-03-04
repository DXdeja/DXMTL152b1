//================================================================================
// CBPFleshFragment.
//================================================================================
class CBPFleshFragment extends FleshFragment;

var float V46;
var float Z86;

final simulated function V00 ()
{
	local Vector VEB;

	if ( Level.NetMode != 1 )
	{
		Velocity=VRand() * 300;
		VEB=Velocity;
		VEB.Z=0.00;
		SetRotation(rotator(VEB));
		DrawScale=FRand() * 1.10 + 1.10;
		if ( Class'GameInfo'.Default.bLowGore )
		{
			Destroy();
		}
	}
}

auto simulated state Flying
{
	simulated function BeginState ()
	{
		Super(Object).BeginState();
	}

Begin:
	V00();
}

simulated state Dying
{
	simulated function BeginState ()
	{
		Super.BeginState();
	}

}

simulated function Tick (float VC5)
{
	local CBPBloodDrop Z87;

	if ( Level.NetMode == 1 )
	{
		Disable('Tick');
		return;
	}
	Super(Actor).Tick(VC5);
	Z86 += VC5;
	if ( Z86 < 0.06 )
	{
		return;
	}
	if (  !IsInState('Dying') )
	{
		if ( FRand() < V46 )
		{
			Z87=Spawn(Class'CBPBloodDrop',,,Location);
			if ( Z87 != None )
			{
				Z87.RemoteRole=ROLE_None;
			}
		}
		V46 -= Z86 * 0.10;
	}
	Z86=0.00;
}

defaultproperties
{
    V46=0.50
}
