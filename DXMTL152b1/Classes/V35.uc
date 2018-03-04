//================================================================================
// V35.
//================================================================================
class V35 extends Actor;

var byte V13;

replication
{
	reliable if ( bNetInitial && (Role == ROLE_Authority) )
		V13;
}

final simulated function V00 ()
{
	local Actor V91;
	local byte VD3;
	Log("V35 V00");

	if ( (Level.NetMode == NM_DedicatedServer) || Class'GameInfo'.Default.bLowGore )
	{
		return;
	}
	V91=Spawn(Class'CBPBloodSpurt',,,Location);
	if ( V91 != None )
	{
		V91.RemoteRole=ROLE_None;
	}
	for(VD3=0; VD3<V13; VD3++)
    {
		V91=Spawn(Class'CBPBloodDrop',,,Location);
		if ( V91 != None )
		{
			V91.RemoteRole=ROLE_None;
		}
	}
}

auto simulated state V12
{
Begin:
	V00();
}

defaultproperties
{
    V13=2
    bNetTemporary=True
    bNetOptional=True
    RemoteRole=ROLE_SimulatedProxy
    LifeSpan=1.00
    DrawType=DT_None
    Texture=None
}
