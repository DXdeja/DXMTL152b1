//================================================================================
// CBPCarcass.
//================================================================================
class CBPCarcass extends DeusExCarcass;

var bool Z79;
var bool Z7A;
var bool Z7B;

replication
{
	reliable if ( Role == ROLE_Authority )
		Z7A;
    reliable if ( bNetInitial && (Role == ROLE_Authority) )
		Z7B;
}

function Initfor (Actor V91)
{
	V5F(V91);
	SetScaleGlow();
	Super.Initfor(V91);
}

function Destroyed ()
{
	local Inventory Inv;

JL0000:
	if ( Inventory != None )
	{
		Inv=Inventory;
		DeleteInventory(Inv);
		Inv.Destroy();
		goto JL0000;
	}
	Super.Destroyed();
}

final function V5F (Actor V91)
{
	local int VD3;
	local Mesh S42;

	if ( (V91 == None) || Z79 )
	{
		return;
	}
	S42=V91.Mesh;
	if ( S42 == LodMesh'mp_jumpsuit' )
	{
		S42=LodMesh'GM_Jumpsuit';
	}
	Mesh=Mesh(DynamicLoadObject(string(S42) $ "_Carcass",Class'Mesh',True));
	Mesh2=Mesh(DynamicLoadObject(string(S42) $ "_CarcassB",Class'Mesh',True));
	Mesh3=Mesh(DynamicLoadObject(string(S42) $ "_CarcassC",Class'Mesh',True));
	if ( Mesh == None )
	{
		Mesh=Mesh(DynamicLoadObject(string(S42) $ string('Carcass'),Class'Mesh',True));
	}
	if ( Mesh == None )
	{
		Mesh=S42;
	}
	if ( Mesh2 == None )
	{
		Mesh2=Mesh;
	}
	if ( Mesh3 == None )
	{
		Mesh3=Mesh;
	}
	if ( Region.Zone.bWaterZone )
	{
		Mesh=Mesh3;
	}
	VD3=0;
JL015E:
	if ( VD3 < 8 )
	{
		MultiSkins[VD3]=V91.MultiSkins[VD3];
		VD3++;
		goto JL015E;
	}
	if ( V91.IsA('MTLPlayer') && MTLPlayer(V91).V7C )
	{
		MultiSkins[5]=MTLPlayer(V91).V6B[0];
		MultiSkins[6]=MTLPlayer(V91).V6B[1];
		MultiSkins[7]=MTLPlayer(V91).V6B[2];
	}
	Texture=V91.Texture;
	DrawScale=V91.DrawScale;
	Fatness=V91.Fatness;
}

final simulated function V00 ()
{
	local Vector S30;
	local Vector Z14;
	local Vector Z7C;
	local BloodPool Z7D;

	if (  !bNotDead &&  !Region.Zone.bWaterZone )
	{
		Z7A=True;
		if ( Level.NetMode == 1 )
		{
			return;
		}
		Z7C=Location - vect(0.00,0.00,320.00);
		Trace(S30,Z14,Z7C,Location,False);
		Z7D=Spawn(Class'BloodPool',,,S30 + Z14,rotator(Z14));
		if ( Z7D != None )
		{
			Z7D.maxDrawScale=CollisionRadius * 0.02;
			if ( Z7B )
			{
				Z7D.Time=100.00;
				Z7D.DrawScale=Z7D.maxDrawScale;
				Z7D.ReattachDecal(vect(0.10,0.10,0.00));
			}
		}
	}
}

auto simulated state Dead
{
	function HandleLanding ()
	{
		if (  !bNotDead )
		{
			AIStartEvent('Food',EAITYPE_Visual);
		}
		if (  !bAnimalCarcass )
		{
			SetCollisionSize(40.00,Default.CollisionHeight);
		}
		if ( bEmitCarcass )
		{
			AIStartEvent('Carcass',EAITYPE_Visual);
		}
		V00();
	}

Begin:
	if ( Role == ROLE_Authority )
	{
		while ( Physics == PHYS_Falling )
		{
			Sleep(1.00);
		}
		HandleLanding();
		Sleep(4.00);
		Z7B=True;
	} else {

		while (  !Z7A )
		{
			Sleep(1.00);
		}
		Sleep(0.20);
		V00();
	}
}

defaultproperties
{
    Mesh2=LodMesh'DeusExItems.TestBox'
    Mesh3=LodMesh'DeusExItems.TestBox'
    Texture=Texture'DeusExItems.Skins.PinkMaskTex'
    Mesh=LodMesh'DeusExItems.TestBox'
    CollisionRadius=40.00
}
