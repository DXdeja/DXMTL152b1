//================================================================================
// CBPBloodSplat.
//================================================================================
class CBPBloodSplat extends BloodSplat;

function BeginPlay ()
{
	local float S41;

	if ( (Level.NetMode == 1) || Class'GameInfo'.Default.bLowGore )
	{
		Destroy();
		return;
	}
	S41=FRand();
	if ( S41 < 0.25 )
	{
		Texture=Texture'FlatFXTex3';
	} else {
		if ( S41 < 0.50 )
		{
			Texture=Texture'FlatFXTex5';
		} else {
			if ( S41 < 0.75 )
			{
				Texture=Texture'FlatFXTex6';
			}
		}
	}
	DrawScale += (FRand() - 0.50) * 0.40;
	Super(Decal).BeginPlay();
}
