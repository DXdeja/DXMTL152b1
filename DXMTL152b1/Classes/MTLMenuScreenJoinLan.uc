//================================================================================
// MTLMenuScreenJoinLan.
//================================================================================
class MTLMenuScreenJoinLan extends MTLMenuScreenJoinGame;

var deusexlocallink Link;
var string BeaconProduct;
var int ServerBeaconPort;

function bool ButtonActivated (Window buttonPressed)
{
	local bool bHandled;

	bHandled=True;
	switch (buttonPressed)
	{
		case HostButton:
		ProcessMenuAction(MA_MenuScreen,Class'MTLMenuScreenHostLan');
		break;
		default:
		bHandled=False;
		break;
	}
	if (  !bHandled )
	{
		bHandled=Super.ButtonActivated(buttonPressed);
	}
	return bHandled;
}

function Query ()
{
	Link=GetPlayerPawn().GetEntryLevel().Spawn(Class'deusexlocallink');
	Link.OwnerWindow=self;
	Link.Start();
	Link.SetTimer(1.00,False);
}

function QueryFinished (bool bSuccess, optional string ErrorMsg)
{
	Link.Destroy();
	Link=None;
	PingUnpingedServers();
}

function ShutdownLink ()
{
	if ( Link != None )
	{
		Link.Destroy();
	}
	Link=None;
}

function string GetExtraJoinOptions ()
{
	return Super.GetExtraJoinOptions() $ "?lan";
}

defaultproperties
{
    Title="Start Multiplayer LAN Game"
}
