;=====================================================================

; typora代码块快捷键自动添加语言
; 适合windows+搜狗输入法，windows自带输入法不行
; 目前功能
;	可以实现typora的代码块自动添加语言，默认是java,下面可以通过 code_block自定义设置
;	代码块快捷键默认是Ctr+alt+k，可以修改想要修改可以通过下面代码实现
;		常用热键：Ctrl=^ alt=! 字母键=字母键，如 a=a
;		其他热键看官方文档：https://wyagd001.github.io/v2/docs/Hotkeys.htm
; 开销很小，占用内存2M左右，CPU几乎不占用。



;-------------修改区---------------
;生成代码块快捷键是Ctrl+R
^r:: settyporaIME()
;生成代码块快捷键是Ctrl+alt+k
;^!k:: settyporaIME()
;代码块的语言，默认java
code_block :="java"
;-------------修改区---------------




settyporaIME(){
	ProcessName := getProcessName()
	if InStr(ProcessName, "Typora.exe")
	{
		setIME("EN")
		Send Format("``````{1}{Enter}",code_block)
	}
	;return
}



getProcessName(WinTitle:="A"){
	try {
			ahkId := WinGetID(WinTitle)
	} catch Error {
		; ^Esc 开始菜单弹窗，会卡死在找不到当前窗口
		return
	}
	ProcessName := WinGetProcessName(ahkId)
	return ProcessName
}


setIME(language)
{
    Sleep 50 ; 等一等是为了承接窗口切换的缓冲
    if language == "中文" {
        if (hasIME() = 0) {
            Send "^{Space}"
            ToolTip "中"
        }
    } else if language == "EN" {
        if (hasIME() = 1) {
            Send "^{Space}"
            ToolTip "EN"
        }
    }
	SetCapsLockState 0
    Sleep 250 ; 悬浮提示（如有）0.25 秒后消失
    ToolTip
}

hasIME(WinTitle:="A")
{
    try {
        hWnd := WinGetID(WinTitle)
    } catch Error {
        ; ^Esc 开始菜单弹窗，会卡死在找不到当前窗口
        return
    }
    DetectHiddenWindows True
    result := SendMessage(
            0x283,  ; Message : WM_IME_CONTROL
            0x005,  ; wParam  : IMC_GETOPENSTATUS
            0,      ; lParam  ： (NoArgs)
            ,       ; Control ： (Window)
            "ahk_id " DllCall( "imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")
            )
    DetectHiddenWindows False
    return result
}
