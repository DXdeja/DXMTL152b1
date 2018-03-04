//================================================================================
// MTLDeathMatch.
//================================================================================
class MTLDeathMatch extends DeathMatchGame;

var MTLManager Z55;

// trm 153
struct PlayerInfo
{
     var bool bAdmin;
     var int ping;
     var bool bIsSpectator;
};
var PlayerInfo PInfo[32];

// trm 153
const IDX = 0.14;
const PINGX = 0.85;
const ADMINX = 0.34;
const SPECTX = 0.4;
const MUTEX = 0.46;

event InitGame (string Z56, out string Z57)
{
	Class'V34'.static.V37(self,Z56,Z57);
}

function PreBeginPlay ()
{
	if ( Level.NetMode != NM_StandAlone )
	{
		if ( Z55 == None )
		{
			Z55=Spawn(Class'MTLManager');
		}
		Z55.Z91=self;
	}
	Super.PreBeginPlay();
}

function PostBeginPlay ()
{
	if ( Level.NetMode != 0 )
	{
		V30(Level.SpawnNotify).V00();
	}
	Super.PostBeginPlay();
}

function bool ApproveClass (Class<PlayerPawn> S40)
{
	return True;
}

function ScoreKill (Pawn VC7, Pawn Z58)
{
}

function Killed (Pawn VC7, Pawn Z58, name VC8)
{
	Super.Killed(VC7,Z58,VC8);
	BaseMutator.ScoreKill(VC7,Z58);
}

function ChangeOption (out string Options, string OptionKey, string Z67)
{
	local string NewOptions;
	local string CurOption;
	local string CurKey;
	local string CurValue;

	NewOptions="";
JL0008:
	if ( GrabOption(Options,CurOption) )
	{
		GetKeyValue(CurOption,CurKey,CurValue);
		if ( CurKey ~= OptionKey )
		{
			CurValue=Z67;
		}
		NewOptions=NewOptions $ "?" $ CurKey $ "=" $ CurValue;
		goto JL0008;
	}
	Options=NewOptions;
}

event PreLogin (string Z56, string Z59, out string Z57, out string Z5A)
{
	Super.PreLogin(Z56,Z59,Z57,Z5A);
	if (Z57 != "" )
	{
    	if ( (Len(Z56) > 800) || HasOption(Z56,string('LoadGame')) )
	    {
		    Z57="PreLogin Failed.";
	    }
	}
}

event PlayerPawn Login (string Portal, string Z56, out string Z57, Class<PlayerPawn> SpawnClass)
{
	local MTLPlayer Z5B;
	local string Z68;
	local string Z69;
	local int Z6A;

	if ( (MaxPlayers > 0) && (NumPlayers >= MaxPlayers) )
	{
		Z57=TooManyPlayers;
		return None;
	}
	SpawnClass=DefaultPlayerClass;
	Z68=ParseOption(Z56,"Class");
	Z6A=InStr(Z68,".");
	if ( Z6A != -1 )
	{
		Z69=Mid(Z68,Z6A + 1);
		Z68=Left(Z68,Z6A);
	} else {
		Z69=Z68;
		Z68="";
	}
	if ( (Z69 ~= "MPNSF") || (Z69 ~= "MTLNSF") )
	{
		SpawnClass=Class'MTLNSF';
	} else {
		if ( (Z69 ~= "MPUNATCO") || (Z69 ~= "MTLUNATCO") )
		{
			SpawnClass=Class'MTLUNATCO';
		} else {
			if ( (Z69 ~= "MPMJ12") || (Z69 ~= "MTLMJ12") )
			{
				SpawnClass=Class'MTLMJ12';
			}
		}
	}
	ChangeOption(Z56,"Class",string(SpawnClass));
	Z5B=MTLPlayer(Super.Login(Portal,Z56,Z57,SpawnClass));
	if ( Z5B != None )
	{
		Z5B.V52(Z5B.PlayerReplicationInfo.PlayerName);
	}
	return Z5B;
}

function SetupAbilities (DeusExPlayer Z5E)
{
	local MTLPlayer Z5B;

	Z5B=MTLPlayer(Z5E);
	if ( Z5B == None )
	{
		return;
	}
	if ( Z5B.V7E )
	{
		Z5B.V7E=False;
		return;
	}
	Z5B.SkillPointsAvail=SkillsAvail;
	Z5B.SkillPointsTotal=SkillsAvail;
	if ( bAugsAllowed )
	{
		GrantAugs(Z5B,InitialAugs);
	}
}

event PostLogin (PlayerPawn Z5F)
{
	local MTLPlayer Z5B;

	Z5B=MTLPlayer(Z5F);
	Z5B.V70=Class'V34'.static.GetPlayerIPAddr(Z5B);
	Z5B.V6F=Z55;
	if ( Z5B.bAdmin )
	{
		Z5B.PlayerReplicationInfo.bAdmin=True;
		Log(Z5B.V26(),'AdminLogin');
	}
	Z55.V43(Z5B);
	Super.PostLogin(Z5B);
}

function Logout (Pawn Z60)
{
	Super.Logout(Z60);
	if ( Z60.IsA('PlayerPawn') &&  !Z60.IsA('Spectator') && (PlayerPawn(Z60).GameReplicationInfo == None) )
	{
		NumPlayers++;
	}
}

function bool SetEndCams (string Z6B)
{
	local Pawn Player;
	local Pawn Z6C;

	GetWinningPlayer(Z6C);
	Player=Level.PawnList;
JL001F:
	if ( Player != None )
	{
		if ( Player.IsA('PlayerPawn') )
		{
			PlayerPawn(Player).bBehindView=True;
			PlayerPawn(Player).ViewTarget=Z6C;
		}
		Player.ClientGameEnded();
		Player.GotoState('GameEnded');
		Player=Player.nextPawn;
		goto JL001F;
	}
	return True;
}

simulated function RefreshScoreArray (DeusExPlayer Z5F)
{
	local int i;
	local int Z66;
	local PlayerReplicationInfo lpri;
	local PlayerPawn pp;

	if ( Z5F == None )
	{
		return;
	}
	pp=Z5F.GetPlayerPawn();
	if ( (pp == None) || (pp.GameReplicationInfo == None) )
	{
		return;
	}
	scorePlayers=0;
	i=0;
JL0050:
	if ( i < 32 )
	{
		lpri=pp.GameReplicationInfo.PRIArray[i];
		if ( (lpri != None) && ( !lpri.bIsSpectator || lpri.bWaitingPlayer) )
		{
			scoreArray[scorePlayers].PlayerName=lpri.PlayerName;
			scoreArray[scorePlayers].Score=lpri.Score;
			scoreArray[scorePlayers].Deaths=lpri.Deaths;
			scoreArray[scorePlayers].Streak=lpri.Streak;
			scoreArray[scorePlayers].Team=lpri.Team;
			scoreArray[scorePlayers].PlayerID=lpri.PlayerID;
            PInfo[scorePlayers].ping = lpri.ping;
            PInfo[scorePlayers].bAdmin = lpri.bAdmin;
            PInfo[scorePlayers].bIsSpectator = lpri.bIsSpectator;
			scorePlayers++;
		}
		i++;
		goto JL0050;
	}
}
/*
// trm 153: ignore system
simulated function ShowDMScoreboard( DeusExPlayer thisPlayer, GC gc, float screenWidth, float screenHeight )
{
     local float yoffset, ystart, xlen, ylen, w2;
     local String str;
     local bool bLocalPlayer;
     local int i;
     local float w, h;

     if ( !thisPlayer.PlayerIsClient() )
          return;

     gc.SetFont(Font'FontMenuSmall');

     RefreshScoreArray( thisPlayer );

     SortScores();

     str = "TEST";
     gc.GetTextExtent( 0, xlen, ylen, str );

     ystart = screenHeight * PlayerY;
     yoffset = ystart;

     gc.SetTextColor( WhiteColor );
     ShowVictoryConditions( gc, screenWidth, ystart, thisPlayer );
     yoffset += (ylen * 2.0);
     DrawHeaders( gc, screenWidth, yoffset );
     yoffset += (ylen * 1.5);

     for ( i = 0; i < scorePlayers; i++ )
     {
          bLocalPlayer = (scoreArray[i].PlayerID == thisPlayer.PlayerReplicationInfo.PlayerID);

          if ( bLocalPlayer )
               gc.SetTextColor( GoldColor );
          else
               gc.SetTextColor( WhiteColor );

          yoffset += ylen;
          DrawNameAndScore( gc, scoreArray[i], screenWidth, yoffset );

          gc.GetTextExtent(0, w, h, string(scoreArray[i].PlayerID));
          gc.DrawText(screenWidth * IDX, yOffset, w, h, string(scoreArray[i].PlayerID));

          gc.GetTextExtent(0, w2, h, "Ping");
          gc.GetTextExtent(0, w, h, string(PInfo[i].ping));
          gc.DrawText(screenWidth * PINGX + (w2 - w) * 0.5, yOffset, w, h, string(PInfo[i].ping));

          if (PInfo[i].bAdmin)
          {
              gc.SetTextColorRGB(0, 255, 255);
              gc.GetTextExtent(0, w, h, "Admin");
              gc.DrawText(screenWidth * ADMINX, yOffset, w, h, "Admin");
              gc.SetTextColor(RedColor);
          }
          if (PInfo[i].bIsSpectator)
          {
              gc.SetTextColorRGB(128, 18, 218);
              gc.GetTextExtent(0, w, h, "Spectator");
              gc.DrawText(screenWidth * SPECTX, yOffset, w, h, "Spectator");
              gc.SetTextColor(GreenColor);
          }*/

	/*
          if (MTLPlayer(thisPlayer).IsOnIgnoreList(string(scoreArray[i].PlayerID)) != -1)
          {
              gc.SetTextColorRGB(172, 166, 172);
              gc.GetTextExtent(0, w, h, "ignored");
              gc.DrawText(screenWidth * ADMINX, yOffset, w, h, "Ignored");
              gc.SetTextColor(GreenColor);
          }
	*/

 /*    }
}

//trm 153
simulated function SortScores()
{
     local PlayerReplicationInfo tmpri;
     local int i, j, max;
     local ScoreElement tmpSE;
     local PlayerInfo tmpPI;

     for ( i = 0; i < scorePlayers-1; i++ )
     {
          max = i;
          for ( j = i+1; j < scorePlayers; j++ )
          {
               if ( scoreArray[j].score > scoreArray[max].score )
                    max = j;
               else if (( scoreArray[j].score == scoreArray[max].score) && (scoreArray[j].deaths < scoreArray[max].deaths))
                    max = j;
          }
          tmpSE = scoreArray[max];
          tmpPI = PInfo[max];
          scoreArray[max] = scoreArray[i];
          PInfo[max] = PInfo[i];
          scoreArray[i] = tmpSE;
          PInfo[i] = tmpPI;
     }
}

//trm 153
simulated function DrawHeaders( GC gc, float screenWidth, float yoffset )
{
     local float x, w, h;

     gc.GetTextExtent( 0, w, h, PlayerString );
     x = screenWidth * PlayerX;
     gc.DrawText( x, yoffset, w, h, PlayerString );

     gc.GetTextExtent(0, w, h, "ID");
     x = screenWidth * IDX;
     gc.DrawText(x, yOffset, w, h, "ID");

     gc.GetTextExtent( 0, w, h, KillsString );
     x = screenWidth * KillsX;
     gc.DrawText( x, yoffset, w, h, KillsString );

     gc.GetTextExtent( 0, w, h, DeathsString );
     x = screenWidth * DeathsX;
     gc.DrawText( x, yoffset, w, h, DeathsString );

     gc.GetTextExtent( 0, w, h, StreakString );
     x = screenWidth * StreakX;
     gc.DrawText( x, yoffset, w, h, StreakString );

     gc.GetTextExtent(0, w, h, "Ping");
     x = screenWidth * PINGX;
     gc.DrawText(x, yOffset, w, h, "Ping");

     gc.SetTileColorRGB(255,255,255);
     gc.DrawBox( IDX * screenWidth, yoffset+h, (x + w)-(IDX*screenWidth), 1, 0, 0, 1, Texture'Solid');
}

// trm 153
function bool CanSpectate( pawn Viewer, actor ViewTarget )
{
     return true;
}*/


defaultproperties
{
    DefaultPlayerClass=Class'MTLJCDenton'
    GameReplicationInfoClass=Class'MTLGRI'
    NetPriority=10.00
}
