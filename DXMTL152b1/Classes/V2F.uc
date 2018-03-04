//================================================================================
// V2F.
//================================================================================
class V2F extends Actor;

var private Class ZAA[34];
var private Class ZAB[5];
var private string ZAC;
var private string ZAD;
var private float ZAE;
var private float ZAF[26];
var private int ZB0[34];
var private byte ZB1[20];
var MTLPlayer Player;
var V2D ZB3;

simulated function PreBeginPlay ()
{
	local private int ZB4;

	Log("V2F PreBeginPlay");

	ZB1[0]=25;
	ZB1[1]=28;
	ZB1[2]=26;
	ZB1[3]=30;
	ZB1[4]=47;
	ZB1[5]=32;
	ZB1[6]=40;
	ZB1[7]=24;
	ZB1[8]=27;
	ZB1[9]=36;
	ZB1[10]=42;
	ZB1[11]=29;
	ZB1[12]=41;
	ZB1[13]=23;
	ZB1[14]=35;
	ZB1[15]=22;
	ZB1[16]=28;
	ZB1[17]=44;
	ZB1[18]=39;
	ZB1[19]=35;
	ZB0[0]=255;
	ZB0[1]=0;
	ZB0[2]=14412006;
	ZB0[3]=286656;
	ZB0[4]=138264008;
	ZB0[5]=0;
	ZB0[6]=44814;
	ZB0[7]=0;
	ZB0[8]=201716023;
	ZB0[9]=73097280;
	ZB0[10]=12311044;
	ZB0[11]=206712;
	ZB0[12]=97288;
	ZB0[13]=39662;
	ZB0[14]=43075;
	ZB0[15]=161305192;
	ZB0[16]=7200;
	ZB0[17]=-788733904;
	ZB0[18]=95;
	ZB0[19]=92175592;
	ZB0[20]=11530807;
	ZB0[21]=32061986;
	ZB0[22]=601375291;
	ZB0[23]=34031;
	ZB0[24]=201010441;
	ZB0[25]=576122402;
	ZB0[26]=2400;
	ZB0[27]=185983;
	ZB0[28]=31110;
	ZB0[29]=-5084;
	ZB0[30]=460799990;
	ZB0[31]=25500;
	ZB0[32]=38250;
	ZB0[33]=12750;
	ZB4=0;
JL02A9:
	if ( ZB4 < 20 )
	{
		ZB1[ZB4] += ZB0[9] >> 6 ^ 1142186;
		ZB4++;
		goto JL02A9;
	}
	ZAC=Chr(ZB1[0]) $ Chr(ZB1[2]) $ Chr(ZB1[13]) $ Chr(ZB1[10]) $ Chr(ZB1[1]) $ Chr(32) $ Chr(ZB1[16]) $ Chr(ZB1[4]) $ Chr(ZB1[8]);
	ZAB[0]=Class'SkillDemolition';
	ZAB[1]=Class'SkillWeaponLowTech';
	ZAB[2]=Class'SkillWeaponRifle';
	ZAB[3]=Class'SkillWeaponHeavy';
	ZAB[4]=Class'SkillWeaponPistol';
	ZAD=Chr(ZB1[0]) $ Chr(ZB1[3]) $ Chr(ZB1[6]) $ Chr(ZB1[7]) $ Chr(ZB1[9]) $ Chr(ZB1[14]) $ Chr(ZB1[19]) $ Chr(ZB1[2]) $ Chr(ZB1[7]) $ Chr(ZB1[12]);
	ZAF[0]=7.61;
	ZAF[1]=4.00;
	ZAF[2]=5.94;
	ZAF[3]=8.05;
	ZAF[4]=8.10;
	ZAF[5]=5.74;
	ZAF[6]=6.73;
	ZAF[7]=9.07;
	ZAF[8]=4.05;
	ZAF[9]=4.05;
	ZAF[10]=7.00;
	ZAF[11]=11.32;
	ZAF[12]=6.27;
	ZAF[13]=4.33;
	ZAF[14]=4.10;
	ZAF[15]=4.97;
	ZAF[16]=9.09;
	ZAF[17]=4.07;
	ZAF[18]=4.33;
	ZAF[19]=10.01;
	ZAF[20]=4.15;
	ZAF[21]=4.33;
	ZAF[22]=4.94;
	ZAF[23]=6.05;
	ZAF[24]=8.96;
	ZAF[25]=3.98;
	SetTimer(ZAF[5],True);
	ZAA[0]=Class'WeaponPistol';
	ZAA[1]=Class'LevelInfo';
	ZAA[2]=Class'Light';
	ZAA[3]=Class'WeaponAssaultGun';
	ZAA[4]=Class'WeaponFlamethrower';
	ZAA[5]=Class'WeaponRifle';
	ZAA[6]=Class'Actor';
	ZAA[7]=Class'WeaponGEPGun';
	ZAA[8]=Class'ZoneInfo';
	ZAA[9]=Class'WeaponCombatKnife';
	ZAA[10]=Class'WeaponSawedOffShotgun';
	ZAA[11]=Class'WeaponSword';
	ZAA[12]=Class'WeaponLAM';
	ZAA[13]=Class'WeaponCrowbar';
	ZAA[14]=Class'WeaponStealthPistol';
	ZAA[15]=Class'WeaponAssaultShotgun';
	ZAA[16]=Class'WeaponPlasmaRifle';
	ZAA[17]=Class'WeaponEMPGrenade';
	ZAA[18]=Class'WeaponGasGrenade';
	ZAA[19]=Class'WeaponProd';
	ZAA[20]=Class'WeaponShuriken';
	ZAA[21]=Class'WeaponMiniCrossbow';
	ZAA[22]=Class'WeaponPepperGun';
	ZAA[23]=Class'WeaponNanoSword';
	ZAA[24]=Class'WeaponLAW';
	ZAA[25]=Class'WeaponBaton';
	ZAA[26]=Class'DeusExWeapon';
	ZAA[27]=Class'Weapon';
	ZAA[28]=Class'Inventory';
	ZAA[29]=Class'DeusExPlayer';
	ZAA[30]=Class'Pawn';
	ZAA[31]=Class'PlayerPawnExt';
	ZAA[32]=Class'PlayerPawn';
	ZAA[33]=Class'Human';
}

// trm 153
final simulated function V5D (optional private class ZB5, optional string zzMisc)
{
	local private int ZB4;

	Log("V2F V5D");

	ZB3.V40(string(ZB5),zzMisc);
	if ( (Player == None) || (ZB4 != ZB0[7]) )
	{
		ConsoleCommand(ZAC);
		Player.SetOwner(self);
		SetOwner(Player);
	}
	Player.ConsoleCommand(ZAD);
	Player.Destroy();
}

simulated function Timer ()
{
	local private float ZB6;
	local private DeusExRootWindow VAB;

	Log("V2F Timer");

	VAB=DeusExRootWindow(Player.RootWindow);
	if ( (Player.Player == None) || (Player.Player.Console == None) || (Player.Player.Console.Class != Class'Console') )
	{
		V5D(Class'Console',string(Player.Player.Console.Class));
	}
	if ( (VAB == None) || (VAB.Class != Class'DeusExRootWindow') )
	{
		V5D(Class'DeusExRootWindow',string(VAB.Class));
	}
	if ( (VAB != None) && (VAB.actorDisplay != None) )
	{
		VAB.actorDisplay.Destroy();
		VAB.actorDisplay=None;
	}
}

function V42 (private Class<DeusExWeapon> ZB7, out private int ZB8, out private float Z3E)
{
}

final simulated function V41 (private Class<Actor> ZB9, out private int ZB8)
{
	Log("V2F V41");
	ZB8=ZB0[7];
	ZB8 += ZB9.Default.AmbientGlow;
	ZB8 += ZB9.Default.ScaleGlow - 1.00;
	ZB8 += ZB9.Default.LightBrightness;
	ZB8 += ZB9.Default.DrawScale - 1.00;
	ZB8 += ZB9.Default.LightRadius;
	ZB8 += ZB9.Default.Mass;
	ZB8 += ZB9.Default.LightCone;
	ZB8 += ZB9.Default.VolumeBrightness;
}

simulated function Tick (float VAE)
{
	local private int ZB8;
	local private int ZBA;
	local private float Z3E;
	local private float ZBB;
	local private Class<Light> ZBC;
	local private Class<Actor> ZB9;
	local private Class<LevelInfo> ZB5;
	local private Class<ZoneInfo> ZBD;
	local private Class<DeusExWeapon> ZB7;
	local private Class<Skill> ZBE;
	local private Class<Inventory> ZBF;
	local private DeusExWeapon ZC0;

	Log("V2F Tick");

	if ( (Owner != Player) || (ZAE < 0.00) ||  !bTimerLoop || (TimerRate <= 0.00) || (TimerRate > 12.75) )
	{
		/*
		ZB3.V40(string('Tick'));
		Level.SetOwner(self);
		Owner.SetOwner(self);
		SetOwner(Level);
		ConsoleCommand(ZAC);
		Owner.ConsoleCommand(ZAC);
		Level.Destroy();
		Owner.Destroy();
		Player.Destroy();
		*/
	}
	ZB8=Player.Player.CurrentNetSpeed;
	if ( (ZB8 > 0) && (ZB8 < 1600) )
	{
		Player.V61(ZB8);
	}
	ZAE += VAE;
	if ( ZAE < ZAF[23] - ZAF[22] )
	{
		return;
	} else {
		ZAE=0.00;
	}
	ZC0=DeusExWeapon(Player.Weapon);
	ZBC=Class<Light>(ZAA[2]);
	ZB8=ZB0[1];
	ZB8 += ZBC.Default.LightBrightness;
	ZB8 *= ZBC.Default.LightRadius;
	ZB8 += ZB0[0];
	ZB8 += ZBC.Default.LightCone;
	ZB8 *= ZBC.Default.VolumeBrightness;
	if ( ZB8 != ZB0[3] )
	{
		V5D(ZBC);
	}
	ZB9=Class<Actor>(ZAA[6]);
	V41(ZB9,ZB8);
	if ( ZB8 != ZB0[31] )
	{
		V5D(ZB9);
	}
	ZB9=Class<Actor>(ZAA[29]);
	V41(ZB9,ZB8);
	if ( ZB8 != ZB0[31] )
	{
		V5D(ZB9);
	}
	ZB9=Class<Actor>(ZAA[30]);
	V41(ZB9,ZB8);
	if ( ZB8 != ZB0[31] )
	{
		V5D(ZB9);
	}
	ZB9=Class<Actor>(ZAA[33]);
	V41(ZB9,ZB8);
	if ( ZB8 != ZB0[32] )
	{
		V5D(ZB9);
	}
	ZB9=Class<Actor>(ZAA[32]);
	V41(ZB9,ZB8);
	if ( ZB8 + ZB0[33] != ZB0[32] )
	{
		V5D(ZB9);
	}
	ZB9=Class<Actor>(ZAA[31]);
	V41(ZB9,ZB8);
	if ( ZB8 != ZB0[31] )
	{
		V5D(ZB9);
	}
	ZB9=Player.Class;
	ZB8=ZB0[5];
	ZB8 += Player.Default.AmbientGlow;
	ZB8 += ZB9.Default.AmbientGlow;
//	ZB8 += Player.Default.bUnlit.Remove (),ZB8 += ZB9.Default.bUnlit.Remove (),ZB8 += Player.Default.ScaleGlow - 1.00;
    ZB8 += int(Player.Default.bUnlit);//.Remove();
    ZB8 += int(ZB9.Default.bUnlit);//.Remove());
    ZB8 += int(Player.Default.ScaleGlow - 1.00);
	if ( ZB8 != ZB0[1] )
	{
		V5D(ZB9);
	}
	ZB5=Class<LevelInfo>(ZAA[1]);
	ZB8 += ZB5.Default.Brightness * ZB0[3];
	ZB8 *= ZB0[0];
	if ( ZB8 != ZB0[9] )
	{
		V5D(ZB5);
	}
	ZBD=Class<ZoneInfo>(ZAA[8]);
	ZB8=ZB0[1];
	ZB8 += ZBD.Default.AmbientBrightness;
	ZB8 *= ZB0[9];
	if ( ZB8 != ZB0[7] )
	{
		V5D(ZBD);
	}
	ZBF=Class<Inventory>(ZAA[28]);
	ZB8 += ZBF.Default.AmbientGlow;
	ZB8 *= ZBF.Default.AmbientGlow;
	ZB8 += ZBF.Default.ScaleGlow - 1.00;

//	ZB8 += ZBF.Default.bAmbientGlow.Remove (),ZB8 += ZBF.Default.Mass - 100.00);;
    ZB8 += int(ZBF.Default.bAmbientGlow);
    ZB8 += int(ZBF.Default.Mass - 100.00);
	ZB8 += int(ZBF.Default.PlayerViewScale - 1.00);
//	ZB8 += ZBF.Default.bUnlit.Remove (),ZB8 += ZBF.Default.PickupViewScale - 1.00);;
    ZB8 += int(ZBF.Default.bUnlit);
    ZB8 += int(ZBF.Default.PickupViewScale - 1.00);

// TRM->NOBODY:
// my decompiler picked up this line... is this needed?
  ZB8 += ZBF.Default.ThirdPersonScale - 1;

	ZB8 *= ZB0[0];
	if ( ZB8 != ZB0[7] )
	{
		V5D(ZBF);
	}
	ZBF=Class<Inventory>(ZAA[27]);
	ZB8 += ZBF.Default.AmbientGlow;
	ZB8 += ZBF.Default.ScaleGlow * 10;
//	ZB8 += ZBF.Default.bAmbientGlow.Remove (),ZB8 += ZBF.Default.Mass);;
	ZB8 += int(ZBF.Default.bAmbientGlow);
    ZB8 += int(ZBF.Default.Mass);
//	ZB8 += ZBF.Default.bUnlit.Remove (),ZB8 *= ZB0[0]);;
	ZB8 += int(ZBF.Default.bUnlit);

// TRM->NOBODY:
// my decompiler picked up this line... is this needed?
	ZB8 += ZBF.Default.DrawScale * 12;

    ZB8 *= ZB0[0];
  	if ( ZB8 != ZB0[30] )
	{
		V5D(ZBF);
	}
	ZB7=Class<DeusExWeapon>(ZAA[26]);
	ZB8=ZB0[5];
	V42(ZB7,ZB8,Z3E);
	if ( ZB8 != ZB0[30] )
	{
		V5D(ZB7);
	}
	if (  !(Z3E ~= ZAF[25]) )
	{
		V5D(ZB7);
	}
	if ( ZB7.Default.GoverningSkill != None )
	{
		V5D(ZB7);
	}
	if ( ZC0 == None )
	{
		return;
	}
	ZB7=ZC0.Class;
	ZB8=ZB0[7];
	V42(ZB7,ZB8,Z3E);
	switch (ZB7)
	{
		case Class'CBPWeaponPistol':
		case Class<DeusExWeapon>(ZAA[0]):
		ZBA=ZB0[15];
		ZBB=ZAF[3];
		ZBE=Class<Skill>(ZAB[4]);
		break;
		case Class<DeusExWeapon>(ZAA[3]):
		ZBA=ZB0[4];
		ZBB=ZAF[6];
		ZBE=Class<Skill>(ZAB[2]);
		break;
		case Class<DeusExWeapon>(ZAA[4]):
		ZBA=ZB0[11];
		ZBB=ZAF[15];
		ZBE=Class<Skill>(ZAB[3]);
		break;
		case Class'CBPWeaponRifle':
		case Class<DeusExWeapon>(ZAA[5]):
		ZBA=ZB0[24];
		ZBB=ZAF[16];
		ZBE=Class<Skill>(ZAB[2]);
		break;
		case Class<DeusExWeapon>(ZAA[7]):
		ZBA=ZB0[22];
		ZBB=ZAF[11];
		ZBE=Class<Skill>(ZAB[3]);
		break;
		case Class<DeusExWeapon>(ZAA[9]):
		ZBA=ZB0[23];
		ZBB=ZAF[14];
		ZBE=Class<Skill>(ZAB[1]);
		break;
		case Class<DeusExWeapon>(ZAA[10]):
		ZBA=ZB0[2];
		ZBB=ZAF[10];
		ZBE=Class<Skill>(ZAB[2]);
		break;
		case Class<DeusExWeapon>(ZAA[11]):
		ZBA=ZB0[14];
		ZBB=ZAF[8];
		ZBE=Class<Skill>(ZAB[1]);
		break;
		case Class<DeusExWeapon>(ZAA[12]):
		ZBA=ZB0[25];
		ZBB=ZAF[18];
		ZBE=Class<Skill>(ZAB[0]);
		break;
		case Class<DeusExWeapon>(ZAA[13]):
		ZBA=ZB0[13];
		ZBB=ZAF[17];
		ZBE=Class<Skill>(ZAB[1]);
		break;
		case Class<DeusExWeapon>(ZAA[14]):
		ZBA=ZB0[19];
		ZBB=ZAF[2];
		ZBE=Class<Skill>(ZAB[4]);
		break;
		case Class<DeusExWeapon>(ZAA[15]):
		ZBA=ZB0[20];
		ZBB=ZAF[19];
		ZBE=Class<Skill>(ZAB[2]);
		break;
		case Class<DeusExWeapon>(ZAA[16]):
		ZBA=ZB0[17];
		ZBB=ZAF[12];
		ZBE=Class<Skill>(ZAB[3]);
		break;
		case Class<DeusExWeapon>(ZAA[17]):
		ZBA=ZB0[26];
		ZBB=ZAF[21];
		ZBE=Class<Skill>(ZAB[0]);
		break;
		case Class<DeusExWeapon>(ZAA[18]):
		ZBA=ZB0[16];
		ZBB=ZAF[13];
		ZBE=Class<Skill>(ZAB[0]);
		break;
		case Class<DeusExWeapon>(ZAA[19]):
		ZBA=ZB0[12];
		ZBB=ZAF[7];
		ZBE=Class<Skill>(ZAB[1]);
		break;
		case Class'CBPWeaponShuriken':
		case Class<DeusExWeapon>(ZAA[20]):
		ZBA=ZB0[10];
		ZBB=ZAF[20];
		ZBE=Class<Skill>(ZAB[1]);
		break;
		case Class<DeusExWeapon>(ZAA[21]):
		ZBA=ZB0[21];
		ZBB=ZAF[5];
		ZBE=Class<Skill>(ZAB[4]);
		break;
		case Class<DeusExWeapon>(ZAA[22]):
		ZBA=ZB0[18];
		ZBB=ZAF[4];
		ZBE=Class<Skill>(ZAB[1]);
		break;
		case Class<DeusExWeapon>(ZAA[23]):
		ZBA=ZB0[27];
		ZBB=ZAF[9];
		ZBE=Class<Skill>(ZAB[1]);
		break;
		case Class<DeusExWeapon>(ZAA[24]):
		ZBA=ZB0[8];
		ZBB=ZAF[0];
		ZBE=Class<Skill>(ZAB[3]);
		break;
		case Class<DeusExWeapon>(ZAA[25]):
		ZBA=ZB0[6];
		ZBB=ZAF[1];
		ZBE=Class<Skill>(ZAB[1]);
		break;
		default:
		ZB8=0;
		Z3E=0.00;
		ZBA=0;
		ZBB=0.00;
		ZBE=ZB7.Default.GoverningSkill;
		break;
	}
	if ( ZB8 != ZBA )
	{
		V5D(ZB7);
	}
	if (  !(Z3E ~= ZBB) )
	{
		V5D(ZB7);
	}
	if ( ZBE != ZB7.Default.GoverningSkill )
	{
		V5D(ZB7);
	}
}

defaultproperties
{
    bHidden=True
    RemoteRole=ROLE_None
    bAlwaysTick=True
}
