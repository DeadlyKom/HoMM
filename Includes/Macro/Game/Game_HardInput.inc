                ifndef _MACRO_CONFIG_HARD_INPUT_
                define _MACRO_CONFIG_HARD_INPUT_
; -----------------------------------------
; установка HL на HardConfig.Input флаги
; In:
; Out:
; Corrupt:
; -----------------------------------------
HARD_INPUT_FLAGS  macro
                LD HL, HardConfig.Input
                endm
; -----------------------------------------
; прочитать значения HardConfig.Input флагов в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
HARD_INPUT_FLAGS_A macro
                LD A, (HardConfig.Input)
                endm
; -----------------------------------------
; проверка HardConfig.Input флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_HARD_INPUT_FLAG macro FlagBit?
                HARD_INPUT_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка HardConfig.Input флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_HARD_INPUT_FLAGS macro Flags?
                HARD_INPUT_FLAGS_A
                CHECK_FLAGS (Flags?)
                endm
; -----------------------------------------
; проверка HardConfig.Input флага используя аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_HARD_INPUT_FLAG_A macro FlagBit?
                HARD_INPUT_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; установка HardConfig.Input флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_HARD_INPUT_FLAG macro FlagBit?
                HARD_INPUT_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; сброс HardConfig.Input флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_HARD_INPUT_FLAG macro FlagBit?
                HARD_INPUT_FLAGS
                RES_FLAG (FlagBit?)
                endm

                endif ; ~_MACRO_CONFIG_HARD_INPUT_
