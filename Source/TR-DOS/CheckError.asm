
                ifndef _TR_DOS_CHECK_ERROR_
                define _TR_DOS_CHECK_ERROR_
; -----------------------------------------
; проверка ошибок после вызова #3D13
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
CheckError:     DI

                ; проверка на ошибку
                LD A, (TRDOS.TRDOS_ERR)
                OR A                                                            ; операция закончилась успешно
                RET Z

                LD B, A
                DEC A
                CP ErroroTable.Num
                JR NC, .Unrecognize                                             ; ошибка не определена

                ; определение ошибки
                ADD A, A    ; x2
                ADD A, LOW ErroroTable
                LD L, A
                ADC A, HIGH ErroroTable
                SUB L
                LD H, A

                ; чтение адреса ошибки
                LD E, (HL)
                INC HL
                LD D, (HL)
  
                ; проверка нализия адреса текста
                LD A, E
                OR D
                JR NZ, .DrawError

.Unrecognize    ; не распознанная ошибка

                ; старший полубайт
                RRCA
                RRCA
                RRCA
                RRCA
                AND #0F

                CP #0A
                CCF
                ADC A, #30
                DAA
                LD (ErrorMessages.TypeError+0), A

                ; младший полубайт
                LD A, B
                AND #0F
                
                CP #0A
                CCF
                ADC A, #30
                DAA
                LD (ErrorMessages.TypeError+1), A
                LD DE, ErrorMessages.Unrecognize
                
.DrawError      ; отображение ошибки
                PUSH DE
                CALL OpenWindow
                POP HL

                ; DE - координаты в знакоместах (D - y, E - x)
                LD D, (Window.PosY + 16) >> 3

.Draw           ; отображение строки
                PUSH HL
                CALL GetLength

                ; выравнивание текста по горизонтали
                LD A, 16
                SRL C
                SUB C
                LD E, A
                CALL SetCursor

                POP BC

.DrawString     LD A, (BC)
                OR A
                JR Z, .WaitInput

                INC BC
                CALL DrawChar
                JR .DrawString

                ; проверка нажатия любой клавиши
.WaitInput      XOR A
                IN A, (#FE)
                CPL
                AND %00011111
                JR Z, .WaitInput                                                ; если флаг нуля сброшен, клавиша нажата

                CALL CloseWindow
                SCF                                                             ; операция закончилась с ошибкой
                RET

ErroroTable:    ; таблица адресов
                DW #0000; ErrorMessages.NoFile
                DW #0000; ErrorMessages.NoExists
                DW #0000; ErrorMessages.NoSpace
                DW #0000; ErrorMessages.DirectoryFull
                DW #0000; ErrorMessages.Overflow
                DW ErrorMessages.NoDisc
                DW ErrorMessages.ErrorOnDisk
                DW #0000; ErrorMessages.SyntaxError
                DW #0000
                DW #0000; ErrorMessages.ChannelOpen
                DW #0000; ErrorMessages.NotFormatted
                DW #0000; ErrorMessages.ChannelNotOpen
.Num            EQU ($-ErroroTable) / 2
ErrorMessages:                                                                  ; Код ошибки и описание
; .NoFile         BYTE "No file\0"                                                ; 1 - нет файла
; .NoExists       BYTE "File exists\0"                                            ; 2 - файл уже существует
; .NoSpace        BYTE "No space\0"                                               ; 3 - нет места на диске
; .DirectoryFull  BYTE "Directory full\0"                                         ; 4 - каталог переполнен
; .Overflow       BYTE "Overflow of the record number\0"                          ; 5 - переполнение номера записи
.NoDisc         BYTE "No disc\0"                                                ; 6 - нет диска
.ErrorOnDisk    BYTE "Error on disk\0"                                          ; 7 - ошибка на диске
; .SyntaxError    BYTE "Syntax error\0"                                           ; 8 - ошибка синтаксиса
; .ChannelOpen    BYTE "The channel is already open\0"                            ; 10 - канал уже открыт
; .NotFormatted   BYTE "The disk is not formatted\0"                              ; 11 - диск не форматирован
; .ChannelNotOpen BYTE "The channel is not open\0"                                ; 12 - канал не открыт
.Unrecognize    BYTE "Unrecognize: "                                            ; не распознанная ошибка
.TypeError      DB #00, #00, #00                                                ; тип ошибки

                endif ; ~ _TR_DOS_CHECK_ERROR_
