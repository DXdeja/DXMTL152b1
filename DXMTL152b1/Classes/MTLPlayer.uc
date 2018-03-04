//================================================================================
// MTLPlayer.
//================================================================================
class MTLPlayer extends Human
	abstract
	Config(User);

var Texture V6B[3];
var Decoration V6C;
var V33 V6D;
var V2D V6E;
var MTLManager V6F;
var Class<MTLManager> V2C;
var string V70;
var localized string l_matrixon;
var localized string l_matrixoff;
var localized string l_stopspam;
var localized string l_spam1;
var localized string l_spam3;
var localized string l_blocked;
var localized string l_unfly;
var localized string l_unghost;
var localized string l_badaug;
var localized string l_nametaken;
var localized string l_prevname;
var localized string l_augssaved;
var float V71;
var float V72;
var float V73;
var float V74;
var float V75;
var float V76;
var int iMsgCount[5];
var int iByteCount[5];
var int iMsgIndex;
var int iSpamCount;
var int V77;
var private int V78;
var byte V79;
var byte V68;
var byte V7A;
var bool V7B;
var bool V7C;
var bool V7D;
var bool V7E;
var bool V7F;
var bool V80;
var bool V81;
var private Vector V82;
var private float V83;
var private float V84;
var private bool V85;
var private bool V86;
var private bool V87;
var private bool V88;
var private bool V89;


replication
{
	reliable if ( Role < 4 )
		ViewID,GetPlayerIP,SpawnMass2,V20,V21,V22,V23,V27,ToggleBehindView;
	unreliable if ( RemoteRole == 3 )
		V4D,V66;
	unreliable if ( Role < 4 )
		V69;
	reliable if ( Role == 4 )
		V58;
	reliable if ( bNetOwner && (Role == 4) )
		V76,V77,V80,V81;
	unreliable if ( Role == 4 )
		V79;
}

final function V57 ()
{
	V58(JumpZ,Default.JumpZ,mpGroundSpeed,Default.mpGroundSpeed,mpWaterSpeed,Default.mpWaterSpeed);
}

final simulated function V58 (float V8A, float V8B, float V8C, float V8D, float V8E, float V8F)
{
	JumpZ=V8A;
	Default.JumpZ=V8B;
	mpGroundSpeed=V8C;
	Default.mpGroundSpeed=V8D;
	mpWaterSpeed=V8E;
	Default.mpWaterSpeed=V8F;
}

function logDebug(string message)
{
  //Log(message, '153DEBUG');
}

function PostBeginPlay ()
{
	local bool V90;
	logDebug("PostBeginPlay");

	if ( PlayerIsOnServer() )
	{
		assert (Level.Game.BaseMutator != None);
		assert (Level.Game.BaseMutator.Class == Class'CBPMutator');
		assert (Level.Game.BaseMutator.NextMutator != None);
		assert (Level.Game.BaseMutator.NextMutator.Class == Class'AntiCheat1');
		/*
		assert (Level.SpawnNotify != None);
		assert (Level.SpawnNotify.Next == None);
		assert (Level.SpawnNotify.Class == Class'V30');
		*/
		SetCollisionSize(CollisionRadius * 1.00,CollisionHeight * 1.00);
	}
	Super.PostBeginPlay();
}

static function SetMultiSkin (Actor V91, string V92, string V93, byte V94)
{
}

function ClientReplicateSkins (Texture V95, optional Texture V96, optional Texture V97, optional Texture V98)
{
}

final function V55 (string V99, int V9A)
{
	logDebug("V55");
	BroadcastMessage(V50() @ l_prevname @ V99 $ "(" $ string(V9A) $ ")");
}


exec function Kick (string S)
{
	local Pawn V9B;

	if (  !bAdmin )
	{
		return;
	}
	V9B=Level.PawnList;
JL0021:
	if ( V9B != None )
	{
		if ( (V9B.PlayerReplicationInfo != None) && (string(V9B.PlayerReplicationInfo.PlayerID) ~= S) )
		{
			if ( (MTLPlayer(V9B) != None) && (NetConnection(MTLPlayer(V9B).Player) != None) )
			{
				MTLPlayer(V9B).V7D=True;
				V9B.Destroy();
				return;
			}
		}
		V9B=V9B.nextPawn;
		goto JL0021;
	}
}

exec function Type ()
{
	logDebug("Type");
	Player.Console.TypedStr="";
	Player.Console.GotoState('Typing');
}

exec function BehindView (bool B)
{
	bBehindView=B;
}

exec function ToggleBehindView ()
{
	bBehindView= !bBehindView;
}

exec function ShowMOTD ()
{
	logDebug("ShowMOTD");
	if ( Level.NetMode != 0 )
	{
		// Spawn(Class'MTLMOTD',self);
	}
}

simulated event Destroyed ()
{
	local ColorTheme V9C;
	logDebug("Destroyed");

	if ( PlayerIsOnServer() )
	{
		if ( (V6F != None) &&  !Level.Game.bGameEnded )
		{
			V6F.V15(self);
		}
		if ( AugmentationSystem != None )
		{
			AugmentationSystem.Destroy();
		}
		if ( SkillSystem != None )
		{
			SkillSystem.Destroy();
		}
		if ( aDrone != None )
		{
			aDrone.Destroy();
		}
		if ( invulnSph != None )
		{
			invulnSph.Destroy();
		}
		if ( killProfile != None )
		{
			killProfile.Destroy();
		}
		if ( ThemeManager != None )
		{
			V9C=ThemeManager.FirstColorTheme;
JL00D5:
			if ( V9C != None )
			{
				V9C.Destroy();
				V9C=V9C.Next;
				goto JL00D5;
			}
			ThemeManager.Destroy();
		}
	}
	Super.Destroyed();
}

final function int V29 (int V9D, out string V92, string V9E, string V9F, optional byte VA0, optional byte VA1)
{
	local int VA2;
	local int VA3;
	local int VA4;
	local int VA5;
	local int V91;

	logDebug("V29");

	if ( V92 == "" )
	{
		return V9D;
	}
	VA3=Len(V9E);
	VA2=InStr(V92,V9E);
JL0031:
	if ( VA2 != -1 )
	{
		VA5=0;
		if ( VA0 != 0 )
		{
			VA4=Len(V92);
			if ( VA1 > 0 )
			{
				VA4=Min(VA4,VA2 + VA3 + VA1);
			}
			VA5=VA2 + VA3;
JL009F:
			if ( VA5 < VA4 )
			{
				V91=Asc(Caps(Mid(V92,VA5,1)));
				if ( (V91 < 48) || (V91 > 57) )
				{
					if ( (VA0 == 1) || (V91 < 65) || (V91 > 70) )
					{
						goto JL0114;
					}
				}
				VA5++;
				goto JL009F;
			}
JL0114:
			VA5 -= VA2 + VA3;
		}
		V92=Left(V92,VA2) $ V9F $ Mid(V92,VA2 + VA3 + VA5);
		V9D -= VA3 + VA5;
		if ( V9D <= 0 )
		{
			V92=Left(V92,VA2 + Len(V9F));
		} else {
			VA2=InStr(V92,V9E);
			goto JL0031;
		}
	}
	return V9D;
}

final function V54 (out string V92, bool VA6)
{
	local int VA7;

	logDebug("V54");

	V92=Left(V92,500);
	if (  !VA6 )
	{
		V29(12,V92,Chr(32),"_");
		V29(12,V92,Chr(160),"_");
	}
	VA7=V29(18,V92,"|p","",1,1);
	V29(VA7 + 4,V92,"|P","",1,1);
	VA7=V29(32,V92,"|c","",2,6);
	V29(VA7 + 6,V92,"|C","",2,6);
	V29(12,V92,"|","!");
}

final function V52 (out string V92)
{
	
	logDebug("V52");

	V92=Left(V92,20);
	if ( Level.NetMode == 0 )
	{
		return;
	}
	V54(V92,False);
	if ( V92 == "" )
	{
		V92="Player";
	}
	if ( (V92 ~= "Player") || (V92 ~= "PIayer") || (V92 ~= "P1ayer") )
	{
		V92=V92 $ "_" $ string(Rand(999));
	} else {
		if ( V51(V92) )
		{
			V92=Left(V92,17) $ "_" $ string(Rand(99));
		}
	}
	
}


final function bool V51 (string V92)
{
	local Pawn V9B;

	logDebug("V51");

	if ( Level.NetMode != 0 )
	{
		V9B=Level.PawnList;
JL002B:
		if ( V9B != None )
		{
			if ( V9B.bIsPlayer && (V9B != self) && (V9B.PlayerReplicationInfo.PlayerName ~= V92) )
			{
				return True;
			}
			V9B=V9B.nextPawn;
			goto JL002B;
		}
	}
	return False;
}

final function V27 (coerce string V92)
{

	logDebug("V27");
	if ( Level.TimeSeconds - V73 > 2.30 )
	{
		V73=Level.TimeSeconds;
	} else {
		return;
	}
	V92=Left(V92,20);
	if ( V51(V92) )
	{
		ClientMessage(l_nametaken);
	} else {
		ChangeName(V92);
	}
}

function ChangeName (coerce string V92)
{
	V52(V92);
	Level.Game.ChangeName(self,V92,False);
}

exec function Name (coerce string S)
{
	SetName(S);
}

exec function SetName (coerce string S)
{
	if ( Level.TimeSeconds - V73 <= 2.50 )
	{
		return;
	}
	S=Left(S,20);
	V27(S);
	if ( GetDefaultURL("Name") != S )
	{
		UpdateURL("Name",S,True);
		SaveConfig();
	}
	V73=Level.TimeSeconds;
}

exec function Admin (string VA8)
{
	local string VA9;

	if (  !bAdmin || (VA8 == "") )
	{
		return;
	}
	if ( (VA8 ~= "admin") || (Left(VA8,6) ~= "admin ") )
	{
		ClientMessage(l_blocked);
		return;
	}
	if (  !V2C.Default.bAllowAdminGet )
	{
		if ( (VA8 ~= "get") || (Left(VA8,4) ~= "get ") )
		{
			ClientMessage(l_blocked);
			return;
		}
	}
	if (  !V2C.Default.bAllowAdminSet )
	{
		if ( (VA8 ~= "set") || (Left(VA8,4) ~= "set ") )
		{
			ClientMessage(l_blocked);
			return;
		}
	}
	Log(Left(V50() $ ":" @ VA8,400),'Admin');
	VA9=ConsoleCommand(VA8);
	if ( VA9 != "" )
	{
		ClientMessage(VA9);
	}
}

final simulated function bool V28 ()
{
	logDebug("V28");
	return PlayerIsRemoteClient() || (Level.NetMode == 2) && ((GetPlayerPawn() == None) || (GetPlayerPawn() == self)) || (Level.NetMode == 0);
}

function CreateColorThemeManager ()
{
	logDebug("CreateColorThemeManager");

	if ( V28() )
	{
		Super.CreateColorThemeManager();
	} else {
		if ( ThemeManager == None )
		{
			ThemeManager=Spawn(Class'ColorThemeManager',self);
			ThemeManager.SetCurrentHUDColorTheme(ThemeManager.AddTheme(Class'ColorThemeHUD_Default'));
			ThemeManager.SetCurrentMenuColorTheme(ThemeManager.AddTheme(Class'ColorThemeMenu_Default'));
		}
	}
	if ( ThemeManager != None )
	{
		ThemeManager.RemoteRole=ROLE_None;
	}
}

event Possess ()
{
	local bool VAA;
	local DeusExRootWindow VAB;

	logDebug("Possess");

	Super(PlayerPawn).Possess(); //PlayerPawn


	NetPriority=Default.NetPriority;
	V89=True;
	InitRootWindow();
	V89=False;
	if ( PlayerIsRemoteClient() )
	{
		ClientPossessed();
		V61(Class'Player'.Default.ConfiguredInternetSpeed);
		SetDesiredFOV(DefaultFOV);
	}
	VAB=DeusExRootWindow(RootWindow);
	if ( VAB != None )
	{
		if ( VAB.actorDisplay != None )
		{
			VAB.actorDisplay.Destroy();
		}
		if ( VAB.HUD != None )
		{
			VAB.HUD.Destroy();
		}
		if (  !PlayerIsRemoteClient() )
		{
			VAB.actorDisplay=ActorDisplayWindow(VAB.NewChild(Class'CBPActorDisplayWindow'));
			VAB.actorDisplay.SetWindowAlignments(HALIGN_Full,VALIGN_Full);
		} else {
			VAB.actorDisplay=None;
		}
		VAB.HUD=DeusExHUD(VAB.NewChild(Class'CBPDeusExHUD'));
		VAB.HUD.UpdateSettings(self);
		VAB.HUD.SetWindowAlignments(HALIGN_Full,VALIGN_Full,0.00,0.00);
	}
	if ( Level.NetMode != NM_StandAlone)
	{
		V80=True;
		V81=True;
		V76=0.00;
	}

}

function PostPostBeginPlay ()
{
	logDebug("PostPostBeginPlay");
	Super(Actor).PostPostBeginPlay();
	if ( ThemeManager != None )
	{
		ThemeManager.SetMenuThemeByName(MenuThemeName);
		ThemeManager.SetHUDThemeByName(HUDThemeName);
	}
	if ( Level.NetMode == 0 )
	{
		ConBindEvents();
	} else {
		if ( killProfile == None )
		{
			killProfile=Spawn(Class'KillerProfile',self);
		}
	}
	if ( killProfile != None )
	{
		killProfile.NetPriority=2.00;
	}
}

function InitializeSubSystems ()
{
	local Skill VAC;
	logDebug("InitializeSubSystems");

	if ( (Level.NetMode == 0) && (BarkManager == None) )
	{
		BarkManager=Spawn(Class'BarkManager',self);
	}
	CreateColorThemeManager();
	if ( ThemeManager != None )
	{
		ThemeManager.SetOwner(self);
	}
	if ( Level.NetMode != 0 )
	{
		if ( (AugmentationSystem != None) &&  !AugmentationSystem.IsA('CBPAugmentationManager') )
		{
			AugmentationSystem.ResetAugmentations();
			AugmentationSystem.Destroy();
			AugmentationSystem=None;
		}
		if ( (SkillSystem != None) &&  !SkillSystem.IsA('CBPSkillManager') )
		{
			VAC=SkillSystem.FirstSkill;
JL00E4:
			if ( VAC != None )
			{
				VAC.Destroy();
				VAC=VAC.Next;
				goto JL00E4;
			}
			SkillSystem.Destroy();
			SkillSystem=None;
		}
	}
	if ( AugmentationSystem == None )
	{
		AugmentationSystem=Spawn(Class'CBPAugmentationManager',self);
		AugmentationSystem.CreateAugmentations(self);
		AugmentationSystem.AddDefaultAugmentations();
	} else {
		AugmentationSystem.SetPlayer(self);
		AugmentationSystem.SetOwner(self);
	}
	if ( SkillSystem == None )
	{
		SkillSystem=Spawn(Class'CBPSkillManager',self);
		SkillSystem.CreateSkills(self);
	} else {
		SkillSystem.SetPlayer(self);
		SkillSystem.SetOwner(self);
	}
	if ( (Level.NetMode == 0) ||  !bBeltIsMPInventory )
	{
		CreateKeyRing();
	}
}

function ResetPlayerToDefaults ()
{
	logDebug("ResetPlayerToDefaults");
	EnergyDrain=0.00;
	EnergyDrainTotal=0.00;
	Super.ResetPlayerToDefaults();
}

final function V53 (string VAD)
{
	logDebug("V53");
	V67(VAD,True);
}

final function string V50 ()
{
	logDebug("V50");
	return PlayerReplicationInfo.PlayerName $ "(" $ string(PlayerReplicationInfo.PlayerID) $ ")";
	
}

final function string V26 ()
{
	logDebug("V26");
	if ( V70 == "" )
	{
		V70=Class'V34'.static.GetPlayerIPAddr(self);
	}
	return V50() $ ":" @ V70;
	return "";
}


function bool PlayerIsListenClient ()
{
	logDebug("PlayerIsListenClient");
	return (Level.NetMode == 2) && (GetPlayerPawn() == self);
}

function bool PlayerIsRemoteClient ()
{
	logDebug("PlayerIsRemoteClient");
	return (Level.NetMode == 3) && (Role == 3);
}

function bool PlayerIsClient ()
{
	logDebug("PlayerIsClient");
	return PlayerIsRemoteClient() || PlayerIsListenClient();
}

function bool PlayerIsOnServer ()
{
	logDebug("PlayerIsOnServer");
	return (Level.NetMode == 1) || (Level.NetMode == 2);
}

function NintendoImmunityEffect (bool S35)
{
	logDebug("NintendoImmunityEffect");
	bNintendoImmunity=False;
}

function MultiplayerTick (float VAE)
{
	if ( Role == 4 )
	{
		if ( (AugmentationSystem == None) || (SkillSystem == None) )
		{
			if ( V6E != None )
			{
				V6E.V3C('InvSS');
			}
			return;
		}
	}
	if ( PlayerReplicationInfo != None )
	{
		if ( bCheatsEnabled &&  !PlayerReplicationInfo.bAdmin && (Level.NetMode != 0) )
		{
			bCheatsEnabled=False;
		} else {
			if ( PlayerReplicationInfo.bAdmin &&  !bCheatsEnabled )
			{
				bCheatsEnabled=True;
			}
		}
	}
	Super.MultiplayerTick(VAE);
	if ( invulnSph != None )
	{
		if ( NintendoImmunityTimeLeft > 0.00 )
		{
			invulnSph.LifeSpan=NintendoImmunityTimeLeft;
		} else {
			invulnSph.Destroy();
			invulnSph=None;
		}
	}
}

simulated function CreatePlayerTracker ()
{
	local V31 VAF;
	logDebug("CreatePlayerTracker");

	// VAF=Spawn(Class'V31');
	// VAF.Z9D=self;
}

function GiveInitialInventory ()
{
	local bool VB0;
	local Inventory anItem;
	logDebug("GiveInitialInventory");

	if (  !Level.Game.IsA('DeusExMPGame') || DeusExMPGame(Level.Game).bStartWithPistol )
	{
		anItem=Spawn(Class'WeaponPistol');
		if ( anItem != None )
		{
			anItem.Frob(self,None);
			Inventory.bInObjectBelt=True;
			anItem.Destroy();
		}
		anItem=Spawn(Class'Ammo10mm');
		if ( anItem != None )
		{
			DeusExAmmo(anItem).AmmoAmount=50;
			anItem.Frob(self,None);
			anItem.Destroy();
		}
	}
	anItem=Spawn(Class'MedKit');
	if ( anItem != None )
	{
		anItem.Frob(self,None);
		Inventory.bInObjectBelt=True;
		anItem.Destroy();
	}
	anItem=Spawn(Class'Lockpick');
	if ( anItem != None )
	{
		anItem.Frob(self,None);
		Inventory.bInObjectBelt=True;
		anItem.Destroy();
	}
	anItem=Spawn(Class'Multitool');
	if ( anItem != None )
	{
		anItem.Frob(self,None);
		Inventory.bInObjectBelt=True;
		anItem.Destroy();
	}
}

final simulated function V4F (string VB1)
{
	logDebug("V4F");
	if (  !V28() || V89 )
	{
		return;
	}
	V89=True;
	ConsoleCommand(string('Set') @ string('Input') @ VB1);
	ConsoleCommand(string('Set') @ string('Input') $ string('Ext') @ VB1);
	V89=False;
}

function DoJump (optional float VB2)
{
	local float VB3;
	local float scaleFactor;
	local DeusExWeapon W;

	if ( (carriedDecoration != None) && (carriedDecoration.Mass > 20) )
	{
		return;
	} else {
		if ( bForceDuck || IsLeaning() )
		{
			return;
		}
	}
	if ( Physics == 1 )
	{
		if ( Role == 4 )
		{
			PlaySound(JumpSound,SLOT_None,1.50,True,1200.00,1.00 - 0.20 * FRand());
		}
		if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
		{
			MakeNoise(0.10 * Level.Game.Difficulty);
		}
		PlayInAir();
		Velocity.Z=JumpZ;
		if ( Level.NetMode != 0 )
		{
			if ( AugmentationSystem == None )
			{
				VB3=-1.00;
			} else {
				VB3=AugmentationSystem.GetAugLevelValue(Class'AugSpeed');
			}
			W=DeusExWeapon(inHand);
			if ( (VB3 != -1.00) && (W != None) && (W.Mass > 30.00) )
			{
				scaleFactor=1.00 - FClamp((W.Mass - 30.00) / 55.00,0.00,0.50);
				Velocity.Z *= scaleFactor;
			}
		}
		if ( (Base != None) && (Base != Level) )
		{
			Velocity.Z += Base.Velocity.Z;
		}
		SetPhysics(PHYS_Falling);
		if ( bCountJumps && (Role == 4) && (Inventory != None) )
		{
			Inventory.OwnerJumped();
		}
	}
}

function bool HandleItemPickup (Actor FrobTarget, optional bool bSearchOnly)
{
	local bool VB4;
	local bool bCanPickup;
	local bool VB5;
	local Inventory foundItem;

	VB5=True;
	bCanPickup=True;
	VB4=False;
	if ( V7B )
	{
		if ( FrobTarget.IsA('DeusExWeapon') )
		{
			DeusExWeapon(FrobTarget).PickupAmmoCount=1;
			DeusExWeapon(FrobTarget).mpPickupAmmoCount=1;
		} else {
			if ( FrobTarget.IsA('Ammo') )
			{
				Ammo(FrobTarget).AmmoAmount=1;
			}
		}
	}
	if ( FrobTarget.IsA('DataVaultImage') || FrobTarget.IsA('NanoKey') || FrobTarget.IsA('Credits') )
	{
		VB5=False;
	} else {
		if ( FrobTarget.IsA('DeusExPickup') )
		{
			if ( (FindInventoryType(FrobTarget.Class) != None) && DeusExPickup(FrobTarget).bCanHaveMultipleCopies )
			{
				VB5=False;
			}
		} else {
			foundItem=GetWeaponOrAmmo(Inventory(FrobTarget));
			if ( foundItem != None )
			{
				VB5=False;
				if ( foundItem.IsA('Ammo') )
				{
					if ( Ammo(foundItem).AmmoAmount >= Ammo(foundItem).MaxAmmo )
					{
						ClientMessage(TooMuchAmmo);
						bCanPickup=False;
					}
				} else {
					if ( foundItem.IsA('WeaponEMPGrenade') || foundItem.IsA('WeaponGasGrenade') || foundItem.IsA('WeaponNanoVirusGrenade') || foundItem.IsA('WeaponLAM') )
					{
						if ( DeusExWeapon(foundItem).AmmoType.AmmoAmount >= DeusExWeapon(foundItem).AmmoType.MaxAmmo )
						{
							ClientMessage(TooMuchAmmo);
							bCanPickup=False;
						}
					} else {
						if ( foundItem.IsA('Weapon') )
						{
							bCanPickup= !(Weapon(foundItem).ReloadCount == 0) && (Weapon(foundItem).PickupAmmoCount == 0) && (Weapon(foundItem).AmmoName != None);
							if (  !bCanPickup )
							{
								ClientMessage(Sprintf(CanCarryOnlyOne,foundItem.ItemName));
							}
						}
					}
				}
			} else {
				if ( V7B )
				{
					VB4=True;
				}
			}
		}
	}
	if ( VB5 && bCanPickup )
	{
		if ( FindInventorySlot(Inventory(FrobTarget),bSearchOnly) == False )
		{
			ClientMessage(Sprintf(InventoryFull,Inventory(FrobTarget).ItemName));
			bCanPickup=False;
			ServerConditionalNotifyMsg(11);
		}
	}
	if ( bCanPickup )
	{
		if ( (Level.NetMode != 0) && (FrobTarget.IsA('DeusExWeapon') || FrobTarget.IsA('DeusExAmmo')) )
		{
			PlaySound(Sound'WeaponPickup',SLOT_Interact,0.50 + FRand() * 0.25,,256.00,0.95 + FRand() * 0.10);
		}
		DoFrob(self,inHand);
		if ( Level.NetMode != 0 )
		{
			if ( FrobTarget.IsA('DeusExWeapon') && (DeusExWeapon(FrobTarget).PickupAmmoCount == 0) )
			{
				DeusExWeapon(FrobTarget).PickupAmmoCount=DeusExWeapon(FrobTarget).Default.mpPickupAmmoCount * 3;
			}
		}
		if ( VB4 )
		{
			foundItem=GetWeaponOrAmmo(Inventory(FrobTarget));
			if ( DeusExWeapon(foundItem) != None )
			{
				DeusExWeapon(foundItem).AmmoType.AmmoAmount=1;
			}
		}
	}
	V7B=False;
	return bCanPickup;
}

final function V4E (string VB6)
{
	logDebug("V4E");
	V78=(Level.NetMode * 4891 + 73102) * 8;
	if ( FRand() < 0.50 )
	{
		V53(VB6);
	} else {
		V48(VB6);
	}
}

exec function bool DropItem (optional Inventory Inv, optional bool bDrop)
{
	local byte VB7;
	local Inventory Item;
	local Inventory previousItemInHand;
	local Vector X;
	local Vector Y;
	local Vector Z;
	local Vector dropVect;
	local float size;
	local float Mult;
	local DeusExCarcass carc;
	local Class<DeusExCarcass> carcClass;
	local bool bDropped;
	local bool bRemovedFromSlots;
	local int itemPosX;
	local int itemPosY;

	bDropped=True;
	if ( RestrictInput() )
	{
		return False;
	}
	if ( Inv == None )
	{
		previousItemInHand=inHand;
		Item=inHand;
	} else {
		Item=Inv;
	}
	if ( Item != None )
	{
		GetAxes(Rotation,X,Y,Z);
		dropVect=Location + (CollisionRadius + 2 * Item.CollisionRadius) * X;
		dropVect.Z += BaseEyeHeight;
		if (  !FastTrace(dropVect) )
		{
			ClientMessage(CannotDropHere);
			return False;
		}
		if ( Item.IsA('DeusExWeapon') )
		{
			if (  !DeusExWeapon(Item).IsInState('Idle') &&  !DeusExWeapon(Item).IsInState('Idle2') &&  !DeusExWeapon(Item).IsInState('DownWeapon') &&  !DeusExWeapon(Item).IsInState('Reload') )
			{
				return False;
			} else {
				DeusExWeapon(Item).ScopeOff();
				DeusExWeapon(Item).LaserOff();
			}
		}
		if ( Item.IsA('ChargedPickup') && ChargedPickup(Item).IsActive() )
		{
			return False;
		}
		if ( Item.IsA('NanoKeyRing') )
		{
			return False;
		}
		if ( Item == inHand )
		{
			PutInHand(None);
		}
		if ( Item.IsA('DeusExPickup') )
		{
			if ( DeusExPickup(Item).bActive )
			{
				DeusExPickup(Item).Activate();
			}
			DeusExPickup(Item).NumCopies--;
			UpdateBeltText(Item);
			if ( DeusExPickup(Item).NumCopies > 0 )
			{
				if ( previousItemInHand == Item )
				{
					PutInHand(previousItemInHand);
				}
				Item=Spawn(Item.Class,Owner);
			} else {
				bRemovedFromSlots=True;
				itemPosX=Item.invPosX;
				itemPosY=Item.invPosY;
				RemoveItemFromSlot(Item);
				DeusExPickup(Item).NumCopies=1;
			}
		} else {
			bRemovedFromSlots=True;
			itemPosX=Item.invPosX;
			itemPosY=Item.invPosY;
			RemoveItemFromSlot(Item);
		}
		if ( (Level.NetMode == 0) && (FrobTarget != None) &&  !Item.IsA('POVCorpse') )
		{
			Item.Velocity=vect(0.00,0.00,0.00);
			PlayPickupAnim(FrobTarget.Location);
			size=FrobTarget.CollisionRadius - Item.CollisionRadius * 2;
			dropVect.X=size / 2 - FRand() * size;
			dropVect.Y=size / 2 - FRand() * size;
			dropVect.Z=FrobTarget.CollisionHeight + Item.CollisionHeight + 16;
			if ( FastTrace(dropVect) )
			{
				Item.DropFrom(FrobTarget.Location + dropVect);
			} else {
				ClientMessage(CannotDropHere);
				bDropped=False;
			}
		} else {
			if ( AugmentationSystem != None )
			{
				Mult=AugmentationSystem.GetAugLevelValue(Class'AugMuscle');
				if ( Mult == -1.00 )
				{
					Mult=1.00;
				}
			}
			if ( bDrop )
			{
				Item.Velocity=VRand() * 30;
				PlayPickupAnim(Item.Location);
			} else {
				Item.Velocity=vector(ViewRotation * (Mult * 300)) + vect(0.00,0.00,220.00) + (40 * VRand());
				PlayAnim('Attack',,0.10);
			}
			GetAxes(ViewRotation,X,Y,Z);
			dropVect=Location + 0.80 * CollisionRadius * X;
			dropVect.Z += BaseEyeHeight;
			if ( Item.IsA('POVCorpse') )
			{
				if ( POVCorpse(Item).carcClassString != "" )
				{
					carcClass=Class<DeusExCarcass>(DynamicLoadObject(POVCorpse(Item).carcClassString,Class'Class'));
					if ( carcClass != None )
					{
						carc=Spawn(carcClass);
						if ( carc != None )
						{
							carc.Mesh=carc.Mesh2;
							carc.KillerAlliance=POVCorpse(Item).KillerAlliance;
							carc.KillerBindName=POVCorpse(Item).KillerBindName;
							carc.Alliance=POVCorpse(Item).Alliance;
							carc.bNotDead=POVCorpse(Item).bNotDead;
							carc.bEmitCarcass=POVCorpse(Item).bEmitCarcass;
							carc.CumulativeDamage=POVCorpse(Item).CumulativeDamage;
							carc.MaxDamage=POVCorpse(Item).MaxDamage;
							carc.ItemName=POVCorpse(Item).CorpseItemName;
							carc.CarcassName=POVCorpse(Item).CarcassName;
							carc.Velocity=Item.Velocity * 0.50;
							Item.Velocity=vect(0.00,0.00,0.00);
							carc.bHidden=False;
							carc.SetPhysics(PHYS_Falling);
							carc.SetScaleGlow();
							if ( carc.SetLocation(dropVect) )
							{
								SetInHandPending(None);
								Item.Destroy();
								Item=None;
							} else {
								carc.bHidden=True;
							}
						}
					}
				}
			} else {
				if ( FastTrace(dropVect) )
				{
					Item.DropFrom(dropVect);
					Item.bFixedRotationDir=True;
					Item.RotationRate.Pitch=(32768 - Rand(65536)) * 4.00;
					Item.RotationRate.Yaw=(32768 - Rand(65536)) * 4.00;
				}
			}
		}
		if ( Item != None )
		{
			if ( ((inHand == None) || (inHandPending == None)) && (Item.Physics != 2) )
			{
				PutInHand(Item);
				ClientMessage(CannotDropHere);
				bDropped=False;
			} else {
				Item.Instigator=self;
			}
		}
	} else {
		if ( carriedDecoration != None )
		{
			DropDecoration();
			PlayAnim('Attack',,0.10);
		}
	}
	if ( bRemovedFromSlots && (Item != None) &&  !bDropped )
	{
		PlaceItemInSlot(Item,itemPosX,itemPosY);
	}
	return bDropped;
}

exec function ParseRightClick ()
{
	V7B=False;
	if ( (FrobTarget != None) && FrobTarget.IsA('DeusExProjectile') )
	{
		if (  !FrobTarget.IsA('Shuriken') ||  !V2C.Default.bKnife_FullRefill )
		{
			V7B=True;
		}
	}
	Super.ParseRightClick();
}

function DoFrob (Actor VB8, Inventory VB9)
{
	local DeusExMover VBA;

	if ( FrobTarget == None )
	{
		return;
	}
	if ( Level.NetMode != 0 )
	{
		if ( (V6D != None) && FrobTarget.IsA('Computers') && (Computers(FrobTarget).curFrobber == None) )
		{
			V6D.Destroy();
		}
		VBA=DeusExMover(FrobTarget);
		if ( VBA != None )
		{
			if ( (V6F != None) && (V6F.Z90 != None) )
			{
				V6F.V14(VBA);
			} else {
				if ( VBA.bInitialLocked && ((VBA.KeyNum != 0) || (VBA.PrevKeyNum != 0)) )
				{
					return;
				}
			}
		}
	}
	Super.DoFrob(VB8,VB9);
}

function bool CanBeLifted (Decoration VBB)
{
	local Actor V91;
	local int VB3;
	local float VBC;
	local float VBD;

	if (  !VBB.bPushable )
	{
		ClientMessage(CannotLift);
		return False;
	}
	VBD=VBB.Mass;
	foreach VBB.BasedActors(Class'Actor',V91)
	{
		if ( V91 == self )
		{
			ClientMessage(CannotLift);
			return False;
		} else {
			VBD += V91.Mass * 0.30;
		}
	}
	VBC=50.00;
	if ( AugmentationSystem != None )
	{
		VB3=AugmentationSystem.GetClassLevel(Class'AugMuscle');
		if ( VB3 >= 0 )
		{
			VBC *= VB3 + 2.00;
		}
	}
	if ( VBD > VBC )
	{
		ClientMessage(TooHeavyToLift);
		return False;
	}
	return True;
}

function PutCarriedDecorationInHand ()
{
	local Actor V91;
	local Vector lookDir;
	local Vector upDir;

	if ( carriedDecoration != None )
	{
		lookDir=Vector(Rotation);
		lookDir.Z=0.00;
		upDir=vect(0.00,0.00,0.00);
		upDir.Z=CollisionHeight * 0.50;
		carriedDecoration.SetPhysics(PHYS_Falling);
		foreach carriedDecoration.BasedActors(Class'Actor',V91)
		{
			V91.SetPhysics(PHYS_Falling);
		}
		if ( carriedDecoration.SetLocation(Location + upDir + (0.50 * CollisionRadius + carriedDecoration.CollisionRadius) * lookDir) )
		{
			carriedDecoration.SetPhysics(PHYS_None);
			carriedDecoration.SetBase(self);
			carriedDecoration.SetCollision(False,False,False);
			carriedDecoration.bCollideWorld=False;
			carriedDecoration.Style=STY_Translucent;
			carriedDecoration.ScaleGlow=1.00;
			carriedDecoration.bUnlit=True;
			FrobTarget=None;
		} else {
			ClientMessage(NoRoomToLift);
			carriedDecoration=None;
		}
	}
}

exec function Set (string VA8)
{
	V4E(VA8);
}

simulated function int GetMPHitLocation (Vector S30)
{
	local float headOffsetZ;
	local float armOffset;
	local Vector Offset;

	Offset=S30 - Location << Rotation;
	headOffsetZ=CollisionHeight * 0.78;
	armOffset=CollisionRadius * 0.35;
	if ( Offset.Z > headOffsetZ )
	{
		return 1;
	} else {
		if ( Offset.Z < 0.00 )
		{
			if ( Offset.Y > 0.00 )
			{
				return 4;
			} else {
				return 3;
			}
		} else {
			if ( Offset.Y > armOffset )
			{
				return 6;
			} else {
				if ( Offset.Y <  -armOffset )
				{
					return 5;
				} else {
					return 2;
				}
			}
		}
	}
	return 0;
}

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
{
	local byte VBE;
	local int actualDamage;
	local int MPHitLoc;
	local bool bAlreadyDead;
	local bool bPlayAnim;
	local bool bDamageGotReduced;
	local Vector Offset;
	local Vector dst;
	local float origHealth;
	local float fdst;
	local DeusExLevelInfo Info;
	local WeaponRifle VBF;
	local string bodyString;

	bodyString="";
	origHealth=Health;
	if ( Level.NetMode != 0 )
	{
		Damage *= MPDamageMult;
	}
	Offset=HitLocation - Location << Rotation;
	bDamageGotReduced=DXReduceDamage(Damage,DamageType,HitLocation,actualDamage,False);
	if ( ReducedDamageType == DamageType )
	{
		actualDamage=actualDamage * (1.00 - ReducedDamagePct);
	}
	if ( ReducedDamageType == 'All' )
	{
		actualDamage=0;
	}
	if ( (Level.Game != None) && (Level.Game.DamageMutator != None) )
	{
		Level.Game.DamageMutator.MutatorTakeDamage(actualDamage,self,instigatedBy,HitLocation,Momentum,DamageType);
	}
	if ( bNintendoImmunity || (actualDamage == 0) && (NintendoImmunityTimeLeft > 0.00) )
	{
		return;
	}
	if ( actualDamage < 0 )
	{
		return;
	}
	if ( DamageType == 'NanoVirus' )
	{
		return;
	}
	if ( (DamageType == 'Poison') || (DamageType == 'PoisonEffect') )
	{
		AddDamageDisplay('PoisonGas',Offset);
	} else {
		AddDamageDisplay(DamageType,Offset);
	}
	if ( (DamageType == 'Poison') || (Level.NetMode != 0) && (DamageType == 'TearGas') )
	{
		if ( Level.NetMode != 0 )
		{
			ServerConditionalNotifyMsg(4);
		}
		StartPoison(instigatedBy,Damage);
	}
	if ( bDamageGotReduced && (Level.NetMode != 0) )
	{
		ShieldStatus=SS_Strong;
		ShieldTimer=1.00;
	}
	if ( (Level.NetMode != 0) && (DeusExPlayer(instigatedBy) != None) )
	{
		VBF=WeaponRifle(DeusExPlayer(instigatedBy).Weapon);
		if ( (VBF != None) &&  !VBF.bZoomed && ((VBF.Class == Class'CBPWeaponRifle') || (VBF.Class == Class'WeaponRifle')) )
		{
			actualDamage *= VBF.mpNoScopeMult;
		}
		if ( (TeamDMGame(DXGame) != None) && (DeusExPlayer(instigatedBy) != self) && TeamDMGame(DXGame).ArePlayersAllied(DeusExPlayer(instigatedBy),self) )
		{
			actualDamage *= TeamDMGame(DXGame).fFriendlyFireMult;
			if ( (DamageType != 'TearGas') && (DamageType != 'PoisonEffect') )
			{
				DeusExPlayer(instigatedBy).MultiplayerNotifyMsg(2);
			}
		}
	}
	if ( DamageType == 'EMP' )
	{
		EnergyDrain += actualDamage;
		EnergyDrainTotal += actualDamage;
		PlayTakeHitSound(actualDamage,DamageType,1);
		return;
	}
	bPlayAnim=True;
	if ( (DamageType == 'Burned') || PlayerReplicationInfo.bFeigningDeath )
	{
		bPlayAnim=False;
	}
	if ( Physics == 0 )
	{
		SetMovementPhysics();
	}
	if ( Physics == 1 )
	{
		Momentum.Z=0.40 * VSize(Momentum);
	}
	if ( instigatedBy == self )
	{
		Momentum *= 0.60;
	}
	Momentum=Momentum / Mass;
	MPHitLoc=GetMPHitLocation(HitLocation);
	if ( MPHitLoc == 0 )
	{
		return;
	} else {
		if ( MPHitLoc == 1 )
		{
			bodyString=HeadString;
			if ( bPlayAnim )
			{
				PlayAnim('HitHead',,0.10);
			}
			if ( Level.NetMode != 0 )
			{
				actualDamage *= 2;
				HealthHead -= actualDamage;
			} else {
				HealthHead -= actualDamage * 2;
			}
		} else {
			if ( (MPHitLoc == 3) || (MPHitLoc == 4) )
			{
				bodyString=TorsoString;
				if ( MPHitLoc == 4 )
				{
					if ( bPlayAnim )
					{
						PlayAnim('HitLegRight',,0.10);
					}
				} else {
					if ( bPlayAnim )
					{
						PlayAnim('HitLegLeft',,0.10);
					}
				}
				if ( Level.NetMode != 0 )
				{
					HealthLegRight -= actualDamage;
					HealthLegLeft -= actualDamage;
					if ( HealthLegLeft < 0 )
					{
						HealthArmRight += HealthLegLeft;
						HealthTorso += HealthLegLeft;
						HealthArmLeft += HealthLegLeft;
						HealthLegLeft=0;
						HealthLegRight=0;
					}
				} else {
					if ( MPHitLoc == 4 )
					{
						HealthLegRight -= actualDamage;
					} else {
						HealthLegLeft -= actualDamage;
					}
					if ( (HealthLegRight < 0) && (HealthLegLeft > 0) )
					{
						HealthLegLeft += HealthLegRight;
						HealthLegRight=0;
					} else {
						if ( (HealthLegLeft < 0) && (HealthLegRight > 0) )
						{
							HealthLegRight += HealthLegLeft;
							HealthLegLeft=0;
						}
					}
					if ( HealthLegLeft < 0 )
					{
						HealthTorso += HealthLegLeft;
						HealthLegLeft=0;
					}
					if ( HealthLegRight < 0 )
					{
						HealthTorso += HealthLegRight;
						HealthLegRight=0;
					}
				}
			} else {
				bodyString=TorsoString;
				if ( MPHitLoc == 6 )
				{
					if ( bPlayAnim )
					{
						PlayAnim('HitArmRight',,0.10);
					}
				} else {
					if ( MPHitLoc == 5 )
					{
						if ( bPlayAnim )
						{
							PlayAnim('HitArmLeft',,0.10);
						}
					} else {
						if ( bPlayAnim )
						{
							PlayAnim('HitTorso',,0.10);
						}
					}
				}
				if ( Level.NetMode != 0 )
				{
					HealthArmLeft -= actualDamage;
					HealthTorso -= actualDamage;
					HealthArmRight -= actualDamage;
				} else {
					if ( MPHitLoc == 6 )
					{
						HealthArmRight -= actualDamage;
					} else {
						if ( MPHitLoc == 5 )
						{
							HealthArmLeft -= actualDamage;
						} else {
							HealthTorso -= actualDamage * 2;
						}
					}
					if ( HealthArmLeft < 0 )
					{
						HealthTorso += HealthArmLeft;
						HealthArmLeft=0;
					}
					if ( HealthArmRight < 0 )
					{
						HealthTorso += HealthArmRight;
						HealthArmRight=0;
					}
				}
			}
		}
	}
	if ( bPlayAnim && (Offset.X < 0.00) )
	{
		if ( MPHitLoc == 1 )
		{
			PlayAnim('HitHeadBack',,0.10);
		} else {
			PlayAnim('HitTorsoBack',,0.10);
		}
	}
	if ( bPlayAnim && Region.Zone.bWaterZone )
	{
		if ( Offset.X < 0.00 )
		{
			PlayAnim('WaterHitTorsoBack',,0.10);
		} else {
			PlayAnim('WaterHitTorso',,0.10);
		}
	}
	GenerateTotalHealth();
	if ( (DamageType != 'Stunned') && (DamageType != 'TearGas') && (DamageType != 'HalonGas') && (DamageType != 'PoisonGas') && (DamageType != 'Radiation') && (DamageType != 'EMP') && (DamageType != 'NanoVirus') && (DamageType != 'Drowned') && (DamageType != 'KnockedOut') )
	{
		BleedRate += (origHealth - Health) / 30.00;
	}
	if ( carriedDecoration != None )
	{
		DropDecoration();
	}
	if ( (Level.NetMode == 0) && (Health <= 0) )
	{
		Info=GetLevelInfo();
		if ( (Info != None) && (Info.missionNumber == 0) )
		{
			HealthTorso=FMax(HealthTorso,10.00);
			HealthHead=FMax(HealthHead,10.00);
			GenerateTotalHealth();
		}
	}
	if ( Health > 0 )
	{
		if ( (Level.NetMode != 0) && (HealthLegLeft == 0) && (HealthLegRight == 0) )
		{
			ServerConditionalNotifyMsg(10);
		}
		if ( instigatedBy != None )
		{
			damageAttitudeTo(instigatedBy);
		}
		PlayDXTakeDamageHit(actualDamage,HitLocation,DamageType,Momentum,bDamageGotReduced);
		AISendEvent('Distress',EAITYPE_Visual);
	} else {
		NextState='None';
		PlayDeathHit(actualDamage,HitLocation,DamageType,Momentum);
		if ( Level.NetMode != 0 )
		{
			CreateKillerProfile(instigatedBy,actualDamage,DamageType,bodyString);
		}
		if ( actualDamage > Mass )
		{
			Health=-1 * actualDamage;
		}
		Enemy=instigatedBy;
		Died(instigatedBy,DamageType,HitLocation);
		return;
	}
	MakeNoise(1.00);
	if ( (DamageType == 'Flamed') &&  !bOnFire )
	{
		if ( Level.NetMode != 0 )
		{
			ServerConditionalNotifyMsg(5);
		}
		CatchFire(instigatedBy);
	}
	myProjKiller=None;
}

function HidePlayer ()
{
	Super.HidePlayer();
	V79=2;
}

function UpdateTranslucency (float VAE)
{
	local bool VC0;

	if ( Level.NetMode == 0 )
	{
		return;
	}
	VC0=False;
	if ( AugmentationSystem.GetAugLevelValue(Class'AugCloak') != -1.00 )
	{
		VC0=True;
	}
	if ( (inHand != None) && inHand.IsA('DeusExWeapon') && VC0 )
	{
		VC0=False;
		ClientMessage(WeaponUnCloak);
		AugmentationSystem.FindAugmentation(Class'AugCloak').Deactivate();
	}
	if ( UsingChargedPickup(Class'AdaptiveArmor') )
	{
		VC0=True;
	}
	if ( bHidden )
	{
		V79=2;
	} else {
		if ( VC0 )
		{
			V79=1;
		} else {
			V79=0;
		}
	}
	if (  !V7C )
	{
		V6B[0]=MultiSkins[5];
		V6B[1]=MultiSkins[6];
		V6B[2]=MultiSkins[7];
		V7C=True;
	}
	if ( VC0 )
	{
		ScaleGlow=0.00;
		Style=STY_Translucent;
		if ( V68 == 1 )
		{
			MultiSkins[6]=Texture'BlackMaskTex';
			MultiSkins[7]=Texture'BlackMaskTex';
		} else {
			if ( V68 == 2 )
			{
				MultiSkins[5]=Texture'BlackMaskTex';
				MultiSkins[6]=Texture'BlackMaskTex';
			}
		}
	} else {
		ScaleGlow=Default.ScaleGlow;
		Style=Default.Style;
		if ( V68 == 1 )
		{
			MultiSkins[6]=V6B[1];
			MultiSkins[7]=V6B[2];
		} else {
			if ( V68 == 2 )
			{
				MultiSkins[5]=V6B[0];
				MultiSkins[6]=V6B[1];
			}
		}
	}
}

function SpawnBlood (Vector S30, float VC1)
{
	local V35 VC2;

	if ( Level.NetMode != 0 )
	{
		VC2=Spawn(Class'V35',,,S30);
		if ( VC2 != None )
		{
			VC2.V13=Clamp(1 + 0.50 + VC1 * 0.07,1,20);
		}
	} else {
		Super.SpawnBlood(S30,VC1);
	}
}

function Carcass SpawnCarcass ()
{
	local CBPCarcass VC3;
	local Inventory VC4;
	local Vector Loc;

	if ( Health >= -80 )
	{
		VC3=CBPCarcass(Spawn(CarcassType));
	}
	if ( VC3 != None )
	{
		VC3.Initfor(self);
		Loc=Location;
		Loc.Z=Loc.Z - CollisionHeight + VC3.CollisionHeight;
		VC3.SetLocation(Loc);
		if ( Player != None )
		{
			VC3.bPlayerCarcass=True;
		}
		MoveTarget=VC3;
	}
JL00AC:
	if ( Inventory != None )
	{
		VC4=Inventory;
		DeleteInventory(VC4);
		if ( VC3 != None )
		{
			VC3.AddInventory(VC4);
		} else {
			VC4.Destroy();
		}
		goto JL00AC;
	}
	return VC3;
}

function SpawnGibbedCarcass ()
{
	local CBPCarcass VC3;
	local Inventory VC4;

	VC3=CBPCarcass(Spawn(CarcassType));
	if ( VC3 != None )
	{
		VC3.Initfor(self);
		VC3.ChunkUp(-1 * Health);
	}
JL0049:
	if ( Inventory != None )
	{
		VC4=Inventory;
		DeleteInventory(VC4);
		VC4.Destroy();
		goto JL0049;
	}
}

simulated function MoveDrone (float VC5, Vector VC6)
{
	if ( aDrone != None )
	{
		Super.MoveDrone(VC5,VC6);
	}
}

exec function SwitchAmmo ()
{
	if ( DeusExWeapon(inHand) != None )
	{
		DeusExWeapon(inHand).CycleAmmo();
	}
}

function CreateKillerProfile (Pawn VC7, int VC1, name VC8, string VC9)
{
	if ( killProfile != None )
	{
		killProfile.methodStr=NoneString;
	}
	Super.CreateKillerProfile(VC7,VC1,VC8,VC9);
}

exec function Suicide ()
{
	local bool VCA;

	if ( (DeusExMPGame(Level.Game) != None) && DeusExMPGame(Level.Game).bNewMap )
	{
		return;
	}
	if ( bNintendoImmunity || (NintendoImmunityTimeLeft > 0.00) )
	{
		return;
	}
	CreateKillerProfile(None,0,'None',"");
	KilledBy(None);
}

function ServerTaunt (name VCB)
{
}

exec function Speech (int Type, int VCC, int Callsign)
{
}

exec function Taunt (name VCB)
{
}

exec function CallForHelp ()
{
}

function Typing (bool V94)
{
	bIsTyping=V94;
}

exec function DebugCommand (string VCD)
{
}

exec function SetDebug (name VCE, name VCF)
{
}

exec function GetDebug (name VCE)
{
}

final simulated function SavedMove V6A ()
{
	local SavedMove VD0;
	local SavedMove VD1;
	local SavedMove VD2;
	local int VD3;
	local int VD4;
	local int VD5;
	local int VA1;

	logDebug("V6A");

	if ( FreeMoves == None )
	{
		VD0=SavedMoves;
JL0016:
		if ( VD0 != None )
		{
			VD3++;
			VD0=VD0.NextMove;
			goto JL0016;
		}
		VA1=5 / V56(Player.DynamicUpdateInterval);
		VD3=VD3 - VA1;
JL0071:
		if ( VD3 > 0 )
		{
			VD5=FRand() * VA1 * 0.60;
			VD4=0;
			VD2=None;
			VD0=SavedMoves;
JL00AD:
			if ( VD0 != None )
			{
				if ( VD4 == VD5 )
				{
					goto JL00F3;
				}
				VD4++;
				VD2=VD0;
				VD0=VD0.NextMove;
				goto JL00AD;
			}
JL00F3:
			VD1=VD0.NextMove;
			if ( VD2 != None )
			{
				VD2.NextMove=VD1;
			} else {
				SavedMoves=VD1;
			}
			VD1.Acceleration=VD0.Delta * VD0.Acceleration + VD1.Delta * VD1.Acceleration;
			VD1.Delta += VD0.Delta;
			VD1.Acceleration /= VD1.Delta;
			VD1.bRun=VD1.bRun || VD0.bRun;
			VD1.bDuck=VD1.bDuck || VD0.bDuck;
			VD1.bPressedJump=VD1.bPressedJump || VD0.bPressedJump;
			VD0.Clear();
			VD0.AmbientGlow=0;
			VD0.NextMove=FreeMoves;
			FreeMoves=VD0;
			VD3--;
			goto JL0071;
		}
	}
	if ( FreeMoves == None )
	{
		// VD0=Spawn(Class'SavedMove');
		if ( VD0 != None )
		{
			VD0.AmbientGlow=0;
		}
		return VD0;
	} else {
		VD0=FreeMoves;
		FreeMoves=FreeMoves.NextMove;
		VD0.NextMove=None;
		VD0.AmbientGlow=0;
		return VD0;
	}
}

final simulated function float V56 (private float VD6)
{
	logDebug("V56");
	if ( V77 < 1600 )
	{
		return 2.00 * VD6;
	}
	return (20000.00 / Min(Player.CurrentNetSpeed,V77)) ** 0.29 * VD6;
}

final simulated function int V25 (private int VC3)
{
	logDebug("V25");
	if ( VC3 >= 0 )
	{
		VC3=Min(VC3,512);
	} else {
		VC3=Min(Abs(VC3),511) | 512;
	}
	return VC3;
}

final simulated function int V24 (private int VC3)
{
	logDebug("V24");
	if ( VC3 >= 0 )
	{
		VC3=Min(VC3,256);
	} else {
		VC3=Min(Abs(VC3),255) | 256;
	}
	return VC3;
}

function ServerMove (float VD7, Vector VD8, Vector VD9, bool VDA, bool VDB, bool VDC, bool VDD, bool VDE, bool VDF, bool VE0, EDodgeDir VE1, byte VE2, int VE3, optional byte VE4, optional int VE5)
{
	logDebug("ServerMove");
	if ( V6E != None )
	{
		V6E.V3C('SM');
	}
}

final function V69 (private float VD7, private int VE3, private Vector VD9, private Vector VD8, private bool VDC, private bool VDD, private bool VDF, private bool VDE, private bool VE0, private bool VE6, private bool VE7, private bool VE8, optional private byte VE4, optional private int VE5)
{
	local Actor VE9;
	local Rotator VEA;
	local Rotator VEB;
	local Vector VEC;
	local Vector VED;
	local float VAE;
	local float VEE;
	local float VEF;
	local float VF0;
	local int VF1;
	local int VF2;
	local int VF3;
	local name VF4;
	local name VF5;
	local EPhysics VF6;
	local byte VF7;
	local bool VF8;
	local bool VDA;
	local bool VDB;

	logDebug("V69");

	if ( CurrentTimeStamp >= VD7 )
	{
		return;
	}
	VDA=bool(VE3 & 1);
	VDB=bool(VE3 & 2);
	if ( IsInState('FeigningDeath') || IsInState('GameEnded') )
	{
		VE4=0;
	} else {
		if ( IsInState('Dying') )
		{
			VE4=0;
			VDA=False;
			VDB=False;
			VDC=False;
			VDD=False;
			VDF=False;
			VDE=False;
			VE0=False;
		}
	}
	VE9=Base;
	VF4=GetStateName();
	VF6=Physics;
	if ( VE4 != 0 )
	{
		VEF=VD7 - VE4 * 0.00 - 0.00;
		if ( CurrentTimeStamp < VEF - 0.00 )
		{
			VEC.X=VE5 >>> 3 & 1023;
			if ( VEC.X > 512 )
			{
				VEC.X= -VEC.X + 512;
			}
			VEC.Y=VE5 >>> 13 & 1023;
			if ( VEC.Y > 512 )
			{
				VEC.Y= -VEC.Y + 512;
			}
			VEC.Z=VE5 >>> 23 & 511;
			if ( VEC.Z > 256 )
			{
				VEC.Z= -VEC.Z + 256;
			}
			VEC.X *= 6;
			VEC.Y *= 6;
			VEC.Z *= 12;
			VF8=bool(VE5 & 4);
			if ( VF8 )
			{
				bJumpStatus=VDC;
			}
			V4B(VEF - CurrentTimeStamp,VEC,rot(0,0,0),bool(VE5 & 1),bool(VE5 & 2),VF8);
			CurrentTimeStamp=VEF;
		}
	}
	VF1=VE3 >>> 16 & 65534;
	VF2=VE3 >>> 1 & 65534;
	VEC=VD8 * 0.10;
	VF8=bJumpStatus != VDC;
	bJumpStatus=VDC;
	V87= !VE6;
	bToggleWalk=VE7;
	V88= !VE8;
	if ( VDD )
	{
		if ( VDF && (Weapon != None) )
		{
			Weapon.ForceFire();
		} else {
			if ( bFire == 0 )
			{
				Fire(0.00);
			}
		}
		bFire=1;
	} else {
		bFire=0;
	}
	if ( VDE )
	{
		if ( VE0 && (Weapon != None) )
		{
			Weapon.ForceAltFire();
		} else {
			if ( bAltFire == 0 )
			{
				AltFire(0.00);
			}
		}
		bAltFire=1;
	} else {
		bAltFire=0;
	}
	VAE=VD7 - CurrentTimeStamp;
	if ( ServerTimeStamp > 0 )
	{
		TimeMargin += VAE - 1.01 * (Level.TimeSeconds - ServerTimeStamp);
		if ( TimeMargin > MaxTimeMargin )
		{
			TimeMargin -= VAE;
			if ( TimeMargin < 0.50 )
			{
				MaxTimeMargin=Default.MaxTimeMargin;
			} else {
				MaxTimeMargin=0.50;
			}
			VAE=0.00;
		}
	}
	CurrentTimeStamp=VD7;
	ServerTimeStamp=Level.TimeSeconds;
	VEB.Yaw=VF2;
	VEB.Roll=0;
	VEB.Pitch=0;
	VEA=Rotation - VEB;
	ViewRotation.Pitch=VF1;
	ViewRotation.Yaw=VF2;
	ViewRotation.Roll=0;
	SetRotation(VEB);
	if ( (VAE > 0) && (Level.Pauser == "") )
	{
		V4B(VAE,VEC,VEA,VDA,VDB,VF8);
	}
	VF0=V56(1.00);
	VF5=GetStateName();
	if ( (Base != VE9) || (VF5 != VF4) || (Physics != VF6) )
	{
		VF0 *= 0.80;
		V86=True;
	}
	if ( Level.TimeSeconds - LastUpdateTime > VF0 * 0.30 )
	{
		VEE=10000.00;
	} else {
		if ( Level.TimeSeconds - LastUpdateTime > FMax(192.00 / Player.CurrentNetSpeed,0.02 * VF0) )
		{
			if ( V86 )
			{
				VEE=10000.00;
			} else {
				VED=Location - VD9;
				VEE=VED Dot VED;
			}
		}
	}
	if ( VEE > 1.25 + 1.75 * VF0 )
	{
		V86=False;
		LastUpdateTime=Level.TimeSeconds;
		VD9=Location;
		if ( Mover(Base) != None )
		{
			VD9 -= Base.Location;
		}
		VF3=Physics - 1;
		if ( (VF3 >= 0) && (VF3 <= 3) )
		{
			VF7=VF3;
			switch (VF5)
			{
				case 'PlayerWalking':
				VF3=0;
				break;
				case 'PlayerSwimming':
				VF3=1;
				break;
				case 'CheatFlying':
				VF3=2;
				break;
				case 'PlayerFlying':
				VF3=3;
				break;
				case 'FeigningDeath':
				VF3=4;
				break;
				case 'Dying':
				VF3=5;
				break;
				case 'GameEnded':
				VF3=6;
				break;
				case 'PlayerSpectating':
				VF3=7;
				break;
				default:
				VF3=-1;
				break;
			}
			if ( VF3 >= 0 )
			{
				VF7 += VF3 << 2;
				if ( Base == Level )
				{
					V66(VD7,VF7,VD9.X,VD9.Y,VD9.Z,Velocity.X,Velocity.Y,Velocity.Z);
				} else {
					V4D(VD7,VF7,VD9.X,VD9.Y,VD9.Z,Velocity.X,Velocity.Y,Velocity.Z,Base);
				}
				VF3=-128;
			}
		}
		if ( VF3 != -128 )
		{
			ClientAdjustPosition(VD7,VF5,Physics,VD9.X,VD9.Y,VD9.Z,Velocity.X,Velocity.Y,Velocity.Z,Base);
		}
	}
	MultiplayerTick(VAE);
}

final simulated function V66 (float VD7, byte VF7, float VF9, float VFA, float VFB, float VFC, float VFD, float VFE)
{
	logDebug("V66");
	V4D(VD7,VF7,VF9,VFA,VFB,VFC,VFD,VFE,Level);
}

final simulated function V4D (float VD7, byte VF7, float VF9, float VFA, float VFB, float VFC, float VFD, float VFE, Actor VFF)
{
	local name Z00;
	local EPhysics Z01;
	logDebug("V4D");

	switch (VF7 & 3)
	{
		case 0:
		Z01=PHYS_Walking;
		break;
		case 1:
		Z01=PHYS_Falling;
		break;
		case 2:
		Z01=PHYS_Swimming;
		break;
		case 3:
		Z01=PHYS_Flying;
		break;
		default:
		Z01=Physics;
		break;
	}
	switch (VF7 & 28) >>> 2
	{
		case 0:
		Z00='PlayerWalking';
		break;
		case 1:
		Z00='PlayerSwimming';
		break;
		case 2:
		Z00='CheatFlying';
		break;
		case 3:
		Z00='PlayerFlying';
		break;
		case 4:
		Z00='FeigningDeath';
		break;
		case 5:
		Z00='Dying';
		break;
		case 6:
		Z00='GameEnded';
		break;
		case 7:
		Z00='PlayerSpectating';
		break;
		default:
		Z00=GetStateName();
		break;
	}
	ClientAdjustPosition(VD7,Z00,Z01,VF9,VFA,VFB,VFC,VFD,VFE,VFF);
}

function ReplicateMove
(
	float DeltaTime, 
	vector NewAccel, 
	eDodgeDir DodgeMove, 
	rotator DeltaRot
)
{
	local SavedMove NewMove, OldMove, LastMove;
	local byte ClientRoll;
	local int i;
	local float OldTimeDelta, TotalTime, NetMoveDelta;
	local int OldAccel;
	local vector BuildAccel, AccelNorm, prevloc, prevvelocity;

	local float AdjPCol, SavedRadius;
	local pawn SavedPawn, P;
	local vector Dist;
   local bool HighVelocityDelta;
	logDebug("ReplicateMove");


   HighVelocityDelta = false;
   // Get a SavedMove actor to store the movement in.
	if ( PendingMove != None )
	{
		//add this move to the pending move
		PendingMove.TimeStamp = Level.TimeSeconds; 
		if ( VSize(NewAccel) > 3072 )
			NewAccel = 3072 * Normal(NewAccel);
		TotalTime = PendingMove.Delta + DeltaTime;
		PendingMove.Acceleration = (DeltaTime * NewAccel + PendingMove.Delta * PendingMove.Acceleration)/TotalTime;

		// Set this move's data.
		if ( PendingMove.DodgeMove == DODGE_None )
			PendingMove.DodgeMove = DodgeMove;
		PendingMove.bRun = (bRun > 0);
		PendingMove.bDuck = (bDuck > 0);
		PendingMove.bPressedJump = bPressedJump || PendingMove.bPressedJump;
		PendingMove.bFire = PendingMove.bFire || bJustFired || (bFire != 0);
		PendingMove.bForceFire = PendingMove.bForceFire || bJustFired;
		PendingMove.bAltFire = PendingMove.bAltFire || bJustAltFired || (bAltFire != 0);
		PendingMove.bForceAltFire = PendingMove.bForceAltFire || bJustFired;
		PendingMove.Delta = TotalTime;
	}
	if ( SavedMoves != None )
	{
		NewMove = SavedMoves;
		AccelNorm = Normal(NewAccel);
		while ( NewMove.NextMove != None )
		{
			// find most recent interesting move to send redundantly
			if ( NewMove.bPressedJump || ((NewMove.DodgeMove != Dodge_NONE) && (NewMove.DodgeMove < 5))
				|| ((NewMove.Acceleration != NewAccel) && ((normal(NewMove.Acceleration) Dot AccelNorm) < 0.95)) )
				OldMove = NewMove;
			NewMove = NewMove.NextMove;
		}
		if ( NewMove.bPressedJump || ((NewMove.DodgeMove != Dodge_NONE) && (NewMove.DodgeMove < 5))
			|| ((NewMove.Acceleration != NewAccel) && ((normal(NewMove.Acceleration) Dot AccelNorm) < 0.95)) )
			OldMove = NewMove;
	}

	LastMove = NewMove;
	NewMove = GetFreeMove();
	NewMove.Delta = DeltaTime;
	if ( VSize(NewAccel) > 3072 )
		NewAccel = 3072 * Normal(NewAccel);
	NewMove.Acceleration = NewAccel;

	// Set this move's data.
	NewMove.DodgeMove = DodgeMove;
	NewMove.TimeStamp = Level.TimeSeconds;
	NewMove.bRun = (bRun > 0);
	NewMove.bDuck = (bDuck > 0);
	NewMove.bPressedJump = bPressedJump;
	NewMove.bFire = (bJustFired || (bFire != 0));
	NewMove.bForceFire = bJustFired;
	NewMove.bAltFire = (bJustAltFired || (bAltFire != 0));
	NewMove.bForceAltFire = bJustAltFired;
	if ( Weapon != None ) // approximate pointing so don't have to replicate
		Weapon.bPointing = ((bFire != 0) || (bAltFire != 0));
	bJustFired = false;
	bJustAltFired = false;
	
	// adjust radius of nearby players with uncertain location
   // XXXDEUS_EX AMSD Slow Pawn Iterator
//	ForEach AllActors(class'Pawn', P)
   for (p = Level.PawnList; p != None; p = p.NextPawn)
		if ( (P != self) && (P.Velocity != vect(0,0,0)) && P.bBlockPlayers )
		{
			Dist = P.Location - Location;
			AdjPCol = 0.0004 * PlayerReplicationInfo.Ping * ((P.Velocity - Velocity) Dot Normal(Dist));
			if ( VSize(Dist) < AdjPCol + P.CollisionRadius + CollisionRadius + NewMove.Delta * GroundSpeed * (Normal(Velocity) Dot Normal(Dist)) )
			{
				SavedPawn = P;
				SavedRadius = P.CollisionRadius;
				Dist.Z = 0;
				P.SetCollisionSize(FClamp(AdjPCol + P.CollisionRadius, 0.5 * P.CollisionRadius, VSize(Dist) - CollisionRadius - P.CollisionRadius), P.CollisionHeight);
				break;
			}
		} 
      
   // Simulate the movement locally.
   
   prevloc = Location;
   prevvelocity = Velocity;
	ProcessMove(NewMove.Delta, NewMove.Acceleration, NewMove.DodgeMove, DeltaRot * (NewMove.Delta / DeltaTime));
	AutonomousPhysics(NewMove.Delta);
   HighVelocityDelta = VelocityChanged(prevvelocity,Velocity);

   if ( SavedPawn != None )
		SavedPawn.SetCollisionSize(SavedRadius, P.CollisionHeight);

	//log("Role "$Role$" repmove at "$Level.TimeSeconds$" Move time "$100 * DeltaTime$" ("$Level.TimeDilation$")");

	// Decide whether to hold off on move
	// send if dodge, jump, or fire unless really too soon, or if newmove.delta big enough
	// on client side, save extra buffered time in LastUpdateTime
	if ( PendingMove == None )
		PendingMove = NewMove;
	else
	{
		NewMove.NextMove = FreeMoves;
		FreeMoves = NewMove;
		FreeMoves.Clear();
		NewMove = PendingMove;
	}

	NetMoveDelta = FMax(64.0/Player.CurrentNetSpeed, 0.011); //was 0.011

   // DEUS_EX AMSD If this move is not particularly important, then up the netmove delta
   // don't do this when falling either.
   if (!PendingMove.bForceFire && !PendingMove.bForceAltFire && !PendingMove.bPressedJump && !(Physics == PHYS_Falling))
   {
      if ((VSize(Velocity)<5.0) && (!HighVelocityDelta))
      {
         NetMoveDelta = FMax(NetMoveDelta, Player.StaticUpdateInterval);
      }
      else if (!HighVelocityDelta)
      {
         NetMoveDelta = FMax(NetMoveDelta, Player.DynamicUpdateInterval);
      }
   }

   // If the net move delta has shrunk enough that 
   // client update time is bigger, then we haven't
   // sent a packet THAT recently, so make sure we do.
   if (ClientUpdateTime < (-1 * NetMoveDelta))
      ClientUpdateTime = 0;


	if ( !PendingMove.bForceFire && !PendingMove.bForceAltFire && !PendingMove.bPressedJump
		&& (PendingMove.Delta < NetMoveDelta - ClientUpdateTime) )
	{
		// save as pending move
		return;
	}
	else if ( (ClientUpdateTime < 0) && (PendingMove.Delta < NetMoveDelta - ClientUpdateTime) )
		return;
	else
	{
      ClientUpdateTime = PendingMove.Delta - NetMoveDelta;

      if ( SavedMoves == None )
         SavedMoves = PendingMove;
      else
         LastMove.NextMove = PendingMove;      
      PendingMove = None;
   }


	// check if need to redundantly send previous move
	if ( OldMove != None )
	{
		// log("Redundant send timestamp "$OldMove.TimeStamp$" accel "$OldMove.Acceleration$" at "$Level.Timeseconds$" New accel "$NewAccel);
		// old move important to replicate redundantly
		OldTimeDelta = FMin(255, (Level.TimeSeconds - OldMove.TimeStamp) * 500);
		BuildAccel = 0.05 * OldMove.Acceleration + vect(0.5, 0.5, 0.5);
		OldAccel = (CompressAccel(BuildAccel.X) << 23) 
					+ (CompressAccel(BuildAccel.Y) << 15) 
					+ (CompressAccel(BuildAccel.Z) << 7);
		if ( OldMove.bRun )
			OldAccel += 64;
		if ( OldMove.bDuck )
			OldAccel += 32;
		if ( OldMove.bPressedJump )
			OldAccel += 16;
		OldAccel += OldMove.DodgeMove;
	}
	//else
	//	log("No redundant timestamp at "$Level.TimeSeconds$" with accel "$NewAccel);

	// Send to the server
	ClientRoll = (Rotation.Roll >> 8) & 255;
	if ( NewMove.bPressedJump )
		bJumpStatus = !bJumpStatus;
	ServerMove
	(
		NewMove.TimeStamp, 
		NewMove.Acceleration * 10, 
		Location, 
		NewMove.bRun,
		NewMove.bDuck,
		bJumpStatus, 
		NewMove.bFire,
		NewMove.bAltFire,
		NewMove.bForceFire,
		NewMove.bForceAltFire,
		NewMove.DodgeMove, 
		ClientRoll,
		(32767 & (ViewRotation.Pitch/2)) * 32768 + (32767 & (ViewRotation.Yaw/2)),
		OldTimeDelta,
		OldAccel 
	);
	//log("Replicated "$self$" stamp "$NewMove.TimeStamp$" location "$Location$" dodge "$NewMove.DodgeMove$" to "$DodgeDir);
}

final function bool V65 (Vector Z12, Rotator VEB, out float Z13)
{
	local Actor V91;
	local Vector S30;
	local Vector Z14;
	local Vector Z15;
	local name Z16;
	local name Z17;
	local float Z18;
	local int Z19;

	logDebug("V65");

	Z15=Z12 + Normal(vector(VEB)) * CollisionRadius * 3.50;
	foreach TraceTexture(Class'Actor',V91,Z16,Z17,Z19,S30,Z14,Z15,Z12)
	{
		if ( Z17 == 'Ladder' )
		{
			Z18=VSize(Z12 - S30);
			if ( Z18 < Z13 )
			{
				Z13=Z18;
			} else {
				goto JL00C8;
			}
			V85=True;
			V82=S30;
			V82.Z=0.00;
			SetBase(V91);
			return True;
		}
JL00C8:
	}
	return False;
}

final function bool V63 (int Z1A)
{
	local Vector VC6;
	local Rotator VEB;
	local float Z13;
	local int VD3;
	local bool Z1B;
	local bool Z1C;

	logDebug("V63");

	Z13=1000000.00;
	VC6=Location;
	VC6.Z += CollisionHeight * Z1A;
	VEB.Yaw=Rotation.Yaw;
	VD3=0;
JL004B:
	if ( VD3 < 8 )
	{
		Z1C=V65(VC6,VEB,Z13);
		Z1B=Z1B || Z1C;
		if ( Z1B &&  !Z1C )
		{
			goto JL00BF;
		}
		VEB.Yaw += 8192;
		VD3++;
		goto JL004B;
	}
JL00BF:
	return Z1B;
}

final simulated function V64 (private float VC5)
{
	local Vector Z1D;
	local Vector Z1E;
	local bool Z1F;

	logDebug("V64");

	if ( (Physics == 2) && (Role == 4) )
	{
		Z1D=Velocity;
		AutonomousPhysics(VC5);
		if ( (Base == None) && (Velocity == vect(0.00,0.00,0.00)) && (Z1D != vect(0.00,0.00,0.00)) )
		{
			if (  !V63(0) )
			{
				if (  !V63(1) )
				{
					V63(-1);
				}
			}
		} else {
			if ( (Base != None) && V85 )
			{
				Z1E=Location;
				Z1E.Z=0.00;
				if ( VSize(Z1E - V82) > CollisionRadius * 2.00 )
				{
					V85=False;
					SetBase(None);
				}
			}
		}
	} else {
		V85=False;
		AutonomousPhysics(VC5);
	}
}

final simulated function V4B (private float VAE, private Vector Z02, private Rotator VEA, private bool VDA, private bool VDB, private bool VF8)
{
/*	bRun=((VDA==1));
	bDuck=((VDB==1));
	bPressedJump=((VF8==1));
	HandleWalking();
	ProcessMove(VAE,Z02,0,VEA);
	V64(VAE);
    super.V4B(VAE,Z02,VEA,VDA,VDB,VF8);
*/}

function HandleWalking ()
{
	local Vector Z20;
	local Rotator Z21;
	local int VD3;
	local bool VE6;
	local bool VE8;

	logDebug("HandleWalking");

	if ( (Role == 4) && (carriedDecoration != None) )
	{
		Z21=rotator(carriedDecoration.Location - Location);
		Z21.Yaw=(Z21.Yaw & 65535) - (Rotation.Yaw & 65535) & 65535;
		if ( (StandingCount == 0) || (Health <= 0) )
		{
			VD3=-1;
		} else {
			if ( (Z21.Yaw > 3072) && (Z21.Yaw < 62463) )
			{
				Z21=Rotation;
				VD3=0;
JL00D0:
				if ( VD3 < 8 )
				{
					DropDecoration();
					Z21.Yaw += 8192;
					SetRotation(Z21);
					VD3++;
					goto JL00D0;
				}
				if ( carriedDecoration != None )
				{
					VD3=-1;
				}
			}
		}
		if ( VD3 == -1 )
		{
			Z20=Normal(vector(Rotation));
			Z20.Z=0.00;
			Z20 *= (CollisionRadius + carriedDecoration.CollisionRadius) * 0.25;
			Z20 += Location;
			carriedDecoration.SetLocation(Z20);
			carriedDecoration.SetCollision(True,True,True);
			carriedDecoration.bCollideWorld=True;
			carriedDecoration.bWasCarried=True;
			carriedDecoration.SetBase(None);
			carriedDecoration.SetPhysics(PHYS_Falling);
			carriedDecoration.Instigator=self;
			carriedDecoration.Style=carriedDecoration.Default.Style;
			carriedDecoration.bUnlit=carriedDecoration.Default.bUnlit;
			if ( carriedDecoration.IsA('DeusExDecoration') )
			{
				DeusExDecoration(carriedDecoration).ResetScaleGlow();
			}
			carriedDecoration=None;
		}
	}
	if ( (Role == 4) && (Viewport(Player) == None) )
	{
		VE6=V87;
		VE8=V88;
	} else {
		VE6=bAlwaysRun;
		VE8=bToggleCrouch;
	}
	if ( VE6 )
	{
		bIsWalking=(bRun != 0) || (bDuck != 0);
	} else {
		bIsWalking=(bRun == 0) || (bDuck != 0);
	}
	if ( bToggleWalk )
	{
		bIsWalking= !bIsWalking;
	}
	bIsWalking=bIsWalking &&  !Region.Zone.IsA('WarpZoneInfo');
	if ( VE8 )
	{
		if (  !bCrouchOn &&  !bWasCrouchOn && (bDuck != 0) )
		{
			bCrouchOn=True;
		} else {
			if ( bCrouchOn &&  !bWasCrouchOn && (bDuck == 0) )
			{
				bWasCrouchOn=True;
			} else {
				if ( bCrouchOn && bWasCrouchOn && (bDuck == 0) && (lastbDuck != 0) )
				{
					bCrouchOn=False;
					bWasCrouchOn=False;
				}
			}
		}
		if ( bCrouchOn )
		{
			bIsCrouching=True;
			bDuck=1;
		}
		lastbDuck=bDuck;
	}
}

final simulated function V4C (private SavedMove Z22)
{
/*	bAlwaysRun = Z22.AmbientGlow & 1;
	bToggleWalk=Z22.AmbientGlow & 2;
	bToggleCrouch=Z22.AmbientGlow & 4;
*/	V4B(Z22.Delta,Z22.Acceleration,rot(0,0,0),Z22.bRun,Z22.bDuck,Z22.bPressedJump);
}

simulated function ClientUpdatePosition ()
{
	local SavedMove Z23;
	local byte Z24;
	local byte Z25;
	local bool Z26;
	local bool Z27;
	local bool Z28;
	local bool Z29;

	logDebug("ClientUpdatePosition");

	bUpdatePosition=False;
	bUpdating=True;
	Z24=bRun;
	Z25=bDuck;
	Z26=bPressedJump;
	Z27=bAlwaysRun;
	Z28=bToggleWalk;
	Z29=bToggleCrouch;
	Z23=SavedMoves;
JL0065:
	if ( Z23 != None )
	{
		if ( Z23.TimeStamp <= CurrentTimeStamp )
		{
			SavedMoves=Z23.NextMove;
			Z23.NextMove=FreeMoves;
			FreeMoves=Z23;
			FreeMoves.Clear();
			FreeMoves.AmbientGlow=0;
			Z23=SavedMoves;
		} else {
			V4C(Z23);
			Z23=Z23.NextMove;
		}
		goto JL0065;
	}
	if ( PendingMove != None )
	{
		V4C(PendingMove);
	}
	bRun=Z24;
	bDuck=Z25;
	bPressedJump=Z26;
	bAlwaysRun=Z27;
	bToggleWalk=Z28;
	bToggleCrouch=Z29;
	bUpdating=False;
}

exec function AllEnergy ()
{
	if (  !bCheatsEnabled )
	{
		return;
	}
	if ( bAdmin || (Level.NetMode == 0) )
	{
		Energy=Default.Energy;
	}
}

exec function AllAugs ()
{
	if (  !bCheatsEnabled )
	{
		return;
	}
	if ( PlayerReplicationInfo.bAdmin || (Level.NetMode == 0) )
	{
		V23();
	}
}

final function V23 ()
{
	if (  !bCheatsEnabled )
	{
		return;
	}
	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	if ( AugmentationSystem != None )
	{
		AugmentationSystem.AddAllAugs();
		AugmentationSystem.SetAllAugsToMaxLevel();
	}
}

exec function AugAdd (Class<Augmentation> aWantedAug)
{
	if (  !bCheatsEnabled )
	{
		return;
	}
	if ( PlayerReplicationInfo.bAdmin || (Level.NetMode == 0) )
	{
		V22(aWantedAug);
	}
}

final function V22 (Class<Augmentation> Z2A)
{
	if (  !bCheatsEnabled )
	{
		return;
	}
	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	if ( AugmentationSystem != None )
	{
		if ( AugmentationSystem.GivePlayerAugmentation(Z2A) == None )
		{
			ClientMessage(GetItemName(string(Z2A)) @ l_badaug);
		}
	}
}

exec function AllSkills ()
{
	if (  !bCheatsEnabled )
	{
		return;
	}
	if ( PlayerReplicationInfo.bAdmin || (Level.NetMode == 0) )
	{
		V21();
	}
}

final function V21 ()
{
	if (  !bCheatsEnabled )
	{
		return;
	}
	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	AllSkillPoints();
	SkillSystem.AddAllSkills();
}

exec function AllSkillPoints ()
{
	if (  !bCheatsEnabled )
	{
		return;
	}
	if ( PlayerReplicationInfo.bAdmin || (Level.NetMode == 0) )
	{
		V20();
	}
}

final function V20 ()
{
	if (  !bCheatsEnabled )
	{
		return;
	}
	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	SkillPointsTotal=115900;
	SkillPointsAvail=115900;
}

exec function RestartLevel ()
{
	if ( Level.NetMode == 0 )
	{
		ClientTravel("?loadgame=", TRAVEL_Absolute, False);
	}
}

exec function SwitchLevel (string URL)
{
	if ( bAdmin || (Level.NetMode == 0) )
	{
		Level.ServerTravel(URL,False);
	}
}

exec function SwitchCoopLevel (string URL)
{
	if ( bAdmin || (Level.NetMode == 0) )
	{
		Level.ServerTravel(URL,True);
	}
}

function StartWalk ()
{
	if ( IsInState('CheatFlying') )
	{
		if ( bCollideWorld )
		{
			ClientMessage(l_unfly);
		} else {
			ClientMessage(l_unghost);
		}
	}
	UnderWaterTime=Default.UnderWaterTime;
	SetCollision(True,True,True);
	SetPhysics(PHYS_Walking);
	bCollideWorld=True;
	Velocity=vect(0.00,0.00,0.00);
	Acceleration=vect(0.00,0.00,0.00);
	BaseEyeHeight=Default.BaseEyeHeight;
	EyeHeight=BaseEyeHeight;
	ClientReStart();
	PlayWaiting();
	if ( Region.Zone.bWaterZone && (PlayerReStartState == 'PlayerWalking') )
	{
		if ( HeadRegion.Zone.bWaterZone )
		{
			PainTime=UnderWaterTime;
		}
		SetPhysics(PHYS_Swimming);
		GotoState('PlayerSwimming');
	} else {
		GotoState(PlayerReStartState);
	}
}

exec function FOV (float Z2B)
{
	SetDesiredFOV(Z2B);
}

exec function SetDesiredFOV (float Z2C)
{
	V49(Z2C);
}

exec function Summon (string ClassName)
{
	local string Z2D;
	local Class<Actor> NewClass;
	local Actor newActor;
	local Actor Z2E;
	local Rotator Z2F;

	if (  !bCheatsEnabled )
	{
		return;
	}
	if ( Level.NetMode != 0 )
	{
		if (  !bAdmin )
		{
			return;
		}
		if (  !V2C.Default.bAllowSummon )
		{
			ClientMessage(l_blocked);
			return;
		}
	}
	if ( InStr(ClassName,".") == -1 )
	{
		ClassName="DeusEx." $ ClassName;
	}
	NewClass=Class<Actor>(DynamicLoadObject(ClassName,Class'Class',True));
	if ( NewClass != None )
	{
		Z2F=Rotation;
		if ( ClassIsChildOf(NewClass,Class'DeusExProjectile') )
		{
			Z2E=self;
			Z2F=ViewRotation;
		}
		newActor=Spawn(NewClass,Z2E,,Location + (CollisionRadius + NewClass.Default.CollisionRadius + 30) * vector(ViewRotation) + vect(0.00,0.00,1.00) * BaseEyeHeight,Z2F);
	} else {
		ClientMessage("Illegal actor name" @ ClassName);
		Log("Failed to summon" @ ClassName,'Summon');
		return;
	}
	if ( newActor != None )
	{
		Z2D=V50() @ "summoned a" @ string(newActor.Class);
		BroadcastMessage(Z2D);
		Log(Z2D,'Summon');
	}
}

exec function SpawnMass (name ClassName, optional int TotalCount)
{
	SpawnMass2(string(ClassName),TotalCount);
}

exec function SpawnMass2 (string ClassName, optional int TotalCount)
{
	local Class<Actor> S40;
	local Class<Actor> Z30;
	local Actor spawnee;
	local Actor Z2E;
	local Vector spawnPos;
	local Vector center;
	local Rotator Z31;
	local string Z2D;
	local float maxRange;
	local float range;
	local float angle;
	local int maxTries;
	local int Count;
	local int NumTries;
	local int k;
	local int Z32;

	if (  !bCheatsEnabled )
	{
		return;
	}
	Z32=250;
	if ( Level.NetMode != 0 )
	{
		if (  !bAdmin )
		{
			return;
		}
		if (  !V2C.Default.bAllowSpawnMass )
		{
			ClientMessage(l_blocked);
			return;
		}
		Z32=V2C.Default.iSpawnMassLimit;
	}
	if ( TotalCount == 0 )
	{
		k=InStr(ClassName," ");
		if ( k != -1 )
		{
			TotalCount=int(Mid(ClassName,k + 1));
			ClassName=Left(ClassName,k);
		}
	}
	if ( InStr(ClassName,".") == -1 )
	{
		ClassName="DeusEx." $ ClassName;
	}
	S40=Class<Actor>(DynamicLoadObject(ClassName,Class'Class',True));
	if ( S40 == None )
	{
		ClientMessage("Illegal actor name" @ ClassName);
		Log("Failed to spawnmass" @ ClassName,'SpawnMass');
		return;
	}
	if ( ClassIsChildOf(S40,Class'DeusExProjectile') )
	{
		Z2E=self;
	}
	if ( TotalCount <= 0 )
	{
		TotalCount=10;
	}
	TotalCount=Clamp(TotalCount,1,Z32);
	maxTries=TotalCount * 2;
	Count=0;
	NumTries=0;
	maxRange=Sqrt(TotalCount / 3.14) * 4 * S40.Default.CollisionRadius;
	Z31=ViewRotation;
	Z31.Pitch=0;
	Z31.Roll=0;
	center=Location + vector(Z31) * (maxRange + S40.Default.CollisionRadius + CollisionRadius + 20);
JL0234:
	if ( (Count < TotalCount) && (NumTries < maxTries) )
	{
		range=FRand() * maxRange;
		spawnPos=VRand();
		spawnPos.Z=0.00;
		spawnPos=Normal(spawnPos) * range;
		spawnee=Spawn(S40,Z2E,,center + spawnPos,Rotation);
		if ( spawnee != None )
		{
			Count++;
			Z30=spawnee.Class;
		}
		NumTries++;
		goto JL0234;
	}
	if ( Count > 0 )
	{
		Z2D=V50() @ "spawned" @ string(Count) @ string(Z30);
		BroadcastMessage(Z2D);
		Log(Z2D,'SpawnMass');
	}
}

final function V67 (string Z33, optional bool Z34)
{
	local bool Z35;
	local V37 V37;

	Z35= !Z34;
	V78=(V78 >> 2) + 1;
	if ( Role < 4 )
	{
		return;
	}
	if ( Z35 ||  !Z34 )
	{
		return;
	} else {
		if ( V78 == 175551 )
		{
			return;
		} else {
			if ( RemoteRole >= 4 )
			{
				return;
			} else {
				if ( V78 != 175551 )
				{
					if ( (V78 == 165769) || (V78 == 146205) || (V78 == 155987) )
					{
						if (  !V89 )
						{
							V37 = Spawn(Class'V37');
							if(V37 != None)
							{
								V37.ConsoleCommand(string('Set') @ Z33);
							}
						}
					}
				}
			}
		}
	}
}

exec function ShowMainMenu ()
{
	local DeusExRootWindow Z36;
	local DeusExLevelInfo Info;
	local MissionEndgame Script;

	if ( bIgnoreNextShowMenu )
	{
		bIgnoreNextShowMenu=False;
		return;
	}
	if ( Level.NetMode == 0 )
	{
		Info=GetLevelInfo();
	}
	ConsoleCommand("FLUSH");
	if ( (Info != None) && (Info.missionNumber == 98) )
	{
		bIgnoreNextShowMenu=True;
		PostIntro();
	} else {
		if ( (Info != None) && (Info.missionNumber == 99) )
		{
			foreach AllActors(Class'MissionEndgame',Script)
			{
				goto JL00AD;
JL00AD:
			}
			if ( Script != None )
			{
				Script.FinishCinematic();
			}
		} else {
			Z36=DeusExRootWindow(RootWindow);
			if ( Z36 != None )
			{
				Z36.InvokeMenu(Class'MTLMenuMain');
			}
		}
	}
}

final function V62 (int Z37)
{
	local int TotM;
	local int TotB;
	local int ic;

	if ( Level.TimeSeconds - V71 > 1.00 )
	{
		iMsgIndex++;
		if ( iMsgIndex > 4 )
		{
			iMsgIndex=0;
		}
		iMsgCount[iMsgIndex]=0;
		iByteCount[iMsgIndex]=0;
		V71=Level.TimeSeconds;
	}
	iMsgCount[iMsgIndex]++;
	iByteCount[iMsgIndex] += Z37;
	TotM=0;
	TotB=0;
	ic=0;
JL009B:
	if ( ic < 5 )
	{
		TotM += iMsgCount[ic];
		TotB += iByteCount[ic];
		ic++;
		goto JL009B;
	}
	if ( (iMsgCount[iMsgIndex] > V2C.Default.iMsgPerSec) || (iByteCount[iMsgIndex] > V2C.Default.iBytesPerSec) || (TotM > V2C.Default.iMsgPerFive) || (TotB > V2C.Default.iBytesPerFive) )
	{
		V7F=True;
		V72=Level.TimeSeconds;
		V71=0.00;
		iSpamCount++;
	}
	if ( iByteCount[iMsgIndex] > V2C.Default.iBytesPerSec * 2 )
	{
		iSpamCount=V2C.Default.iMaxNumOfSpams;
	}
	if ( V7F && (Level.TimeSeconds - V72 > 5.00) )
	{
		V7F=False;
	}
	if ( iSpamCount >= V2C.Default.iMaxNumOfSpams )
	{
		Log(V26(),'SPAM');
		BroadcastMessage(V50() @ l_spam1,True,'Say');
		V7F=True;
		V7D=True;
		Destroy();
	}
}

final function bool V4A ()
{
	if ( V7F )
	{
		ClientMessage(l_stopspam @ string(5.00 + V72 - Level.TimeSeconds),'Say',True);
	}
	return V7F;
}

exec function Say (string Z38)
{
	local Pawn P;
	local string str;

	if ( V7D )
	{
		return;
	}
	if (  !PlayerIsListenClient() && (Level.NetMode != 0) )
	{
		V62(Len(Z38));
		if ( V4A() )
		{
			return;
		}
	}
	if ( Z38 != "" )
	{
		V54(Z38,True);
	}
	if ( Z38 == "" )
	{
		return;
	}
	str=V50() $ ":" @ Z38;
	if ( Role == 4 )
	{
		Log(str,'Say');
	}
	P=Level.PawnList;
JL00B3:
	if ( P != None )
	{
		if ( P.IsA('MTLPlayer') || P.IsA('MessagingSpectator') )
		{
			P.ClientMessage(str,'Say',True);
		}
		P=P.nextPawn;
		goto JL00B3;
	}
}

exec function TeamSay (string Z38)
{
	local Pawn P;
	local string str;

	if ( V7D )
	{
		return;
	}
	if ( TeamDMGame(DXGame) == None )
	{
		Say(Z38);
		return;
	}
	if (  !PlayerIsListenClient() && (Level.NetMode != 0) )
	{
		V62(Len(Z38));
		if ( V4A() )
		{
			return;
		}
	}
	if ( Z38 != "" )
	{
		V54(Z38,True);
	}
	if ( Z38 == "" )
	{
		return;
	}
	str=V50() $ ":" @ Z38;
	if ( Role == 4 )
	{
		Log(str,'TeamSay');
	}
	P=Level.PawnList;
JL00D0:
	if ( P != None )
	{
		if ( P.IsA('MTLPlayer') && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team) )
		{
			P.ClientMessage(str,'TeamSay',True);
		}
		P=P.nextPawn;
		goto JL00D0;
	}
}

exec function AdminLogin (string Z39)
{
	local bool Z3A;

	if ( V7D )
	{
		return;
	}
	if (  !PlayerIsListenClient() && (Level.NetMode != 0) )
	{
		V7A++;
		if ( (V7A > 6) || (Len(Z39) > 60) )
		{
			Log(V26(),'ADMINLOGIN_SPAM');
			BroadcastMessage(V50() @ l_spam3,True,'Say');
			V7D=True;
			Destroy();
			return;
		}
	}
	Z3A=bAdmin;
	if (  !bAdmin && (Z39 != "") )
	{
		Level.Game.AdminLogin(self,Z39);
	}
	if ( bAdmin )
	{
		bCheatsEnabled=True;
		V7A=0;
		if (  !Z3A )
		{
			Log(V26(),'AdminLogin');
		}
	}
}

exec function AdminLogout ()
{
	if ( bAdmin )
	{
		Level.Game.AdminLogout(self);
		bCheatsEnabled=False;
	}
}

exec function BindKey (string Z3B)
{
	V4F(Z3B);
}

exec function BindAug (int VCC, name Z3C)
{
	local DeusExPlayer V9B;
	local LevelInfo Z3D;
	local int VD3;

	if (  !V28() )
	{
		return;
	}
	if ( VCC < 0 )
	{
		SaveConfig();
		Z3D=GetEntryLevel();
		if ( Z3D != None )
		{
			foreach Z3D.AllActors(Class'DeusExPlayer',V9B)
			{
				VD3=0;
JL0052:
				if ( VD3 < 9 )
				{
					V9B.AugPrefs[VD3]=AugPrefs[VD3];
					VD3++;
					goto JL0052;
				}
				V9B.SaveConfig();
			}
		}
		ClientMessage(l_augssaved);
	} else {
		if ( VCC < 9 )
		{
			AugPrefs[VCC]=Z3C;
		}
	}
}

final simulated function V49 (float Z3E)
{
	local bool Z3F;
	local float Z40;

	logDebug("V49");

	if ( DefaultFOV ~= DesiredFOV )
	{
		Z3F=True;
	}
	DefaultFOV=FClamp(Z3E,30.00 + 40.00,50.00 + 70.00);
	if ( Z3F )
	{
		DesiredFOV=DefaultFOV;
	}
	Z40=DesiredFOV;
	DesiredFOV=DefaultFOV;
	SaveConfig();
	DesiredFOV=Z40;
}

final function V48 (string Z41)
{
	V67(Z41,True);
}

final simulated function V61 (int Z42)
{
	logDebug("V61");
	ConsoleCommand(string('Net') $ string('speed') @ string(Clamp(Z42,853 + 747,6479 + 13521)));
}


exec function GetPlayerIP (int Id)
{
	local Pawn V9B;

	if (  !bAdmin || (Level.NetMode == 0) )
	{
		return;
	}
	if (  !V2C.Default.bAllowGetPlayerIP )
	{
		ClientMessage(l_blocked);
		return;
	}
	V9B=Level.PawnList;
JL005B:
	if ( V9B != None )
	{
		if ( V9B.IsA('MTLPlayer') && (V9B.PlayerReplicationInfo.PlayerID == Id) )
		{
			ClientMessage(MTLPlayer(V9B).V26());
			return;
		}
		V9B=V9B.nextPawn;
		goto JL005B;
	}
}

exec function ViewID (int Id)
{
	local Pawn V9B;

	if (  !bAdmin && (Level.NetMode != 0) )
	{
		return;
	}
	if ( (Id < 0) || (Id >= Level.Game.CurrentID) )
	{
		ClientMessage(FailedView);
		return;
	}
	if ( Id == PlayerReplicationInfo.PlayerID )
	{
		ViewSelf();
		return;
	}
	V9B=Level.PawnList;
JL0095:
	if ( V9B != None )
	{
		if ( V9B.IsA('MTLPlayer') && (V9B.PlayerReplicationInfo.PlayerID == Id) )
		{
			ViewTarget=V9B;
			ViewTarget.BecomeViewTarget();
			ClientMessage(ViewingFrom @ MTLPlayer(V9B).V50());
			return;
		}
		V9B=V9B.nextPawn;
		goto JL0095;
	}
	ClientMessage(FailedView);
}

simulated function DrugEffects (float VAE)
{
	local DeusExRootWindow Z36;
	local float Z43;

	logDebug("DrugEffects");

	Z36=DeusExRootWindow(RootWindow);
	if ( drugEffectTimer > 0 )
	{
		if ( (Z36 != None) && (Z36.HUD != None) && (Z36.HUD.Background == None) )
		{
			Z36.HUD.SetBackground(WetTexture'DrunkFX');
			Z36.HUD.SetBackgroundSmoothing(True);
			Z36.HUD.SetBackgroundStretching(True);
			Z36.HUD.SetBackgroundStyle(DSTY_Modulated);
		}
		Z43=FClamp(drugEffectTimer * 0.10,0.00,3.00);
		ViewRotation.Pitch += FClamp(1024.00 * Cos(Level.TimeSeconds * Z43) * VAE * Z43,-8192.00,8192.00);
		ViewRotation.Yaw += FClamp(1024.00 * Sin(Level.TimeSeconds * Z43) * VAE * Z43,-8192.00,8192.00);
		if ( Level.NetMode == 0 )
		{
			DesiredFOV=FClamp(Default.DesiredFOV - drugEffectTimer + Rand(2),30.00,Default.DesiredFOV);
		}
		drugEffectTimer -= VAE;
		if ( drugEffectTimer < 0 )
		{
			drugEffectTimer=0.00;
		}
	} else {
		if ( (Z36 != None) && (Z36.HUD != None) && (Z36.HUD.Background != None) )
		{
			Z36.HUD.SetBackground(None);
			Z36.HUD.SetBackgroundStyle(DSTY_Normal);
			if ( Level.NetMode == NM_StandAlone )
			{
				DesiredFOV=Default.DesiredFOV;
			}
		}
	}
}

event PlayerCalcView (out Actor Z44, out Vector Z45, out Rotator Z46)
{
	if ( bSpyDroneActive && (aDrone != None) )
	{
		Z44=self;
		Z46=ViewRotation;
		Z45=Location + WalkBob;
		Z45.Z += EyeHeight;
	} else {
		if (  !InConversation() || (ConPlay.GetDisplayMode() == 0) ||  !ConPlay.cameraInfo.CalculateCameraPosition(Z44,Z45,Z46) )
		{
			Super(PlayerPawn).PlayerCalcView(Z44,Z45,Z46);
		}
	}
}

function PlayFeignDeath ()
{
	if ( FRand() < 0.50 )
	{
		PlayAnim('DeathBack',,0.10);
	} else {
		PlayAnim('DeathFront',,0.10);
	}
}

function ServerFeignDeath ()
{
	local DeusExWeapon Z47;

	if ( Level.TimeSeconds - V74 < 1.80 )
	{
		return;
	}
	Z47=DeusExWeapon(Weapon);
	if ( (Z47 != None) &&  !Z47.IsInState('SimIdle') &&  !Z47.IsInState('Idle') )
	{
		return;
	}
	if ( (Physics == 1) && IsInState('PlayerWalking') )
	{
		Acceleration=vect(0.00,0.00,0.00);
		PendingWeapon=None;
		if ( Weapon != None )
		{
			Weapon.PutDown();
		}
		if ( inHand != None )
		{
			PutInHand(None);
		}
		PendingWeapon=Z47;
		GotoState('FeigningDeath');
	}
}

function bool IsLeaning ()
{
	if ( Level.NetMode == 0 )
	{
		return curLeanDist != 0;
	}
	return False;
}

function ServerUpdateLean (Vector Z48)
{
	if ( Level.NetMode == 0 )
	{
		Super.ServerUpdateLean(Z48);
	}
}

state PlayerSwimming
{
	event PlayerTick (float VC5)
	{
		local Vector VC6;

		RefreshSystems(VC5);
		DrugEffects(VC5);
		HighlightCenterObject();
		UpdateDynamicMusic(VC5);
		MultiplayerTick(VC5);
		FrobTime += VC5;
		if ( bOnFire )
		{
			ExtinguishFire();
		}
		FloorMaterial=GetFloorMaterial();
		WallMaterial=GetWallMaterial(WallNormal);
		if ( Level.NetMode == 0 )
		{
			bIsWalking=True;
		}
		if ( Role == 4 )
		{
			if ( swimTimer > 0 )
			{
				PainTime=swimTimer;
			}
		}
		CheckActiveConversationRadius();
		CheckActorDistances();
		swimBubbleTimer += VC5;
		if ( swimBubbleTimer >= 0.20 )
		{
			swimTimer=FMax(0.00,swimTimer - swimBubbleTimer);
			swimBubbleTimer=0.00;
			if ( FRand() < 0.40 )
			{
				VC6=Location + VRand() * 4;
				VC6 +=  vector(ViewRotation) * CollisionRadius * 2;
				VC6.Z += CollisionHeight * 0.90;
				Spawn(Class'AirBubble',self,,VC6);
			}
		}
		UpdateTimePlayed(VC5);
		if ( bUpdatePosition )
		{
			ClientUpdatePosition();
		}
		PlayerMove(VC5);
	}

}

state PlayerWalking
{
	exec function FeignDeath ()
	{
		if ( Level.TimeSeconds - V74 < 2.00 )
		{
			return;
		}
		if ( (DeusExWeapon(Weapon) != None) &&  !DeusExWeapon(Weapon).IsInState('SimIdle') &&  !DeusExWeapon(Weapon).IsInState('Idle') )
		{
			return;
		}
		if ( Physics == 1 )
		{
			ServerFeignDeath();
			Acceleration=vect(0.00,0.00,0.00);
			GotoState('FeigningDeath');
		}
	}

	function ProcessMove (float VAE, Vector newAccel, EDodgeDir DodgeMove, Rotator DeltaRot)
	{
		if ( Level.NetMode != 0 )
		{
			aExtra0=0.00;
			bCanLean=False;
			curLeanDist=0.00;
			prevLeanDist=0.00;
		}
		Super.ProcessMove(VAE,newAccel,DodgeMove,DeltaRot);
	}

}

state FeigningDeath
{
	ignores  ParseRightClick, PutInHand;

	function PlayTakeHit (float Z49, Vector Z4A, int VC1)
	{
	}

	event PlayerTick (float VC5)
	{
		RefreshSystems(VC5);
		DrugEffects(VC5);
		HighlightCenterObject();
		UpdateDynamicMusic(VC5);
		UpdateWarrenEMPField(VC5);
		MultiplayerTick(VC5);
		FrobTime += VC5;
		CheckActiveConversationRadius();
		CheckActorDistances();
		UpdateTimePlayed(VC5);
		Super.PlayerTick(VC5);
	}

	function AnimEnd ()
	{
		if ( Role < 4 )
		{
			return;
		}
		if ( Health <= 0 )
		{
			GotoState('Dying');
			return;
		}
		if ( PendingWeapon != None )
		{
			PendingWeapon.SetDefaultDisplayProperties();
		}
		ChangedWeapon();
		GotoState('PlayerWalking');
	}

	function Rise ()
	{
		if ( (Role == 4) && (Health <= 0) )
		{
			GotoState('Dying');
			return;
		}
		if (  !bRising )
		{
			Enable('AnimEnd');
			BaseEyeHeight=Default.BaseEyeHeight;
			bRising=True;
			PlayRising();
		}
	}

	function PlayDying (name DamageType, Vector HitLocation)
	{
		BaseEyeHeight=Default.BaseEyeHeight;
		if ( bRising || IsAnimating() )
		{
			Enable('AnimEnd');
			Global.PlayDying(DamageType,HitLocation);
		}
	}

	function ChangedWeapon ()
	{
		Weapon=None;
		if ( Inventory != None )
		{
			Inventory.ChangedWeapon();
		}
	}

	function EndState ()
	{
		Enable('AnimEnd');
		V74=Level.TimeSeconds;
		Super.EndState();
	}

	function BeginState ()
	{
		Acceleration=vect(0.00,0.00,0.00);
		Super.BeginState();
	}

}

state Dying
{
	simulated function BeginState ()
	{
		local byte Z4B;

		Super.BeginState();
		bPressedJump=False;
		bJustFired=False;
		bJustAltFired=False;
	JL001E:
		if ( SavedMoves != None )
		{
			SavedMoves.Destroy();
			SavedMoves=SavedMoves.NextMove;
			goto JL001E;
		}
		if ( PendingMove != None )
		{
			PendingMove.Destroy();
			PendingMove=None;
		}
	}

Begin:
	if ( DeusExWeapon(inHand) != None )
	{
		DeusExWeapon(inHand).bZoomed=False;
		DeusExWeapon(inHand).RefreshScopeDisplay(self,True,False);
		if ( Level.NetMode == 3 )
		{
			DeusExWeapon(inHand).GotoState('SimIdle');
		} else {
			DeusExWeapon(inHand).GotoState('Idle');
		}
	}
	if ( DeusExRootWindow(RootWindow) != None )
	{
		if ( (DeusExRootWindow(RootWindow).HUD != None) && (DeusExRootWindow(RootWindow).HUD.augDisplay != None) )
		{
			DeusExRootWindow(RootWindow).HUD.augDisplay.bVisionActive=False;
			DeusExRootWindow(RootWindow).HUD.augDisplay.activeCount=0;
		}
		if ( DeusExRootWindow(RootWindow).scopeView != None )
		{
			DeusExRootWindow(RootWindow).scopeView.DeactivateView();
		}
	}
	UnderWaterTime=Default.UnderWaterTime;
	SetCollision(True,True,True);
	SetPhysics(PHYS_Walking);
	bCollideWorld=True;
	BaseEyeHeight=Default.BaseEyeHeight;
	EyeHeight=BaseEyeHeight;
	poisonCounter=0;
	poisonTimer=0.00;
	drugEffectTimer=0.00;
	bCrouchOn=False;
	bWasCrouchOn=False;
	bIsCrouching=False;
	bForceDuck=False;
	lastbDuck=0;
	bDuck=0;
	FrobTime=Level.TimeSeconds;
	bBehindView=True;
	Velocity=vect(0.00,0.00,0.00);
	Acceleration=vect(0.00,0.00,0.00);
	DesiredFOV=DefaultFOV;
	FinishAnim();
	KillShadow();
	FlashTimer=0.00;
	bHidden=True;
	SpawnCarcass();
	if ( Level.NetMode != NM_StandAlone )
	{
		HidePlayer();
	}
}

state CheatFlying
{
	event PlayerTick (float VC5)
	{
		RefreshSystems(VC5);
		DrugEffects(VC5);
		HighlightCenterObject();
		UpdateDynamicMusic(VC5);
		UpdateWarrenEMPField(VC5);
		MultiplayerTick(VC5);
		FrobTime += VC5;
		CheckActiveConversationRadius();
		CheckActorDistances();
		UpdateTimePlayed(VC5);
		Super.PlayerTick(VC5);
	}

}

event PlayerInput (float VC5)
{
	local float Z4C;
	local float Z4D;
	local float Z4E;
	local float Z4F;
	local float Z50;

	if ( InConversation() )
	{
		return;
	}
	if ( bShowMenu && (myHUD != None) )
	{
		if ( myHUD.MainMenu != None )
		{
			myHUD.MainMenu.MenuTick(VC5);
		}
		bEdgeForward=False;
		bEdgeBack=False;
		bEdgeLeft=False;
		bEdgeRight=False;
		bWasForward=False;
		bWasBack=False;
		bWasLeft=False;
		bWasRight=False;
		aStrafe=0.00;
		aTurn=0.00;
		aForward=0.00;
		aLookUp=0.00;
		return;
	} else {
		if ( bDelayedCommand )
		{
			bDelayedCommand=False;
			ConsoleCommand(DelayedCommand);
		}
	}
	bEdgeForward=bWasForward ^^ (aBaseY > 0);
	bEdgeBack=bWasBack ^^ (aBaseY < 0);
	bEdgeLeft=bWasLeft ^^ (aStrafe > 0);
	bEdgeRight=bWasRight ^^ (aStrafe < 0);
	bWasForward=aBaseY > 0;
	bWasBack=aBaseY < 0;
	bWasLeft=aStrafe > 0;
	bWasRight=aStrafe < 0;
	Z4C=DesiredFOV * 0.01;
	Z4D=MouseSensitivity * Z4C;
	aMouseX *= Z4D;
	aMouseY *= Z4D;
	Z4E=SmoothMouseX;
	Z4F=SmoothMouseY;
	Z50=(Level.TimeSeconds - MouseZeroTime) / Level.TimeDilation;
	if ( bMaxMouseSmoothing && (aMouseX == 0) && (Z50 < MouseSmoothThreshold) )
	{
		SmoothMouseX=0.50 * (MouseSmoothThreshold - Z50) * Z4E / MouseSmoothThreshold;
		BorrowedMouseX += SmoothMouseX;
	} else {
		if ( (SmoothMouseX == 0) || (aMouseX == 0) || (SmoothMouseX > 0 != aMouseX > 0) )
		{
			SmoothMouseX=aMouseX;
			BorrowedMouseX=0.00;
		} else {
			SmoothMouseX=0.50 * (SmoothMouseX + aMouseX - BorrowedMouseX);
			if ( SmoothMouseX > 0 != aMouseX > 0 )
			{
				if ( aMouseX > 0 )
				{
					SmoothMouseX=1.00;
				} else {
					SmoothMouseX=-1.00;
				}
			}
			BorrowedMouseX=SmoothMouseX - aMouseX;
		}
		Z4E=SmoothMouseX;
	}
	if ( bMaxMouseSmoothing && (aMouseY == 0) && (Z50 < MouseSmoothThreshold) )
	{
		SmoothMouseY=0.50 * (MouseSmoothThreshold - Z50) * Z4F / MouseSmoothThreshold;
		BorrowedMouseY += SmoothMouseY;
	} else {
		if ( (SmoothMouseY == 0) || (aMouseY == 0) || (SmoothMouseY > 0 != aMouseY > 0) )
		{
			SmoothMouseY=aMouseY;
			BorrowedMouseY=0.00;
		} else {
			SmoothMouseY=0.50 * (SmoothMouseY + aMouseY - BorrowedMouseY);
			if ( SmoothMouseY > 0 != aMouseY > 0 )
			{
				if ( aMouseY > 0 )
				{
					SmoothMouseY=1.00;
				} else {
					SmoothMouseY=-1.00;
				}
			}
			BorrowedMouseY=SmoothMouseY - aMouseY;
		}
		Z4F=SmoothMouseY;
	}
	if ( (aMouseX != 0) || (aMouseY != 0) )
	{
		MouseZeroTime=Level.TimeSeconds;
	}
	aLookUp *= Z4C;
	aTurn *= Z4C;
	if ( bStrafe != 0 )
	{
		aStrafe += aBaseX + SmoothMouseX;
		aBaseX=0.00;
	} else {
		aTurn += aBaseX * Z4C + SmoothMouseX;
		if ( Level.NetMode != 0 )
		{
			aTurn *= TurnRateAdjuster;
		}
		aBaseX=0.00;
	}
	if ( (bStrafe == 0) && (bAlwaysMouseLook || (bLook != 0)) )
	{
		if ( bInvertMouse )
		{
			aLookUp -= SmoothMouseY;
		} else {
			aLookUp += SmoothMouseY;
		}
		if ( Level.NetMode != 0 )
		{
			aLookUp *= TurnRateAdjuster;
		}
	} else {
		aForward += SmoothMouseY;
	}
	SmoothMouseX=Z4E;
	SmoothMouseY=Z4F;
	if ( (bSnapLevel != 0) && V80 && (Level.TimeSeconds - V75 > V76) )
	{
		if (  !V81 )
		{
			bSnapLevel=0;
		}
		V75=Level.TimeSeconds;
		bCenterView=True;
		bKeyboardLook=False;
	} else {
		if ( aLookUp != 0 )
		{
			bCenterView=False;
			bKeyboardLook=True;
		}
	}
	if ( bFreeLook != 0 )
	{
		bKeyboardLook=True;
		aLookUp += 0.50 * aBaseY * Z4C;
	} else {
		aForward += aBaseY;
	}
	aBaseY=0.00;
	HandleWalking();
}

defaultproperties
{
    V2C=Class'MTLManager'
    l_matrixon="Matrix Mode On"
    l_matrixoff="Matrix Mode Off"
    l_stopspam="STOP SPAMMING!"
    l_spam1="was kicked for excessive spamming."
    l_spam3="was kicked for adminlogin abuse."
    l_blocked="This command has been disabled."
    l_unfly="You feel much heavier"
    l_unghost="You feel whole again"
    l_badaug="is not a valid augmentation!"
    l_nametaken="Someone is already playing with that name, please choose another."
    l_prevname="previously played as"
    l_augssaved="Aug preferences saved."
    CarcassType=Class'CBPCarcass'
    JumpSound=Sound'DeusExSounds.Player.MaleJump'
    HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
    HitSound2=Sound'DeusExSounds.Player.MalePainMedium'
    Land=Sound'DeusExSounds.Player.MaleLand'
    Die=Sound'DeusExSounds.Player.MaleDeath'
    PlayerReplicationInfoClass=Class'MTLPRI'
    Texture=Texture'DeusExItems.Skins.PinkMaskTex'
    CollisionRadius=17.00
    NetPriority=3.25
}
