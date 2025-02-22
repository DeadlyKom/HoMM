
                ifndef _TR_DOS_WINDOW_
                define _TR_DOS_WINDOW_
; -----------------------------------------
; отображение окна
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
OpenWindow:     SET_REG_ATTR_IPB A, BLACK, CYAN, 0
                CALL SetAttribute
                
                ; анимация открытия окна
                LD BC, #0400

.WindowLoop     PUSH BC
                
                ; отобразить текущий фрейм анимации окна
                LD A, C
                CALL DrawWindow
                CALL Wait

                POP BC
                INC C                                                           ; следующий фрейм
                DJNZ .WindowLoop

                RET
                
.CLS            ; -----------------------------------------
                ; очистка прямоугольной области экрана
                ; In:
                ;   ScreenAddress? - адрес экрана
                ;   X?, Y?         - позиция в знакоместах
                ;   SizeX?         - ширина в знакоместах (кратная 2)
                ;   SizeY?         - высота в пикселях
                ;   Value?         - двухбайтное значение
                ; -----------------------------------------
                CLS_RECT SCR_ADR_BASE, Window.PosX, Window.PosY >> 3, Window.SizeX, Window.SizeY, #0000
                
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
                SET_REG_ATTR_IPB A, BLACK, WHITE, 0
                SCREEN_ATTR_ADR_REG DE, SCR_ADR_BASE, Window.PosX-1, (Window.PosY >> 3) -1
                LD BC, ((Window.SizeX + 2) << 8) | (Window.SizeY >> 3) + 2
                JP AttributeRect
; -----------------------------------------
; скрытие окна
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
CloseWindow:    PUSH AF

                ; анимация открытия окна
                LD BC, #0302

.WindowLoop     PUSH BC

                ; отобразить текущий фрейм анимации окна
                LD A, C
                PUSH AF
                CALL OpenWindow.CLS
                POP AF
                CALL DrawWindow
                CALL Wait

                POP BC
                DEC C                                                           ; следующий фрейм
                DJNZ .WindowLoop

                CALL OpenWindow.CLS

                ; установка адреса временного буфера
                LD HL, Buffer
                LD (Print.Buffer), HL

                POP AF
                RET
; -----------------------------------------
; отображение сообщения RAI
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Message_RAI:    LD HL, Buffer
                ; DE - координаты в знакоместах (D - y, E - x)
                LD D, Window.PosY >> 3
                
.Draw           ; проверка окончания сообщения
                LD A, (HL)
                OR A
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
                CALL GetLength
                
                ; выравнивание текста по горизонтали
                LD A, 16
                SRL C
                SUB C
                LD E, A
                CALL SetCursor

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
                CALL DrawChar

                SET_REG_ATTR_IPB A, BLACK, CYAN, 0
                CALL SetAttribute
                JR .DrawString

.SetInputKey    SET_REG_ATTR_IPB A, BLACK, RED, 0
                JP SetAttribute
; -----------------------------------------
; определение длины строки
; In:
; Out:
; Corrupt:
;   HL, C, AF
; Note:
; -----------------------------------------
GetLength       LD C, #00
.GetLengthLoop  LD A, (HL)
                OR A
                RET Z

                CP #0D
                RET Z

                INC C
                INC HL
                JR .GetLengthLoop
; -----------------------------------------
; задержка
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Wait:           LD BC, #3000
.Loop           DEC BC
                LD A, B
                OR C
                JR NZ, .Loop
                RET

                endif ; ~ _TR_DOS_WINDOW_
