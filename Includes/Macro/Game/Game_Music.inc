                ifndef _MACRO_GAME_MUSIC_
                define _MACRO_GAME_MUSIC_
; -----------------------------------------
; установка HL на Music флаги
; In:
; Out:
; Corrupt:
; -----------------------------------------
MUSIC_FLAGS     macro
                LD HL, GameState.Music
                endm
; -----------------------------------------
; прочитать значения Music флагов в аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
MUSIC_FLAGS_A   macro
                LD A, (GameState.Music)
                endm
; -----------------------------------------
; проверка Music флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_MUSIC_FLAG macro FlagBit?
                MUSIC_FLAGS
                CHECK_FLAG (FlagBit?)
                endm
; -----------------------------------------
; проверка Music флага используя аккумулятор
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_MUSIC_FLAG_A macro FlagBit?
                MUSIC_FLAGS_A
                CHECK_FLAG_A (FlagBit?)
                endm
; -----------------------------------------
; проверка Music флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
CHECK_MUSIC_FLAGS macro Flags?
                MUSIC_FLAGS_A
                CHECK_FLAGS (Flags?)
                endm
; -----------------------------------------
; установка Music флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_MUSIC_FLAG  macro FlagBit?
                MUSIC_FLAGS
                SET_FLAG (FlagBit?)
                endm
; -----------------------------------------
; сброс Music флага
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_MUSIC_FLAG  macro FlagBit?
                MUSIC_FLAGS
                RES_FLAG (FlagBit?)
                endm
; -----------------------------------------
; выборочный сброс Music флагов
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_MUSIC_FLAGS macro FlagBit?
                MUSIC_FLAGS
                RES_FLAGS (FlagBit?)
                endm

                endif ; ~_MACRO_GAME_MUSIC_
