                ifndef _MACRO_VIEW_
                define _MACRO_VIEW_
; -----------------------------------------
; установка HL на View флаги
; In:
; Out:
; Corrupt:
; -----------------------------------------
VIEW_FLAGS      macro
                LD HL, GameState.View
                endm
; -----------------------------------------
; прочитать значения View флагов в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
VIEW_FLAGS_A    macro
                LD A, (GameState.View)
                endm
VIEW_FLAGS_A_SAVE  macro
                LD (GameState.View), A
                endm
; -----------------------------------------
; проверка View флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_VIEW_FLAG macro FlagBit?
                VIEW_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка View флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_VIEW_FLAGS macro Flags?
                VIEW_FLAGS_A
                CHECK_FLAGS (Flags?)
                endm
; -----------------------------------------
; проверка View флага используя аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_VIEW_FLAG_A macro FlagBit?
                VIEW_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; установка View флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_VIEW_FLAG   macro FlagBit?
                VIEW_FLAGS
                SET_FLAG (FlagBit?)
                endm
SET_VIEW_FLAG_A macro FlagBit?
                VIEW_FLAGS_A
                SET_FLAG_A (FlagBit?)
                VIEW_FLAGS_A_SAVE
                endm
; -----------------------------------------
; сброс View флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_VIEW_FLAG   macro FlagBit?
                VIEW_FLAGS
                RES_FLAG (FlagBit?)
                endm

                endif ; ~_MACRO_VIEW_
