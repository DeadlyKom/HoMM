
                ifndef _MACRO_MAIN_LOOP_
                define _MACRO_MAIN_LOOP_
; -----------------------------------------
; установка HL на MAIN флаги
; In:
; Out:
; Corrupt:
; -----------------------------------------
MAIN_FLAGS      macro
                LD HL, GameState.MainLoop
                endm
; -----------------------------------------
; прочитать значения MAIN флагов в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
MAIN_FLAGS_A    macro
                LD A, (GameState.MainLoop)
                endm
; -----------------------------------------
; проверка MAIN флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_MAIN_FLAG macro FlagBit?
                MAIN_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка MAIN флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_MAIN_FLAGS macro Flags?
                MAIN_FLAGS_A
                CHECK_FLAGS (Flags?)
                endm
; -----------------------------------------
; проверка MAIN флага используя аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_MAIN_FLAG_A macro FlagBit?
                MAIN_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; установка MAIN флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_MAIN_FLAG   macro FlagBit?
                MAIN_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; установка MAIN флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_MAIN_FLAGS  macro Flags?
                MAIN_FLAGS
                SET_FLAGS (Flags?)
                endm
; -----------------------------------------
; сброс MAIN флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_MAIN_FLAG   macro FlagBit?
                MAIN_FLAGS
                RES_FLAG (FlagBit?)
                endm
; -----------------------------------------
; выборочный сброс MAIN флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_MAIN_FLAGS  macro Flags?
                MAIN_FLAGS
                RES_FLAGS (Flags?)
                endm
; -----------------------------------------
; сброс MAIN флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_ALL_MAIN_FLAGS macro
                MAIN_FLAGS
                RES_ALL
                endm

                endif ; ~_MACRO_MAIN_LOOP_
