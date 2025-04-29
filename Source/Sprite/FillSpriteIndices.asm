
                ifndef _SPRITE_FILL_SPRITE_INDICES_
                define _SPRITE_FILL_SPRITE_INDICES_
; -----------------------------------------
; заполнение массива индексов спрайтов, согласно указанной последовательности
; In:
;   HL - адрес заполняемого массива индексов
;   DE - адрес хеша
;   IX - адрес функции парсера
;        HL - адрес выходного массива индексов спрайтов (Adr.SpriteInfoBuffer)
;        DE - смещение от начала ассета
;        B  - количество структур в массиве
;        A  - индекс спрайта в буфере спрайтов (Adr.SpriteInfoBuffer)
; Out:
;   HL - адрес найденой структуры FGraphicHeader
;   флаг переполнения Carry сброшен, если поиск удачен
; Corrupt:
; Note:
;   необходимо проинициализировать следующие переменные
;       FindGraphHeader.HeaderNum - количество количество заголовков графики FGraphicHeader
;       FindGraphHeader.HeaderAdr - адрес массива заголовков графики FGraphicHeader
; -----------------------------------------
FillSpriteIndices:
                LD (.ArrayInicesAdr), HL
.Loop           PUSH BC
                PUSH DE
                CALL FindGraphHeader
                JR C, .Next

                ; рассчёт адреса FSpriteHeader.Num
                LD BC, FGraphicHeader.Num
                ADD HL, BC
                LD A, (HL)
                OR A
                JR Z, .Next

                ; чтение количество спрайтов в массиве FGraphicHeader.Num
                LD B, A
                INC HL

                ; чтение смещения FGraphicHeader.Offset
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL

                PUSH HL
.ArrayInicesAdr EQU $+1
                LD HL, #0000
                CALL .Parser                                                    ; парсинг структуры
                LD HL, (.ArrayInicesAdr)
                INC HL
                LD (.ArrayInicesAdr), HL
                POP HL
                JR .NextGraph
.Parser         JP (IX)
                
.Next           ; неудалось найти нужный заголовок, отметить блок как несуществующий
                LD HL, (.ArrayInicesAdr)
                LD (HL), #FF
                INC HL
                LD (.ArrayInicesAdr), HL
                
.NextGraph      ; переход к следующему хешу
                POP DE
                INC DE
                INC DE

                POP BC
                DJNZ .Loop
                RET

                display " - Sprite fill sprite indices:\t\t\t", /A, FillSpriteIndices, "\t= busy [ ", /D, $-FillSpriteIndices, " byte(s)  ]"

                endif ; ~_SPRITE_FILL_SPRITE_INDICES_
