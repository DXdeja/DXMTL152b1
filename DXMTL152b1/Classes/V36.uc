//================================================================================
// V36.
//================================================================================
class V36 extends Actor;

var V36 VD2;
var V36 VD1;
var DeusExMover VBA;
var float ZDE;
var bool ZDF;

final function V3A (DeusExMover S42)
{
	Log("V36 V3A");
	VBA=S42;
	ZDE=S42.TimeSinceReset;
}

function Tick (float VC5)
{
	Log("V36 Tick");
	if ( VBA == None )
	{
		Disable('Tick');
		return;
	}
	ZDE += VC5;
	if (  !VBA.bPicking && (ZDE > VBA.TimeToReset) )
	{
		ZDF=True;
	}
	if ( ZDF )
	{
		VBA.bLocked=True;
		VBA.lockStrength=VBA.initiallockStrength;
		VBA.bFrobbable=False;
		if ( VBA.KeyNum == 0 )
		{
			if (  !VBA.bInterpolating )
			{
				VBA.bFrobbable=True;
				Destroy();
			}
		} else {
			VBA.DoClose();
		}
	}
}

function Destroyed ()
{
	Log("V36 Destroyed");
	if ( VD2 != None )
	{
		VD2.VD1=VD1;
	}
	if ( VD1 != None )
	{
		VD1.VD2=VD2;
	}
	Super.Destroyed();
}

defaultproperties
{
    bHidden=True
    RemoteRole=0
}
