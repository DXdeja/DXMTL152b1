//================================================================================
// MTLMenuChoice_GameType.
//================================================================================
class MTLMenuChoice_GameType extends MenuUIChoiceEnum;

var MTLMenuScreenHostGame hostparent;
var string gameTypes[4];
var string gameNames[4];
var int NumGameTypes;

event InitWindow ()
{
	PopulateGameTypes();
	Super.InitWindow();
	SetActionButtonWidth(179);
}

function PopulateGameTypes ()
{
	local int typeIndex;

	typeIndex=0;
JL0007:
	if ( typeIndex < NumGameTypes )
	{
		enumText[typeIndex]=gameNames[typeIndex];
		typeIndex++;
		goto JL0007;
	}
}

function SaveSetting ()
{
	Player.ConsoleCommand(string('Set') @ configSetting @ GetModuleName(CurrentValue));
}

function LoadSetting ()
{
	local string TypeString;
	local int typeIndex;

	TypeString=Player.ConsoleCommand(string('get') @ configSetting);
	typeIndex=0;
JL0029:
	if ( typeIndex < NumGameTypes )
	{
		if ( TypeString == GetModuleName(typeIndex) )
		{
			SetValue(typeIndex);
		}
		typeIndex++;
		goto JL0029;
	}
}

function ResetToDefault ()
{
	CurrentValue=defaultValue;
	SaveSetting();
	LoadSetting();
}

function string GetModuleName (int gameIndex)
{
	return gameTypes[gameIndex];
}

function SetValue (int NewValue)
{
	local Class<GameInfo> TypeClass;
	local GameInfo CurrentType;
	local bool bCanCustomize;

	Super.SetValue(NewValue);
	bCanCustomize=True;
	if ( (hostparent != None) && (gameTypes[NewValue] != "") )
	{
		TypeClass=Class<GameInfo>(Player.DynamicLoadObject(GetModuleName(NewValue),Class'Class'));
		if ( TypeClass != None )
		{
			CurrentType=Player.Spawn(TypeClass);
		}
		if ( DeusExMPGame(CurrentType) != None )
		{
			bCanCustomize=DeusExMPGame(CurrentType).bCustomizable;
		}
		hostparent.SetCustomizable(bCanCustomize);
		if ( CurrentType != None )
		{
			CurrentType.Destroy();
		}
	}
}

defaultproperties
{
    gameTypes(0)="DXMTL152b1.MTLDeathMatch"
    gameTypes(1)="DXMTL152b1.MTLBasicTeam"
    gameTypes(2)="DXMTL152b1.MTLAdvTeam"
    gameTypes(3)="DXMTL152b1.MTLTeam"
    gameNames(0)="Deathmatch (MTL)"
    gameNames(1)="Basic Team DM (MTL)"
    gameNames(2)="Advanced Team DM (MTL)"
    gameNames(3)="Custom Team DM (MTL)"
    NumGameTypes=4
    defaultInfoWidth=243
    defaultInfoPosX=203
    HelpText="Type of game to play"
    actionText="Game Type"
    configSetting="MTLMenuScreenHostGame CurrentGameType"
}
