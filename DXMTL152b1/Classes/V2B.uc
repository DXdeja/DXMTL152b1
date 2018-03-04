//================================================================================
// V2B.
//================================================================================
class V2B extends Keypoint;

var float V60;
var bool Z51;

function PreBeginPlay ()
{
}

function PostPostBeginPlay ()
{
	SetCollision(True,True,True);
}

function Timer ()
{
	Z51=False;
	SetCollision(True,True,True);
}

function Trigger (Actor V91, Pawn Player)
{
	if (  !Z51 )
	{
		Z51=True;
		SetCollision(False,False,False);
		SetTimer(V60,False);
	}
}

defaultproperties
{
    V60=28.00
    bStatic=False
    bAlwaysRelevant=True
    CollisionRadius=60.00
    CollisionHeight=45.00
    NetPriority=2.00
}
