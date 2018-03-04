//================================================================================
// CBPButton1.
//================================================================================
class CBPButton1 extends Button1;

final function V00 (Button1 V94)
{
	local Mover S42;

	if ( V94 == None )
	{
		return;
	}
	ButtonType=V94.ButtonType;
	buttonLitTime=V94.buttonLitTime;
	buttonSound1=V94.buttonSound1;
	buttonSound2=V94.buttonSound2;
	bLit=V94.bLit;
	bWaitForEvent=V94.bWaitForEvent;
	Mesh=V94.Mesh;
	moverTag=V94.moverTag;
	DrawScale=V94.DrawScale;
	isPressed=V94.isPressed;
	SetSkin(ButtonType,bLit);
	if ( moverTag != 'None' )
	{
		foreach AllActors(Class'Mover',S42,moverTag)
		{
			SetBase(S42);
			goto JL011C;
JL011C:
		}
	}
}

simulated function Tick (float VC5)
{
	if ( Role == 4 )
	{
		if ( bIsMoving && (Location == lastLoc) )
		{
			rpcLocation=Location;
		}
		bIsMoving=Location != lastLoc;
		lastLoc=Location;
	} else {
		if ( (Location == lastLoc) && (Location != rpcLocation) )
		{
			SetLocation(rpcLocation);
		}
		lastLoc=Location;
	}
	Super(DeusExDecoration).Tick(VC5);
}

defaultproperties
{
    bAlwaysRelevant=True
    NetPriority=2.70
}
