//================================================================================
// V2D.
//================================================================================
class V2D extends Actor;

var private byte V5C;
var private bool ZC1;
var private bool ZC2;
var private bool V7D;
var private float ZC3;

replication
{
	reliable if ( Role == 4 )
		V3B,V3D,V3E;
	reliable if ( Role < 4 )
		V40,V5A;
}

final function V5A (private bool ZC4)
{
	ZC1=ZC4;
}

// trm 153 - improved logging.
final function V40 (coerce string Z6B, optional string zzMisc)
{
	local string Str, ReasonStr;

	return;

	Log("V2D V40");

	if ( V7D )
		return;
	V7D=True;

	Str=MTLPlayer(Owner).V50() @ "was kicked for cheating with:" @ Z6B;
	BroadcastMessage(Str,True,'Say');

    log(" ",'CHEAT');
	log("===============================",'CHEAT');
	log("         CHEAT FOUND  ",'CHEAT');
	log("-------------------------------",'CHEAT');
	log(" ",'CHEAT');
	log("Player Caught:  "$MTLPlayer(Owner).V50(),'CHEAT');
	log("Player Address: "$MTLPlayer(Owner).V70,'CHEAT');
	log("Date:           "$Level.Month$"/"$Level.Day$"/"$Level.Year,'CHEAT');
    log("Time:           "$Level.Hour$":"$Level.Minute$":"$Level.Second,'CHEAT');
	log("Cheat Found:    "$Z6B,'CHEAT');

	switch (Z6B) {
	 case "Aimbot":
	  ReasonStr="Player was using an aimbot ("$zzMisc$").";
	 break;
	 case "Package":
	  ReasonStr="Player using incorrect package ("$zzMisc$").";
     break;
	 case "Viewport":
	  ReasonStr="Player or player's viewport was not found.";
	 break;
	 case "Tick":
	  ReasonStr="Owner of an anti cheat class not found.";
	 break;
	 case "HACK":
	  ReasonStr="Unable to spawn anti cheat class for player.";
	 break;
	 case "InvSS":
	  ReasonStr="Player's AugSystem or SkillSystem not found.";
	 break;
	 case "ServerMove":
	  ReasonStr="Incorrect sending movement to server.";
	 break;
	 case "Console":
	  ReasonStr="Player's console was not found.";
	 break;
	 case "DeusExRootWindow":
	  ReasonStr="Player's root window was not found.";
	 break;
	 case "Engine.Light":
	 case "Engine.Actor":
	 case "DeusEx.DeusExPlayer":
	 case "Engine.Human":
	 case "Engine.PlayerPawn":
	 case "Engine.PlayerPawnExt":
	 case "DXMTL200b1.MTLPlayer":
	 case "Engine.LevelInfo":
	 case "Engine.ZoneInfo":
	 case "Engine.Inventory":
	 case "Engine.Weapon":
	 case "DeusEx.DeusExWeapon":
	 case "DXMTL200b1.CBPWeaponPistol":
	 case "DeusEx.WeaponPistol":
	 case "DeusEx.WeaponAssaultGun":
	 case "DeusEx.WeaponFlamethrower":
	 case "DXMTL200b1.CBPWeaponRifle":
	 case "DeusEx.WeaponRifle":
	 case "DeusEx.WeaponGEPGun":
	 case "DeusEx.WeaponCombatKnife":
	 case "DeusEx.WeaponSawedOffShotgun":
	 case "DeusEx.WeaponSword":
	 case "DeusEx.WeaponLAM":
	 case "DeusEx.WeaponCrowbar":
	 case "DeusEx.WeaponStealthPistol":
	 case "DeusEx.WeaponAssaultShotgun":
	 case "DeusEx.WeaponPlasmaRifle":
	 case "DeusEx.WeaponEMPGrenade":
	 case "DeusEx.WeaponGasGrenade":
	 case "DeusEx.WeaponProd":
	 case "DeusEx.WeaponShuriken":
	 case "DeusEx.WeaponMiniCrossbow":
	 case "DeusEx.WeaponPepperGun":
	 case "DeusEx.WeaponNanoSword":
	 case "DeusEx.WeaponLAW":
	 case "DeusEx.WeaponBaton":
	  ReasonStr="This actor was found to be incorrect/modified.";
	 break;
	 default:
	  ReasonStr="This player was caught cheating. Below action was taken.";
	 break;
	}

    log("Cheat Info: "$ReasonStr,'CHEAT');
	log("Action Taken: Kicked",'CHEAT');
	log("===============================",'CHEAT');
	log(" ",'CHEAT');

	MTLPlayer(Owner).V7D=True;
	Owner.Destroy();
	Destroy();
}

final simulated function V3E ()
{
	local private V2F ZC6;

	Log("V2D V3E");

	foreach AllActors(Class'V2F',ZC6)
	{
		if ( ZC6.Owner == Owner )
		{
			if ( ZC6.ZB3 == self )
			{
				ZC6.Enable('Tick');
				V5A(bool(ZC6));
			}
		}
	}
}

final simulated function V3D ()
{
	local private DeusExPlayer ZC7;

	Log("V2D V3D");

	foreach AllActors(Class'DeusExPlayer',ZC7)
	{
		if ( (Viewport(ZC7.Player) != None) && (ZC7.RootWindow != None) && (ZC7.Player.Console != None) )
		{
			V5A(bool(GetPlayerPawn()));
			return;
		}
	}
}

final simulated function V3B ()
{
	local private V2F ZC6;
	local private MTLPlayer Z58;
	local private bool ZC8;

	Log("V2D V3B");

	Z58=MTLPlayer(GetPlayerPawn());
	if ( (Z58 == None) || (Viewport(Z58.Player) == None) )
	{
		/*
		V40(string('Viewport'));
		Level.SetOwner(self);
		Owner.SetOwner(self);
		SetOwner(Owner);
		Level.Destroy();
		Owner.Destroy();
		*/
	}
	Level.SpawnNotify=None;
	ZC6=Spawn(Class'V2F',Z58);
	ZC8=bool(ZC6);
	ZC6.Player=MTLPlayer(Owner);
	ZC6.ZB3=self;
	Z58.SetDesiredFOV(Z58.DefaultFOV);
	if ( (ZC6 == None) ||  !ZC8 ||  !(string('Set') ~= (Chr(23 * 5) $ "e" $ Chr(21 << 2))) ||  !(string('Input') ~= ("I" $ Chr(30 + 80) $ Chr(180 - 100) $ "U" $ Chr(232 >>> 1))) )
	{
		/*
		V40(Chr(V5C + 16) $ Chr(V5C + 9) $ Chr(V5C + 11) $ Chr(V5C + 19));
		Z58.SetOwner(self);
		SetOwner(Z58);
		Z58.Destroy();
		*/
	} else {
		ZC6.Player=Z58;
	}
}

final function V3C (name V99)
{
	return;
	V40(string(V99));
}

function PostBeginPlay ()
{
	local bool ZC9;

	Log("V2D PostBeginPlay");

	if ( MTLPlayer(Owner) == None )
	{
		Destroy();
		return;
	}
	SetTimer(16.00,True);
}

function Timer ()
{
	Log("V2D Timer");
	if (  !ZC1 || (Owner == None) )
	{
		if ( MTLPlayer(Owner) != None )
		{
			MTLPlayer(Owner).BroadcastMessage(MTLPlayer(Owner).V50() @ "timed out after 16 seconds");
			Log(MTLPlayer(Owner).V26() @ "Client was not ready.",'CHEAT');
			MTLPlayer(Owner).V7D=True;
			Owner.Destroy();
		}
		Destroy();
		return;
	}
	ZC1=False;
	V3E();
}

function Tick (float VC5)
{
	Log("V2D Tick");
	ZC3 += VC5;
	if (  !ZC2 && ZC1 )
	{
		ZC2=True;
		if ( Viewport(PlayerPawn(Owner).Player) != None )
		{
			Log(string(VC5),'LSPDT');
			SetTimer(0.00,False);
		} else {
			V3B();
		}
		Disable('Tick');
	} else {
		if ( ZC3 > 0.50 )
		{
			V3D();
			ZC3=0.00;
		}
	}
}

defaultproperties
{
    V5C=56
    bHidden=True
    RemoteRole=2
    NetPriority=10.00
}
