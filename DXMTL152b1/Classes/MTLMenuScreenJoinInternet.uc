//================================================================================
// MTLMenuScreenJoinInternet.
//================================================================================
class MTLMenuScreenJoinInternet extends MTLMenuScreenJoinGame;

var deusexgspylink Link;

function bool ButtonActivated (Window buttonPressed)
{
	local bool bHandled;

	bHandled=True;
	switch (buttonPressed)
	{
		case HostButton:
		ProcessMenuAction(MA_MenuScreen,Class'MTLMenuScreenHostNet');
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
	Link=GetPlayerPawn().GetEntryLevel().Spawn(Class'deusexgspylink');
	Link.MasterServerAddress=MasterServerAddress;
	Link.MasterServerTCPPort=MasterServerTCPPort;
	Link.Region=Region;
	Link.MasterServerTimeout=MasterServerTimeout;
	Link.GameName=GameName;
	Link.OwnerWindow=self;
	Link.Start();
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

defaultproperties
{
    Title="Start Multiplayer Internet Game"
}
