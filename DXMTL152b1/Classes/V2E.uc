//================================================================================
// V2E.
//================================================================================
class V2E extends Actor;

var V2E VD2;
var V2E VD1;
var AugmentationManager AugManager;
var SkillManager SkillM;
var string V99;
var string ZCC;
var float ZCD;
var float ZCE;
var float ZCF;
var float ZD0;
var int V9A;
var int ZD1;
var int ZD2;
var int ZD3;
var int ZD4;
var int ZD5;
var int ZD6;
var int ZD7;
var int ZD8;
var int ZD9;
var int ZDA;
var bool TDB;

final function V3F (MTLPlayer Player)
{
	local Inventory VC4;
	local DeusExWeapon ZDC;

	Log("V2E V3F");

	if ( (Player == None) || (Player.PlayerReplicationInfo == None) )
	{
		Destroy();
		return;
	}
	ZCC=Player.V70;
	if ( (ZCC == "") || (ZCC == "0.0.0.0") )
	{
		Destroy();
		return;
	}
	TDB=Player.V7D;
	ZCD=Player.PlayerReplicationInfo.Score;
	ZCE=Player.PlayerReplicationInfo.Deaths;
	ZCF=Player.PlayerReplicationInfo.Streak;
	V99=Player.PlayerReplicationInfo.PlayerName;
	V9A=Player.PlayerReplicationInfo.PlayerID;
	ZD1=Player.PlayerReplicationInfo.Team;
	if ( Player.IsInState('Dying') )
	{
		ZD2=0;
	} else {
		ZD2=Player.Health;
	}
	ZD3=Player.HealthHead;
	ZD4=Player.HealthTorso;
	ZD5=Player.HealthLegLeft;
	ZD6=Player.HealthLegRight;
	ZD7=Player.HealthArmLeft;
	ZD8=Player.HealthArmRight;
	ZD0=Player.Energy;
	if ( (ZD2 <= 0) || (ZD3 <= 0) || (ZD4 <= 0) || TDB )
	{
		return;
	}
	ZD9=Player.SkillPointsTotal;
	ZDA=Player.SkillPointsAvail;
JL023D:
	if ( Player.Inventory != None )
	{
		VC4=Player.Inventory;
		ZDC=DeusExWeapon(VC4);
		if ( (ZDC != None) && (ZDC.AmmoName != ZDC.AmmoNames[0]) )
		{
			ZDC.LoadAmmo(0);
		}
		Player.DeleteInventory(VC4);
		if (  !VC4.IsA('ChargedPickup') ||  !ChargedPickup(VC4).IsActive() )
		{
			V0D(VC4);
		} else {
			VC4.Destroy();
		}
		goto JL023D;
	}
	AugManager=Player.AugmentationSystem;
	if ( AugManager != None )
	{
		AugManager.DeactivateAll();
		AugManager.SetPlayer(None);
		AugManager.SetOwner(self);
	}
	Player.AugmentationSystem=None;
	SkillM=Player.SkillSystem;
	if ( SkillM != None )
	{
		SkillM.SetPlayer(None);
		SkillM.SetOwner(self);
	}
	Player.SkillSystem=None;
}

final function bool V0E (MTLPlayer Player)
{
	local Inventory VC4;

	Log("V2E V0E");
	return True;


	if ( (Player == None) || (Player.PlayerReplicationInfo == None) )
	{
		return False;
	}
	if ( (Player.V70 != ZCC) ||  !(Player.PlayerReplicationInfo.PlayerName ~= V99) )
	{
		if ( VD1 != None )
		{
			if ( VD1.V0E(Player) )
			{
				return True;
			}
		}
		if ( Player.V70 != ZCC )
		{
			return False;
		}
	}
	if (  !(Player.PlayerReplicationInfo.PlayerName ~= V99) )
	{
		Player.V55(V99,V9A);
	}
	Player.Level.Game.ChangeTeam(Player,ZD1);
	Player.PlayerReplicationInfo.Deaths=ZCE;
	if ( TDB )
	{
		Destroy();
		return True;
	}
	Player.PlayerReplicationInfo.Score=ZCD;
	Player.PlayerReplicationInfo.Streak=ZCF;
	if ( (ZD2 <= 0) || (ZD3 <= 0) || (ZD4 <= 0) )
	{
		Destroy();
		return True;
	}
	Player.V7E=True;
	Player.Health=ZD2;
	Player.HealthHead=ZD3;
	Player.HealthTorso=ZD4;
	Player.HealthLegLeft=ZD5;
	Player.HealthLegRight=ZD6;
	Player.HealthArmLeft=ZD7;
	Player.HealthArmRight=ZD8;
	Player.Energy=ZD0;
	Player.SkillPointsTotal=ZD9;
	Player.SkillPointsAvail=ZDA;
JL026D:
	if ( Player.Inventory != None )
	{
		VC4=Player.Inventory;
		Player.DeleteInventory(VC4);
		VC4.Destroy();
		goto JL026D;
	}
	if ( (Player.AugmentationSystem != None) && (AugManager != None) )
	{
		Player.AugmentationSystem.Destroy();
	}
	if ( (Player.SkillSystem != None) && (SkillM != None) )
	{
		Player.SkillSystem.Destroy();
	}
JL0324:
	if ( Inventory != None )
	{
		VC4=Inventory;
		V0F(VC4);
		Player.AddInventory(VC4);
		goto JL0324;
	}
	if ( AugManager != None )
	{
		AugManager.SetPlayer(Player);
		AugManager.SetOwner(Player);
		Player.AugmentationSystem=AugManager;
		AugManager=None;
	}
	if ( SkillM != None )
	{
		SkillM.SetPlayer(Player);
		SkillM.SetOwner(Player);
		Player.SkillSystem=SkillM;
		SkillM=None;
	}
	Destroy();
	return True;
}

function Destroyed ()
{
	local Inventory VC4;

	if ( VD2 != None )
	{
		VD2.VD1=VD1;
	}
	if ( VD1 != None )
	{
		VD1.VD2=VD2;
	}
JL003E:
	if ( Inventory != None )
	{
		VC4=Inventory;
		V0F(VC4);
		VC4.Destroy();
		goto JL003E;
	}
	if ( AugManager != None )
	{
		AugManager.Destroy();
	}
	if ( SkillM != None )
	{
		SkillM.Destroy();
	}
	Super.Destroyed();
}

final function bool V0D (Inventory VC4)
{
	local Inventory Z7E;

	Log("V2E V0D");

	if ( VC4 == None )
	{
		return False;
	}
	Z7E=Inventory;
JL0018:
	if ( Z7E != None )
	{
		if ( Z7E == VC4 )
		{
			return False;
		}
		Z7E=Z7E.Inventory;
		goto JL0018;
	}
	VC4.SetOwner(self);
	VC4.Inventory=Inventory;
	VC4.InitialState='Idle2';
	VC4.GotoState('Idle2');
	Inventory=VC4;
	return True;
}

final function V0F (Inventory VC4)
{
	local Actor ZDD;

	Log("V2E V0F");

	if ( VC4 == None )
	{
		return;
	}
	ZDD=self;
JL0014:
	if ( ZDD != None )
	{
		if ( ZDD.Inventory == VC4 )
		{
			ZDD.Inventory=VC4.Inventory;
		} else {
			ZDD=ZDD.Inventory;
			goto JL0014;
		}
	}
	VC4.SetOwner(None);
}

defaultproperties
{
    bHidden=True
    RemoteRole=ROLE_None
    LifeSpan=360.00
}
