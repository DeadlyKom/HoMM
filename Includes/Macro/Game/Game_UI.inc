
                ifndef _MACRO_GAME_UI_
                define _MACRO_GAME_UI_
; -----------------------------------------
; установка HL на Input флаги
; In:
; Out:
; Corrupt:
; -----------------------------------------
UI_FLAGS        macro
                LD HL, GameState.UIRuntime + FUIRuntime.Flags
                endm
; -----------------------------------------
; прочитать значения Input флагов в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
UI_FLAGS_A      macro
                LD A, (GameState.UIRuntime + FUIRuntime.Flags)
                endm
; -----------------------------------------
; проверка Input флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_UI_FLAG   macro FlagBit?
                UI_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка Input флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_UI_FLAGS  macro Flags?
                UI_FLAGS_A
                CHECK_FLAGS (Flags?)
                endm
; -----------------------------------------
; проверка Input флага используя аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_UI_FLAG_A macro FlagBit?
                UI_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; установка Input флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_UI_FLAG     macro FlagBit?
                UI_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; установка Input флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_UI_FLAGS    macro Flags?
                UI_FLAGS
                SET_FLAGS (Flags?)
                endm
; -----------------------------------------
; сброс Input флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_UI_FLAG     macro FlagBit?
                UI_FLAGS
                RES_FLAG (FlagBit?)
                endm
; -----------------------------------------
; выборочный сброс Input флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_UI_FLAGS    macro Flags?
                UI_FLAGS
                RES_FLAGS (Flags?)
                endm
; -----------------------------------------
; сброс Input флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_ALL_UI_FLAGS macro
                UI_FLAGS
                RES_ALL
                endm

                endif ; ~_MACRO_GAME_UI_
