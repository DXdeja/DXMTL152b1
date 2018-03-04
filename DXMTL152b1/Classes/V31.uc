//================================================================================
// V31.
//================================================================================
class V31 extends Actor;

var MTLPlayer Z9C;
var MTLPlayer Z9D;
var private float V44;

function Tick (float VAE)
{
	Log("V31 Tick");
	Z9C=MTLPlayer(GetPlayerPawn());
	if ( (Z9D == None) || (Z9C == None) || (Z9D == Z9C) )
	{
		Destroy();
	} else {
		V11();
		V10(VAE);
	}
}

final function V11 ()
{
	Log("V31 V11");
	if ( Z9D.NintendoImmunityTimeLeft > 0.00 )
	{
		Z9D.DrawInvulnShield();
		if ( Z9D.invulnSph != None )
		{
			Z9D.invulnSph.LifeSpan=Z9D.NintendoImmunityTimeLeft;
		}
	} else {
		if ( Z9D.invulnSph != None )
		{
			Z9D.invulnSph.Destroy();
			Z9D.invulnSph=None;
		}
	}
}

final function V10 (float VAE)
{
	local DeusExRootWindow VAB;
	local Vector VC6;
	local float Z9E;
	Log("V31 V10");

	V44=Abs(V44) + VAE;
	Z9D.bHidden=False;
	if ( Z9D.V79 == 0 )
	{
		V44=0.00;
		Z9D.CreateShadow();
		Z9D.ScaleGlow=Z9D.Default.ScaleGlow;
		return;
	} else {
		Z9D.KillShadow();
		if ( Z9D.V79 >= 2 )
		{
			Z9D.bHidden=True;
			return;
		}
	}
	if ( (TeamDMGame(Z9C.DXGame) != None) && TeamDMGame(Z9C.DXGame).ArePlayersAllied(Z9D,Z9C) )
	{
		Z9D.ScaleGlow=0.25;
	} else {
		Z9D.ScaleGlow=Z9D.Default.ScaleGlow * 0.01 / V44;
		if ( Z9D.ScaleGlow <= 0.02 )
		{
			Z9D.ScaleGlow=0.00;
			Z9D.bHidden=True;
			VAB=DeusExRootWindow(Z9C.RootWindow);
			if ( (VAB != None) && (VAB.HUD != None) && (VAB.HUD.augDisplay != None) && VAB.HUD.augDisplay.bVisionActive )
			{
				VC6=Z9C.Location;
				VC6.Z += Z9C.BaseEyeHeight;
				Z9E=VSize(Z9D.Location - VC6);
				if ( Z9E <= VAB.HUD.augDisplay.visionLevelValue )
				{
					Z9D.bHidden=False;
				}
			}
		}
	}
}

defaultproperties
{
    V44=10.00
    bHidden=True
    RemoteRole=0
}
