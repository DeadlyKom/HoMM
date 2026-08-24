
                ifndef _MACRO_GAME_TICK_RUNTIME_
                define _MACRO_GAME_TICK_RUNTIME_
; -----------------------------------------
; установка HL на флаги состояния планировщика тиков
; In:
; Out:
; Corrupt:
; -----------------------------------------
TICK_CONTROL_FLAGS macro
                LD HL, GameState.TickRuntime + FTickRuntime.Control
                endm
; -----------------------------------------
; прочитать значения флагов состояния планировщика тиков в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
TICK_CONTROL_FLAGS_A macro
                LD A, (GameState.TickRuntime + FTickRuntime.Control)
                endm
; -----------------------------------------
; проверка флага состояния планировщика тиков
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_TICK_CONTROL_FLAG macro FlagBit?
                TICK_CONTROL_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; установка флага состояния планировщика тиков
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_TICK_CONTROL_FLAG macro FlagBit?
                TICK_CONTROL_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; установка флагов состояния планировщика тиков
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_TICK_CONTROL_FLAGS macro Flags?
                TICK_CONTROL_FLAGS
                SET_FLAGS (Flags?)
                endm
; -----------------------------------------
; сброс флага состояния планировщика тиков
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_TICK_CONTROL_FLAG macro FlagBit?
                TICK_CONTROL_FLAGS
                RES_FLAG (FlagBit?)
                endm
; -----------------------------------------
; сменить на противоположный флаг состояния планировщика тиков
; In:
; Out:
; Corrupt:
; -----------------------------------------
SWAP_TICK_CONTROL_FLAG macro FlagBit?
                TICK_CONTROL_FLAGS
                SWAP_FLAG (FlagBit?)
                endm
; -----------------------------------------
; установка HL на флаги запросов планировщика тиков
; In:
; Out:
; Corrupt:
; -----------------------------------------
TICK_REQUEST_FLAGS macro
                LD HL, GameState.TickRuntime + FTickRuntime.Requests
                endm
; -----------------------------------------
; прочитать значения флагов запросов планировщика тиков в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
TICK_REQUEST_FLAGS_A macro
                LD A, (GameState.TickRuntime + FTickRuntime.Requests)
                endm
; -----------------------------------------
; проверка флага запроса планировщика тиков
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_TICK_REQUEST_FLAG macro FlagBit?
                TICK_REQUEST_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; установка флага запроса планировщика тиков
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_TICK_REQUEST_FLAG macro FlagBit?
                TICK_REQUEST_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; установка флагов запросов планировщика тиков
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_TICK_REQUEST_FLAGS macro Flags?
                TICK_REQUEST_FLAGS
                SET_FLAGS (Flags?)
                endm
; -----------------------------------------
; сброс флага запроса планировщика тиков
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_TICK_REQUEST_FLAG macro FlagBit?
                TICK_REQUEST_FLAGS
                RES_FLAG (FlagBit?)
                endm
; -----------------------------------------
; сменить на противоположный флаг запроса планировщика тиков
; In:
; Out:
; Corrupt:
; -----------------------------------------
SWAP_TICK_REQUEST_FLAG macro FlagBit?
                TICK_REQUEST_FLAGS
                SWAP_FLAG (FlagBit?)
                endm

                endif ; ~_MACRO_GAME_TICK_RUNTIME_
