                ifndef _MACRO_GAME_INTERRUPT_
                define _MACRO_GAME_INTERRUPT_
; -----------------------------------------
; установка HL на Interrupt флаги
; In:
; Out:
; Corrupt:
; -----------------------------------------
INTERRUPT_FLAGS macro
                LD HL, GameState.Interrupt
                endm
; -----------------------------------------
; прочитать значения Interrupt флагов в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
INTERRUPT_FLAGS_A macro
                LD A, (GameState.Interrupt)
                endm
; -----------------------------------------
; проверка Interrupt флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_INTERRUPT_FLAG macro FlagBit?
                INTERRUPT_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка Interrupt флага используя аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_INTERRUPT_FLAG_A macro FlagBit?
                INTERRUPT_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; установка Interrupt флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_INTERRUPT_FLAG macro FlagBit?
                INTERRUPT_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; сброс Interrupt флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_INTERRUPT_FLAG macro FlagBit?
                INTERRUPT_FLAGS
                RES_FLAG (FlagBit?)
                endm
; -----------------------------------------
; выборочный сброс Interrupt флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_INTERRUPT_FLAGS macro FlagBit?
                INTERRUPT_FLAGS
                RES_FLAGS (FlagBit?)
                endm

                endif ; ~_MACRO_GAME_INTERRUPT_
