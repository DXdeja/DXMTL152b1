//================================================================================
// MTLMenuChoice_VictoryValue.
//================================================================================
class MTLMenuChoice_VictoryValue extends menuchoice_victoryvalue;

function SetVictoryType (string S04)
{
	local float S05;

	S05=(btnSlider.winSlider.GetTickPosition() + 1) / numTicks;
	if ( S04 ~= "Frags" )
	{
		startValue=1.00;
		numTicks=100;
		endValue=100.00;
		actionText=FragLimitActionText;
		HelpText=FragLimitHelpText;
	} else {
		if ( S04 ~= "Time" )
		{
			startValue=1.00;
			numTicks=60;
			endValue=60.00;
			actionText=TimeLimitActionText;
			HelpText=TimeLimitHelpText;
		}
	}
	btnAction.SetButtonText(actionText);
	btnSlider.SetTicks(numTicks,startValue,endValue);
	btnSlider.winSlider.SetTickPosition(Clamp(S05 * numTicks - 1,0,numTicks - 1));
}

defaultproperties
{
    numTicks=100
    endValue=100.00
}
