//================================================================================
// MTLMenuMPMain.
//================================================================================
class MTLMenuMPMain extends menumpmain;

defaultproperties
{
     buttonDefaults(0)=(Y=13,Action=MA_MenuScreen,Invoke=Class'MTLmenuscreenjoininternet')
     buttonDefaults(1)=(Y=49,Action=MA_MenuScreen,Invoke=Class'MTLmenuscreenjoinlan')
     buttonDefaults(2)=(Y=85,Action=MA_MenuScreen,Invoke=Class'MTLmenuscreenplayersetup')
     buttonDefaults(3)=(Y=121,Action=MA_MenuScreen,Invoke=Class'CBPmenuscreenaugsetup')
    Title="DXMTL Multiplayer Main Menu"
}
