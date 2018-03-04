//================================================================================
// MTLMOTD.
//================================================================================
class MTLMOTD extends Actor;

var localized string l_welcome;
var localized string l_adminname;
var localized string l_adminemail;
var localized string l_mapname;
var localized string l_mapauthor;
var localized string l_mlocation;

function PostBeginPlay ()
{
	SetTimer(0.50,True);
}

function Timer ()
{
	local HUDMissionStartTextDisplay Z8C;
	local MTLGRI Z8D;
	local DeusExPlayer Z8E;

	Z8E=DeusExPlayer(Owner);
	if ( Z8E == None )
	{
		SetTimer(0.00,False);
		return;
	}
	if ( (Z8E.RootWindow != None) && (DeusExRootWindow(Z8E.RootWindow).HUD != None) )
	{
		Z8C=DeusExRootWindow(Z8E.RootWindow).HUD.startDisplay;
	}
	Z8D=MTLGRI(Z8E.GameReplicationInfo);
	if ( (Z8C != None) && (Z8D != None) && Z8D.smsg0.b1 )
	{
		Z8C.Message="";
		Z8C.charIndex=0;
		Z8C.winText.SetText("");
		Z8C.winTextShadow.SetText("");
		Z8C.winText.SetTextColor(Z8D.smsg0.c1);
		Z8C.displayTime=5.00;
		Z8C.perCharDelay=0.30;
		Z8C.AddMessage(" ");
		Z8C.AddMessage(" ");
		if ( Z8D.smsg0.s1 != "" )
		{
			Z8C.AddMessage(l_welcome @ Z8D.smsg0.s1);
		} else {
			Z8C.AddMessage(l_welcome @ Level.GetAddressURL());
		}
		Z8C.AddMessage(" ");
		Z8C.AddMessage(Z8D.smsg0.s2);
		Z8C.AddMessage(Z8D.smsg0.s3);
		Z8C.AddMessage(Z8D.smsg0.s4);
		Z8C.AddMessage(Z8D.smsg0.s5);
		Z8C.AddMessage(" ");
		if ( Z8D.smsg0.s6 != "" )
		{
			Z8C.AddMessage(l_adminname @ Z8D.smsg0.s6);
		}
		if ( Z8D.smsg0.s7 != "" )
		{
			Z8C.AddMessage(l_adminemail @ Z8D.smsg0.s7);
		}
		if ( Z8D.smsg0.b3 )
		{
			Z8C.AddMessage(" ");
			if ( Z8D.smsg0.s8 != "" )
			{
				Z8C.AddMessage(l_mapname @ Z8D.smsg0.s8);
			}
			if ( Z8D.smsg0.s9 != "" )
			{
				Z8C.AddMessage(l_mapauthor @ Z8D.smsg0.s9);
			}
			if ( Z8D.smsg0.s10 != "" )
			{
				Z8C.AddMessage(l_mlocation @ Z8D.smsg0.s10);
			}
		}
		Z8C.StartMessage();
		SetTimer(0.00,False);
		return;
	}
}

function Tick (float VC5)
{
	local DeusExLevelInfo Z52;

	foreach AllActors(Class'DeusExLevelInfo',Z52)
	{
		goto JL0014;
JL0014:
	}
	if ( Z52 != None )
	{
		Z52.missionNumber=7;
		Z52.bMultiPlayerMap=True;
		Z52.ConversationPackage=Class'DeusExLevelInfo'.Default.ConversationPackage;
		Disable('Tick');
	}
}

defaultproperties
{
    l_welcome="Welcome to"
    l_adminname="Admin Name:"
    l_adminemail="Admin Email:"
    l_mapname="Map Name:"
    l_mapauthor="Map Author:"
    l_mlocation="Mission Location:"
    bHidden=True
    RemoteRole=ROLE_None
    LifeSpan=10.00
}
