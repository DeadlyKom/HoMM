
                ifndef _CONST_OBJECT_UI_
                define _CONST_OBJECT_UI_
; значения для поля FObjectUI.Flags
OBJECT_UI_HOVER_BIT         EQU 0x00                                            ; флаг, обрабатывать наведение на объект привязки

OBJECT_UI_HOVER             EQU 1 << OBJECT_UI_HOVER_BIT

                endif ; ~_CONST_OBJECT_UI_
