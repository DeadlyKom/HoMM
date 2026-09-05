
                ifndef _MACRO_GAME_WORLD_CHRONO_
                define _MACRO_GAME_WORLD_CHRONO_
; -----------------------------------------
; установка HL на флаги управления игровым временем
; In:
; Out:
; Corrupt:
; -----------------------------------------
WORLD_CHRONO_FLAGS macro
                LD HL, GameSession.WorldTimeCtrl + FWorldTimeControl.Flags
                endm
; -----------------------------------------
; прочитать флаги управления игровым временем в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
WORLD_CHRONO_FLAGS_A macro
                LD A, (GameSession.WorldTimeCtrl + FWorldTimeControl.Flags)
                endm
; -----------------------------------------
; проверка флага управления игровым временем
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_WORLD_CHRONO_FLAG macro FlagBit?
                WORLD_CHRONO_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка флагов управления игровым временем
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_WORLD_CHRONO_FLAGS macro Flags?
                WORLD_CHRONO_FLAGS_A
                CHECK_FLAGS (Flags?)
                endm
; -----------------------------------------
; проверка флага управления игровым временем через аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_WORLD_CHRONO_FLAG_A macro FlagBit?
                WORLD_CHRONO_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; установка флага управления игровым временем
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_WORLD_CHRONO_FLAG macro FlagBit?
                WORLD_CHRONO_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; установка флагов управления игровым временем
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_WORLD_CHRONO_FLAGS macro Flags?
                WORLD_CHRONO_FLAGS
                SET_FLAGS (Flags?)
                endm
; -----------------------------------------
; сброс флага управления игровым временем
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_WORLD_CHRONO_FLAG macro FlagBit?
                WORLD_CHRONO_FLAGS
                RES_FLAG (FlagBit?)
                endm
; -----------------------------------------
; выборочный сброс флагов управления игровым временем
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_WORLD_CHRONO_FLAGS macro Flags?
                WORLD_CHRONO_FLAGS
                RES_FLAGS (Flags?)
                endm
; -----------------------------------------
; сброс всех флагов управления игровым временем
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_ALL_WORLD_CHRONO_FLAGS macro
                WORLD_CHRONO_FLAGS
                RES_ALL
                endm
; -----------------------------------------
; сменить на противоположный флаг управления игровым временем
; In:
; Out:
; Corrupt:
; -----------------------------------------
SWAP_WORLD_CHRONO_FLAG macro FlagBit?
                WORLD_CHRONO_FLAGS
                SWAP_FLAG (FlagBit?)
                endm

                endif ; ~_MACRO_GAME_WORLD_CHRONO_
