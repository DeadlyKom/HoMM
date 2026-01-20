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
; проверка Render флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_RENDER_FLAGS macro Flags?
                RENDER_FLAGS_A
                CHECK_FLAGS (Flags?)
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
; установка Render флага переключение экрана автоматически
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_RENDER_AUTO macro
                RENDER_FLAGS
                RES_FLAGS ((1 << SWAP_TARGET_BITS) | (1 <<(SWAP_TARGET_BITS+1)))
                endm
; -----------------------------------------
; установка Render флага переключение экрана на базовый
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_RENDER_BASE macro
                RENDER_FLAGS
                SET_FLAG SWAP_TARGET_BITS
                RET_FLAG (SWAP_TARGET_BITS+1)
                endm
; -----------------------------------------
; установка Render флага переключение экрана на теневой
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_RENDER_SHADOW macro
                RENDER_FLAGS
                SET_FLAGS ((1 << SWAP_TARGET_BITS) | (1 <<(SWAP_TARGET_BITS+1)))
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
; -----------------------------------------
; выборочный сброс Render флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_RENDER_FLAGS macro FlagBit?
                RENDER_FLAGS
                RES_FLAGS (FlagBit?)
                endm

                endif ; ~_MACRO_GAME_RENDER_
