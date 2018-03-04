//================================================================================
// CBPMenuChoice_Connection.
//================================================================================
class CBPMenuChoice_Connection extends MenuUIChoiceEnum;

var int ConnectionSpeeds[8];
var localized string ConnectionNames[8];

event InitWindow ()
{
	Super.InitWindow();
	SetActionButtonWidth(153);
	btnAction.SetHelpText(HelpText);
}

function UpdateInfoButton ()
{
	if ( btnInfo != None )
	{
		btnInfo.SetButtonText(enumText[CurrentValue]);
	}
}

function PopulateConnectionSpeeds ()
{
	local int S02;
	local int VD3;

	ConnectionSpeeds[7]=Class'Player'.Default.ConfiguredInternetSpeed;
	VD3=7;
	S02=0;
JL0026:
	if ( S02 < 8 )
	{
		enumText[S02]=ConnectionNames[S02] @ "(" $ string(ConnectionSpeeds[S02]) $ ")";
		if ( (S02 != 7) && (ConnectionSpeeds[S02] == ConnectionSpeeds[7]) )
		{
			VD3=S02;
		}
		S02++;
		goto JL0026;
	}
	SetValue(VD3);
}

function SaveSetting ()
{
	local bool S03;

	if ( ConnectionSpeeds[CurrentValue] != ConnectionSpeeds[7] )
	{
		Class'Player'.Default.ConfiguredInternetSpeed=ConnectionSpeeds[CurrentValue];
		Class'Player'.StaticSaveConfig();
		if ( (MTLPlayer(Player) != None) && (Player.Level.NetMode == 3) )
		{
			MTLPlayer(Player).V61(ConnectionSpeeds[CurrentValue]);
		}
	}
}

function LoadSetting ()
{
	PopulateConnectionSpeeds();
}

function ResetToDefault ()
{
	CurrentValue=defaultValue;
	SaveSetting();
	LoadSetting();
}

function string GetModuleName (int S02)
{
	return string(ConnectionSpeeds[S02]);
}

defaultproperties
{
    ConnectionSpeeds(0)=1600
    ConnectionSpeeds(1)=2600
    ConnectionSpeeds(2)=3200
    ConnectionSpeeds(3)=5200
    ConnectionSpeeds(4)=10000
    ConnectionSpeeds(5)=15000
    ConnectionSpeeds(6)=20000
    ConnectionNames(0)="33.6k"
    ConnectionNames(1)="56k-Low"
    ConnectionNames(2)="56k-High"
    ConnectionNames(3)="ISDN"
    ConnectionNames(4)="DSL"
    ConnectionNames(5)="Cable"
    ConnectionNames(6)="T1/LAN"
    ConnectionNames(7)="Custom"
    defaultValue=1
    defaultInfoWidth=153
    defaultInfoPosX=170
    HelpText="Type of Internet Connection"
    actionText="Connection Type"
}
