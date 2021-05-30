# GuiCtlExt_ahk2
GuiControl extensions for AHK v2 controls

## Button

### ctl.SetImg(sFile, sOptions:="")
Sets the image for a button.  Specify no text if you want an image button only.  Otherwise you will get the image and text.

sOptions is the same as `LoadPicture()`.

Example:  `Icon5 w32 h-1`

NOTE:  Specify `*w32 *h-1` to use filtering when scaling an image.

The type of image loaded is always auto-detected.

If you change a Button Pic image, then the previous image handle is automatically destroyed.

This method does not return a value.

### ctl.SetSplit(callback, def:=false)
Sets a button to a split button.  The specified callback is triggered when you click the down arrow on the split button.  You must specify a function object for the callback.  Specify `dev := true` to use style `BS_DEFSPLITBUTTON`.

Callback format:

```
callback(ctl, coords) {
    msgbox ctl.name "`r`n" coords.x " / " coords.y
}
```

The `coords` parameter is an `{object}` with properties X and Y.  The X/Y is the client coords needed to properly position a menu for the split button.

## ListBox and ComboBox

### ctl.GetCount()
Returns number of items in Listbox or ComboBox drop window.

### ctl.GetText(row)
Gets the text of the specified row.

### ctl.GetItems()
Gets a linear array of all the items in the ListBox or ComboBox drop window.

## ListView

### ctl.Checked(row)
Returns true if checked, false if not, for specified row.

### ctl.IconIndex(row)
Returns the icon index for the row.  Note that the default index for all rows, even without an icon is 1.

### ctl.GetColWidth(col)
Returns the width of the specified column.

