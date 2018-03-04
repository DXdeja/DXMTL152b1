//================================================================================
// CBPMenuChoice_Team.
//================================================================================
class CBPMenuChoice_Team extends menuchoice_team;

var string ZFF;

function SetInitialTeam ()
{
}

function SetValue (int Z67)
{
	CurrentValue=Z67;
	UpdateInfoButton();
	UpdatePortrait();
}

function SaveSetting ()
{
	local string V92;

	V92=GetModuleName(CurrentValue);
	Player.ChangeTeam(int(V92));
	if (  !(V92 ~= ZFF) )
	{
		Player.UpdateURL("Team",V92,True);
		Player.SaveConfig();
	}
}

function LoadSetting ()
{
	local int VD3;

	ZFF=Player.GetDefaultURL("Team");
	VD3=int(GetModuleName(int(ZFF)));
	if ( VD3 == 128 )
	{
		VD3=2;
	}
	SetValue(VD3);
	SaveSetting();
}

function ResetToDefault ()
{
	CurrentValue=defaultValue;
	SaveSetting();
	LoadSetting();
}

function string GetModuleName (int S00)
{
	if ( S00 == 0 )
	{
		return string(0);
	}
	if ( S00 == 1 )
	{
		return string(1);
	}
	return string(128);
}
