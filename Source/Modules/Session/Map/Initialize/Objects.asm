
                ifndef _MODULE_SESSION_INITIALIZE_OBJECTS_
                define _MODULE_SESSION_INITIALIZE_OBJECTS_
; -----------------------------------------
; инициализация объектов карты после загрузки
; In:
;   HL - адрес FMapHeader.ObjectNum
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Objects:        ; чтение данных об объектах
                LD A, (HL)
                OR A
                RET Z                                                           ; выход, если нет объектов для инициализации

                INC HL

                PUSH AF
                EX DE, HL

                ; -----------------------------------------
                ; копирование объектов во временный буфер
                ; -----------------------------------------

                ; умножение FMapHeader.ObjectNum * FMapObject
                LD B, #00
                LD C, A
                LD H, B
                LD L, B
                LD A, FMapObject

.MultiplyLoop   ADD HL, BC
                DEC A
                JR NZ, .MultiplyLoop

                LD B, H
                LD C, L

                LD HL, Adr.ExtraBuffer
                EX DE, HL
                CALL Memcpy.FastLDIR

                ; -----------------------------------------
                ; инициализация объектов
                ; -----------------------------------------
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                POP BC
                LD HL, Adr.ExtraBuffer

.ObjectLoop     PUSH BC
                CALL .ObjectInit
                POP BC

                DJNZ .ObjectLoop
                RET

.ObjectInit     LD B, (HL)                                                      ; FMapObject.Type
                SRL B                                                           ; ??
                INC HL
                LD E, (HL)                                                      ; FMapObject.Position.X
                INC HL
                LD D, (HL)                                                      ; FMapObject.Position.Y
                INC HL

                ; спавн объекта
                PUSH HL
                CALL Object.Spawn
                POP HL

                ; -----------------------------------------
                ; инициализация спрайта
                ; -----------------------------------------
                LD A, (HL)                                                      ; FMapObject.SpriteIndex
                INC HL
                PUSH HL

                ; проверка наличия данного индекса спрайта в мапе инициализированных спрайтов
                LD L, A
                LD H, HIGH Kernel.Sprite.BUFFER_ADDRESS
                LD A, (HL)
                
                CP Kernel.Sprite.EMPTY_INDEX
                JR Z, .AddNewIndex                                              ; переход, если индекс спрайта отсутствует в мапе инициализированных спрайтов

                ; чтение индекса спрайта из мапы инициализированных спрайтов
                LD L, (HL)
                JR .SetSprIndex

.AddNewIndex    PUSH HL                                                         ; сохраним адрес карты значения

                ; определение адреса расположения необходимой структуры FSprite
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                LD DE, (GameState.Assets + FAssets.Address.Adr)                 ; адрес загрузки ассета графического ассета
                ADD HL, DE
                EX DE, HL

                ; включение страницы ресурса
                LD A, (GameState.Assets + FAssets.Address.Page)
                SET_PAGE_A

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
                CALL Sprite.Add                                                 ; добавление спрайта в общий список
                
                ; сохранение значения в мапе инициализированных спрайтов
                POP HL
                LD (HL), A

                LD L, A

.SetSprIndex    SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                LD (IY + FObject.Sprite), L                                     ; установка индекс спрайта в буфере спрайтов Adr.SpriteInfoBuffer

                POP HL
                RET

                display " - Initialize objects:\t\t\t\t\t", /A, Objects, "\t= busy [ ", /D, $-Objects, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_INITIALIZE_OBJECTS_
