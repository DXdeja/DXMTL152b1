//================================================================================
// MTLGameInfo.
//================================================================================
class MTLGameInfo extends DeusExGameInfo;

event InitGame (string Z56, out string Z57)
{
	Class'V34'.static.V37(self,Z56,Z57);
}

function PostBeginPlay ()
{
	V30(Level.SpawnNotify).V00();
	Super.PostBeginPlay();
}

function ScoreKill (Pawn VC7, Pawn Z58)
{
}

function Killed (Pawn VC7, Pawn Z58, name VC8)
{
	Super.Killed(VC7,Z58,VC8);
	BaseMutator.ScoreKill(VC7,Z58);
}

function bool ApproveClass (Class<PlayerPawn> S40)
{
	return True;
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

event PlayerPawn Login (string Portal, string Z56, out string Error, Class<PlayerPawn> SpawnClass)
{
	local string Z68;
	local string Z69;
	local DeusExPlayer Player;
	local NavigationPoint StartSpot;
	local byte InTeam;
	local DumpLocation dump;
	local int Z6A;

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
	Player=DeusExPlayer(Super(GameInfo).Login(Portal,Z56,Error,SpawnClass));
	if ( Player != None )
	{
		Player.UpdateURL("Class",string(SpawnClass),True);
		Player.SaveConfig();
	}
	if ( (Player != None) &&  !HasOption(Z56,string('LoadGame')) )
	{
		Player.ResetPlayerToDefaults();
		dump=Player.CreateDumpLocationObject();
		if ( (dump != None) && dump.HasLocationBeenSaved() )
		{
			dump.LoadLocation();
			Player.Pause();
			Player.SetLocation(dump.currentDumpLocation.Location);
			Player.SetRotation(dump.currentDumpLocation.ViewRotation);
			Player.ViewRotation=dump.currentDumpLocation.ViewRotation;
			Player.ClientSetRotation(dump.currentDumpLocation.ViewRotation);
			CriticalDelete(dump);
		} else {
			InTeam=GetIntOption(Z56,"Team",0);
			if ( Level.NetMode == 0 )
			{
				StartSpot=FindPlayerStart(None,InTeam,Portal);
			} else {
				StartSpot=FindPlayerStart(Player,InTeam,Portal);
			}
			Player.SetLocation(StartSpot.Location);
			Player.SetRotation(StartSpot.Rotation);
			Player.ViewRotation=StartSpot.Rotation;
			Player.ClientSetRotation(Player.Rotation);
		}
	}
	return Player;
}

defaultproperties
{
    DefaultPlayerClass=Class'MTLJCDenton'
    GameReplicationInfoClass=Class'MTLGRI'
}
