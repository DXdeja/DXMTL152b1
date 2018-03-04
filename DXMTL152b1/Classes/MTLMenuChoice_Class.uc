//================================================================================
// MTLMenuChoice_Class.
//================================================================================
class MTLMenuChoice_Class extends MenuUIChoiceEnum;

var string ClassClasses[4];
var string ClassNames[4];
var Texture texPortraits[4];
var string enumText[4];
var const int NextPlayerIndex;
var ButtonWindow btnPortrait;
var int portraitIndex;

event InitWindow ()
{
	PopulateClassChoices();
	CreatePortraitButton();
	CreateInfoButton();
	Super(MenuUIChoice).InitWindow();
	SetActionButtonWidth(153);
	btnAction.SetHelpText(HelpText);
	btnInfo.SetPos(0.00,195.00);
}

function PopulateClassChoices ()
{
	local int typeIndex;

	typeIndex=0;
JL0007:
	if ( typeIndex < 4 )
	{
		enumText[typeIndex]=ClassNames[typeIndex];
		typeIndex++;
		goto JL0007;
	}
}

function SetValue (int NewValue)
{
	CurrentValue=NewValue;
	UpdateInfoButton();
	UpdatePortrait();
}

function SaveSetting ()
{
	Player.UpdateURL("Class",GetModuleName(CurrentValue),True);
	Player.SaveConfig();
}

function LoadSetting ()
{
	local string TypeString;
	local int typeIndex;
	local int S01;

	TypeString=Player.GetDefaultURL("Class");
	typeIndex=0;
JL0023:
	if ( typeIndex < 4 )
	{
		if ( TypeString ~= GetModuleName(typeIndex) )
		{
			S01=typeIndex;
		} else {
			typeIndex++;
			goto JL0023;
		}
	}
	SetValue(S01);
	UpdatePortrait();
}

function ResetToDefault ()
{
	CurrentValue=defaultValue;
	SaveSetting();
	LoadSetting();
}

function string GetModuleName (int ClassIndex)
{
	return ClassClasses[ClassIndex];
}

function CreatePortraitButton ()
{
	btnPortrait=ButtonWindow(NewChild(Class'ButtonWindow'));
	btnPortrait.SetSize(116.00,163.00);
	btnPortrait.SetPos(19.00,27.00);
	btnPortrait.SetBackgroundStyle(DSTY_Masked);
}

function UpdatePortrait ()
{
	btnPortrait.SetBackground(texPortraits[CurrentValue]);
}

function bool ButtonActivated (Window buttonPressed)
{
	if ( buttonPressed == btnInfo )
	{
		CycleNextValue();
		return True;
	} else {
		return Super(MenuUIChoice).ButtonActivated(buttonPressed);
	}
}

function bool ButtonActivatedRight (Window buttonPressed)
{
	if ( buttonPressed == btnAction )
	{
		CyclePreviousValue();
		return True;
	} else {
		return ButtonActivated(buttonPressed);
	}
}

function CycleNextValue ()
{
	local int NewValue;

	NewValue=GetValue() + 1;
	if ( NewValue == 4 )
	{
		NewValue=0;
	} else {
		if ( enumText[NewValue] == "" )
		{
			NewValue=0;
		}
	}
	SetValue(NewValue);
}

function CyclePreviousValue ()
{
	local int NewValue;

	NewValue=GetValue() - 1;
	if ( NewValue < 0 )
	{
		NewValue=4 - 1;
JL0027:
		if ( (enumText[NewValue] == "") && (NewValue > 0) )
		{
			NewValue--;
			goto JL0027;
		}
	}
	SetValue(NewValue);
}

function CreateInfoButton ()
{
	btnInfo=MenuUIInfoButtonWindow(NewChild(Class'MenuUIInfoButtonWindow'));
	btnInfo.SetSelectability(False);
	btnInfo.SetSize(defaultInfoWidth,19.00);
	btnInfo.SetPos(defaultInfoPosX,0.00);
}

function UpdateInfoButton ()
{
	btnInfo.SetButtonText(enumText[CurrentValue]);
}

defaultproperties
{
    ClassClasses(0)="DXMTL152b1.MTLJCDenton"
    ClassClasses(1)="DXMTL152b1.MTLNSF"
    ClassClasses(2)="DXMTL152b1.MTLUNATCO"
    ClassClasses(3)="DXMTL152b1.MTLMJ12"
    ClassNames(0)="JC Denton"
    ClassNames(1)="NSF Terrorist"
    ClassNames(2)="UNATCO Trooper"
    ClassNames(3)="Majestic-12 Agent"
    texPortraits(0)=Texture'DeusExUI.UserInterface.menuplayersetupjcdenton'
    texPortraits(1)=Texture'DeusExUI.UserInterface.menuplayersetupnsf'
    texPortraits(2)=Texture'DeusExUI.UserInterface.menuplayersetupunatco'
    texPortraits(3)=Texture'DeusExUI.UserInterface.menuplayersetupmj12'
    NextPlayerIndex=4
    defaultInfoWidth=153
    defaultInfoPosX=170
    HelpText="Model for your character in non-team games."
    actionText="Non-Team Model"
}
