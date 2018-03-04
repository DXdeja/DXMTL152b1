class AntiCheat1 extends CBPMutator
	Config(DXMTL);

struct V03
{
	var const float S44;
	var const float VBA;
	var const float Z6F;
	var const bool Z70;
};

var bool S31;
var bool Z6E;
var globalconfig bool AllowCenterView;
var globalconfig bool ContinuousCenterView;
var globalconfig float CenterViewDelay;
var globalconfig float StandingProtectionTime;
var globalconfig float MovingProtectionTime;
var globalconfig int SimMaxClientRate;
var const V03 V47;
var int V77;

function PreBeginPlay ()
{
	Super.PreBeginPlay();
	if (  !Z6E )
	{
		Z6E=True;
		Level.Game.RegisterDamageMutator(self);
	}
}

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( S31 )
	{
		return;
	}
	S31=True;
	CenterViewDelay=FMax(CenterViewDelay,0.00);
	StandingProtectionTime=FMin(StandingProtectionTime,60.00);
	MovingProtectionTime=FClamp(MovingProtectionTime,0.00,30.00);
	SimMaxClientRate=Clamp(SimMaxClientRate,1600,20000);
	SaveConfig();
	V77=SimMaxClientRate;
	Log("",'DXMTL');
	Log("Starting anti-cheat mutator...",'DXMTL');
	Log("Allow CenterView:" @ string(AllowCenterView),'DXMTL');
	Log("Continuous CenterView:" @ string(ContinuousCenterView),'DXMTL');
	Log("CenterView Delay:" @ string(CenterViewDelay),'DXMTL');
	Log("",'DXMTL');
	Class'PlayerPawn'.Default.MaxTimeMargin=1.00;
	Class'PlayerPawn'.StaticSaveConfig();
	V1D();
	SetTimer(5.00,True);
}

function ModifyPlayer (Pawn Z58)
{
	local MTLPlayer Player;


	Player=MTLPlayer(Z58);
	if ( Player == None )
	{
		Log("Bad player login",'DXMTL');
		if ( Z58 != None )
		{
			Z58.Destroy();
		}
		return;
	}
	Super.ModifyPlayer(Player);
	Player.V80=AllowCenterView;
	Player.V81=ContinuousCenterView;
	Player.V76=CenterViewDelay;
	Player.V77=V77;
	if ( Player.V6D != None )
	{
		Player.V6D.Destroy();
	}
	Player.V6D=Player.Spawn(Class'V33',Player);
	Player.V6D.V5B(StandingProtectionTime,MovingProtectionTime);
	if ( Player.V6E == None )
	{
		Player.V6E=Spawn(Class'V2D',Player);
		Log("ModifyPlayer #1");
	}
		Log("ModifyPlayer #2");
	Player.V57();
		Log("ModifyPlayer #3");
}

function Timer ()
{
	local DeusExMover Z71;

	foreach AllActors(Class'DeusExMover',Z71)
	{
		if ( Z71.bDestroyed && (Z71.Texture != None) )
		{
			Z71.StopPicking();
			Z71.GotoState('None');
			Z71.Disable('Tick');
			Z71.SetTimer(0.00,False);
			Z71.Velocity=vect(0.00,0.00,0.00);
			Z71.SetPhysics(PHYS_None);
			Z71.Texture=None;
		}
	}
}

final function V1D ()
{
	local DeusExLevelInfo Z52;
	local DeusExMover VBA;
	local string Z72;

	foreach AllActors(Class'DeusExLevelInfo',Z52)
	{
	    if(Z52 != none)
		break;
	}
	if ( Z52 == None )
	{
		Z52=Level.Spawn(Class'DeusExLevelInfo');
		Log("DeusExLevelInfo Created!",'DXMTL');
	} else {
		Log("DeusExLevelInfo Repaired!",'DXMTL');
	}
	Z52.missionNumber=7;
	Z52.bMultiPlayerMap=True;
	Z52.ConversationPackage=Class'DeusExLevelInfo'.Default.ConversationPackage;
	Z52.bAlwaysRelevant=True;
	Z52.NetPriority=5.00;
	Z72=Caps(Left(string(self),InStr(string(self),".")));
	switch (Z72)
	{
		case "DXMP_CMD":
		Spawn(Class'V2B',self,'bot4_door',vect(-1549.21,2638.23,-1999.44));
		break;
		case "DXMP_CATHEDRAL":
		foreach AllActors(Class'DeusExMover',VBA)
		{
			if ( VBA.Name == 'DeusExMover34' )
			{
				VBA.StayOpenTime=28.00;
			} else {
				if ( VBA.Name == 'DeusExMover0' )
				{
					VBA.MoveTime=1.00;
				}
			}
		}
		break;
		default:
	}
	FixCollision();
}

function FixCollision()
{
 local RepairBot Bot;
 local string lvl;

 foreach allactors(class'RepairBot',Bot)
 {
         Bot.SetCollisionSize(50,47.470001);
         lvl=Caps(Left(string(self),InStr(string(self),".")));

      switch (lvl)
      {
		case "DXMP_AREA51BUNKER":
		 Bot.SetLocation(vect(1409.770874,2807.921875,-464.430481));
		break;
		case "DXMP_CATHEDRAL":
		 Bot.SetLocation(vect(1470.803467,-2478.102539,-400.434937));
        	break;
		case "DXMP_CMD":
		 Bot.SetCollisionSize(54,47.470001);
		break;
		case "DXMP_SILO":
		 Bot.SetLocation(vect(-869.184875,-4137.898926,1473.565063));
		break;
		case "DXMP_SMUGGLER":
		 Bot.SetLocation(vect(-976.438416,-0.116975,15.570381));
		break;
		default:
	 }
 }
}

function ReplaceMapItem (out Actor V91, Class<Actor> S43)
{
	Super.ReplaceMapItem(V91,S43);
	V1C(V91);
	V1A(V91);
	V1B(V91);
}

function SpawnNotification (out Actor V91, Class<Actor> S43)
{
	Super.SpawnNotification(V91,S43);
	//V1C(V91);
	//V1B(V91);
}

final function V1C (out Actor V91)
{
	local Class<Actor> S43;
	local Actor Z73;

	if ( V91 == None )
	{
		return;
	}
	if ( V91.IsA('Decal') && (Level.NetMode == 1) )
	{
		V91.Destroy();
		V91=None;
		return;
	}
	switch (V91.Class)
	{
		case Class'BloodDrop':
		S43=Class'CBPBloodDrop';
		break;
		case Class'FleshFragment':
		S43=Class'CBPFleshFragment';
		break;
		case Class'BloodSpurt':
		S43=Class'CBPBloodSpurt';
		break;
		case Class'Shuriken':
		S43=Class'CBPShuriken';
		break;
		case Class'WeaponPistol':
		S43=Class'CBPWeaponPistol';
		break;
		case Class'WeaponRifle':
		S43=Class'CBPWeaponRifle';
		break;
		case Class'WeaponShuriken':
		S43=Class'CBPWeaponShuriken';
		break;
		case Class'WeaponGEPGun':
		S43=Class'CBPWeaponGEPGun';
		break;
		case Class'ammocrate':
		S43=Class'CBPAmmoCrate';
		break;
		case Class'Button1':
		S43=Class'CBPButton1';
		break;
		case Class'WeaponLAM':
		S43=Class'MTLWeaponLAM';
		break;
        default:
	}
	if ( S43 != None )
	{
		Log("V1C S43"@V91);
		V91.bHidden=True;
		V91.SetCollision(False,False,False);
		Z73=Spawn(S43,V91.Owner,V91.Tag,V91.Location,V91.Rotation);
		if ( Z73 != None )
		{
			if ( V91.IsA('Inventory') && Z73.IsA('Inventory') )
			{
				Inventory(Z73).RespawnTime=Inventory(V91).RespawnTime;
			}
			Z73.Event=V91.Event;
			Z73.AttachTag=V91.AttachTag;
			Z73.SetPhysics(V91.Physics);
			Z73.SetCollisionSize(V91.CollisionRadius,V91.CollisionHeight);
			if ( Z73.IsA('CBPButton1') )
			{
				CBPButton1(Z73).V00(Button1(V91));
			}
		}
		V91.Tag='None';
		V91.Event='None';
		V91.Destroy();
		V91=Z73;
	}
}

final function V1B (out Actor V91)
{
	local float Z74;

	if ( V91 == None )
	{
		return;
	}
	if ( V91.IsA('Fragment') )
	{
		V91.bReplicateInstigator=False;
	} else {
		if ( V91.IsA('ElectronicDevices') )
		{
			Z74=V47.S44;
			if ( V91.IsA('SecurityCamera') && V47.Z70 )
			{
				SecurityCamera(V91).bSwing=False;
			}
		} else {
			if ( V91.IsA('DeusExDecoration') && (V91.Physics == PHYS_Rotating) && (V91.RemoteRole == ROLE_DumbProxy) )
			{
				V91.RemoteRole=ROLE_SimulatedProxy;
			}
		}
	}
	if ( Z74 > 0.00 )
	{
		Log("V1B Z74"@V91);
		V91.NetUpdateFrequency=Z74;
	}
}

final function V1A (out Actor V91)
{
	local float Z74;

	if ( V91 == None )
	{
		return;
	}
	if ( V91.IsA('ZoneInfo') )
	{
		Z74=V47.Z6F;
	} else {
		if ( V91.IsA('Mover') )
		{
			Z74=V47.VBA;
			if ( V91.IsA('ElevatorMover') && (Z74 > 0.00) )
			{
				Z74=FMax(Z74 * 1.50,10.00);
			}
		} else {
			if ( V91.IsA('Button1') )
			{
				V91.bAlwaysRelevant=True;
				V91.NetPriority=2.70;
			} else {
				if ( V91.IsA('AmmoRocketWP') )
				{
					V91.SetCollisionSize(FMin(V91.CollisionRadius * 0.90,12.00),V91.CollisionHeight * 0.90);
				} else {
					if ( V91.IsA('Ammo20mm') || V91.IsA('WeaponLAW') || V91.IsA('RepairBot') )
					{
						V91.SetCollisionSize(V91.CollisionRadius * 0.90,V91.CollisionHeight * 0.90);
					} else {
						if ( V91.IsA('WeaponLAM') || V91.IsA('WeaponEMPGrenade') || V91.IsA('WeaponGasGrenade') || V91.IsA('MedicalBot') || V91.IsA('BioelectricCell') || V91.IsA('Lockpick') || V91.IsA('Multitool') || V91.IsA('MedKit') )
						{
							V91.SetCollisionSize(V91.CollisionRadius * 0.99,V91.CollisionHeight * 0.99);
						}
					}
				}
			}
		}
	}
	if ( Z74 > 0.00 )
	{
		V91.NetUpdateFrequency=Z74;
	}
}

function MutatorTakeDamage (out int Z75, Pawn Z76, Pawn Z77, out Vector S30, out Vector Z78, name VC8)
{
	if ( (DeusExPlayer(Z76) != None) && (DeusExPlayer(Z76).NintendoImmunityTimeLeft > 0.00) )
	{
		Z78=vect(0.00,0.00,0.00);
		Z75=0;
	}
	Super.MutatorTakeDamage(Z75,Z76,Z77,S30,Z78,VC8);
}

defaultproperties
{
    AllowCenterView=True
    CenterViewDelay=2.50
    StandingProtectionTime=7.00
    MovingProtectionTime=8.00
    SimMaxClientRate=10000
    V47=(S44=16.00, VBA=10.00, Z6F=2.00, Z70=True)
    RemoteRole=ROLE_None
}
