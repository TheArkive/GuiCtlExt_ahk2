; ==================================================================
; **** WARNING *** WARNING *** WARNING *** WARNING *** WARNING ****
;
; This script adds modifications to original built-in GUI and
; GuiControl-related objects.  If you combine this script with
; another script that does the same thing, you will likely get
; unpredictable results.  Especially in the case of methods /
; properties being mistakenly overwritten, no error messages will be
; generated.
;
; It is not recommended to use this script in combination with other
; scripts that also modify the Gui and GuiControl objects.
; ==================================================================
; GuiControl_Ext
; ==================================================================

; class GuiCtl_Ext extends Gui.Control { ; apply common stuff to other gui controls
    ; Static __New() {
        ; For p in this.Prototype.OwnProps() 
            ; (p!="__Class") ? super.Prototype.DefineProp(p,this.Prototype.GetOwnPropDesc(p)) : ""
    ; }
; }

class ComboBox_Ext extends Gui.ComboBox { ; also has GetItems() method
    Static __New() {
        super.Prototype._CurCueText := ""
        For p in this.Prototype.OwnProps() 
            (p!="__Class") ? super.Prototype.DefineProp(p,this.Prototype.GetOwnPropDesc(p)) : ""
        
        super.Prototype.DefineProp("CueText",{Get:this.Prototype._CueText,Set:this.Prototype._CueText})
        
        super.Prototype.DefineProp("SelText",{Get:this.Prototype._SelText.Bind(,0x140,"sel")})
        super.Prototype.DefineProp("SelStart",{Get:this.Prototype._SelText.Bind(,0x140,"start")})
        super.Prototype.DefineProp("SelEnd",{Get:this.Prototype._SelText.Bind(,0x140,"end")})
        
        super.Prototype.AutoComplete := false
    }
    
    GetCount() => SendMessage(0x146, 0, 0, this.hwnd) ; CB_GETCOUNT
    
    GetItems() {
        result := []
        Loop this.GetCount()
            result.Push(this.GetText(A_Index))
        return result
    }
    
    GetText(row) => this._GetString(0x149,0x148,row) ; 0x149 > CB_GETLBTEXTLEN // 0x148 > CB_GETLBTEXT
    
    SetSel(start:="",end:="") {
        result := this._SetSel(start,end)
        dword := (result[1] | (result[2] << 16))
        SendMessage(0x142, 0, dword, this.hwnd) ; CB_SETEDITSEL
    }
    
    _CueText(p*) { ; thanks to AHK_user and iPhilip for this one: https://www.autohotkey.com/boards/viewtopic.php?p=426941#p426941
        If !p.Length
            return this._CurCueText
        Else SendMessage(0x1703, 0, StrPtr(this._CurCueText:=p[1]), this.hwnd)
    }
    
    _GetString(getLen_msg,get_msg,row) {
        size := SendMessage(getLen_msg, row-1, 0, this.hwnd) ; GETTEXTLEN
        buf := Buffer( (size+1) * (StrLen(Chr(0xFFFF))?2:1), 0 )
        SendMessage(get_msg, row-1, buf.ptr, this.hwnd) ; GETTEXT
        return StrGet(buf)
    }
    
    _SetSel(start,end) {
        If (start="")
            start := this.SelStart
        If (end="")
            (start=-1) ? (start := end := StrLen(this.Text)) : (start=0) ? (end := 0) : (end := start)
        If !IsInteger(start) || !IsInteger(end)
            throw Error("Invalid value.  Only integers are accepted.")
        return [start,end]
    }
    
    _SelText(p*) {
        dword := SendMessage(p[1],0,0,this.hwnd) ; CB_GETEDITSEL
        range := [start := (dword & 0xFFFF), end := ((dword >> 16) & 0xFFFF)]
        
        result := ""
        Switch p[2] {
            Case "sel": result := SubStr(this.Text,range[1]+1,range[2]-range[1])
               Default: result := (p[2]="start")?start:end
        }
        return result
    }
    
    check_match(t:=false) {
        For i, val in this.GetItems()
            If (InStr(val,(t?this.temp_value:this.Text))=1 && (t?this.temp_value:this.Text))
                return val
    }
}

class Edit_Ext extends Gui.Edit {
    Static __New() {
        super.Prototype._CurCueText := "" ; for easy get/read
        super.Prototype._CueOption := false
        For p in this.Prototype.OwnProps()
            (p!="__Class") ? super.Prototype.DefineProp(p,this.Prototype.GetOwnPropDesc(p)) : ""
        
        super.Prototype.DefineProp("CueText",{Get:this.Prototype._CueText,Set:this.Prototype._CueText})
        
        super.Prototype.DefineProp("SelText",{Get:this.Prototype._SelText.Bind(,0xB0,"sel")}) ; this is also caret position
        super.Prototype.DefineProp("SelStart",{Get:this.Prototype._SelText.Bind(,0xB0,"start")})
        super.Prototype.DefineProp("SelEnd",{Get:this.Prototype._SelText.Bind(,0xB0,"end")})
        ; super.Prototype.DefineProp("Length",{Get:(*)=>StrLen(this.Prototype.Value)})
    }
    
    Append(txt, top := false) {
        txtLen := SendMessage(0x000E, 0, 0,,this.hwnd)           ;WM_GETTEXTLENGTH
        pos := (!top) ? txtLen : 0
        SendMessage(0x00B1, pos, pos,,this.hwnd)           ;EM_SETSEL
        SendMessage(0x00C2, False, StrPtr(txt),,this.hwnd)    ;EM_REPLACESEL
    }
    
    SetCueText(txt,option:=false) => ; option=1 > show cue even when control has focus
        SendMessage(0x1501, this._CueOption:=option, StrPtr(this._CurCueText:=txt), this.hwnd)
    
    SetSel(start:="",end:="") {
        result := this._SetSel(start,end)
        SendMessage(0xB1, result[1], result[2], this.hwnd) ; EM_SETSEL
    }
    
    _CueText(p*) { ; thanks to AHK_user and iPhilip for this one: https://www.autohotkey.com/boards/viewtopic.php?p=426941#p426941
        If !p.Length
            return this._CurCueText
        Else If (p.Length = 2)
            SendMessage(0x1501, (this._CueOption := (p[2]?p[2]:0)), StrPtr(this._CurCueText:=p[1]), this.hwnd)
    }
    
    _SetSel(start,end) {
        If (start="")
            start := this.SelStart
        If (end="")
            (start=-1) ? (start := end := StrLen(this.Text)) : (start=0) ? (end := 0) : (end := start)
        If !IsInteger(start) || !IsInteger(end)
            throw Error("Invalid value.  Only integers are accepted.")
        return [start,end]
    }
    
    _SelText(p*) {
        dword := SendMessage(p[1],0,0,this.hwnd) ; CB_GETEDITSEL
        range := [start := (dword & 0xFFFF), end := ((dword >> 16) & 0xFFFF)]
        
        result := ""
        Switch p[2] {
            Case "sel": result := SubStr(this.Text,range[1]+1,range[2]-range[1])
               Default: result := (p[2]="start")?start:end
        }
        return result
    }
}

class ListBox_Ext extends Gui.ListBox { ; also has GetItems() method
    Static __New() {
        For p in this.Prototype.OwnProps()
            (p!="__Class") ? super.Prototype.DefineProp(p,this.Prototype.GetOwnPropDesc(p)) : ""
    }
    
    GetCount() => (SendMessage(0x018B, 0, 0, this.hwnd)) ; LB_GETCOUNT
    
    GetText(row) => this._GetString(0x18A,0x189,row) ; 0x18A > LB_GETTEXTLEN // 0x189 > LB_GETTEXT
    
    GetItems() {
        result := []
        Loop this.GetCount()
            result.Push(this.GetText(A_Index))
        return result
    }
    
    _GetString(getLen_msg,get_msg,row) {
        size := SendMessage(getLen_msg, row-1, 0, this.hwnd) ; GETTEXTLEN
        buf := Buffer( (size+1) * (StrLen(Chr(0xFFFF))?2:1), 0 )
        SendMessage(get_msg, row-1, buf.ptr, this.hwnd) ; GETTEXT
        return StrGet(buf)
    }
}

class ListView_Ext extends Gui.ListView { ; Technically no need to extend classes unless
    Static __New() { ; you are attaching new base on control creation.
        For p in this.Prototype.OwnProps()
            (p!="__Class") ? super.Prototype.DefineProp(p,this.Prototype.GetOwnPropDesc(p)) : ""
    }
    
    Checked(row) => ; This was taken directly from the AutoHotkey help files.
        (SendMessage(4140,row-1,0xF000,, "ahk_id " this.hwnd) >> 12) - 1 ; VM_GETITEMSTATE = 4140 / LVIS_STATEIMAGEMASK = 0xF000
    
    IconIndex(row,col:=1) { ; from "just me" LV_EX ; Link: https://www.autohotkey.com/boards/viewtopic.php?f=76&t=69262&p=298308#p299057
        LVITEM := Buffer((A_PtrSize=8)?56:40, 0)                   ; create variable/structure
        NumPut("UInt", 0x2, "Int", row-1, "Int", col-1, LVITEM.ptr, 0)  ; LVIF_IMAGE := 0x2 / iItem (row) / column num
        NumPut("Int", 0, LVITEM.ptr, (A_PtrSize=8)?36:28)               ; iImage
        SendMessage(StrLen(Chr(0xFFFF))?0x104B:0x1005, 0, LVITEM.ptr,, "ahk_id " this.hwnd) ; LVM_GETITEMA/W := 0x1005 / 0x104B
        return NumGet(LVITEM.ptr, (A_PtrSize=8)?36:28, "Int")+1 ;iImage
    }
    
    GetColWidth(n) => SendMessage(0x101D, n-1, 0, this.hwnd)
}

class PicButton extends Gui.Button {
    Static __New() {
        Gui.Prototype.AddPicButton := this.AddPicButton
    }
    
    Static AddPicButton(sOptions:="",sPicFile:="",sPicFileOpt:="",txt:="") {
        ctl := this.Add("Button",sOptions,txt)
        ctl.base := PicButton.Prototype
        ctl.SetImg(sPicFile, sPicFileOpt)
        return ctl
    }
    
    SetImg(sFile, sOptions:="") { ; input params exact same as first 2 params of LoadPicture()
        Static ImgType := 0       ; thanks to teadrinker: https://www.autohotkey.com/boards/viewtopic.php?p=299834#p299834
        Static BS_ICON := 0x40, BS_BITMAP := 0x80, BM_SETIMAGE := 0xF7
        
        hImg := LoadPicture(sFile, sOptions, &_type)
        If !this.Text ; thanks to "just me" for advice on getting text and images to display
            ControlSetStyle (ControlGetStyle(this.hwnd) | (!_type?BS_BITMAP:BS_ICON)), this.hwnd
        hOldImg := SendMessage(BM_SETIMAGE, _type, hImg, this.hwnd)
        
        If (hOldImg)
            (ImgType) ? DllCall("DestroyIcon","UPtr",hOldImg) : DllCall("DeleteObject","UPtr",hOldImg)
        
        ImgType := _type ; store current img type for next call/release
    }
    
    Type => "PicButton"
}

class SplitButton extends Gui.Button {
    Static __New() {
        super.Prototype.SetImg := PicButton.Prototype.SetImg
        Gui.Prototype.AddSplitButton := this.AddSplitButton
    }
    
    Static AddSplitButton(sOptions:="",sText:="",callback:="") {
        Static BS_SPLITBUTTON := 0xC
        
        ctl := this.Add("Button",sOptions,sText)
        ctl.base := SplitButton.Prototype
        
        ControlSetStyle (ControlGetStyle(ctl.hwnd) | BS_SPLITBUTTON), ctl.hwnd
        If callback
            ctl.callback := callback
          , ctl.OnNotify(-1248, ObjBindMethod(ctl,"DropCallback"))
            
        return ctl
    }
    
    Drop() => this.DropCallback(this,0)
    
    DropCallback(ctl, lParam) {
        ctl.GetPos(&x,&y,,&h)
        f := this.callback, f(ctl,{x:x, y:y+h})
    }
    
    Type => "SplitButton"
}

class StatusBar_Ext extends Gui.StatusBar {
    Static __New() {
        For p in this.Prototype.OwnProps()
            (p!="__Class") ? super.Prototype.DefineProp(p,this.Prototype.GetOwnPropDesc(p)) : ""
    }
    
    RemoveIcon(part:=1) {
        hIcon := SendMessage(0x414, part-1, 0, this.hwnd)
        If hIcon
            SendMessage(0x40F, part-1, 0, this.hwnd)
        return DllCall("DestroyIcon","UPtr",hIcon)
    }
}

; TCIF_IMAGE := 0x2
; TCIF_PARAM := 0x8
; TCIF_RTLREADING := 0x4
; TCIF_STATE := 0x10
; TCIF_TEXT := 0x1

; typedef struct tagTCITEMA { x86 / x64
  ; UINT   mask;            ;    0 /  0
  ; DWORD  dwState;         ;    4 /  4
  ; DWORD  dwStateMask;     ;    8 /  8
  ; LPSTR  pszText;         ;   12 / 16
  ; int    cchTextMax;      ;   16 / 24
  ; int    iImage;          ;   20 / 28
  ; LPARAM lParam;          ;   24 / 32
; } TCITEMA, *LPTCITEMA; size = 28 / 40

class Tab_Ext extends Gui.Tab {
    Static __New() {
        For p in this.Prototype.OwnProps()
            (p!="__Class") ? super.Prototype.DefineProp(p,this.Prototype.GetOwnPropDesc(p)) : ""
        super.Prototype.DefineProp("a",{Value:A_Is64BitOS})
        super.Prototype.DefineProp("u",{Value:StrLen(Chr(0xFFFF))})
    }
    
    GetCount() => SendMessage(0x1304, 0, 0, this.hwnd) ; TCM_GETITEMCOUNT
    
    GetIcon(tab_num) => this._GetItem(tab_num-1).Icon+1 ; gets icon index in ImgList
    
    GetItems() { ; returns array of tab names
        o := []
        Loop this.GetCount()
            o.Push(this.GetName(A_Index))
        return o
    }
    
    GetName(tab_num) => StrGet(this._GetItem(tab_num-1).Text)
    
    Insert(pos, name:="", icon:="") { ; TCM_INSERTITEM := 0x133E / TCM_INSERTITEMA := 0x1307
        TCITEM := Tab_Ext.TCITEM(), TCITEM.mask := 0x3 ; TCIF_TEXT | TCIF_IMAGE := 0x3
        TCITEM.Text := StrPtr(name), TCITEM.Icon := icon-1
        SendMessage(this.u?0x133E:0x1307,pos-1,TCITEM.ptr,this.hwnd)
    }
    
    RowCount => SendMessage(0x132C, 0, 0, this.hwnd) ; TCM_GETROWCOUNT
    
    SetIcon(tab_num,icon:=0) {
        TCITEM := Tab_Ext.TCITEM(), TCITEM.mask := 2 ; TCIF_IMAGE:=2
        TCITEM.Icon := icon-1, this._SetItem(tab_num-1,TCITEM)
    }
    
    SetImageList(hList) => SendMessage(0x1303, 0, hList, this.hwnd) ; TCM_SETIMAGELIST
    
    SetName(tab_num, name:="") {
        If (StrLen(name) > 127) ; not ideal, but seems to be necessary
            throw Error("Tab name too long.",-1)
        TCITEM := Tab_Ext.TCITEM(), TCITEM.mask := 1, TCITEM.Text := StrPtr(name) ; TCIF_TEXT:=1
        this._SetItem(tab_num-1,TCITEM)
    }
    
    _GetItem(i) { ; TCM_GETITEM := 0x133C / TCM_GETITEMA := 0x1305
        If i >= this.GetCount()
            throw Error("Invalid tab specified.`n`nSpecified: " (i+1),-1,"Max tabs: " this.GetCount())
        TCITEM := Tab_Ext.TCITEM(), TCITEM.mask := 0x3 ; get text and icon index
        return SendMessage(this.u?0x133C:0x1305,i,TCITEM.ptr,this.hwnd) ? TCITEM : ""
    }
    
    _SetItem(i,TCITEM) { ; TCM_SETITEM := 0x133D / TCM_SETITEMA := 0x1306
        SendMessage(this.u?0x133D:0x1306,i,TCITEM.ptr,this.hwnd)
        this.Redraw() ; this is needed, otherwise controls sometimes disappear
    }
    
    class TCITEM { ; props: dwState, dwStateMask, pszText, cchTextMax, iImage, lParam
        __New(ptr:=0) {
            Static a := A_Is64BitOS
            Static obj := {mask:{o:0,t:"UInt"}, dwState:{o:4,t:"UInt"}, dwStateMask:{o:8,t:"UInt"}, Text:{o:(!a?12:16),t:"UPtr"}
                         , cchTextMax:{o:(!a?16:24),t:"Int"}, Icon:{o:(!a?20:28),t:"Int"}, lParam:{o:(!a?24:32),t:"UPtr"}}
            buf := (ptr ? {ptr:ptr} : Buffer((!a?28:40),0)), this.DefineProp("buf",{Value:buf})
            this.DefineProp("f",{Value:obj}), this.DefineProp("ptr",{Value:this.buf.ptr})
            textBuf := Buffer(128,0), this.DefineProp("textBuf",{Value:textBuf})
            this.cchTextMax := 128, this.Text := textBuf.ptr
        }
        __Get(n,p) => NumGet(this.ptr,this.f.%n%.o,this.f.%n%.t)
        __Set(n,p,Value) => NumPut(this.f.%n%.t, Value, this.ptr, this.f.%n%.o)
        __Delete() => (this.textBuf := "") ; clean up text buffer, avoid memory leak
    }
}

class ToggleButton extends Gui.Checkbox {
    Static __New() {
        super.Prototype.SetImg := PicButton.Prototype.SetImg
        Gui.Prototype.AddToggleButton := this.AddToggleButton
    }
    
    Static AddToggleButton(sOptions:="",sText:="") {
        ctl := this.Add("Checkbox",sOptions " +0x1000",sText)
        ctl.base := ToggleButton.Prototype
        return ctl
    }
    
    Type => "ToggleButton"
}

; ==================================================================
; Gui_Ext
; ==================================================================

class Gui_Ext extends Gui {
    Static __New() {
        Gui.Prototype := this.Prototype
    }
    Add(p*) {
        ctl := super.Add(p*)
        
        If (p[1] = "ComboBox") {
            ctl.temp_value := ""
            ctl.OnEvent("change",AutoCompCb)
            OnMessage(0x102,ComboChar) ; WM_CHAR
        }
        
        return ctl
        
        AutoCompCb(ctl, info) {
            If ctl.temp_value { ; temp_value
                ctl.Text := ctl.temp_value
                If (match := ctl.check_match()) {
                    ctl.Text := match
                    ctl.SetSel(StrLen(ctl.temp_value),0xFFFF)
                }
            }
        }
        
        ComboChar(wParam, lParam, msg, hwnd) { ; WM_CHAR callback
            ctl := GuiCtrlFromHwnd(hwnd)
            If (ctl.Type = "ComboBox" && ctl.AutoComplete) {
                start := SubStr(ctl.Text,1,ctl.SelStart)
                end   := SubStr(ctl.Text,ctl.SelEnd+1)
                sel   := ctl.SelText
                
                If (char := (wParam=8) ? "" : Chr(wParam)) {
                    ctl.temp_value := (ctl.SelStart=0 && ctl.Text!=ctl.SelText) ? (sel char) : (start char end)
                    ctl.temp_value := (!ctl.check_match(true)) ? "" : ctl.temp_value
                } Else ctl.temp_value := ""
            } ; dbg("temp_value: '" ctl.temp_value "' / do_select: " ctl.do_select " / selStart: " ctl.SelStart " / selEnd: " ctl.SelEnd)
        }
    }
    
    SetIcon(FileName := "Shell32.dll", Icon:=1) => ; SendMsg 2nd param, 1 means ICON_BIG (vs. 0 for ICON_SMALL).
		SendMessage(0x0080, 0, LoadPicture(FileName, "Icon" Icon " w" 32 " h" 32, &imgtype), this.hwnd) ; 0x0080 is WM_SETICON

    Type => "Gui"
}
