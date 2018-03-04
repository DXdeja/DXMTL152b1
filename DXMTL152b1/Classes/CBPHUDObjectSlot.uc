//================================================================================
// CBPHUDObjectSlot.
//================================================================================
class CBPHUDObjectSlot extends HUDObjectSlot;

function UpdateItemText ()
{
	local DeusExWeapon Z47;

	itemText="";
	if ( Item == None )
	{
		return;
	}
	Z47=DeusExWeapon(Item);
	if ( (Z47 != None) && (Z47.AmmoType != None) )
	{
		if ( Z47.IsA('WeaponNanoVirusGrenade') || Z47.IsA('WeaponGasGrenade') || Z47.IsA('WeaponEMPGrenade') || Z47.IsA('WeaponLAM') )
		{
			if ( Z47.AmmoType.AmmoAmount > 1 )
			{
				itemText=CountLabel @ string(Z47.AmmoType.AmmoAmount);
			}
		} else {
			if ( (Z47.AmmoName != Class'AmmoNone') &&  !Z47.bHandToHand && (Z47.ReloadCount != 0) )
			{
				itemText=Z47.AmmoType.beltDescription;
			}
		}
	} else {
		if ( Item.IsA('DeusExPickup') &&  !Item.IsA('NanoKeyRing') && (DeusExPickup(Item).NumCopies > 1) )
		{
			itemText=DeusExPickup(Item).CountLabel @ string(DeusExPickup(Item).NumCopies);
		}
	}
}

function DrawHUDIcon (GC GC)
{
	if ( (Item != None) && (Item.Icon != None) )
	{
		GC.SetStyle(DSTY_Masked);
		GC.SetTileColorRGB(255,255,255);
		GC.DrawTexture(slotIconX,slotIconY,slotFillWidth,slotFillHeight,0.00,0.00,Item.Icon);
	}
}
