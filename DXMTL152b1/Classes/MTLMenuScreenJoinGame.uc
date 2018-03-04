//================================================================================
// MTLMenuScreenJoinGame.
//================================================================================
class MTLMenuScreenJoinGame extends menuscreenjoingame;

var string ZE0;
var localized string l_password;
var localized string l_rules;
var localized string l_name;
var localized string l_kills;
var localized string l_ping;
var localized string l_id;
var MenuUIScrollAreaWindow ZE1;
var MenuUIListWindow ZE2;
var MenuUIEditWindow IPPassWindow;
var LargeTextWindow ZE3;
var MenuUIListHeaderButtonWindow btnHeaderRules;
var MenuUIListHeaderButtonWindow btnHeaderPName;
var MenuUIListHeaderButtonWindow btnHeaderPPing;
var MenuUIListHeaderButtonWindow btnHeaderPFrag;
var MenuUIListHeaderButtonWindow btnHeaderPID;
var bool bPNameOrder;
var bool bPFragOrder;
var bool bPPingOrder;
var bool bPIDOrder;

function bool ButtonActivated (Window ZE4)
{
	local bool ZE5;

	ZE5=True;
	switch (ZE4)
	{
		case HostButton:
		ProcessMenuAction(MA_MenuScreen,Class'MTLMenuScreenHostGame');
		break;
		case btnHeaderRules:
		if ( (ServerList != None) && (ServerList.GetNumSelectedRows() == 1) )
		{
			UpdateSelectionInfo(ServerList.GetSelectedRow());
		}
		break;
		case btnHeaderPName:
		bPNameOrder= !bPNameOrder;
		ZE2.SetSortColumn(0,bPNameOrder);
		break;
		case btnHeaderPFrag:
		bPFragOrder= !bPFragOrder;
		ZE2.SetSortColumn(1,bPFragOrder);
		break;
		case btnHeaderPPing:
		bPPingOrder= !bPPingOrder;
		ZE2.SetSortColumn(2,bPPingOrder);
		break;
		case btnHeaderPID:
		bPIDOrder= !bPIDOrder;
		ZE2.SetSortColumn(3,bPIDOrder);
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

event bool ListSelectionChanged (Window ZE6, int ZE7, int ZE8)
{
	if ( ZE6 == ServerList )
	{
		if ( (ZE8 == ClickRowID) && JoinButton.IsSensitive() )
		{
			HandleJoinGame();
		} else {
			ClickRowID=ZE8;
			ClickTimer=0.00;
			UpdateSelectionInfo(ZE8);
		}
	}
	return False;
}

function PopulateServerList ()
{
	local int ZE9;
	local int r1;

	if ( ServerList == None )
	{
		return;
	}
	Super.PopulateServerList();
	if ( ZE0 ~= "" )
	{
		return;
	}
	ZE9=0;
JL0028:
	if ( ZE9 < ServerList.GetNumRows() )
	{
		r1=ServerList.IndexToRowId(ZE9);
		if ( ZE0 ~= (ServerList.GetField(r1,6) $ ServerList.GetField(r1,7)) )
		{
			ServerList.SelectRow(r1);
			ServerList.SetFocusRow(r1);
		} else {
			ZE9++;
			goto JL0028;
		}
	}
}

function UpdateGameInfo (deusexserverlist ZEA)
{
	local int ZEB;
	local int ZEC;
	local string ZED;
	local UBrowserRulesList CurrentRule;
	local UBrowserPlayerList CurrentPlayer2;

	ZE3.SetText("");
	ZE2.DeleteAllRows();
	if ( ZEA == None )
	{
		return;
	}
	CurrentRule=ZEA.RulesList;
	CurrentPlayer2=ZEA.PlayerList;
	if ( CurrentRule != None )
	{
		CurrentRule=UBrowserRulesList(CurrentRule.Next);
	}
	if ( CurrentPlayer2 != None )
	{
		CurrentPlayer2=UBrowserPlayerList(CurrentPlayer2.Next);
	}
	ZEB=0;
JL009E:
	if ( CurrentPlayer2 != None )
	{
		ZEB++;
		ZED=CurrentPlayer2.PlayerName;
		ZEC=InStr(ZED,";");
JL00D4:
		if ( ZEC != -1 )
		{
			ZED=Left(ZED,ZEC) $ Mid(ZED,ZEC + 1);
			ZEC=InStr(ZED,";");
			goto JL00D4;
		}
		ZE2.AddRow(ZED $ ";" $ string(CurrentPlayer2.PlayerFrags) $ ";" $ string(CurrentPlayer2.PlayerPing) $ ";" $ string(CurrentPlayer2.PlayerID));
		CurrentPlayer2=UBrowserPlayerList(CurrentPlayer2.Next);
		goto JL009E;
	}
	if ( CurrentRule == None )
	{
		ZEB=-1;
	}
	ZED="";
JL01A6:
	if ( CurrentRule != None )
	{
		if ( ZED != "" )
		{
			ZED=ZED $ "|n";
		}
		ZED=ZED $ CurrentRule.Rule $ ": " @ CurrentRule.Value;
		CurrentRule=UBrowserRulesList(CurrentRule.Next);
		goto JL01A6;
	}
	ZE3.SetText(ZED);
	if ( (ServerList != None) && (ServerList.GetNumSelectedRows() == 1) )
	{
		ZE0=ServerList.GetField(ServerList.GetSelectedRow(),6) $ ServerList.GetField(ServerList.GetSelectedRow(),7);
		if ( ZEB >= 0 )
		{
			ServerList.SetField(ServerList.GetSelectedRow(),3,string(ZEB) $ "/" $ string(ZEA.MaxPlayers));
		}
	}
}

function CreateIPEditWindow ()
{
	Super.CreateIPEditWindow();
	CreateMenuLabel(325,341,l_password,winClient);
	IPPassWindow=CreateMenuEditWindow(401,337,115,32,winClient);
	IPPassWindow.SetText("");
}

function CreateGameInfoList ()
{
	btnHeaderRules=CreateHeaderButton(143,240,230,l_rules,winClient);
	btnHeaderRules.textLeftMargin=3;
	GameInfoScroll=CreateScrollAreaWindow(winClient);
	GameInfoScroll.SetPos(144.00,256.00);
	GameInfoScroll.SetSize(229.00,72.00);
	ZE3=LargeTextWindow(GameInfoScroll.ClipWindow.NewChild(Class'LargeTextWindow'));
	ZE3.SetTextMargins(0.00,0.00);
	ZE3.SetFont(Font'FontMenuSmall');
	ZE3.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	ZE3.SetTextColor(Player.ThemeManager.GetCurrentMenuColorTheme().GetColorFromName('MenuColor_ListText'));
	btnHeaderPName=CreateHeaderButton(374,240,110,l_name,winClient);
	btnHeaderPFrag=CreateHeaderButton(484,240,44,l_kills,winClient);
	btnHeaderPPing=CreateHeaderButton(528,240,44,l_ping,winClient);
	btnHeaderPID=CreateHeaderButton(572,240,36,l_id,winClient);
	btnHeaderPName.textLeftMargin=3;
	btnHeaderPFrag.textLeftMargin=3;
	btnHeaderPPing.textLeftMargin=3;
	btnHeaderPID.textLeftMargin=3;
	ZE1=CreateScrollAreaWindow(winClient);
	ZE1.SetPos(374.00,256.00);
	ZE1.SetSize(234.00,72.00);
	ZE2=MenuUIListWindow(ZE1.ClipWindow.NewChild(Class'MenuUIListWindow'));
	ZE2.EnableMultiSelect(False);
	ZE2.EnableAutoExpandColumns(False);
	ZE2.SetNumColumns(4);
	ZE2.SetColumnWidth(0,110.00);
	ZE2.SetColumnWidth(1,44.00);
	ZE2.SetColumnWidth(2,44.00);
	ZE2.SetColumnWidth(3,21.00);
	ZE2.SetColumnType(0,COLTYPE_String);
	ZE2.SetColumnType(1,COLTYPE_Float,"%.0f");
	ZE2.SetColumnType(2,COLTYPE_Float,"%.0f");
	ZE2.SetColumnType(3,COLTYPE_Float,"%.0f");
	ZE2.SetSortColumn(1,True);
	ZE2.EnableAutoSort(True);
	ZE2.SetSensitivity(False);
}

function string GetExtraJoinOptions ()
{
	local string ZEE;

	ZEE=IPPassWindow.GetText();
	if ( ZEE != "" )
	{
		ZEE="?password=" $ ZEE;
	}
	return ZEE;
}

function CreateGamesList ()
{
	Super.CreateGamesList();
	ServerScroll.SetSize(602.00,188.00);
}

function bool CanShowgame (string ZEF)
{
	local int ZF0;

	if ( bShowAllGameTypes )
	{
		return True;
	}
	ZF0=0;
JL0012:
	if ( ZF0 < 5 )
	{
		if ( ZEF ~= GameClassNames[ZF0] )
		{
			return bShowGameTypeOne;
		}
		ZF0++;
		goto JL0012;
	}
	ZF0=5;
JL004C:
	if ( ZF0 < 14 )
	{
		if ( ZEF ~= GameClassNames[ZF0] )
		{
			return bShowGameTypeTwo;
		}
		ZF0++;
		goto JL004C;
	}
	return False;
}

defaultproperties
{
    l_password="Password"
    l_rules="Server Rules"
    l_name="Player Name"
    l_kills="Kills"
    l_ping="Ping"
    l_id="ID"
    bPFragOrder=True
    GameClassNames(1)="MTLDeathMatch"
    GameClassNames(2)="CBPDeathMatch"
    GameClassNames(3)="CBPAdvDM"
    GameClassNames(4)="CBPBasicDM"
    GameClassNames(5)="TeamDMGame"
    GameClassNames(6)="AdvTeamDMGame"
    GameClassNames(7)="BasicTeamDMGame"
    GameClassNames(8)="MTLTeam"
    GameClassNames(9)="MTLAdvTeam"
    GameClassNames(10)="MTLBasicTeam"
    GameClassNames(11)="CBPTeam"
    GameClassNames(12)="CBPAdvTeam"
    GameClassNames(13)="CBPBasicTeam"
    GameHumanNames(1)="Deathmatch MTL"
    GameHumanNames(2)="DM Custom CBP"
    GameHumanNames(3)="DM Adv. CBP"
    GameHumanNames(4)="DM Basic CBP"
    GameHumanNames(5)="Team Custom"
    GameHumanNames(6)="Team Adv."
    GameHumanNames(7)="Team Basic"
    GameHumanNames(8)="Team Custom MTL"
    GameHumanNames(9)="Team Adv. MTL"
    GameHumanNames(10)="Team Basic MTL"
    GameHumanNames(11)="Team Custom CBP"
    GameHumanNames(12)="Team Adv. CBP"
    GameHumanNames(13)="Team Basic CBP"
}
