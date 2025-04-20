
                ifndef _DRAW_SPRITE_FUNCTION_NO_SHIFT_LD_ATTR_
                define _DRAW_SPRITE_FUNCTION_NO_SHIFT_LD_ATTR_

                module LD_ATTR
Begin_NoShift:  EQU $
; -----------------------------------------
;
; In:
;   HL  - адрес экрана (начало строки)
;   DE  - адрес экрана (текущий)
;   B   - количество оставшихся строк в знакоместе
;   C   - количество оставшихся строк рисования
;   H'  - старший байт таблицы преобразования адреса экрана в атрибутный
;   L'  - младший адрес первоночального адреса экрана атрибутов
;   DE  - адрес экрана атрибутов
;   BC' - 2 батйа спрайта (значение маски и спрайта)
;   SP  - адрес спрайта
; Out:
; Corrupt:
; Note:
;   форма хранения спрайта:
;   первый байт всегда отзеркален, что позволяет исключить два раза зеркалить и маску и спрайт
; -----------------------------------------

NoShiftLeft:
._LDA_XXX_X     INC SP      ; пропуск
._LDA_XX_X      INC SP      ; пропуск
._LDA_X_X       INC SP      ; пропуск
                JP NoShift._LDA_X
._LDA_XX_XX     INC SP      ; пропуск
._LDA_X_XX      INC SP      ; пропуск
                JP NoShift._LDA_XX
._LDA_X_XXX     INC SP      ; пропуск
                JP NoShift._LDA_XXX
NoShift:
._LDA_XXXX      DEC SP
                POP AF

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._LDA_XXX       DEC SP
                POP AF

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._LDA_XX        DEC SP
                POP AF

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._LDA_X         DEC SP
                POP AF

                LD (DE), A  ; запись байта в экран

                ; новая строка
                INC D
                DJNZ NextRow
                JP (IY)                                                         ; завершено отображение знакоместа

; -----------------------------------------
;   HL  - адрес экрана (начало строки)
;   DE  - адрес экрана (текущий)
;   B   - количество оставшихся строк в знакоместе
;   C   - количество оставшихся строк рисования
;   H'  - старший байт таблицы преобразования адреса экрана в атрибутный
;   L'  - младший адрес первоночального адреса экрана атрибутов
;   DE  - адрес экрана атрибутов
;   BC' - 2 батйа спрайта (значение маски и спрайта)
;   SP  - адрес спрайта
; -----------------------------------------
NoShiftAttrLeft:
._LDA_XXX_X     POP AF      ; пропуск
._LDA_XX_X      POP AF      ; пропуск
._LDA_X_X       POP AF      ; пропуск
                JP NoShiftAttr._LDA_X
._LDA_XX_XX     POP AF      ; пропуск
._LDA_X_XX      POP AF      ; пропуск
                JP NoShiftAttr._LDA_XX
._LDA_X_XXX     POP AF      ; пропуск
                JP NoShiftAttr._LDA_XXX
NoShiftAttr:    ;
._LDA_XXXX      EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                INC E       ; следующее знакоместо
                EXX
                
._LDA_XXX       EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                INC E       ; следующее знакоместо
                EXX

._LDA_XX        EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                INC E       ; следующее знакоместо
                EXX

._LDA_X         EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                EXX
NextRowAttr:    DEC C
                JP Z, Kernel.Sprite.DrawOR_XOR_ATTR.Exit

                ; новая строка атрибутов
                EXX
                LD E, L
                LD A, E
                ADD A, #20
                LD E, A
                ADC A, D
                SUB E
                LD D, A
                LD L, E
                EXX

                LD B, #08
                LD A, L
                ADD A, #20
                LD L, A
                JR C, .NextBoundary                                             ; переход, если переход на следующую 1/3 экрана
                LD D, H                                                         ; восстановление адреса экрана
                LD E, L
                JP (IX)

.NextBoundary   LD H, D                                                         ; сохранение старший байт адреса экрана
NextRow         LD E, L                                                         ; восстановление младший байт адреса экрана
                JP (IX)
NoShiftRight:
._LDA_XXX_X     DEC SP
                POP AF

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._LDA_XX_X      DEC SP
                POP AF

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._LDA_X_X       DEC SP
                POP AF

                LD (DE), A  ; запись байта в экран

                INC SP      ; пропуск

                ; новая строка
                INC D
                DJNZ NextRow
                JP (IY)                                                         ; завершено отображение знакоместа

._LDA_XX_XX     DEC SP
                POP AF

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._LDA_X_XX      DEC SP
                POP AF

                LD (DE), A  ; запись байта в экран

                INC SP      ; пропуск
                INC SP      ; пропуск

                ; новая строка
                INC D
                DJNZ NextRow
                JP (IY)                                                         ; завершено отображение знакоместа

._LDA_X_XXX     DEC SP
                POP AF

                LD (DE), A  ; запись байта в экран

                INC SP      ; пропуск
                INC SP      ; пропуск
                INC SP      ; пропуск

                ; новая строка
                INC D
                DJNZ NextRow
                JP (IY)                                                         ; завершено отображение знакоместа
; -----------------------------------------
;   HL  - адрес экрана (начало строки)
;   DE  - адрес экрана (текущий)
;   B   - количество оставшихся строк в знакоместе
;   C   - количество оставшихся строк рисования
;   H'  - старший байт таблицы преобразования адреса экрана в атрибутный
;   L'  - младший адрес первоночального адреса экрана атрибутов
;   DE  - адрес экрана атрибутов
;   BC' - 2 батйа спрайта (значение маски и спрайта)
;   SP  - адрес спрайта
; -----------------------------------------
NoShiftAttrRight:
._LDA_XXX_X     EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                INC E       ; следующее знакоместо
                EXX

._LDA_XX_X      EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                INC E       ; следующее знакоместо
                EXX

._LDA_X_X       EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                EXX

                POP AF      ; пропуск
                JP NextRowAttr

._LDA_XX_XX     EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                INC E       ; следующее знакоместо
                EXX

._LDA_X_XX      EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                EXX

                POP AF      ; пропуск
                POP AF      ; пропуск
                JP NextRowAttr

._LDA_X_XXX     EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                EXX

                POP AF      ; пропуск
                POP AF      ; пропуск
                POP AF      ; пропуск
                JP NextRowAttr
NoShift.Table:
.LDA_8          DW NoShift._LDA_X,          NoShiftAttr._LDA_X                  ;  1.0

                DW NoShiftLeft._LDA_X_X,    NoShiftAttrLeft._LDA_X_X            ; -1.0
.LDA_16         DW NoShift._LDA_XX,         NoShiftAttr._LDA_XX                 ;  2.0
                DW NoShiftRight._LDA_X_X,   NoShiftAttrRight._LDA_X_X           ; +1.0

                DW NoShiftLeft._LDA_XX_X,   NoShiftAttrLeft._LDA_XX_X           ; -2.0
                DW NoShiftLeft._LDA_X_XX,   NoShiftAttrLeft._LDA_X_XX           ; -1.0
.LDA_24         DW NoShift._LDA_XXX,        NoShiftAttr._LDA_XXX                ;  3.0
                DW NoShiftRight._LDA_XX_X,  NoShiftAttrRight._LDA_XX_X          ; +1.0
                DW NoShiftRight._LDA_X_XX,  NoShiftAttrRight._LDA_X_XX          ; +2.0

                DW NoShiftLeft._LDA_XXX_X,  NoShiftAttrLeft._LDA_XXX_X          ; -3.0
                DW NoShiftLeft._LDA_XX_XX,  NoShiftAttrLeft._LDA_XX_XX          ; -2.0
                DW NoShiftLeft._LDA_X_XXX,  NoShiftAttrLeft._LDA_X_XXX          ; -1.0
.LDA_32         DW NoShift._LDA_XXXX,       NoShiftAttr._LDA_XXXX               ;  4.0
                DW NoShiftRight._LDA_XXX_X, NoShiftAttrRight._LDA_XXX_X         ; +1.0
                DW NoShiftRight._LDA_XX_XX, NoShiftAttrRight._LDA_XX_XX         ; +2.0
                DW NoShiftRight._LDA_X_XXX, NoShiftAttrRight._LDA_X_XXX         ; +3.0

                display " - Draw function 'No Shift LD Attribute':\t\t", /A, Begin_NoShift, "\t= busy [ ", /D, $-Begin_NoShift, " byte(s)  ]"
                endmodule

                endif ; ~ _DRAW_SPRITE_FUNCTION_NO_SHIFT_LD_ATTR_
