//================================================================================
// CBPDeusExHUD.
//================================================================================
class CBPDeusExHUD extends DeusExHUD;

event InitWindow ()
{
	Super.InitWindow();
	if ( belt != None )
	{
		belt.Destroy();
	}
	belt=HUDObjectBelt(NewChild(Class'CBPHUDObjectBelt'));
	if ( augDisplay != None )
	{
		augDisplay.Destroy();
	}
	augDisplay=AugmentationDisplayWindow(NewChild(Class'CBPAugmentationDisplayWindow'));
	augDisplay.SetWindowAlignments(HALIGN_Full,VALIGN_Full);
}
