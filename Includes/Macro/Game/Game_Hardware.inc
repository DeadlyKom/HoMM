                ifndef _MACRO_CONFIG_HARDWARE_
                define _MACRO_CONFIG_HARDWARE_
; -----------------------------------------
; установка HL на Hardware флаги
; In:
; Out:
; Corrupt:
; -----------------------------------------
HARDWARE_FLAGS  macro
                LD HL, GameConfig.Hardware
                endm
; -----------------------------------------
; прочитать значения Hardware флагов в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
HARDWARE_FLAGS_A macro
                LD A, (GameConfig.Hardware)
                endm
; -----------------------------------------
; проверка Hardware флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_HARDWARE_FLAG macro FlagBit?
                HARDWARE_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка Hardware флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_HARDWARE_FLAGS macro Flags?
                HARDWARE_FLAGS_A
                CHECK_FLAGS (Flags?)
                endm
; -----------------------------------------
; проверка Hardware флага используя аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_HARDWARE_FLAG_A macro FlagBit?
                HARDWARE_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; установка Hardware флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_HARDWARE_FLAG macro FlagBit?
                HARDWARE_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; сброс Hardware флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_HARDWARE_FLAG macro FlagBit?
                HARDWARE_FLAGS
                RES_FLAG (FlagBit?)
                endm

                endif ; ~_MACRO_CONFIG_HARDWARE_
