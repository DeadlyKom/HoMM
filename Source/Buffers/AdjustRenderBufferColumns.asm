
                ifndef _BUFFERS_ADJUST_RENDER_BUFFER_COLUMNS_
                define _BUFFERS_ADJUST_RENDER_BUFFER_COLUMNS_
; -----------------------------------------
; корректировка столбцов рендер буфера
; In:
; Out:
; Corrupt:
; Note:
;   код расположен рядом с картой (страница 1)
; -----------------------------------------
AdjRenderBufCol:;
                LD HL, Adr.RenderBuffer + 80
                LD D, H

                LD BC, (SCR_WORLD_SIZE_X << 8) | SCR_WORLD_SIZE_X

.Loop           LD A, (GameState.DisplayListLen)
                EX AF, AF'
                PUSH HL

.ColumnLoop     ; проверка окончания колонки
                EX AF, AF'
                DEC A
                JP P, .NextColumn ; переход, т.к. текущая колонка не закончилась

                POP HL
                INC L
                DJNZ .Loop
                RET

.DownColumn     LD A, L
                ADD A, C
                LD L, A
                JR .ColumnLoop

.NextColumn     EX AF, AF'

                ;
                BIT 0, (HL)
                JR Z, .DownColumn ; переход, к следующему столбцу (ниже)

                ; проверка обновление нижнего столбца, т.к. текущий обновляется
                LD A, L
                ADD A, C
                LD E, A
                EX DE, HL
                BIT 0, (HL)
                EX DE, HL
                SET 1, (HL)
                JR Z, $+4 ; нижний столбец не обновляется, необходимо установить флаг обновления половинки
                RES 1, (HL)

                ; переход к нижнему столбцу
                EX DE, HL
                JR .ColumnLoop 

                display " - Adjust render buffer columns:\t\t\t\t", /A, AdjRenderBufCol, "\t= busy [ ", /D, $-AdjRenderBufCol, " byte(s)  ]"

                endif ; ~_BUFFERS_ADJUST_RENDER_BUFFER_COLUMNS_
