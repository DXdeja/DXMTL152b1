//================================================================================
// CBPMenuScreenAugSetup.
//================================================================================
class CBPMenuScreenAugSetup extends menuscreenaugsetup;

function SaveSettings ()
{
	local DeusExPlayer Player;
	local LevelInfo Z3D;
	local int VD3;

	Super.SaveSettings();
	Z3D=Player.GetEntryLevel();
	if ( Z3D != None )
	{
		foreach Z3D.AllActors(Class'DeusExPlayer',Player)
		{
			VD3=0;
JL0046:
			if ( VD3 < 9 )
			{
				Player.AugPrefs[VD3]=Player.AugPrefs[VD3];
				VD3++;
				goto JL0046;
			}
			Player.SaveConfig();
		}
	}
}
