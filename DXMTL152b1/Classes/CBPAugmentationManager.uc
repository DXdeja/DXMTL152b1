//================================================================================
// CBPAugmentationManager.
//================================================================================
class CBPAugmentationManager extends AugmentationManager;

function CreateAugmentations (DeusExPlayer Player)
{
	local Augmentation S46;

	V06();
	Super.CreateAugmentations(Player);
	S46=FirstAug;
JL001C:
	if ( S46 != None )
	{
		S46.NetPriority=1.40;
		S46=S46.Next;
		goto JL001C;
	}
}

function Destroyed ()
{
	V06();
	Super.Destroyed();
}

final function V06 ()
{
	ResetAugmentations();
}

defaultproperties
{
    augClasses(12)=Class'CBPAugLight'
    defaultAugs=Class'CBPAugLight'
    NetPriority=1.40
}
