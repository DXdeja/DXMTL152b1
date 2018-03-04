//================================================================================
// V34.
//================================================================================
class V34 extends Object
	Abstract;

static final function string GetPlayerIPAddr (PlayerPawn Player)
{
	local string V92;
	local int VD3;

	Log("V34 GetPlayerIPAddr");

	if ( Player != None )
	{
		V92=Player.GetPlayerNetworkAddress();
		VD3=InStr(V92,":");
		if ( VD3 != -1 )
		{
			V92=Left(V92,VD3);
		}
	}
	return V92;
}

static final function bool V38 (MTLPlayer Player, Class<MTLPlayer> Z62)
{
	local int i;

	Log("V34 V38");

	if ( (Player == None) || (Z62 == None) || (Z62.Default.Mesh == None) )
	{
		return False;
	}
	for(i=0;i<8;i++)
	{
		Player.MultiSkins[i]=Z62.Default.MultiSkins[i];
	}
	Player.V6B[0]=Player.MultiSkins[5];
	Player.V6B[1]=Player.MultiSkins[6];
	Player.V6B[2]=Player.MultiSkins[7];
	Player.V7C=True;
	Player.V68=Z62.Default.V68;
	Player.CarcassType=Z62.Default.CarcassType;
	Player.Mesh=Z62.Default.Mesh;
	Player.Texture=Z62.Default.Texture;
	Player.JumpSound=Z62.Default.JumpSound;
	Player.HitSound1=Z62.Default.HitSound1;
	Player.HitSound2=Z62.Default.HitSound2;
	Player.Land=Z62.Default.Land;
	Player.Die=Z62.Default.Die;
	Player.DrawScale=Z62.Default.DrawScale;
	Player.bIsFemale=Z62.Default.bIsFemale;
	Player.PlayerSkin=Z62.Default.PlayerSkin;
	return True;
}

static final function V37 (GameInfo S07, string Z56, out string Z57)
{
	local V30 S08;
	local Mutator S09;
	local Class<Mutator> S0A;
	local string S0B;
	local string S0C;
	local int VD3;

	Log("V34 V37");

	Log("InitGame:" @ Left(Z56,800),'DXMTL');
	S07.Level.Game=S07;
	S07.MaxPlayers=Clamp(S07.GetIntOption(Z56,string('MaxPlayers'),S07.MaxPlayers),1,32);
	S0B=S07.ParseOption(Z56,string('Difficulty'));
	if ( S0B != "" )
	{
		S07.Difficulty=int(S0B);
	}
	S0B=S07.ParseOption(Z56,string('GameSpeed'));
	if ( S0B != "" )
	{
		Log(string('GameSpeed') @ S0B,'DXMTL');
		S07.SetGameSpeed(float(S0B));
	}
	S07.BaseMutator=S07.Spawn(Class'CBPMutator');
	assert (S07.BaseMutator != None);
	Log("Base Mutator:" @ string(S07.BaseMutator),'DXMTL');
	if ( S07.IsA('DeusExMPGame') )
	{
		S09=S07.Spawn(Class'AntiCheat1');
		assert (AntiCheat1(S09) != None);
		S07.BaseMutator.AddMutator(S09);
		CBPMutator(S07.BaseMutator).AddCBPMutator(CBPMutator(S09));
	}
	S0B=S07.ParseOption(Z56,string('Mutator'));
	if ( S0B != "" )
	{
		Log(string('Mutators') @ Left(S0B,800),'DXMTL');
JL0231:
		if ( S0B != "" )
		{
			VD3=InStr(S0B,",");
			if ( VD3 > 0 )
			{
				S0C=Left(S0B,VD3);
				S0B=Mid(S0B,VD3 + 1);
			} else {
				S0C=S0B;
				S0B="";
			}
			S0A=Class<Mutator>(S07.DynamicLoadObject(S0C,Class'Class',True));
			if ( (S0A != None) && (S0A != Class'Mutator') && (S0A != Class'CBPMutator') )
			{
				Log("Add mutator" @ string(S0A),'DXMTL');
				S09=S07.Spawn(S0A);
				S07.BaseMutator.AddMutator(S09);
				CBPMutator(S07.BaseMutator).AddCBPMutator(CBPMutator(S09));
			}
			goto JL0231;
		}
	}
	S0B=S07.ParseOption(Z56,string('AdminPassword'));
	if ( S0B != "" )
	{
		S07.ConsoleCommand(string('Set') @ string('GameInfo') @ string('AdminPassword') @ S0B);
	}
	S0B=S07.ParseOption(Z56,string('GamePassword'));
	if ( S0B != "" )
	{
		S07.ConsoleCommand(string('Set') @ string('GameInfo') @ string('GamePassword') @ S0B);
		Log(string('GamePassword') @ S0B,'DXMTL');
	}
	Class'SpawnNotify'.Default.RemoteRole=ROLE_None;
	S08=S07.Spawn(Class'V30');
	assert (S08 != None);
}

static final function V0B (DeusExWeapon Z47)
{
	Log("V34 V0B");
	if ( Z47.ReloadCount == 0 )
	{
		if ( Pawn(Z47.Owner) != None )
		{
			Pawn(Z47.Owner).ClientMessage(Z47.msgCannotBeReloaded);
		}
	} else {
		if (  !Z47.IsInState('Reload') )
		{
			Z47.ClipCount=Z47.ReloadCount;
			Z47.TweenAnim('Still',0.10);
			Z47.GotoState('Reload');
		}
	}
}

static final simulated function V0A (DeusExWeapon Z47, out float Z7F, out float Z80, float S0D)
{
	Log("V34 V0A");
	if ( Z47.MustReload() && Z47.CanReload() )
	{
		Z80=FClamp(Z7F * 0.43 / FMax(S0D + Z47.GetWeaponSkill() * S0D,0.10),0.00,1.00);
		Z7F=0.00;
		if ( Z80 == 1.00 )
		{
			Z47.ClipCount=0;
			Z47.ServerDoneReloading();
			Z80=0.00;
		}
	} else {
		Z80=0.00;
	}
	Z7F=0.00;
}

static final function V0C (DeusExWeapon Z47)
{
	Log("V34 V0C");
	Z47.ScopeOff();
	Z47.LaserOff();
	if ( (Z47.Level.NetMode == 1) || (Z47.Level.NetMode == 2) && (DeusExPlayer(Z47.Owner) != None) &&  !DeusExPlayer(Z47.Owner).PlayerIsListenClient() )
	{
		Z47.ClientDownWeapon();
	}
	Z47.TweenDown();
}
