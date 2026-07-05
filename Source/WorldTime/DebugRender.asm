
                ifndef _WORLD_TIME_DEBUG_RENDER_
                define _WORLD_TIME_DEBUG_RENDER_
; -----------------------------------------
; отладочное отображение игрового календаря
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   формат вывода в области шириной восемь знакомест:
;     WT: 0000
;     H:    00
;     DDMMYYYY
;   WT - остаток "мировых тиков" до следующего часа
; ----------------------------------------
DebugRender:
.Flag           FLAG_MODIFY 1                                                   ; флаг, необходимости обновления отладочного отображения
                RET NC                                                          ; выход, если календарь не изменился
                RES_FLAG_MODIFY DebugRender.Flag                                ; сброс флага, после завершения отрисовки

                SET_REG_ATTR_IPB A, WHITE, BLACK, 0
                CALL Console.SetAttribute

                LD DE, #0918
                CALL Console.SetCursor

                LD BC, .WorldTickText
                CALL Console.DrawString

                LD HL, (GameSession.WorldTime + FWorldTime.WorldTick)
                CALL Convert.BinaryToDecimal.x16
                LD A, #04                                                       ; отображать четыре разряда
                CALL .DrawDecimal

                LD DE, #0A18
                CALL Console.SetCursor

                LD A, 'H'
                CALL Console.DrawChar
                LD A, ':'
                CALL Console.DrawChar

                LD BC, .LinePadding
                CALL Console.DrawString

                LD A, (GameSession.WorldTime + FWorldTime.Hour)
                CALL Console.DrawByte

                LD DE, #0B18
                CALL Console.SetCursor

                LD A, (GameSession.WorldTime + FWorldTime.Day)
                CALL Console.DrawByte

                LD A, (GameSession.WorldTime + FWorldTime.Month)
                INC A
                LD L, A
                CALL Convert.BinaryToDecimal.x8
                LD A, #02                                                       ; отображать два разряда
                CALL .DrawDecimal

                LD HL, (GameSession.WorldTime + FWorldTime.Years)
                CALL Convert.BinaryToDecimal.x16
                LD A, #04                                                       ; отображать четыре младших разряда
                ; CALL .DrawDecimal
; -----------------------------------------
; отображение десятичной строки с ведущими нулями
; In:
;   A  - ширина поля
;   HL - адрес первой цифры строки
;   C  - количество цифр
; Out:
; Corrupt:
;   HL, DE, BC, AF
; ----------------------------------------
.DrawDecimal:   CP C
                JR NC, .Padding

                ; отбросить старшие разряды, не помещающиеся в поле
                LD B, A
                LD A, C
                SUB B
.TrimLoop       INC HL
                DEC A
                JR NZ, .TrimLoop
                LD B, H
                LD C, L
                JP Console.DrawString

.Padding        PUSH HL
                SUB C
                LD B, A
                JR Z, .DrawString

.PaddingLoop    LD A, '0'
                CALL Console.DrawChar
                DJNZ .PaddingLoop

.DrawString     POP BC
                JP Console.DrawString

.WorldTickText  DB "WT: ", #00
.LinePadding    DB "    ", #00

                endif ; ~_WORLD_TIME_DEBUG_RENDER_
