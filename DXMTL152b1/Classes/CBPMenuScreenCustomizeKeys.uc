//================================================================================
// CBPMenuScreenCustomizeKeys.
//================================================================================
class CBPMenuScreenCustomizeKeys extends MenuScreenCustomizeKeys;

var string ZF1[65];
var string ZF2[65];
var localized string Functions2[7];
var string Aliases2[7];

function BuildKeyBindings ()
{
	local int VD3;
	local int j;
	local int pos;
	local int S32;
	local string KeyName;
	local string Alias;

	S32=61;
	VD3=0;
JL000F:
	if ( VD3 < 65 )
	{
		ZF1[VD3]="";
		ZF2[VD3]="";
		VD3++;
		goto JL000F;
	}
	VD3=0;
JL0048:
	if ( VD3 < 255 )
	{
		KeyName=Player.ConsoleCommand("KEYNAME" @ string(VD3));
		if ( KeyName != "" )
		{
			Alias=Player.ConsoleCommand("KEYBINDING" @ KeyName);
			if ( Alias != "" )
			{
				pos=InStr(Alias," ");
				if ( pos != -1 )
				{
					Alias=Left(Alias,pos);
				}
				j=0;
JL00F2:
				if ( j < 7 + S32 )
				{
					if ( (j < S32) && (AliasNames[j] ~= Alias) || (j >= S32) && (Aliases2[j - S32] ~= Alias) )
					{
						if ( ZF1[j] == "" )
						{
							ZF1[j]=GetKeyDisplayNameFromKeyName(KeyName);
						} else {
							if ( ZF2[j] == "" )
							{
								ZF2[j]=GetKeyDisplayNameFromKeyName(KeyName);
							}
						}
					}
					j++;
					goto JL00F2;
				}
			}
		}
		VD3++;
		goto JL0048;
	}
}

function ProcessKeySelection (int KeyNo, string KeyName, string keyDisplayName)
{
	local int VD3;
	local string V92;

	if ( (KeyName == "") || (KeyName ~= "Escape") || (KeyNo >= 112) && (KeyNo <= 129) || (KeyNo >= 48) && (KeyNo <= 57) || (KeyName ~= "Tilde") || (KeyName ~= "PrintScrn") || (KeyName ~= "Pause") )
	{
		return;
	}
	if ( (ZF1[Selection] == keyDisplayName) || (ZF2[Selection] == keyDisplayName) )
	{
		return;
	}
	VD3=0;
JL00CC:
	if ( VD3 < 61 + 7 )
	{
		if ( VD3 < 61 )
		{
			V92=FunctionText[VD3];
		} else {
			V92=Functions2[VD3 - 61];
		}
		if ( ZF2[VD3] == keyDisplayName )
		{
			ShowHelp(Sprintf(ReassignedFromLabel,keyDisplayName,V92));
			AddPending(GetKeyFromDisplayName(ZF2[VD3]));
			ZF2[VD3]="";
		}
		if ( ZF1[VD3] == keyDisplayName )
		{
			ShowHelp(Sprintf(ReassignedFromLabel,keyDisplayName,V92));
			AddPending(GetKeyFromDisplayName(ZF1[VD3]));
			ZF1[VD3]=ZF2[VD3];
			ZF2[VD3]="";
		}
		VD3++;
		goto JL00CC;
	}
	if ( ZF1[Selection] == "" )
	{
		ZF1[Selection]=keyDisplayName;
	} else {
		if ( ZF2[Selection] == "" )
		{
			ZF2[Selection]=keyDisplayName;
		} else {
			if ( CanRemapKey(ZF1[Selection]) )
			{
				AddPending(GetKeyFromDisplayName(ZF1[Selection]));
				ZF1[Selection]=ZF2[Selection];
				ZF2[Selection]=keyDisplayName;
			} else {
				if ( CanRemapKey(ZF2[Selection]) )
				{
					AddPending(GetKeyFromDisplayName(ZF2[Selection]));
					ZF2[Selection]=keyDisplayName;
				}
			}
		}
	}
	if ( Selection < 61 )
	{
		V92=AliasNames[Selection];
	} else {
		V92=Aliases2[Selection - 61];
	}
	AddPending(KeyName @ V92);
	RefreshKeyBindings();
}

function PopulateKeyList ()
{
	local int VD3;

	lstKeys.DeleteAllRows();
	VD3=0;
JL0013:
	if ( VD3 < 61 )
	{
		lstKeys.AddRow(FunctionText[VD3] $ ";" $ GetInputDisplayText(VD3));
		VD3++;
		goto JL0013;
	}
	VD3=0;
JL0059:
	if ( VD3 < 7 )
	{
		lstKeys.AddRow(Functions2[VD3] $ ";" $ GetInputDisplayText(VD3 + 61));
		VD3++;
		goto JL0059;
	}
}

function string GetInputDisplayText (int VD3)
{
	if ( ZF1[VD3] == "" )
	{
		return NoneText;
	} else {
		if ( ZF2[VD3] != "" )
		{
			return ZF1[VD3] $ "," @ ZF2[VD3];
		} else {
			return ZF1[VD3];
		}
	}
}

function RefreshKeyBindings ()
{
	local int VD3;

	VD3=0;
JL0007:
	if ( VD3 < 61 + 7 )
	{
		lstKeys.SetField(lstKeys.IndexToRowId(VD3),1,GetInputDisplayText(VD3));
		VD3++;
		goto JL0007;
	}
}

function ClearFunction ()
{
	local int ZF3;
	local int rowIndex;

	ZF3=lstKeys.GetSelectedRow();
	if ( ZF3 != 0 )
	{
		rowIndex=lstKeys.RowIdToIndex(ZF3);
		if ( (ZF2[rowIndex] != "") && CanRemapKey(ZF2[rowIndex]) )
		{
			AddPending(GetKeyFromDisplayName(ZF2[rowIndex]));
			ZF2[rowIndex]="";
		}
		if ( (ZF1[rowIndex] != "") && CanRemapKey(ZF1[rowIndex]) )
		{
			AddPending(GetKeyFromDisplayName(ZF1[rowIndex]));
			ZF1[rowIndex]=ZF2[rowIndex];
			ZF2[rowIndex]="";
		}
		RefreshKeyBindings();
	}
}

function ProcessPending ()
{
	local int VD3;
	local V32 V91;

	if ( Pending > 0 )
	{
		V91=Player.Spawn(Class'V32');
		VD3=0;
JL0029:
		if ( VD3 < Pending )
		{
			V91.ConsoleCommand(string('Set') @ string('Input') @ PendingCommands[VD3]);
			V91.ConsoleCommand(string('Set') @ string('InputExt') @ PendingCommands[VD3]);
			VD3++;
			goto JL0029;
		}
		V91.Destroy();
	}
	Pending=0;
}

defaultproperties
{
    Functions2(0)="Pretend To Be Dead"
    Functions2(1)="Suicide"
    Functions2(2)="Display The Console"
    Functions2(3)="Toggle BehindView"
    Functions2(4)="Ignore Player"
    Functions2(5)="Alternate Fire"
    Functions2(6)="Private Talk"
    Aliases2(0)="FeignDeath"
    Aliases2(1)="Suicide"
    Aliases2(2)="Type"
    Aliases2(3)="ToggleBehindView"
    Aliases2(4)="IgnoreMute"
    Aliases2(5)="Altfire"
    Aliases2(5)="TalkTo"
}
