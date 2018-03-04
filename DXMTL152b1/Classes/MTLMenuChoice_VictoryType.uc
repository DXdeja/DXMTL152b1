//================================================================================
// MTLMenuChoice_VictoryType.
//================================================================================
class MTLMenuChoice_VictoryType extends menuchoice_victorytype;

var MTLMenuScreenHostGame hostparent;

function SetValue (int NewValue)
{
	Super(MenuUIChoiceEnum).SetValue(NewValue);
	if ( (hostparent != None) && (hostparent.VictoryValueChoice != None) )
	{
		hostparent.VictoryValueChoice.SetVictoryType(GetModuleName(NewValue));
	}
}
