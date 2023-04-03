# GuiCtlExt_ahk2
GuiControl extensions for AHK v2 controls

```
Contributions:

AHK_user
iPhilip
just me
teadrinker

See comments in GuiCtlExt.ahk for details.

```

<br>


### *** WARNING *** WARNING *** WARNING ***
This script modifies the built-in Gui and several GuiControl objects.  Using this script in combination with other scripts that do the same is not recommended.  If methods / properties are unintentionally overwritten, there will be no error message or notification of any kind.

<br>

## Gui

### gui_obj.SetIcon(FileName := "Shell32.dll", Icon:=1)

Sets the icon for the dialog.

<br>


## GuiControl - applies to all controls

### ctl.Destroy()
Destroys the control.  However, this does not mean you can recreate the control with the same `vName`.  In most cases this will be the same as simply permanently hiding the control without the possibility to bring it back.  So this is not a "true" destruction, and memory is not spared.  Depending on how often you use this, it could constitute a memory leak.

### ctl.ExStyle
Gets/Sets an integer that represents the ExStyle for the control.

### ctl.Style
Gets/Sets an integer that represents the Style for the control.

<br>


## ComboBox

### ctl.AutoComplete
Enables or disables Auto-Complete.

### ctl.CueOption
Sets/Gets the cue text option.  Cue text, when set, is always displayed when the control is blank and not in focus.  The options below define this behavior further.

|Option|Effect|
|------|------|
|`0`|Cue text not displayed when the control has focus. (Default)|
|`1`|Cue text displayed even when the control has focus.|

Note that setting the cue option performs no action.  This value is only used when setting cue text with `ctl.CueText`.

Furthermore, when using `ctl.SetCueText()` this value is ignored, and only the specified Option value is used.

### ctl.CueText
Sets/Gets the cue text for the edit control.  Also see `ctl.SetCueText()` below.

### ctl.Dropped
Only gets the dropped state.  You can set or toggle the dropped state with `ctl.Show()`.

### ctl.FindItem(txt)
Returns the one-based index of the first item that matches `txt` in the list, starting from the beginning of the string.

### ctl.FindItemExact(txt)
Returns the one-based index of the item that is an exact match to `txt` in the list.

### ctl.GetCount()
Returns number of items in the list.

### ctl.GetItems()
Returns an array of all the items in the list.

### ctl.GetText(row)
Gets the text of the specified row in the list.

### ctl.Insert(row,txt)
Inserts an item at the specified row.  All items starting from the orignal row, are moved down.

### ctl.ItemHeight(row:=1)
When `row >= 1` this method returns the pixel height of that row item.  If you not using an owner-drawn ComboBox, then all items in your list are likely the same height.  If `row := 0`, then the height of the edit box is returned, without the borders.

### ctl.ItemLen(row)
Returns the number of characters in the string of the specified row in the list.

### ctl.ListHeight(items)
Sets/Changes the number of items to be shown in the list, effectively changing the height of the drop down list.

### ctl.SelEnd
Gets the end pos of the current selection.  This property may act as the "cursor position" when there is no selection.

### ctl.SelStart
Gets the start pos of the current selection.  This property may act as the "cursor position" when there is no selection.

### ctl.SelText
Gets the selected text.

### ctl.SetSel(start := 0, end := 0)
Sets the cursor position or selection, depending on usage.

Note that both start and end are zero based.

|Value(s)|Result|
|:--------:|------|
|`0,0 or *blank*` |Sets cursor to beginning of text.|
|`-1`|Cursor goes to end of selection, and selection is removed.|
|`0, -1`|Select all text.|
|`start, end`|Sets selection according to given values.|

If you enter the same number for both parameters, then the cursor is moved to that point in the text, and there is no selection.

### ctl.SetCueText(txt := "", Option := false)
Sets cue text and option.

See `ctl.CueOption` above for a description of what the Option does.

To clear the cue text, use `ctl.SetCueText()`.

### ctl.Show(show := true)
Shows or hides the drop down menu.

### ctl.TopIndex
Sets/Gets the index of the top visible item.

<br>


## Edit

### ctl.Append(text, top := false)
Appends text to the bottom of the edit control, unless `top := true`, then text is prepended.

### ctl.CueOption
Sets/Gets the cue text option.  Cue text, when set, is always displayed when the control is blank and not in focus.  The options below define this behavior further.

|Option|Effect|
|------|------|
|`0`|Cue text not displayed when the control has focus. (Default)|
|`1`|Cue text displayed even when the control has focus.|

Note that setting the cue option performs no action.  This value is only used when setting cue text with `ctl.CueText`.

Furthermore, when using `ctl.SetCueText()` this value is ignored, and only the specified Option value is used.

### ctl.CueText
Sets/Gets the cue text for the edit control.  Also see `ctl.SetCueText()` below.

### ctl.Length
Returns the number of characters in the control.  Don't confuse this for the number of bytes the text occupies in memory.

### ctl.GoEnd()
Puts the cursor at the end of text.

This is the same as `ctl.SetSel(this.Length, this.Length)`

### ctl.GoStart()
Put the cursor at the beginning of text.

This is the same as `ctl.SetSel()` or `ctl.SetSel(0, 0)`

### ctl.GoSelEnd()
Puts the cursor at the end of the selection and removes the selection.

This is the same as `ctl.SetSel(ctl.SelEnd, ctl.SelEnd)`

### ctl.GoSelStart()
Puts the cursor at the beginning of the selection and removes the selection.

This is the same as `ctl.SetSel(ctl.SelStart, ctl.SelStart)`

### ctl.Length
Returns the number of characters in the EditBox.

### ctl.ReplaceSel(txt := "", undo := true)
Replaces selection with specified text.

By default undo is TRUE, thus allowing the action to be undone.  Set `undo := false` to prevent the action from being undone.

### ctl.SelEnd
Gets the end pos of the current selection.  This property may act as the "cursor position" when there is no selection.

### ctl.SelStart
Gets the start pos of the current selection.  This property may act as the "cursor position" when there is no selection.

### ctl.SelText
Gets the selected text.

### ctl.SetCueText(txt := "", Option := false)
Sets cue text and option.

See `ctl.CueOption` above for a description of what the Option does.

To clear the cue text, use `ctl.SetCueText()`.

### ctl.SetSel(start := 0, end := 0)
Sets the cursor position or selection, depending on usage.

Note that both start and end are zero based.

|Value(s)|Result|
|:--------:|------|
|`0, 0 or *blank*` |Sets cursor to beginning of text.|
|`-1`|Cursor goes to end of selection, and selection is removed.|
|`0, -1`|Select all text.|
|`start, end`|Sets selection according to given values.|

If you enter 2 of the same number for both parameters, then the cursor is moved to that point in the text, and there is no selection.

<br>


## ListBox

### ctl.GetCount()
Returns number of items in Listbox or ComboBox drop window.

### ctl.GetText(row)
Gets the text of the specified row.

### ctl.GetItems()
Gets a linear array of all the items in the ListBox or ComboBox drop window.

### ctl.Insert(row,txt)
Inserts an item at the specified row.  All items starting from the orignal row, are moved down.

### ctl.ItemLen(row)
Returns the number of characters in the string of the specified row/index in the list.

### ctl.SelAll(sel := true)
Selects all items.  If `sel := false` all items are deselected.

### ctl.SelRange(start, end, sel := true)
Selects the specified range of items.  If `sel := false` then the specified range is deselected.

### ctl.TopIndex
Sets/Gets the index of the top visible item.

<br>


## ListView

### ctl.Checked(row)
Returns true if checked, false if not, for specified row.

### ctl.IconIndex(row)
Returns the icon index for the row.  Note that the default index for all rows, even without an icon is 1.

### ctl.GetColWidth(col)
Returns the width of the specified column.

<br>


## Picture Button

### Gui.AddPicButton(sOptions := "", sPicFile := "", sPicFileOpt := "", Text := "")

`sOptions` are the normal options you would specify for any `Gui` control when invoking `Gui.Add()`.

The sPicFile and sPicFileOpt parameters are the same as the first 2 parameters of LoadPicture().  For more info, see `ctl.SetImg()` below, or the AHK help files for LoadPicture().

Text is optional.

### ctl.SetImg(sFile, sOptions := "")
Sets or changes the image for a button.  Specify no text if you want an image button only.  Otherwise you will get the image and text.

sOptions is the same as `LoadPicture()`.

Example:  `Icon5 w32 h-1`

NOTE:  Specify `*w32 *h-1` to use filtering when scaling an image.

The type of image loaded is always auto-detected.

If you change a Button Pic image, then the previous image handle is automatically destroyed.

This method does not return a value.

### ctl.Type
Returns `"PicButton"`.

<br> 


## SplitButton

### Gui.AddSplitButton(sOptions := "", sText := "", callback := "")

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

<br>


## Tab

### ctl.GetCount()
Returns the number of tabs.

### ctl.GetIcon(tab_num)
Returns the index of the icon for the specified tab, or 0 if no icon.

### ctl.GetItems()
Returns an array of tab names.

### ctl.GetName(tab_num, bSize:=128)
Returns the name/text for the specified tab.

Note that by default only the first 128 characters of the tab name will be returned.  If you need more characters than that, you can use the 2nd parameter.

Don't forget to properly calculate your string size with a NULL terminator.

### ctl.Insert(pos, name:="", icon:="")
Inserts a tab at specified position.  Name/Text and Icon are optional.  The tab originally in `pos` is moved to the right, along with all other tabs to the rigth of `pos`.

### ctl.RowCount
Returns the current number of tab rows.

### ctl.SetIcon(tab_num,icon:=0)
Sets or removes the icon for the specified tab.  Specify `0` for the 2nd parameter, or omit it to remove the specified tab icon.

### ctl.SetImageList(hList)
Sets the specified image list created with `IL_Create()` so that icons can be added to tabs.

### ctl.SetName(tab_num,name:="")
Sets or removes the name/text for the specified tab.  Specify `""` for the 2nd parameter, or omit it to remove the specified tab name/text.

<br>


## ToggleButton

### Gui.AddToggleButton(sOptions := "", sText := "")
`sOptions` are the normal options you would specify for any `Gui` control when invoking `Gui.Add()`.

`sText` is the button text, if any.  You can also use .SetImg() to make this toggle button a pic button as well.

<br>



