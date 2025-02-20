
                ifndef _TR_DOS_WINDOW_
                define _TR_DOS_WINDOW_
; -----------------------------------------
; отображение окна
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
OpenWindow:     ; анимация открытия окна
                LD BC, #0400

.WindowLoop     PUSH BC
                
                ; отобразить текущий фрейм анимации окна
                LD A, C
                CALL DrawWindow

                ; задержка
                HALT
                HALT
                HALT

                POP BC
                INC C                                                           ; следующий фрейм
                DJNZ .WindowLoop
                RET
                ; JP_POP_PAGE                                                     ; восстановление номера страницы из стека

.CLS            ; -----------------------------------------
                ; очистка прямоугольной области экрана
                ; In:
                ;   ScreenAddress? - адрес экрана
                ;   X?, Y?         - позиция в знакоместах
                ;   SizeX?         - ширина в знакоместах (кратная 2)
                ;   SizeY?         - высота в пикселях
                ;   Value?         - двухбайтное значение
                ; -----------------------------------------
                CLS_RECT SCR_ADR_BASE, ERR_WIN_PIX_X, ERR_WIN_PIX_Y >> 3, ERR_WIN_PIX_SX, ERR_WIN_PIX_SY, #0000

                ; -----------------------------------------
                ; заполнение прямоугольника атрибутом
                ; In:
                ;   A  - цвет заполнения
                ;   DE - адрес экрана
                ;   BC - размер прямоугольника (B - y, C - x)
                ; Out:
                ; Corrupt:
                ; Note:
                ; -----------------------------------------
                SCREEN_ATTR_ADR_REG DE, SCR_ADR_BASE, ERR_WIN_PIX_X, ERR_WIN_PIX_Y >> 3
                LD BC, (ERR_WIN_PIX_SX << 8) | (ERR_WIN_PIX_SY >> 3)
                SET_REG_ATTR_IPB A, BLACK, CYAN, 0
                CALL Console.SetAttribute
                JP AttributeRect
; -----------------------------------------
; скрытие окна
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
CloseWindow:    EI
                PUSH AF

                PUSH_PAGE                                                       ; сохранение номера страницы в стеке
                CALL Convert.SetShadowScreen                                    ; установка работы с основным экраном по адресу #C000
                SET_PAGE_VISIBLE_SCREEN                                         ; установка страницы видимого экрана

                ; анимация открытия окна
                LD BC, #0302

.WindowLoop     PUSH BC
                LD A, C
                PUSH AF
                ; CALL RestoreScreen
                
                ; отобразить текущий фрейм анимации окна
                POP AF
                CALL DrawWindow

                ; задержка
                HALT
                HALT
                HALT

                POP BC
                DEC C                                                           ; следующий фрейм
                DJNZ .WindowLoop

                ; CALL RestoreScreen

                ; ; восстановление данных из временной области
                ; SET_PAGE_4
                ; LD HL, Adr.TemporaryBuffer
                ; LD DE, Adr.SpriteInfoBuffer
                ; LD BC, Size.TemporaryBuffer 
                ; CALL Memcpy.FastLDIR

                ; установка адреса временного буфера
                LD HL, Adr.SharedBuffer
                LD (Print.Buffer), HL

                POP_PAGE                                                        ; восстановление номера страницы из стека

                POP AF
                DI
                RET

; -----------------------------------------
; отображение сообщения RAI
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Message_RAI:    ;PUSH_PAGE                                                       ; сохранение номера страницы в стеке
                CALL Convert.SetShadowScreen                                    ; установка работы с основным экраном по адресу #C000
                SET_PAGE_VISIBLE_SCREEN                                         ; установка страницы видимого экрана
                
                LD HL, Adr.SharedBuffer
                LD A, (Console.Attribute)
                LD (.DefaultAttr), A

                ; DE - координаты в знакоместах (D - y, E - x)
                LD D, ERR_WIN_PIX_Y >> 3
                
.Draw           ; проверка окончания сообщения
                LD A, (HL)
                OR A
                ; JP Z, Func.PopPage                                              ; восстановление номера страницы из стека
                RET Z

                ; проверка перехода на новую строку
                CP #0D
                JR NZ, .DrawLine
                INC D                                                           ; следующая строка
                INC HL
                JR .Draw

.DrawLine       ; отображение строки
                PUSH DE
                PUSH HL
                CALL .GetLength
                
                ; выравнивание текста по горизонтали
                LD A, 16
                SRL C
                SUB C
                LD E, A
                CALL Console.SetCursor

                POP BC
                CALL .DrawString
                LD H, B
                LD L, C
                POP DE
                JR .Draw

.DrawString     LD A, (BC)
                OR A
                RET Z

                CP #0D
                RET Z

                PUSH AF
                CP 'R'
                CALL Z, .SetInputKey
                CP 'A'
                CALL Z, .SetInputKey
                CP 'I'
                CALL Z, .SetInputKey
                POP AF

                INC BC
                CALL Console.DrawChar
.DefaultAttr    EQU $+1
                LD A, #00
                CALL Console.SetAttribute
                JR .DrawString

.SetInputKey    SET_REG_ATTR_IPB A, BLACK, RED, 0
                JP Console.SetAttribute

.GetLength      LD C, #00
.GetLengthLoop  LD A, (HL)
                OR A
                RET Z

                CP #0D
                RET Z

                INC C
                INC HL
                JR .GetLengthLoop

                endif ; ~ _TR_DOS_WINDOW_
