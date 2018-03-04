//================================================================================
// MTLTeam.
//================================================================================
class MTLTeam extends TeamDMGame;

var Class<MTLPlayer> V1F;
var Class<MTLPlayer> V1E;
var MTLManager Z55;

// trm 153
const IDX = 0.14;
const PINGX = 0.85;
const ADMINX = 0.34;
const SPECTX = 0.4;
const MUTEX = 0.46;

// trm 153: auto balance
var bool bForceBalance;

// trm 153 (player info)
struct PlayerInfo
{
     var bool bAdmin;
     var int ping;
     var bool bIsSpectator;
};
var PlayerInfo PI[32];
var PlayerInfo PInfo[32];


event InitGame (string Z56, out string Z57)
{
	Class'V34'.static.V37(self,Z56,Z57);
}

function PreBeginPlay ()
{
	if ( Level.NetMode != 0 )
	{
		if ( Z55 == None )
		{
			 Z55=Spawn(Class'MTLManager');
		}
		 Z55.Z91=self;
		bForceBalance = Z55.bForceTeamBalance;
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
	local int Z5C;
	local string Z5D;

	if ( (MaxPlayers > 0) && (NumPlayers >= MaxPlayers) )
	{
		Z57=TooManyPlayers;
		return None;
	}
	Z5C=128;
	if ( HasOption(Z56,"Team") )
	{
		Z5D=ParseOption(Z56,"Team");
		if ( Z5D != "" )
		{
			Z5C=int(Z5D);
		}
	}
	if (  !ApproveTeam(Z5C) )
	{
		Z5C=128;
	}
	// trm 153: auto balance
    if ( bForceBalance || Z5C == 128 )
	{
		Z5C=GetAutoTeam();
	}
	if ( Z5C == 1 )
	{
		SpawnClass=V1E;
	} else {
		SpawnClass=V1F;
	}
	ChangeOption(Z56,"Class",string(SpawnClass));
	ChangeOption(Z56,"Team",string(Z5C));
	Z5B=MTLPlayer(Super(DeusExMPGame).Login(Portal,Z56,Z57,SpawnClass)); // MTLPlayer()
	if ( Z5B != None )
	{
//		Z5B.V52(Z5B.PlayerReplicationInfo.PlayerName);
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
   if (Z60.PlayerReplicationInfo.bIsSpectator)
   {
        --NumSpectators;
   }
}

function SetTeam (DeusExPlayer Z5F)
{
	if ( Z5F.IsA(V1F.Name) )
	{
		Z5F.PlayerReplicationInfo.Team=0;
		Z5F.MultiplayerNotifyMsg(Z5F.MPMSG_TeamUnatco);
	} else {
		if ( Z5F.IsA(V1E.Name) )
		{
			Z5F.PlayerReplicationInfo.Team=1;
			Z5F.MultiplayerNotifyMsg(Z5F.MPMSG_TeamNsf);
		} else {
			Log("Warning: Player:" $ string(Z5F) $ " has chosen an invalid team!");
		}
	}
}

function bool ChangeTeam (Pawn Z61, int NewTeam)
{
	local Class<MTLPlayer> Z62;
	local MTLPlayer Z63;

	if (  !ApproveTeam(NewTeam) )
	{
		NewTeam=128;
	}
	if ( NewTeam == 128 )
	{
		if ( PlayerPawn(Z61) != None )
		{
			NewTeam=PlayerPawn(Z61).PlayerReplicationInfo.Team;
		} else {
			return False;
		}
	}
	if (  !Super(DeusExMPGame).ChangeTeam(Z61,NewTeam) )
	{
		return False;
	}
	Z63=MTLPlayer(Z61);
	if ( Z63 == None )
	{
		return False;
	}
	if ( NewTeam == 0 )
	{
		Z62=V1F;
	} else {
		if ( NewTeam == 1 )
		{
			Z62=V1E;
		} else {
			return False;
		}
	}
	return Class'V34'.static.V38(Z63,Z62);
}

simulated function bool ArePlayersAllied (DeusExPlayer Z64, DeusExPlayer Z65)
{
	if ( (Z64 == None) || (Z65 == None) || (Z64.PlayerReplicationInfo == None) || (Z65.PlayerReplicationInfo == None) )
	{
		return False;
	}
	return Z64.PlayerReplicationInfo.Team == Z65.PlayerReplicationInfo.Team;
}
/*
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
			// trm 153
                    PI[scorePlayers].ping = lpri.ping;
                    PI[scorePlayers].bAdmin = lpri.bAdmin;
                    PI[scorePlayers].bIsSpectator = lpri.bIsSpectator;
			scorePlayers++;
		}
		i++;
		goto JL0050;
	}
}

// trm 153: ignore system
simulated function ShowTeamDMScoreboard( DeusExPlayer thisPlayer, GC gc, float screenWidth, float screenHeight ) // modified by nil
{
     local float yoffset, ystart, xlen,ylen, w, h, w2;
     local bool bLocalPlayer;
     local int i, allyCnt, enemyCnt, barLen;
     local ScoreElement fakeSE;
     local String str, teamStr;

     if (!thisPlayer.PlayerIsClient())
          return;

     // Always use this font
     gc.SetFont(Font'FontMenuSmall');
     str = "TEST";
     gc.GetTextExtent( 0, xlen, ylen, str );

     // Refresh out local array
     RefreshScoreArray( thisPlayer );

     // Just allies
     allyCnt = GetTeamList( thisPlayer, true );
     SortTeamScores( allyCnt );

     ystart = screenHeight * PlayerY;
     yoffset = ystart;

     // Headers
     gc.SetTextColor( WhiteColor );
     ShowVictoryConditions( gc, screenWidth, ystart, thisPlayer );
     yoffset += (ylen * 2.0);
     DrawHeaders( gc, screenWidth, yoffset );
     yoffset += (ylen * 1.5);

     if (thisPlayer.PlayerReplicationInfo.team == TEAM_UNATCO )
          teamStr = TeamUnatcoString;
     else
          teamStr = TeamNsfString;

     // Allies
     gc.SetTextColor( GreenColor );
     fakeSE.PlayerName = AlliesString $ " (" $ teamStr $ ")";
     LocalGetTeamTotals( allyCnt, fakeSE.score, fakeSE.deaths, fakeSE.streak );
     DrawNameAndScore( gc, fakeSE, screenWidth, yoffset );
     gc.GetTextExtent( 0, w, h, "Ping" );
     barLen = (screenWidth * PINGX + w)-(IDX*screenWidth);
     gc.SetTileColorRGB(0,255,0);
     gc.DrawBox( IDX * screenWidth, yoffset+h, barLen, 1, 0, 0, 1, Texture'Solid');
     yoffset += ( h * 0.25 );
     for ( i = 0; i < allyCnt; i++ )
     {
          bLocalPlayer = (teamSE[i].PlayerID == thisPlayer.PlayerReplicationInfo.PlayerID);
          if ( bLocalPlayer )
               gc.SetTextColor( GoldColor );
          else
               gc.SetTextColor( GreenColor );
          yoffset += ylen;
          DrawNameAndScore( gc, teamSE[i], screenWidth, yoffset );

          gc.GetTextExtent(0, w, h, string(teamSE[i].PlayerID));
          gc.DrawText(screenWidth * IDX, yOffset, w, h, string(teamSE[i].PlayerID));

          gc.GetTextExtent(0, w2, h, "Ping");
          gc.GetTextExtent(0, w, h, string(PInfo[i].ping));
          gc.DrawText(screenWidth * PINGX + (w2 - w) * 0.5, yOffset, w, h, string(PInfo[i].ping));

          if (PInfo[i].bAdmin)
          {
              gc.SetTextColorRGB(0, 255, 255);
              gc.GetTextExtent(0, w, h, "Admin");
              gc.DrawText(screenWidth * ADMINX,yOffset, w, h, "Admin");
              gc.SetTextColor(GreenColor);
          }

          if (PInfo[i].bIsSpectator)
          {
              gc.SetTextColorRGB(128, 18, 218);
              gc.GetTextExtent(0, w, h, "Spectator");
              gc.DrawText(screenWidth * SPECTX,yOffset, w, h, "Spectator");
              gc.SetTextColor(GreenColor);
          }*/

	/*
          if (MTLPlayer(thisPlayer).IsOnIgnoreList(string(teamSE[i].PlayerID)) != -1)
          {
              gc.SetTextColorRGB(172, 166, 172);
              gc.GetTextExtent(0, w, h, "ignored");
              gc.DrawText(screenWidth * ADMINX, yOffset,w, h, "ignored");
              gc.SetTextColor(GreenColor);
          }
	*/
/*
     }

     yoffset += (ylen*2);

     if ( thisPlayer.PlayerReplicationInfo.team == TEAM_UNATCO )
          teamStr = TeamNsfString;
     else
          teamStr = TeamUnatcoString;

     // Enemies
     enemyCnt = GetTeamList( thisPlayer, false );
     SortTeamScores( enemyCnt );
     gc.SetTextColor( RedColor );
     gc.GetTextExtent( 0, w, h, EnemiesString );
     gc.DrawText( PlayerX * screenWidth, yoffset, w,h, EnemiesString );
     fakeSE.PlayerName = EnemiesString $ " (" $ teamStr $ ")";
     LocalGetTeamTotals( enemyCnt, fakeSE.score, fakeSE.deaths, fakeSE.streak );
     DrawNameAndScore( gc, fakeSE, screenWidth, yoffset );
     gc.SetTileColorRGB(255,0,0);
     gc.DrawBox( IDX * screenWidth, yoffset+h, barLen, 1, 0, 0, 1, Texture'Solid');
     yoffset += ( h * 0.25 );

     for ( i = 0; i < enemyCnt; i++ )
     {
          yoffset += ylen;
          DrawNameAndScore( gc, teamSE[i], screenWidth, yoffset );

          gc.GetTextExtent(0, w, h, string(teamSE[i].PlayerID));
          gc.DrawText(screenWidth * IDX, yOffset, w, h, string(teamSE[i].PlayerID));

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
              gc.SetTextColor(RedColor);
          }*/

	/*
          if (MTLPlayer(thisPlayer).IsOnIgnoreList(string(teamSE[i].PlayerID)) != -1)
          {
              gc.SetTextColorRGB(172, 166, 172);
              gc.GetTextExtent(0, w, h, "Ignored");
              gc.DrawText(screenWidth * ADMINX, yOffset, w, h, "Ignored");
              gc.SetTextColor(RedColor);
          }
	*/
/*     }
}

// trm 153
simulated function SortTeamScores( int PlayerCount )
{
     local ScoreElement tmpSE;
     local PlayerInfo tmpPI;
     local int i, j, max;

     for ( i = 0; i < PlayerCount-1; i++ )
     {
          max = i;
          for ( j = i+1; j < PlayerCount; j++ )
          {
               if ( teamSE[j].Score > teamSE[max].Score )
                    max = j;
               else if (( teamSE[j].Score == teamSE[max].Score) && (teamSE[j].Deaths < teamSE[max].Deaths))
                    max = j;
          }
          tmpSE = teamSE[max];
          tmpPI = PInfo[max];
          teamSE[max] = teamSE[i];
          PInfo[max] = PInfo[i];
          teamSE[i] = tmpSE;
          PInfo[i] = tmpPI;
     }
}

// trm 153: auto balance
function int GetAutoTeam()
{
   local int NumUNATCO;
   local int NumNSF;
   local int CurTeam;
   local Pawn CurPawn;

   NumUNATCO = 0;
   NumNSF = 0;

   for (CurPawn = Level.Pawnlist; CurPawn != None; CurPawn = CurPawn.NextPawn)
   {
      if ((PlayerPawn(CurPawn) != None) && (PlayerPawn(CurPawn).PlayerReplicationInfo != None))
      {
         CurTeam = PlayerPawn(CurPawn).PlayerReplicationInfo.Team;
         if (CurTeam == TEAM_UNATCO)
         {
            NumUNATCO++;
         }
         else if (CurTeam == TEAM_NSF)
         {
            NumNSF++;
         }
      }
   }

    // Force Team Balance:
    // Join team will less score,
    // if score is same, join will less players.
   if (bForceBalance)
   {
    if (TeamScore[Team_UNATCO] < TeamScore[Team_NSF])
    {
     return Team_UNATCO;
    }
    else
    {
     return Team_NSF;
    }

    if (TeamScore[Team_UNATCO] == TeamScore[Team_NSF])
    {
     if (NumUNATCO < NumNSF)
     {
      return Team_UNATCO;
     }
     else
     {
      return Team_NSF;
     }
    }
   }
   else
   {
    if (NumUNATCO < NumNSF)
    {
     return TEAM_UNATCO;
    }
    if (NumUNATCO > NumNSF)
    {
     return TEAM_NSF;
    }
    else
    {
     return TEAM_AUTO;
    }
   }
}

// trm 153
simulated function DrawHeaders( GC gc, float screenWidth, float yoffset )
{
     local float x, w, h;

     // Player header
     gc.GetTextExtent( 0, w, h, PlayerString );
     x = screenWidth * PlayerX;
     gc.DrawText(x, yoffset, w, h, PlayerString );

     gc.GetTextExtent(0, w,h, "ID");
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

simulated function int GetTeamList( DeusExPlayer player, bool Allies )
{
     local int i, numTeamList;

     if ( player == None )
          return(0);

     numTeamList = 0;

     for ( i = 0; i < scorePlayers; i++ )
     {
          if ( (Allies && (scoreArray[i].Team == player.PlayerReplicationInfo.Team) ) ||
                 (!Allies && (scoreArray[i].Team != player.PlayerReplicationInfo.Team) ) )
          {
                    teamSE[numTeamList] = scoreArray[i];
                    PInfo[numTeamList] = PI[i];
                    numTeamList += 1;
          }
     }
     return( numTeamList );
}

function bool CanSpectate( pawn Viewer, actor ViewTarget )
{
     return true;
}*/


defaultproperties
{
    V1F=Class'MTLUNATCO'
    V1E=Class'MTLNSF'
    DefaultPlayerClass=Class'MTLUNATCO'
    GameReplicationInfoClass=Class'MTLGRI'
    NetPriority=10.00
}
