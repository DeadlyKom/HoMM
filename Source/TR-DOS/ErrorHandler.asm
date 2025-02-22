
                ifndef _TR_DOS_ERROR_HANDLER_
                define _TR_DOS_ERROR_HANDLER_
; -----------------------------------------
; обработчик ошибок работы в TR-DOS
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
ErrorHandler:   POP DE                                                          ; извлечение адреса ПЗУ

                ; проверка вызова процедуры "опроса клавиши BREAK"
                LD HL, #1F54
                OR A
                SBC HL, DE
                JR Z, DOS_Return                                                ; опроса клавиши BREAK
                
                ; проверка вызова процедуры "очистка экрана и открытие канала 0"
                LD HL, #0D6B
                OR A
                SBC HL, DE
                JP Z, OpenWindow                                                ; очистка экрана и открытие канала 0

                ; проверка вызова процедуры "печати символа"
                LD HL, #0010
                OR A
                SBC HL, DE
                JP Z, Print.ToBuffer                                            ; печать символа

                ; проверка вызова процедуры "печати цифры в BC"
                LD HL, #1A1B
                OR A
                SBC HL, DE
                JP Z, Print.ToBuffer_BC                                         ; печать цифры в BC

                ; проверка вызова процедуры "опрос клавиатуры"
                LD HL, #028E
                OR A
                SBC HL, DE
                JR Z, DOS_Return                                                ; 
                
                ; проверка вызова процедуры "опрос клавиатуры"
                LD HL, #031E
                OR A
                SBC HL, DE
                JR Z, DOS_Return                                                ; 
                
                ; проверка вызова процедуры "опроса клавиш R, A, I"
                LD HL, #0333
                OR A
                SBC HL, DE
                JP Z, DOS_RAI                                                   ; опроса клавиш R, A, I

                PUSH DE                                                         ; возвращение адреса вызова ПЗУ
DOS_RestoreRegs ; восстановление HL, DE и вызов процедуры ПЗУ
                LD HL, (TRDOS.SAVE_HL)
                LD DE, (TRDOS.SAVE_DE)
                RET
; -----------------------------------------
; вернуться в DOS со включенным флагом Z и C вместо опроса
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
DOS_Return:     LD A, #01
                ADD A, #FF
                RET
; -----------------------------------------
; отображение сообщения RAI и ожидание опроса клавиш
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
DOS_RAI:        CALL Message_RAI                                                ; отображение RAI сообщения
                CALL DOS_Input                                                  ; ожидание нажатия клавиши RAI
                JP CloseWindow                                                  ; завершить окно
; -----------------------------------------
; опрос клавиш R, A, I для ошибоки в TR-DOS'осе
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
DOS_Input:      LD A, #FB
                IN A, (#FE)
                BIT 3, A
                LD A, 'R'
                RET Z
                LD A, #FD
                IN A, (#FE)
                BIT 0, A
                LD A, 'A'
                RET Z
                LD A, #DF
                IN A, (#FE)
                BIT 2, A
                LD A, 'I'
                RET Z
                JR DOS_Input

                endif ; ~ _TR_DOS_ERROR_HANDLER_
