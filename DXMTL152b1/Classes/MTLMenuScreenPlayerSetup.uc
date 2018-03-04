//================================================================================
// MTLMenuScreenPlayerSetup.
//================================================================================
class MTLMenuScreenPlayerSetup extends menuscreenplayersetup;

var MTLMenuChoice_Class ZF4;
var CBPMenuChoice_Connection ZF5;

function CreateClassChoice ()
{
	ZF4=MTLMenuChoice_Class(winClient.NewChild(Class'MTLMenuChoice_Class'));
	ZF4.SetPos(6.00,120.00);
	ZF4.SetSize(153.00,213.00);
}

function CreateHelpChoice ()
{
	HelpChoice=menuchoice_multihelp(winClient.NewChild(Class'CBPMenuChoice_MultiHelp'));
	HelpChoice.SetPos(6.00,81.00);
}

function CreateConnectionChoice ()
{
	ZF5=CBPMenuChoice_Connection(winClient.NewChild(Class'CBPMenuChoice_Connection'));
	ZF5.SetPos(6.00,54.00);
}

function CreateTeamChoice ()
{
	TeamChoice=menuchoice_team(winClient.NewChild(Class'CBPMenuChoice_Team'));
	TeamChoice.SetPos(176.00,120.00);
	TeamChoice.SetSize(153.00,213.00);
}

defaultproperties
{
    filterString=""
}
