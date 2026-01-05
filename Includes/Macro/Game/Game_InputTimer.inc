                ifndef _MACRO_INPUT_TIMER_
                define _MACRO_INPUT_TIMER_
; -----------------------------------------
; установка HL на Input.Timer флаги
; In:
; Out:
; Corrupt:
; -----------------------------------------
INPUT_TIMER_FLAGS macro
                LD HL, GameState.Input.Timer
                endm
; -----------------------------------------
; прочитать значения Input.Timer флагов в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
INPUT_TIMER_FLAGS_A macro
                LD A, (GameState.Input.Timer)
                endm
; -----------------------------------------
; проверка Input.Timer флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_INPUT_TIMER_FLAG macro FlagBit?
                INPUT_TIMER_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка Input.Timer флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_INPUT_TIMER_FLAGS macro Flags?
                INPUT_TIMER_FLAGS_A
                CHECK_FLAGS (Flags?)
                endm
; -----------------------------------------
; проверка Input.Timer флага используя аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_INPUT_TIMER_FLAG_A macro FlagBit?
                INPUT_TIMER_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; установка Input.Timer флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_INPUT_TIMER_FLAG macro FlagBit?
                INPUT_TIMER_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; сброс Input.Timer флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_INPUT_TIMER_FLAG macro FlagBit?
                INPUT_TIMER_FLAGS
                RES_FLAG (FlagBit?)
                endm

                endif ; ~_MACRO_INPUT_TIMER_
