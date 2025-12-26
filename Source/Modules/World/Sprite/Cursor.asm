
                ifndef _MODULE_WORLD_SPRITE_CURSOR_
                define _MODULE_WORLD_SPRITE_CURSOR_

                module Cursor
; -----------------------------------------
; загрузка и инициализация спрайтов курсора
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load:           ; загрузка графики курсора
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LOAD_ASSETS ASSETS_ID_CURSOR_PACK                               ; загрузка ресурса спрайтов "курсора"

                ; расчёт размера копируемых данных структур FSprite
                LD HL, (GameState.Assets + FAssets.Address.Adr)
                LD B, (HL)                                                      ; количество количество заголовков графики FGraphicHeader
                
                ; инициализация функции поиска заголовка в массиве
                LD A, B
                LD (Sprite.FindGraphHeader.HeaderNum), A
                INC HL
                LD (Sprite.FindGraphHeader.HeaderAdr), HL

                ; инициализация
                LD IX, .Parser
                LD HL, Cursor.Indexes                                           ; адрес списока индексов для отображения персонажа
                LD DE, .HashSequence
                CALL Sprite.FillSpriteIndices

                ; "Idle"
                LD A, (Cursor.Indexes + 0)
                LD (World.Base.Render.Idle.SpriteID), A

                ; "Click"
                LD A, (Cursor.Indexes + 1)
                LD (World.Base.Render.Click.SpriteID), A

                CALL World.Base.Render.Cursor.Draw.Initialize                   ; инициализация состояние курсора

                ; восстановление страницы расположения загруженого ассетаа карты
                JP_SET_MODULE_PAGE_World                                        ; включить страницу модуля "World"

                ;   HL - адрес выходного массива индексов спрайтов (Adr.SpriteInfoBuffer)
                ;   DE - смещение до структуры FSpritesRef (от начала ассета)
                ;   B  - количество структур в массиве
                ;   A  - индекс спрайта в буфере спрайтов (Adr.SpriteInfoBuffer)
.Parser         PUSH HL
                LD HL, .TmpLinker
                SET SPRITE_REF_BIT, B
                LD (HL), B
                INC HL
                LD (HL), #00
                INC HL
                LD (HL), E
                INC HL
                LD (HL), D

                ; -----------------------------------------
                ; добавление спрайта
                ; In:
                ;   DE - адрес структуры FSprite
                ; Out:
                ;   A  - индекс спрайта в буфере спрайтов (Adr.SpriteInfoBuffer)
                ;   флаг переполнения Carry сброшен, если спрайт не был добавлен
                ; Corrupt:
                ;   HL, DE, B, AF
                ; Note:
                ;   * структура FSprite расположена в буфере SpriteInfoBuffer нелинейно, переход между полями изменяя старший адрес
                ;   * автоматически корректирует адрес и страницу после загрузки ассета
                ; -----------------------------------------
                LD DE, .TmpLinker
                CALL Sprite.Add                                                 ; добавление спрайта в общий список
                
                ; сохранение индекса в массиве
                POP HL
                LD (HL), A

                RET
.TmpLinker      EQU $
                FSpritesRef

.HashSequence   ; требуемая последовательность хешей
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
