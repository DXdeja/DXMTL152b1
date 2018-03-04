//================================================================================
// CBPMutator.
//================================================================================
class CBPMutator extends Mutator;

var CBPMutator NextCBPMutator;
var bool bReplaceGameRelevant;

function AddCBPMutator (CBPMutator S42)
{
	if ( NextCBPMutator == None )
	{
		NextCBPMutator=S42;
	} else {
		NextCBPMutator.AddCBPMutator(S42);
	}
}

function ReplaceMapItem (out Actor V91, Class<Actor> S43)
{
	if ( NextCBPMutator != None )
	{
		NextCBPMutator.ReplaceMapItem(V91,S43);
	}
}

function SpawnNotification (out Actor V91, Class<Actor> S43)
{
	if (  !S43.Default.bGameRelevant || bReplaceGameRelevant )
	{
		DynamicReplacement(V91,S43);
	}
	if ( NextCBPMutator != None )
	{
		NextCBPMutator.SpawnNotification(V91,S43);
	}
}

function DynamicReplacement (out Actor V91, Class<Actor> S43)
{
}
