//================================================================================
// MTLMutatorSetupWindow.
//================================================================================
class MTLMutatorSetupWindow extends ToolWindow;

var string V39;
var int NumMutatorClasses;
var MTLMenuScreenHostGame BotmatchParent;
var ToolCheckboxWindow btnKeepCheck;
var ToolListWindow lstMutators;
var ToolButtonWindow btnSave;
var ToolButtonWindow btnCancel;
var ToolButtonWindow btnUp1;
var ToolButtonWindow btnDown1;
var string mList1[200];
var string mClass1[200];
var string ZF7;
var bool ZF8;
var localized string l_title;
var localized string l_check;
var localized string l_save;
var localized string l_up;
var localized string l_down;
var localized string l_cancel;
var localized string l_yes;
var localized string l_no;

event InitWindow ()
{
	Super.InitWindow();
	SetSize(500.00,435.00);
	SetTitle(l_title);
	ZF7=Player.ConsoleCommand(string('get') @ string('MTLMenuScreenHostGame') @ string('MutatorList'));
	ZF8=bool(Player.ConsoleCommand(string('get') @ string('MTLMenuScreenHostGame') @ string('bKeepMutators')));
	V07();
	V09();
}

function V07 ()
{
	lstMutators=CreateToolList(6,40,484,360);
	lstMutators.SetColumns(3);
	lstMutators.SetSortColumn(1);
	lstMutators.HideColumn(2);
	lstMutators.EnableMultiSelect(False);
	lstMutators.EnableAutoExpandColumns(True);
	lstMutators.EnableAutoSort(False);
	btnKeepCheck=ToolCheckboxWindow(NewChild(Class'ToolCheckboxWindow'));
	btnKeepCheck.SetText(l_check);
	btnKeepCheck.SetPos(9.00,23.00);
	btnKeepCheck.SetSize(300.00,17.00);
	btnKeepCheck.SetToggle(ZF8);
	btnSave=CreateToolButton(40,405,l_save);
	btnUp1=CreateToolButton(155,405,l_up);
	btnDown1=CreateToolButton(270,405,l_down);
	btnCancel=CreateToolButton(385,405,l_cancel);
}

function V02 (int swapnum, int index1m)
{
	local int index2;
	local int newindex2;
	local int row2;
	local int newrow2;
	local string swapstring2;
	local int k;

	if ( swapnum == 0 )
	{
		return;
	}
	if ( index1m != -1 )
	{
		index2=Clamp(index1m,0,NumMutatorClasses - 1);
		row2=lstMutators.IndexToRowId(index2);
	} else {
		if ( lstMutators.GetNumSelectedRows() != 1 )
		{
			return;
		}
		row2=lstMutators.GetSelectedRow();
		index2=lstMutators.RowIdToIndex(row2);
	}
	newindex2=index2 + swapnum;
	newindex2=Clamp(newindex2,0,NumMutatorClasses - 1);
	newrow2=lstMutators.IndexToRowId(newindex2);
	if ( index2 == newindex2 )
	{
		return;
	}
	k=0;
JL00E0:
	if ( k < lstMutators.GetNumColumns() )
	{
		swapstring2=lstMutators.GetField(row2,k);
		lstMutators.SetField(row2,k,lstMutators.GetField(newrow2,k));
		lstMutators.SetField(newrow2,k,swapstring2);
		k++;
		goto JL00E0;
	}
	swapstring2=mList1[index2];
	mList1[index2]=mList1[newindex2];
	mList1[newindex2]=swapstring2;
	swapstring2=mClass1[index2];
	mClass1[index2]=mClass1[newindex2];
	mClass1[newindex2]=swapstring2;
	if ( index1m == -1 )
	{
		lstMutators.SelectRow(newrow2);
	}
}

function bool ButtonActivated (Window ZE4)
{
	local bool ZE5;

	ZE5=True;
	switch (ZE4)
	{
		case btnUp1:
		V02(-1,-1);
		break;
		case btnDown1:
		V02(1,-1);
		break;
		case btnSave:
		SaveConfigs();
		Root.PopWindow();
		break;
		case btnCancel:
		Root.PopWindow();
		break;
		default:
		ZE5=False;
		break;
	}
	if (  !ZE5 )
	{
		ZE5=Super.ButtonActivated(ZE4);
	}
	return ZE5;
}

function SaveConfigs ()
{
	local string ZF9;
	local int i;
	local int Row;

	i=0;
JL0007:
	if ( i < NumMutatorClasses )
	{
		Row=lstMutators.IndexToRowId(i);
		if ( lstMutators.GetField(Row,0) ~= l_yes )
		{
			if ( ZF9 == "" )
			{
				ZF9=lstMutators.GetField(Row,2);
			} else {
				ZF9=ZF9 $ "," $ lstMutators.GetField(Row,2);
			}
		}
		i++;
		goto JL0007;
	}
	BotmatchParent.MutatorList=ZF9;
	BotmatchParent.bKeepMutators=btnKeepCheck.GetToggle();
	BotmatchParent.SaveSettings();
}

function int V08 (string S34)
{
	local int VD3;

	VD3=0;
JL0007:
	if ( VD3 < NumMutatorClasses )
	{
		if ( mClass1[VD3] ~= S34 )
		{
			return VD3;
		}
		VD3++;
		goto JL0007;
	}
	return -1;
}

function V09 ()
{
	local string ZF9;
	local string NextMutator;
	local string NextDesc;
	local int k;
	local int i;
	local int topswapindex;

	NumMutatorClasses=0;
	Player.GetNextIntDesc(V39,NumMutatorClasses,NextMutator,NextDesc);
JL002A:
	if ( (NextMutator != "") && (NumMutatorClasses < 200) )
	{
		mClass1[NumMutatorClasses]=NextMutator;
		k=InStr(NextDesc,";");
		if ( k == -1 )
		{
			mList1[NumMutatorClasses]=NextDesc;
		} else {
			mList1[NumMutatorClasses]=Left(NextDesc,k);
		}
		NumMutatorClasses++;
		Player.GetNextIntDesc(V39,NumMutatorClasses,NextMutator,NextDesc);
		goto JL002A;
	}
	lstMutators.DeleteAllRows();
	i=0;
JL00E0:
	if ( i < NumMutatorClasses )
	{
		lstMutators.AddRow(l_no $ ";" $ mList1[i] $ ";" $ mClass1[i]);
		i++;
		goto JL00E0;
	}
	ZF9=ZF7;
	topswapindex=0;
JL0140:
	if ( ZF9 != "" )
	{
		k=InStr(ZF9,",");
		if ( k == -1 )
		{
			NextMutator=ZF9;
			ZF9="";
		} else {
			NextMutator=Left(ZF9,k);
			ZF9=Mid(ZF9,k + 1);
		}
		i=V08(NextMutator);
		if ( i != -1 )
		{
			lstMutators.SetField(lstMutators.IndexToRowId(i),0,l_yes);
			V02(topswapindex - i,i);
			topswapindex++;
		} else {
			Log("Unknown mutator in mutator list: " $ NextMutator,'DXMTL');
		}
		goto JL0140;
	}
}

event bool ListRowActivated (Window ZE6, int rowId)
{
	local ListWindow ZFA;

	ZFA=ListWindow(ZE6);
	if ( ZFA.GetField(rowId,0) ~= l_no )
	{
		ZFA.SetField(rowId,0,l_yes);
	} else {
		ZFA.SetField(rowId,0,l_no);
	}
	return False;
}

defaultproperties
{
    V39="Engine.Mutator"
    l_title="Configure Mutators"
    l_check="|&Always use these mutators"
    l_save="|&Save Config"
    l_up="|&Up"
    l_down="|&Down"
    l_cancel="|&Cancel"
    l_yes="Yes"
    l_no="No"
}
