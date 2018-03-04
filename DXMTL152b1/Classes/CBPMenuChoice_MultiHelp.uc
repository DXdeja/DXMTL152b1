//================================================================================
// CBPMenuChoice_MultiHelp.
//================================================================================
class CBPMenuChoice_MultiHelp extends menuchoice_multihelp;

function LoadSetting ()
{
   super.LoadSetting();
}

function SaveSetting ()
{
	local bool V94;

	V94=bool(GetValue());
	if ( Player.bHelpMessages != V94 )
	{
		Player.bHelpMessages=V94;
		Player.SaveConfig();
	}
}

function ResetToDefault ()
{
	CurrentValue=defaultValue;
	SaveSetting();
	LoadSetting();
}

defaultproperties
{
    configSetting=""
}
