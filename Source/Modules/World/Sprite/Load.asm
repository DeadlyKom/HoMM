
                ifndef _MODULE_WORLD_SPRITE_LOAD_
                define _MODULE_WORLD_SPRITE_LOAD_
; -----------------------------------------
; загрузка и инициализация пакета спрайтов
; In:
;   A  - идентификатор ресурса
;   HL - адрес массива индексов спрайтов
;   DE - адрес последовательности хешей
; Out:
; Corrupt:
; Note:
;   ⚠️ ВАЖНО ⚠️
;       - количество хешей и размер массива индексов должны соответствовать
;         количеству заголовков FGraphicHeader в загружаемом графическом пакете
;       - порядок индексов определяется порядком хешей в последовательности
; -----------------------------------------
Load:           PUSH HL                                                         ; сохранение адреса массива индексов
                PUSH DE                                                         ; сохранение адреса последовательности хешей
                PUSH AF                                                         ; сохранение идентификатора ресурса

                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                POP AF
                LOAD_ASSETS_A                                                   ; загрузка ресурса спрайтов

                LD HL, (GameState.Assets + FAssets.Address.Adr)
                LD B, (HL)                                                      ; количество заголовков графики FGraphicHeader

                ; инициализация функции поиска заголовка в массиве
                LD A, B
                LD (Sprite.FindGraphHeader.HeaderNum), A
                INC HL
                LD (Sprite.FindGraphHeader.HeaderAdr), HL

                ; заполнение массива индексов согласно последовательности хешей
                POP DE
                POP HL
                LD IX, .Parser
                CALL Sprite.FillSpriteIndices

                JP_SET_MODULE_PAGE_World                                        ; восстановить страницу модуля "World"

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

                LD DE, .TmpLinker
                CALL Sprite.Add                                                 ; добавление спрайта в общий список

                POP HL
                LD (HL), A                                                      ; сохранение индекса в массиве
                RET

.TmpLinker      EQU $
                FSpritesRef

                display " - Sprite load pack:\t\t\t\t\t", /A, Load, "\t= busy [ ", /D, $-Load, " byte(s)  ]"

                endif ; ~ _MODULE_WORLD_SPRITE_LOAD_
