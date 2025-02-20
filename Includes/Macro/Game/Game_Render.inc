                ifndef _MACRO_GAME_RENDER_
                define _MACRO_GAME_RENDER_
; -----------------------------------------
; установка HL на Render флаги
; In:
; Out:
; Corrupt:
; -----------------------------------------
RENDER_FLAGS    macro
                LD HL, GameState.Render
                endm
; -----------------------------------------
; прочитать значения Render флагов в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
RENDER_FLAGS_A  macro
                LD A, (GameState.Render)
                endm
; -----------------------------------------
; проверка Render флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_RENDER_FLAG macro FlagBit?
                RENDER_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка Render флага используя аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_RENDER_FLAG_A macro FlagBit?
                RENDER_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; установка Render флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_RENDER_FLAG macro FlagBit?
                RENDER_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; сброс Render флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_RENDER_FLAG macro FlagBit?
                RENDER_FLAGS
                RES_FLAG (FlagBit?)
                endm

                endif ; ~_MACRO_GAME_RENDER_
