                ifndef _MACRO_SCROLL_
                define _MACRO_SCROLL_
; -----------------------------------------
; установка HL на Input.Scroll флаги
; In:
; Out:
; Corrupt:
; -----------------------------------------
SCROLL_FLAGS    macro
                LD HL, GameState.Input.Scroll
                endm
; -----------------------------------------
; прочитать значения Input.Scroll флагов в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
SCROLL_FLAGS_A  macro
                LD A, (GameState.Input.Scroll)
                endm
; -----------------------------------------
; проверка Input.Scroll флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_SCROLL_FLAG macro FlagBit?
                SCROLL_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка Input.Scroll флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_SCROLL_FLAGS macro Flags?
                SCROLL_FLAGS_A
                CHECK_FLAGS (Flags?)
                endm
; -----------------------------------------
; проверка Input.Scroll флага используя аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_SCROLL_FLAG_A macro FlagBit?
                SCROLL_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; установка Input.Scroll флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_SCROLL_FLAG macro FlagBit?
                SCROLL_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; сброс Input.Scroll флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_SCROLL_FLAG macro FlagBit?
                SCROLL_FLAGS
                RES_FLAG (FlagBit?)
                endm

                endif ; ~_MACRO_SCROLL_
