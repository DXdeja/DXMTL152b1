//================================================================================
// MTLManager.
//================================================================================
class MTLManager extends Actor
	Config(DXMTL);

var globalconfig int iBytesPerSec;
var globalconfig int iBytesPerFive;
var globalconfig int iMsgPerSec;
var globalconfig int iMsgPerFive;
var globalconfig int iMaxNumOfSpams;
var globalconfig int iSpawnMassLimit;
var globalconfig bool bAllowAdminGet;
var globalconfig bool bAllowAdminSet;
var globalconfig bool bAllowSummon;
var globalconfig bool bAllowSpawnMass;
var globalconfig bool bAllowGetPlayerIP;
var globalconfig bool bKnife_FullRefill;
var globalconfig bool bKnife_KeepPlaceholder;
var globalconfig bool bInvincibleAmmoCrates;

// trm 153: auto balance
var globalconfig bool bForceTeamBalance;


var V2E Z8F;
var V36 Z90;
var GameInfo Z91;
var MTLPlayer Z92;
var bool Z93;

replication
{
	reliable if ( Role == ROLE_Authority )
		Z91;
}

function PreBeginPlay ()
{
	local bool Z94;

	if ( Z93 )
	{
		return;
	}
	iMaxNumOfSpams=Max(iMaxNumOfSpams,1);
	iSpawnMassLimit=Clamp(iSpawnMassLimit,1,250);
	SaveConfig();
	if ( Level.NetMode == 2 )
	{
		SetTimer(0.50,True);
	}
	Z8F=Spawn(Class'V2E',self);
	Z8F.LifeSpan=0.00;
	Z8F.ZCC="LIST";
	Z90=Spawn(Class'V36',self);
	Z93=True;
}

function Timer ()
{
	Z92=MTLPlayer(GetPlayerPawn());
	if ( Z92 == None )
	{
		return;
	}
	Z92.V6F=self;
	Z92.Spawn(Class'MTLMOTD',Z92);
	SetTimer(0.00,False);
}

simulated function PostBeginPlay ()
{
	local ZoneInfo Z95;

	if ( Level.NetMode != 3 )
	{
		return;
	}
	Z92=MTLPlayer(GetPlayerPawn());
	if ( Z92 == None )
	{
		return;
	}
	Z92.V6F=self;
	Z92.Spawn(Class'MTLMOTD',Z92);
	foreach AllActors(Class'ZoneInfo',Z95)
	{
		Z95.LinkToSkybox();
		if ( Z95.IsA('SkyZoneInfo') )
		{
			Log("SkyZoneInfo Repaired!",'DXMTL');
		}
	}
}

simulated function Tick (float VC5)
{
	if ( (Level.Game == None) && (Z91 != None) )
	{
		Level.Game=Z91;
	}
}

final function V15 (MTLPlayer Player)
{
	local V2E Z96;
	local V2E Z97;
	local int Z98;

	if ( Z8F != None )
	{
		Z96=Z8F.VD1;
JL001F:
		if ( Z96 != None )
		{
			Z98++;
			Z97=Z96;
			Z96=Z96.VD1;
			goto JL001F;
		}
		if ( Z98 >= Level.Game.MaxPlayers + 2 )
		{
			Z97.Destroy();
		}
		Z96=Spawn(Class'V2E',self);
		Z96.VD2=Z8F;
		Z96.VD1=Z8F.VD1;
		if ( Z8F.VD1 != None )
		{
			Z8F.VD1.VD2=Z96;
		}
		Z8F.VD1=Z96;
		Z96.V3F(Player);
	}
}

final function V43 (MTLPlayer Player)
{
	if ( Z8F != None )
	{
		Z8F.V0E(Player);
	}
}

final function V16 (DeusExMover S42, out V36 Z99)
{
	local V36 Z9A;

	Z9A=Spawn(Class'V36',self);
	Z9A.VD2=Z99;
	Z99.VD1=Z9A;
	Z99=Z9A;
	Z99.V3A(S42);
}

final function V14 (DeusExMover S42)
{
	local V36 Z99;
	local DeusExMover Z9B;

	if ( S42.bInitialLocked &&  !S42.bLocked && (S42.initiallockStrength > 0.00) )
	{
		Z99=Z90;
JL004D:
		if ( Z99 != None )
		{
			if ( Z99.VBA == S42 )
			{
				goto JL0122;
			}
			if ( Z99.VD1 == None )
			{
				V16(S42,Z99);
				if ( (S42.Tag != 'None') && (S42.Tag != 'DeusExMover') )
				{
					foreach AllActors(Class'DeusExMover',Z9B,S42.Tag)
					{
						if ( Z9B != S42 )
						{
							V16(Z9B,Z99);
						}
					}
				}
			} else {
				Z99=Z99.VD1;
				goto JL004D;
			}
		}
	}
JL0122:
}

defaultproperties
{
    iBytesPerSec=350
    iBytesPerFive=1000
    iMsgPerSec=5
    iMsgPerFive=15
    iMaxNumOfSpams=4
    iSpawnMassLimit=100
    bAllowAdminSet=True
    bAllowSummon=True
    bAllowSpawnMass=True
    bAllowGetPlayerIP=True
    bKnife_FullRefill=True
    bKnife_KeepPlaceholder=True
    bInvincibleAmmoCrates=True
    bHidden=True
    RemoteRole=2
    bAlwaysRelevant=True
    NetPriority=10.00
}
