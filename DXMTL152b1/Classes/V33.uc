//================================================================================
// V33.
//================================================================================
class V33 extends Actor;

const ZA6= 0.1;
const ZA5= 10.0;
var DeusExPlayer Z9F;
var int ZA0;
var int ZA1;
var int ZA2;
var bool ZA3;
var bool ZA4;

event Destroyed ()
{
	Log("V33 Destroyed");
	if ( Z9F != None )
	{
		Z9F.bNintendoImmunity=False;
		Z9F.NintendoImmunityTimeLeft=0.00;
		Z9F=None;
	}
	Super.Destroyed();
}

final function V5B (float ZA7, float ZA8)
{
	Z9F=DeusExPlayer(Owner);
	Log("V33 V5B");
	if ( Z9F != None )
	{
		ZA4=Z9F.bAdmin || (ZA7 < 0.00);
		ZA2=Max(ZA7 * 10.00,0);
		ZA0=ZA8 * 10.00;
		ZA1=ZA0;
		Z9F.bNintendoImmunity=False;
		Z9F.NintendoImmunityTimeLeft=(ZA0 + ZA2) * 0.10;
		if ( (ZA2 == 0) &&  !ZA4 )
		{
			ZA3=True;
		}
		SetTimer(0.10,True);
	} else {
		Destroy();
	}
}

function Timer ()
{
	local int ZA9;
	Log("V33 Timer");

	if ( Level.Game.bGameEnded || (Z9F == None) || Z9F.IsInState('Dying') || (Z9F.Health <= 0) || Z9F.bSpyDroneActive )
	{
		Destroy();
		return;
	}
	if (  !ZA3 )
	{
		if ( (Location.X != Z9F.Location.X) || (Location.Y != Z9F.Location.Y) ||  !ZA4 && ( --ZA2 <= 0) )
		{
			ZA3=True;
			Z9F.NintendoImmunityTimeLeft=ZA0 * 0.10;
			return;
		}
		if ( ZA4 )
		{
			Z9F.NintendoImmunityTimeLeft=60.00;
		} else {
			Z9F.NintendoImmunityTimeLeft -= 0.10;
		}
	} else {
		ZA9=1;
		if ( (Z9F.AugmentationSystem != None) && (Z9F.AugmentationSystem.NumAugsActive() > 0) )
		{
			ZA9 += ZA9;
		}
		if ( Z9F.inHand != None )
		{
			ZA9 *= 3;
		}
		if ( Z9F.Weapon != None )
		{
			ZA9 += ZA9;
		}
		Z9F.NintendoImmunityTimeLeft -= 0.10 * ZA9;
		ZA0 -= ZA9;
		if ( ZA0 <= 0 )
		{
			Destroy();
		}
	}
}

defaultproperties
{
    bHidden=True
    RemoteRole=0
}
