                ifndef _COMBAT_CONTOUR_TEST_
                define _COMBAT_CONTOUR_TEST_

                module ContourTest
; -----------------------------------------
; загрузка обводки для теста "сражения"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   возврат выполняется с включённой страницей "сражения"
; -----------------------------------------
Load:           ; проверка загрузки сабмодуля "обводка"
                SET_PAGE_ASSETS
                ASSETS_ADR IX, ASSETS_ID_SUBMODULE_CONTOUR
                BIT ASSETS_LOAD_BIT, (IX + FAssets.Flags)
                JR NZ, .Find                                                    ; переход, если сабмодуль уже загружен

                CALL Kernel.Submodules.Contour                                  ; загрузка и инициализация сабмодуля "обводка"

.Find           ; получение адреса загруженного диспетчера
                SET_PAGE_ASSETS
                LOAD_ASSETS ASSETS_ID_SUBMODULE_CONTOUR
                CALL GetPage
                LD (Apply.Page), A

                ; чтение адреса таблицы функций из LD HL, nnnn диспетчера
                INC HL
                LD E, (HL)
                INC HL
                LD D, (HL)
                EX DE, HL

                ; расчёт адреса бинда добавления контура
                LD BC, Contour.AddContour * 2
                ADD HL, BC
                LD E, (HL)
                INC HL
                LD D, (HL)
                LD (Apply.Function), DE
                JP_SET_MODULE_PAGE_Combat
; -----------------------------------------
; копирование загруженного кадра конька в спрайт 32x32
; In:
;   B - номер кадра
;   A - индекс FSpritesRef в SpriteInfoBuffer
; Out:
; Corrupt:
;   HL, DE, BC, AF, IXL
; Note:
;   возврат выполняется с включённой страницей "сражения"
; -----------------------------------------
Copy:           ; расчёт адреса FSpritesRef по индексу "мира"
                LD IXL, B
                AND #7F
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                LD DE, Adr.SpriteInfoBuffer
                ADD HL, DE

                ; включение страницы массива кадров
                INC L
                LD A, (HL)
                AND %00011111
                CALL SetPage
                INC L
                LD E, (HL)
                INC L
                LD D, (HL)
                EX DE, HL

                ; расчёт адреса структуры выбранного кадра
                LD A, IXL
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD E, A
                LD D, #00
                ADD HL, DE

                ; расчёт размера строки в знакоместах
                LD A, (HL)
                DEC A
                AND #1F
                SRL A
                SRL A
                SRL A
                INC A
                LD (.Width), A

                ; расчёт пропуска до следующей строки копии 32x32
                ADD A, A    ; x2
                NEG
                ADD A, #08
                LD (.Skip), A

                ; чтение размера кадра по вертикали
                INC HL
                LD A, (HL)
                LD (.Rows), A

                ; чтение страницы и адреса пикселей
                LD DE, FSprite.Data.Page - FSprite.Info.Height
                ADD HL, DE
                LD A, (HL)
                AND %00011111
                INC HL
                LD E, (HL)
                INC HL
                LD D, (HL)
                CALL SetPage

                ; очистка копии спрайта
                PUSH DE
                LD HL, Adr.SharedBuffer
                LD DE, Adr.SharedBuffer + 1
                LD BC, Size.SharedBuffer - 1
                LD (HL), #00
                LDIR
                POP DE

                ; копирование кадра со смещением 8 пикселей вправо и 1 пиксель вниз
.Rows           EQU $+1
                LD B, #00
                LD HL, Adr.SharedBuffer + 10
.Row            ; копирование строки кадра
.Width          EQU $+1
                LD C, #00
.Byte           LD A, (DE)
                INC DE
                LD (HL), A
                INC L
                LD A, (DE)
                INC DE
                LD (HL), A
                INC L
                DEC C
                JR NZ, .Byte                                                    ; переход, если остались байты исходной строки

                ; переход к следующей строке копии
.Skip           EQU $+1
                LD A, #00
                ADD A, L
                LD L, A
                DJNZ .Row

                JP_SET_MODULE_PAGE_Combat
; -----------------------------------------
; вызов обводки из теста "сражения"
; In:
;   HL - адрес спрайта
;   B' - размер спрайта по вертикали в пикселях
;   A' - размер спрайта по горизонтали в знакоместах минус один
;   GameState.View - номер фазы обводки
; Out:
; Corrupt:
; Note:
;   входные регистры сохраняются при переключении страницы
; -----------------------------------------
Apply:          ; сохранение регистров перед включением страницы обводки
                PUSH AF
                PUSH BC
                PUSH HL
.Page           EQU $+1
                LD A, #00
                CALL SetPage
                POP HL
                POP BC
                POP AF

                ; добавление контура к скопированному спрайту
.Function       EQU $+1
                CALL #0000

                ; восстановление страницы "сражения"
                PUSH AF
                PUSH BC
                PUSH HL
                SET_MODULE_PAGE_Combat
                POP HL
                POP BC
                POP AF
                RET

                endmodule

                endif                                                           ; ~ _COMBAT_CONTOUR_TEST_
