; AHK v2
#INCLUDE _GuiCtlExt.ahk
; #Include _JXON.ahk

Global g

IL := IL_Create(2) ; image lists for, ListView, Tabs
IL_Add(IL, "shell32.dll", 128)
IL_Add(IL, "shell32.dll", 129)
IL_Add(IL, "shell32.dll", 256)

g := Gui("-MinimizeBox -MaximizeBox","Test")
g.SetFont("s10","Consolas")
g.SetIcon("shell32.dll",20) ; one of the folder icons

g.OnEvent("close",gui_close)
g.OnEvent("escape",gui_close)

ctl := g.Add("ListView","+Report w210 h100 vLV Checked Icon2",["test"])
ctl.SetImageList(IL,1)
ctl.Add("check Icon3","Row1"), hwnd := ctl.hwnd
ctl.Add("icon1","Row2")
ctl.Opt("+Report")
ctl.ModifyCol()

list := ["ListBox Item 1","ListBox Item 2","ListBox Item 3","ListBox Item 4","ListBox Item 5","asdf","asdf","asdf","asdf","asdf"]
ctl := g.Add("ListBox","w200 h100 vLB Multi",list)
ctl.SelRange(2,4)       ; select a range
ctl.SelRange(3,5,false) ; deseelct a range
ctl.TopIndex := 3

list := ["ComboBox Item 1","ComboBox Item 2","ComboBox Item 3","ComboBox Item 4","AutoC Test","a","b","c","d","e","f","g","h","i","j","k"]
ctl := g.Add("ComboBox","x+10 yp w150 h100 vCB r5 Section",list)

ctl.CueText := "Test Cue Text"
ctl.AutoComplete := true
ctl.Text := "abcdefg"
ctl.SetSel(1,3) ; set selection

btn := g.AddPicButton("vPicBtn w50 h24","netshell.dll","Icon151 w20 h20","Test") ; 24 x 24
btn.OnEvent("click",gui_events)

btn := g.Add("Button","vData x+0","Show Data")
btn.OnEvent("Click",gui_events)

btn := g.AddSplitButton("vDropBtn1 xs h32 w80","Test",gui_events) ; here the callback is only for clicking the split down arrow
btn.OnEvent("click",gui_events) ; this is for when you click the "normal" part of the button
btn.SetImg("netshell.dll","Icon151 w20 h20")

btn := g.AddToggleButton("vToggleBtn w80 h32","Test")   ; Icons+Text on a ToggleButton don't seem to work with native AHK gui.
btn.OnEvent("click",gui_events)                         ; Remove button text to get a ToggleButton with an icon.
; btn.SetImg("netshell.dll","Icon151 w20 h20")            ; Maybe a different combo of buttons styles will work?

ctl := g.Add("Edit","xm w200 r1 vMyEdit1 -Wrap")

ctl.CueOption := 1                  ; do this first, if you want this option (cue visible even when ctl is focused)
ctl.CueText := "Test Cue Edit Text" ; then set the cue text, or use ctl.SetCueText(txt, opt) to set both txt and option

ctl := g.Add("Tab3","vTabs w210",["Tab1","Tab2"])
ctl.SetImageList(IL)

ctl.UseTab("Tab1")

g.Add("Button","vTabData","Tab Data").OnEvent("click",gui_events)
g.Add("Button","vTabName x+0","Change Tab Name").OnEvent("click",gui_events)
g.Add("Button","vNoTabIcon xm+10 y+0","Remove Icon").OnEvent("click",gui_events)
g.Add("Button","vTabIcon x+0","Add Icon").OnEvent("click",gui_events)

ctl.SetIcon(1,2), ctl.SetIcon(2,1)

ctl.UseTab()

g.show("")

gui_close(*) {
    ExitApp
}

gui_events(ctl, info) {
    Global g
    
    If (ctl.name = "DropBtn1") && IsObject(info) {
        m(info)
    } Else If (ctl.name = "DropBtn1") {
        msgbox "You clicked the button portion of the drop button.`r`n`r`nTry clicking the arrow."
    } Else If (ctl.Name = "PicBtn")
        msgbox "You clicked the pic btn."
    Else If (ctl.name = "Data") {
        LVr := 1 ; ListView row - change and experiment
        LBr := 2 ; ListBox row - change and experiment
        CBr := 3 ; ComboBox row - change and experiment
        
        LBi := "", CBi := "" ; ListBox / ComboBox items init
        
        For item in g["LB"].GetItems()
            LBi .= (LBi?"`r`n`t":"`t") item 
        
        For item in g["CB"].GetItems()
            CBi .= (CBi?"`r`n`t":"`t") item 
        
        MsgBox "ListView`r`n`r`n"
             . "`tIconIndex Row " LVr ": " g["LV"].IconIndex(LVr) "`r`n"
             . "`tChecked Row " LVr ": " (g["LV"].Checked(LVr)?"true":"false") "`r`n"
             . "`trow count: " g["LV"].GetCount() "`r`n"
             . "`tsecond row text:  " g["LV"].GetText(2) "`r`n`r`n" ; original LV.GetText() still works as expected
             
             . "ListBox`r`n`r`n"
             . "`tItemText Row " LBr ": " g["LB"].GetText(LBr) "`r`n" ; .GetText() method added to ListBox
             . "`tRow Count: " g["LB"].GetCount() "`r`n`r`n"
             . "`tItems:`r`n" LBI "`r`n`r`n"
             
             . "ComboBox`r`n`r`n"
             . "`tItemText Row " CBr ": " g["CB"].GetText(CBr) "`r`n"
             . "`tRow Count: " g["CB"].GetCount() "`r`n`r`n"
             . "`tItems:`r`n" CBi
    } Else If (ctl.name = "ToggleBtn") {
        Msgbox "Value: " ctl.Value
    } Else If (ctl.name = "TabData") {
        TB := ctl.gui["Tabs"]
        MsgBox "Tab 1`n"
             . "    Name: " TB.GetName(1) "`n"
             . "    Icon: " TB.GetIcon(1) "`n`n"
             . "Tab 2`n"
             . "    Name: " TB.GetName(2) "`n"
             . "    Icon: " TB.GetIcon(2)
    } Else If (ctl.name = "TabName") {
        TB := ctl.gui["Tabs"]
        TB.SetName(2,"Name Changed")
    } Else If (ctl.name = "NoTabIcon") {
        TB := ctl.gui["Tabs"]
        TB.SetIcon(2) ; no icon param, or specify 0
    } Else If (ctl.name = "TabIcon") {
        TB := ctl.gui["Tabs"]
        TB.SetIcon(2,1)
    }
}

m(coords) {
    me := Menu()
    me.Add("Item 1",m_event)
    me.Add("Item 2",m_event)
    me.Show(coords.x, coords.y)
}

m_event(item, pos, m) {
    msgbox "You clicked: " item
}

dbg(_in) { ; AHK v2
    Loop Parse _in, "`n", "`r"
        OutputDebug "AHK: " A_LoopField
}

F2::{
    btn := g.AddPicButton("vPicBtn w50 h24","netshell.dll","Icon151 w20 h20","Test") ; 24 x 24
    btn.OnEvent("click",gui_events)
}
F3::{
    p := g["PicBtn"].Destroy()
    msgbox g["PicBtn"].hwnd
}
F4::g["CB"].Show()
F5::{
    Global g
    c := g["CB"]
    
    ; c.Show()
    ; Sleep(100)
    ; dbg( jxon_dump(c.Test,4) )
    
    ; c.Opt("r10")
    
    c.ListHeight(10)
    
    ; c.GetPos(,,,&h)
    ; a := c.Test
    ; h2 := a[4] - a[2]
    ; msgbox H " / " h2
    
    ; c.Move(,,,c.ItemHeight(0) + ((c.ItemHeight()+0) * 10) + 2)
    ; msgbox Format("0x{:08X}",c.Style)
    
    ; Msgbox Format("0x{:08X}",c.Style)
    ; msgbox c.ItemHeight(0)
    ; Loop 5
        ; msgbox "Item " a_Index ": " c.ItemHeight(A_Index)
}



