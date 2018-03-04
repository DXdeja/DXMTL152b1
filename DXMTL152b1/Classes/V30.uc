//================================================================================
// V30.
//================================================================================
class V30 extends SpawnNotify;

/*
function PreBeginPlay ()
{
}
*/

final function V00 ()
{
	local Actor V91;
	Log("V30 V00");

	foreach AllActors(Class'Actor',V91)
	{
		CBPMutator(Level.Game.BaseMutator).ReplaceMapItem(V91,V91.Class);
	}
}

event Actor SpawnNotification (Actor V91)
{
	local Actor _new;
	Log("V30 SpawnNotification"@V91@V91.Class@string(V91.Class)@string(V91.Name));
	CBPMutator(Level.Game.BaseMutator).SpawnNotification(V91,V91.Class);
	Log("RETURN:"@V91);
	return V91;
}

defaultproperties
{
    RemoteRole=0
}
