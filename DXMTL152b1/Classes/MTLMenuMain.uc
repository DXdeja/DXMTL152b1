//================================================================================
// MTLMenuMain.
//================================================================================
class MTLMenuMain extends MenuMain;

var string QuitMessages[10];

function ShowVersionInfo () {

	local TextWindow version;
    local string date, mth;
    local LevelInfo info;

	version = TextWindow(NewChild(Class'TextWindow'));
	version.SetTextMargins(0, 0);
	version.SetWindowAlignments(HALIGN_Right, VALIGN_Bottom);
	version.SetTextColorRGB(255, 255, 255);
	version.SetTextAlignments(HALIGN_Right, VALIGN_Bottom);

	info = player.GetEntryLevel();
	if (info == none)
	 date = Player.GetDeusExVersion();
    else {
      switch (info.month) {
       case 1: mth = "Jan"; break;
       case 2: mth = "Feb"; break;
       case 3: mth = "Mar"; break;
       case 4: mth = "Apr"; break;
       case 5: mth = "May"; break;
       case 6: mth = "Jun"; break;
       case 7: mth = "Jul"; break;
       case 8: mth = "Aug"; break;
       case 9: mth = "Sep"; break;
       case 10: mth = "Oct"; break;
       case 11: mth = "Nov"; break;
       case 12: mth = "Dec"; break;
      }
     date = mth @ info.Day @ info.Year @ "v1.112fm";

    }
    version.SetText(date $ "|n DXMTL v1.53");
}

function string GrabQuitMsg() {
  local int i;

  i=rand(arraycount(QuitMessages));

  while (QuitMessages[i]=="")
   i=rand(arraycount(QuitMessages));

  return QuitMessages[i];

//  return QuitMessages[rand(arraycount(QuitMessages))];
}

function ProcessCustomMenuButton(string key) {
	if ( key == "EXIT" ) {
	  messageBoxMode = MB_Exit;


	   root.MessageBox(MessageBoxTitle, GrabQuitMsg(), 0, False, Self);
    }
}

defaultproperties
{
     buttonDefaults(3)=(Y=121,Invoke=Class'CBPMenuSettings')
     buttonDefaults(8)=(Y=301,Action=MA_MenuScreen,Invoke=Class'MTLMenuMPMain')
     Title="Welcome to DXMTL!"
     ClientHeight=415

     QuitMessages(0)="Are you sure you|nwant to exit Deus Ex?"
     QuitMessages(1)="Do you know what the hell you're doing?!"
     QuitMessages(2)="Some noob is winning.|nYou want this to happen?"

}
