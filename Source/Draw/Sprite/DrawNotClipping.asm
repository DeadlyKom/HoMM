
                ifndef _DRAW_SPRITE_DRAW_NOT_CLIPPING_
                define _DRAW_SPRITE_DRAW_NOT_CLIPPING_
; -----------------------------------------
; отображение спрайта OR & XOR (без поддержки обрезки)
; In:
;   HL - адрес структуры FSprite
;   DE - координаты в пикселях (D - y, E - x)
;   A  - страница спрайта
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY, SP
; Note:
;   ⚠️ ВАЖНО ⚠️
;   - спрайт не проверяется на границы экрана и не обрезается
;   - спрайт перед отрисовкой копируется в общий буфер
;   - спрайт может выводиться в любую область экрана
;   - основной (#4000) или теневой (#C000) экран выбирается через GameState.Screen
;
;   функция временно использует SP для чтения копии данных спрайта
;   перед завершением функции исходное значение SP восстанавливается
;
;   ℹ️ структура спрайта:
;    - FSprite.Info хранит ширину, высоту и смещение спрайта
;    - FSprite.Data хранит страницу и адрес raw-данных
;    - raw-данные содержат маску и пиксели OR & XOR без атрибутов
; -----------------------------------------
DrawNotClipping.OR_XOR
                ; установка страницы и принудительная установка режима OR & XOR
                AND %00111111                                                   ; сохранение страницы и флага отражения
                OR OR_XOR
                LD (Kernel.Sprite.DrawClipping.Flags), A

                ; расчёт ширины спрайта в байтах, начиная с нуля
                LD A, (HL)                                                      ; FSprite.Info.Width
                DEC A
                SRL A
                SRL A
                SRL A
                EX AF, AF'                                                      ; A' - ширина в байтах минус один
                
                ; подготовка высоты и отсутствующего горизонтального клипинга
                INC HL                                                          ; FSprite.Info.Height
                LD A, (HL)
                EXX
                LD B, A                                                         ; высота видимой части
                LD C, #00                                                       ; ширина невидимой части
                EXX

                INC HL                                                          ; FSprite.Info.SOx
                LD A, E
                ADD A, (HL)                                                     ; A = X + FSprite.Info.SOx
                LD E, A
                INC HL                                                          ; FSprite.Info.SOy
                LD A, D
                ADD A, (HL)                                                     ; A = Y + FSprite.Info.SOy
                LD D, A

                INC HL                                                          ; FSprite.ExtraFlags
                INC HL                                                          ; FSprite.Data.Page

                ; чтение адреса raw-данных спрайта
                INC HL                                                          ; FSprite.Data.Adr.Low
                LD C, (HL)
                INC HL                                                          ; FSprite.Data.Adr.High
                LD B, (HL)
                PUSH BC                                                         ; сохранение адреса спрайта

                ; расчёт адреса строки экрана по координате Y
                LD H, HIGH Adr.ScrAdrTable
                LD L, D
                LD A, (HL)                                                      ; младший адрес строки
                INC H
                LD D, (HL)                                                      ; старший адрес строки

                ; расчёт адреса байта экрана по координате X
                INC H
                LD B, E                                                         ; координата X для пиксельного сдвига
                LD L, B
                OR (HL)                                                         ; добавление номера знакоместа
                LD E, A

                ; выбор основного или теневого экрана
                LD A, (GameState.Screen)
                XOR D
                AND %10000000
                XOR D
                LD D, A

                ; сохранение экранного адреса в DE'
                PUSH DE
                EXX
                POP DE
                EXX
                POP DE                                                          ; восстановление адреса спрайта

                ; сохранение текущей страницы и адреса возврата
                PUSH_PAGE
                LD HL, Func.PopPage
                PUSH HL

                ; подключение страницы raw-данных спрайта
                LD A, (Kernel.Sprite.DrawClipping.Flags)
                AND %00011111
                PUSH BC
                SET_PAGE_A
                POP BC

                ; расчёт адреса таблицы размера спрайта
                EX AF, AF'
                LD L, A
                EX AF, AF'
                LD H, HIGH Adr.MultiplySprite
                JP Kernel.Sprite.DrawOR_XOR.ToCopy                              ; переход к копированию спрайта и отображению на экран

                endif ; ~_DRAW_SPRITE_DRAW_NOT_CLIPPING_
