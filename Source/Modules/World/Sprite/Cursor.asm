
                ifndef _MODULE_WORLD_SPRITE_CURSOR_
                define _MODULE_WORLD_SPRITE_CURSOR_

                module Cursor
; -----------------------------------------
; загрузка и инициализация спрайтов курсора
; In:
; Out:
; Corrupt:
; Note:
;   в общей памяти
; -----------------------------------------
Load:           LD A, ASSETS_ID_CURSOR_PACK
                LD HL, Cursor.Indexes
                LD DE, .HashSequence
                CALL World.Sprite.Load

                ; частная инициализация курсора после загрузки пакета спрайтов
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана

                LD A, (Cursor.Indexes + 0)                                      ; "Idle"
                LD (UI_Cursor.Idle.SpriteID), A

                LD A, (Cursor.Indexes + 1)                                      ; "Click"
                LD (UI_Cursor.Click.SpriteID), A
                CALL UI_Cursor.Initialize                                       ; инициализация состояния курсора

                JP_SET_MODULE_PAGE_World                                        ; восстановить страницу модуля "World"

; ⚠️ ВАЖНО ⚠️
;   количество хешей и размер массива Cursor.Indexes должны точно
;   соответствовать количеству FGraphicHeader в пакете ASSETS_ID_CURSOR_PACK
.HashSequence
                lua allpass
                Hash16("Idle")
                Hash16("Click")
                endlua

Cursor.Indexes  ; индексы спрайтов в буфере спрайтов (Adr.SpriteInfoBuffer)
                DB #00                                                          ; "Idle"
                DB #00                                                          ; "Click"

                display " - Sprite initialize cursor:\t\t\t\t", /A, Load, "\t= busy [ ", /D, $-Load, " byte(s)  ]"
                endmodule

                endif ; ~ _MODULE_WORLD_SPRITE_CURSOR_
