//================================================================================
// MTLGRI.
//================================================================================
class MTLGRI extends GameReplicationInfo;

struct ssmsg
{
	var Color c1;
	var string s1;
	var string s2;
	var string s3;
	var string s4;
	var string s5;
	var string s6;
	var string s7;
	var string s8;
	var string s9;
	var string s10;
	var bool b3;
	var bool b1;
};

var Color MOTDColor;
var transient ssmsg smsg0;

replication
{
	reliable if ( bNetInitial && (Role == ROLE_Authority) )
		smsg0;
}

function PreBeginPlay ()
{
	local DeusExLevelInfo Z52;

	Super.PreBeginPlay();
	if ( Level.NetMode == 0 )
	{
		return;
	}
	smsg0.c1=MOTDColor;
	smsg0.s1=ServerName;
	smsg0.s2=MOTDLine1;
	smsg0.s3=MOTDLine2;
	smsg0.s4=MOTDLine3;
	smsg0.s5=MOTDLine4;
	smsg0.s6=AdminName;
	smsg0.s7=AdminEmail;
	foreach AllActors(Class'DeusExLevelInfo',Z52)
	{
		goto JL00B3;
JL00B3:
	}
	if ( Z52 != None )
	{
		smsg0.s8=Z52.MapName;
		smsg0.s9=Z52.MapAuthor;
		smsg0.s10=Z52.MissionLocation;
		if ( (smsg0.s8 != "") || (smsg0.s9 != "") || (smsg0.s10 != "") )
		{
			smsg0.b3=True;
		}
	}
	smsg0.b1=True;
}

simulated function Timer ()
{
	local PlayerReplicationInfo Z53;
	local int VD3;
	local int Z54;

	if ( Level.NetMode == 3 )
	{
		if ( Level.TimeSeconds - SecondCount >= Level.TimeDilation )
		{
			ElapsedTime++;
			if ( RemainingMinute != 0 )
			{
				RemainingTime=RemainingMinute;
				RemainingMinute=0;
			}
			if ( (RemainingTime > 0) &&  !bStopCountDown )
			{
				RemainingTime--;
			}
			SecondCount += Level.TimeDilation;
		}
	}
	VD3=0;
JL009E:
	if ( VD3 < 32 )
	{
		PRIArray[VD3]=None;
		VD3++;
		goto JL009E;
	}
	VD3=0;
	foreach AllActors(Class'PlayerReplicationInfo',Z53)
	{
		PRIArray[VD3++ ]=Z53;
		if ( VD3 >= 32 )
		{
			goto JL00FB;
		}
JL00FB:
	}
	UpdateTimer=0.00;
	VD3=0;
JL010E:
	if ( VD3 < 32 )
	{
		if ( PRIArray[VD3] != None )
		{
			Z54 += PRIArray[VD3].Score;
		}
		VD3++;
		goto JL010E;
	}
	SumFrags=Z54;
	if ( Level.Game != None )
	{
		NumPlayers=Level.Game.NumPlayers;
	}
}

defaultproperties
{
    MOTDColor=(R=48, G=48, B=255, A=0)
    NetPriority=1.10
}
