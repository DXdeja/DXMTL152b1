//================================================================================
// CBPHUDObjectBelt.
//================================================================================
class CBPHUDObjectBelt extends HUDObjectBelt;

function CreateSlots ()
{
	local int VD3;
	local RadioBoxWindow winRadio;

	winRadio=RadioBoxWindow(NewChild(Class'RadioBoxWindow'));
	winRadio.SetSize(504.00,54.00);
	winRadio.SetPos(10.00,6.00);
	winRadio.bOneCheck=False;
	winSlots=TileWindow(winRadio.NewChild(Class'TileWindow'));
	winSlots.SetMargins(0, 0);
	winSlots.SetMinorSpacing(0);
	winSlots.SetOrder(ORDER_LeftThenUp);
	VD3=0;
JL00A8:
	if ( VD3 < 10 )
	{
		objects[VD3]=HUDObjectSlot(winSlots.NewChild(Class'CBPHUDObjectSlot'));
		objects[VD3].SetObjectNumber(VD3);
		objects[VD3].Lower();
		if ( VD3 == 0 )
		{
			objects[VD3].SetWidth(44.00);
		}
		VD3++;
		goto JL00A8;
	}
	objects[0].Lower();
}
