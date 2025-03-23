                ifndef _MACRO_CONFIG_OPTIONS_
                define _MACRO_CONFIG_OPTIONS_
; -----------------------------------------
; установка HL на Config.Options флаги
; In:
; Out:
; Corrupt:
; -----------------------------------------
CONFIG_OPTIONS_FLAGS    macro
                LD HL, GameConfig.Options
                endm
; -----------------------------------------
; прочитать значения Config.Options флагов в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CONFIG_OPTIONS_FLAGS_A  macro
                LD A, (GameConfig.Options)
                endm
; -----------------------------------------
; проверка Config.Options флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_CONFIG_OPTIONS_FLAG macro FlagBit?
                CONFIG_OPTIONS_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка Config.Options флага используя аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_CONFIG_OPTIONS_FLAG_A macro FlagBit?
                CONFIG_OPTIONS_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; установка Config.Options флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_CONFIG_OPTIONS_FLAG macro FlagBit?
                CONFIG_OPTIONS_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; сброс Config.Options флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_CONFIG_OPTIONS_FLAG macro FlagBit?
                CONFIG_OPTIONS_FLAGS
                RES_FLAG (FlagBit?)
                endm
; -----------------------------------------
; сменить на противоположный Config.Options флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SWAP_CONFIG_OPTIONS_FLAG macro FlagBit?
                CONFIG_OPTIONS_FLAGS
                SWAP_FLAG (FlagBit?)
                endm

                endif ; ~_MACRO_CONFIG_OPTIONS_
