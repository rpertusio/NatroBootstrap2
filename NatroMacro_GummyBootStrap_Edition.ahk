;Environment Controls
;///////////////////////////////////////////////////////////////////////////////////////////
#Requires Autohotkey v2.0
#SingleInstance Force
#Include BootstrapGUI/WebViewToo_Resources/WebView2.ahk
#Include BootstrapGUI/WebViewToo_Resources/WebViewToo.ahk

ScriptPID := DllCall("GetCurrentProcessId")
GroupAdd("ScriptGroup", "ahk_pid" ScriptPID)
;///////////////////////////////////////////////////////////////////////////////////////////

;Create the WebviewWindow/GUI
;///////////////////////////////////////////////////////////////////////////////////////////
MyWindow := WebviewWindow()
MyWindow.OnEvent("Close", (*) => ExitApp())
MyWindow.Load("BootstrapGUI/NatroGUI.html")
;MyWindow.Debug()
MyWindow.AddHostObjectToScript("ahkButtonClick", {func:WebButtonClickEvent})
MyWindow.AddHostObjectToScript("ahkCopyGlyphCode", {func:CopyGlyphCodeEvent})
MyWindow.AddHostObjectToScript("ahkTooltip", {func:WebTooltipEvent})
MyWindow.AddHostObjectToScript("ahkFormSubmit", {func:FormSubmitEvent})
MyWindow.Show("w1050 h650 Center", "Natro Macro (Gummy Boot(strap) Edition - CONCEPT)")
;///////////////////////////////////////////////////////////////////////////////////////////

;Hotkeys
;///////////////////////////////////////////////////////////////////////////////////////////
#HotIf WinActive("ahk_group ScriptGroup")
F1:: {
    MsgBox(MyWindow.Title)
    MyWindow.Title := "New Title!"
    MsgBox(MyWindow.Title)
}

F2:: {
    MyWindow.PostWebMessageAsString("Hello?")
}
#HotIf
;///////////////////////////////////////////////////////////////////////////////////////////

;Web Functions
;///////////////////////////////////////////////////////////////////////////////////////////
WebButtonClickEvent(button) {
    MsgBox(button)
}

CopyGlyphCodeEvent(title) {
	GlyphCode := "<span class='glyphicon glyphicon-" title "' aria-hidden='true'></span>"
	A_Clipboard := GlyphCode
	ClipWait(2)
	MsgBox(GlyphCode, "OuterHTML Copied to Clipboard")
}

WebTooltipEvent(WebView, Msg) {
    ToolTip(Msg)
    SetTimer((*) => ToolTip(), -1000)
}

FormSubmitEvent(source, form) {
    if (source = "webpage") {
        SetTimer((*) => FormSubmitEvent("ahk", form), -1)
    }
    else {
        formValues := MyWindow.GetFormData(form)
        MsgBox(formValues["inputEmail"])
        MsgBox(WebviewWindow.forEach(formValues, form))
    }
}
;///////////////////////////////////////////////////////////////////////////////////////////
