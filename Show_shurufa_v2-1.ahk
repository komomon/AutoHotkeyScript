;=====================================================================
; 白名单版
; 适合windows+搜狗输入法，windows自带输入法不行
; 目前功能
;	可以实现typora的代码块自动添加语言，默认是java,下面可以通过 code_block自定义设置
;	代码块快捷键默认是Ctr+alt+k，可以修改想要修改可以通过下面代码实现
;		常用热键：Ctrl=^ alt=! 字母键=字母键，如 a=a
;		其他热键看官方文档：https://wyagd001.github.io/v2/docs/Hotkeys.htm
; 	鼠标指向输入框变成工字型或者按shift键的时候，会提示当前输入法的是中文还是英文，显示时间为1s
; 	输入法默认也是只有在输入状态时按shift才会切换。
; 	做了白名单的限制，只在Typora wps word vscode idea Pycharm上显示
; 开销很小，占用内存2M左右，CPU几乎不占用。

;-------------修改区---------------
~Shift up:: ShowShiftIME()
;主鼠标按钮，默认是左键
~LButton up:: ShowButtonIME()
;生成代码块快捷键是Ctrl+R
^r:: settyporaIME()
;生成代码块快捷键是Ctrl+alt+k
;^!k:: settyporaIME()
;代码块的语言，默认java
code_block :="java"
;-------------修改区---------------







settyporaIME(){
	global code_block
	ProcessName := getProcessName()
	if InStr(ProcessName, "Typora.exe")
	{	
		setIME("EN")
		Send Format("``````{1}{Enter}",code_block)
		;SendText "java"
		;Send ^{Space}
	}
	;return
}

ShowShiftIME(){
	;Sleep 20
	ToolTip
	If  (A_Cursor = "IBeam" ) {
		Edit_Mode := 1
	} else if(A_Cursor = "Arrow" ) {
	   Edit_Mode := 0
	} else {
	   Edit_Mode := 0
	}
	; wps不太行所以剔除
	if ( Edit_Mode = 1){
		ProcessName := getProcessName()
			Software_Array := ["Typora.exe", "WINWORD.exe","Code.exe","idea64.exe","Pycharm.exe","idea.exe","pycharm64.exe"]
			For value in Software_Array
				if InStr(ProcessName, value){
					If (hasIME()=1){
						ToolTip "中"
						SetTimer () => ToolTip(), -1000
					}
					else{
						ToolTip "EN"
						SetTimer () => ToolTip(), -1000

					}
				}
	}
	return

}

ShowButtonIME(){
	ToolTip
	; 光标类型https://blog.csdn.net/liuyukuan/article/details/82291632
	;IBEAM 工字光标 ARROW 标准的箭头
	If  (A_Cursor = "IBeam" ) {
		Edit_Mode := 1
	} else if(A_Cursor = "Arrow" ) {
	   Edit_Mode := 0
	} else {
	   Edit_Mode := 0
	}
	try{
		if ( Edit_Mode = 1){
			ProcessName := getProcessName()
			Software_Array := ["Typora.exe", "WINWORD.exe","Code.exe","idea64.exe","Pycharm.exe","idea.exe","pycharm64.exe"]
			For value in Software_Array
				if InStr(ProcessName, value){
					If (hasIME()=1){
						ToolTip "中"
						SetTimer () => ToolTip(), -1000
					}
					else{
						ToolTip "EN"
						SetTimer () => ToolTip(), -1000

					}
				}
		}
	}
	return

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
            ;ToolTip "zh"
        }
    } else if language == "EN" {
        if (hasIME() = 1) {
            Send "^{Space}"
            ;ToolTip "EN"
        }
    }
	SetCapsLockState 0
	SetTimer () => ToolTip(), -1000
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
