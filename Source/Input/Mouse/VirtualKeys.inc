
                ifndef _INPUT_MOUSE_VIRTUAL_KEYS_
                define _INPUT_MOUSE_VIRTUAL_KEYS_
; -----------------------------------------
;   виртуальные кнопки мыши
; -----------------------------------------
SVK_LBUTTON_BIT EQU 0x00
SVK_RBUTTON_BIT EQU 0x01
SVK_MBUTTON_BIT EQU 0x02

SVK_LBUTTON     EQU 1 << SVK_LBUTTON_BIT
SVK_RBUTTON     EQU 1 << SVK_RBUTTON_BIT
SVK_MBUTTON     EQU 1 << SVK_MBUTTON_BIT

VK_LBUTTON      EQU KEMPSTON_MOUSE | (SVK_LBUTTON << KEMPSTON_MOUSE_SHIFT)
VK_RBUTTON      EQU KEMPSTON_MOUSE | (SVK_RBUTTON << KEMPSTON_MOUSE_SHIFT)
VK_MBUTTON      EQU KEMPSTON_MOUSE | (SVK_MBUTTON << KEMPSTON_MOUSE_SHIFT)
SVK_BUTTON_MASK EQU SVK_LBUTTON | SVK_RBUTTON | SVK_MBUTTON

; -----------------------------------------
;   флаги границ
; -----------------------------------------
LEFT_EDGE       EQU 0x01
RIGHT_EDGE      EQU 0x02
TOP_EDGE        EQU 0x04
BOTTOM_EDGE     EQU 0x08

                endif ; ~_INPUT_MOUSE_VIRTUAL_KEYS_
