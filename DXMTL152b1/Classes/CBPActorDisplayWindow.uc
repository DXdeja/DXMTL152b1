//================================================================================
// CBPActorDisplayWindow.
//================================================================================
class CBPActorDisplayWindow extends ActorDisplayWindow;

function SetSkins (Actor ZFB, out Texture ZFC[9])
{
	local int VD3;

	VD3=0;
JL0007:
	if ( VD3 < 8 )
	{
		ZFC[VD3]=ZFB.MultiSkins[VD3];
		VD3++;
		goto JL0007;
	}
	ZFC[VD3]=ZFB.Skin;
	if ( ZFB.Mesh != None )
	{
		VD3=0;
JL0072:
		if ( VD3 < 8 )
		{
			ZFB.MultiSkins[VD3]=GetGridTexture(ZFB.GetMeshTexture(VD3));
			VD3++;
			goto JL0072;
		}
	} else {
		VD3=0;
JL00BE:
		if ( VD3 < 8 )
		{
			ZFB.MultiSkins[VD3]=None;
			VD3++;
			goto JL00BE;
		}
	}
	ZFB.Skin=GetGridTexture(ZFC[VD3]);
}
