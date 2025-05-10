
                ifndef _MACRO_INPUT_
                define _MACRO_INPUT_
; -----------------------------------------
; установка HL на Input флаги
; In:
; Out:
; Corrupt:
; -----------------------------------------
INPUT_FLAGS     macro
                LD HL, GameState.Input
                endm
; -----------------------------------------
; прочитать значения Input флагов в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
INPUT_FLAGS_A   macro
                LD A, (GameState.Input)
                endm
; -----------------------------------------
; проверка Input флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_INPUT_FLAG macro FlagBit?
                INPUT_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка Input флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_INPUT_FLAGS macro Flags?
                INPUT_FLAGS_A
                CHECK_FLAGS (Flags?)
                endm
; -----------------------------------------
; проверка Input флага используя аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_INPUT_FLAG_A macro FlagBit?
                INPUT_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; установка Input флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_INPUT_FLAG  macro FlagBit?
                INPUT_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; установка Input флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_INPUT_FLAGS macro Flags?
                INPUT_FLAGS
                SET_FLAGS (Flags?)
                endm
; -----------------------------------------
; сброс Input флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_INPUT_FLAG  macro FlagBit?
                INPUT_FLAGS
                RES_FLAG (FlagBit?)
                endm
; -----------------------------------------
; выборочный сброс Input флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_INPUT_FLAGS macro Flags?
                INPUT_FLAGS
                RES_FLAGS (Flags?)
                endm
; -----------------------------------------
; сброс Input флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_ALL_INPUT_FLAGS macro
                INPUT_FLAGS
                RES_ALL
                endm

                endif ; ~_MACRO_INPUT_
