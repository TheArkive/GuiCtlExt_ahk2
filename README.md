# GuiCtlExt_ahk2
GuiControl extensions for AHK v2 controls

```
Contributions:

AHK_user:
- ctl.SetCue() for Edit and ComboBox

just me:

```

## Picture Button

### Gui.AddPicButton(sOptions:="", sPicFile:="", sPicFileOpt:="", Text:="")

`sOptions` are the normal options you would specify for any `Gui` control when invoking `Gui.Add()`.

The sPicFile and sPicFileOpt parameters are the same as the first 2 parameters of LoadPicture().  For more info, see `ctl.SetImg()` below, or the AHK help files for LoadPicture().

Text is optional.

### ctl.SetImg(sFile, sOptions:="")
Sets or changes the image for a button.  Specify no text if you want an image button only.  Otherwise you will get the image and text.

sOptions is the same as `LoadPicture()`.

Example:  `Icon5 w32 h-1`

NOTE:  Specify `*w32 *h-1` to use filtering when scaling an image.

The type of image loaded is always auto-detected.

If you change a Button Pic image, then the previous image handle is automatically destroyed.

This method does not return a value.

### ctl.Type
Returns `"PicButton"`.

## SplitButton

### Gui.AddSplitButton(sOptions:="",sText:="",callback:="")

`sOptions` are the normal options you would specify for any `Gui` control when invoking `Gui.Add()`.

Callback format:

```
callback(ctl, coords) {
    msgbox ctl.name "`r`n" coords.x " / " coords.y
}
```

The `coords` parameter is an `{object}` with properties X and Y.  The X/Y is the client coords needed to properly position a menu for the split button.

### ctl.SetImg(sFile, sOptions:="")
Same as PicButton above.

### ctl.Type
Returns `"SplitButton"`.

## ToggleButton

### Gui.AddToggleButton(sOptions:="",sText:="")
`sOptions` are the normal options you would specify for any `Gui` control when invoking `Gui.Add()`.

`sText` is the button text, if any.  You can also use .SetImg() to make this toggle button a pic button as well.

### ctl.SetImg(sFile, sOptions:="")
Same as PicButton above.

## ListBox

### ctl.GetCount()
Returns number of items in Listbox or ComboBox drop window.

### ctl.GetText(row)
Gets the text of the specified row.

### ctl.GetItems()
Gets a linear array of all the items in the ListBox or ComboBox drop window.

## ComboBox

### ctl.GetCount()
Returns number of items in Listbox or ComboBox drop window.

### ctl.GetText(row)
Gets the text of the specified row.

### ctl.GetItems()
Gets a linear array of all the items in the ListBox or ComboBox drop window.

### ctl.CueText
Sets/Gets cue text for the ComboBox control.

## ListView

### ctl.Checked(row)
Returns true if checked, false if not, for specified row.

### ctl.IconIndex(row)
Returns the icon index for the row.  Note that the default index for all rows, even without an icon is 1.

### ctl.GetColWidth(col)
Returns the width of the specified column.

## Edit

### ctl.Append(text, top := false)
Appends text to the bottom of the edit control, unless `top := true`, then text is prepended.

### ctl.SetCueText(txt, Option := false)
Sets cue text and option.
If Option = true, then cue text will persist on control focus.
If Option = false, then cue text will disappear on control focus (default).

### ctl.CueText
Sets/Gets the cue text for the edit control.  The option described above in `.SetCueText()` is not changed.
