
                ifndef _DRAW_SPRITE_FUNCTION_NO_SHIFT_OR_XOR_ATTR_
                define _DRAW_SPRITE_FUNCTION_NO_SHIFT_OR_XOR_ATTR_

                module OR_XOR_ATTR
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
;   DE' - адрес экрана атрибутов
;   BC' - 2 батйа спрайта (значение маски и спрайта)
;   SP  - адрес спрайта
; Out:
; Corrupt:
; Note:
;   форма хранения спрайта:
;   первый байт всегда отзеркален, что позволяет исключить два раза зеркалить и маску и спрайт
; -----------------------------------------

NoShiftLeft:
._OXA_XXX_X     POP AF      ; пропуск
._OXA_XX_X      POP AF      ; пропуск
._OXA_X_X       POP AF      ; пропуск
                JP NoShift._OXA_X
._OXA_XX_XX     POP AF      ; пропуск
._OXA_X_XX      POP AF      ; пропуск
                JP NoShift._OXA_XX
._OXA_X_XXX     POP AF      ; пропуск
                JP NoShift._OXA_XXX
NoShift:
._OXA_XXXX      LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска
                XOR B       ; спрайт
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._OXA_XXX       LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска
                XOR B       ; спрайт
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._OXA_XX        LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска
                XOR B       ; спрайт
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._OXA_X         LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска
                XOR B       ; спрайт
                EXX

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
._OXA_XXX_X     POP AF      ; пропуск
._OXA_XX_X      POP AF      ; пропуск
._OXA_X_X       POP AF      ; пропуск
                JP NoShiftAttr._OXA_X
._OXA_XX_XX     POP AF      ; пропуск
._OXA_X_XX      POP AF      ; пропуск
                JP NoShiftAttr._OXA_XX
._OXA_X_XXX     POP AF      ; пропуск
                JP NoShiftAttr._OXA_XXX
NoShiftAttr:    ;
._OXA_XXXX      EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                INC E       ; следующее знакоместо
                EXX
                
._OXA_XXX       EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                INC E       ; следующее знакоместо
                EXX

._OXA_XX        EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                INC E       ; следующее знакоместо
                EXX

._OXA_X         EXX
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
._OXA_XXX_X     LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска
                XOR B       ; спрайт
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._OXA_XX_X      LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска
                XOR B       ; спрайт
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._OXA_X_X       LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска
                XOR B       ; спрайт
                EXX

                LD (DE), A  ; запись байта в экран

                POP AF      ; пропуск

                ; новая строка
                INC D
                DJNZ NextRow
                JP (IY)                                                         ; завершено отображение знакоместа

._OXA_XX_XX     LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска
                XOR B       ; спрайт
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._OXA_X_XX      LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска
                XOR B       ; спрайт
                EXX

                LD (DE), A  ; запись байта в экран

                POP AF      ; пропуск
                POP AF      ; пропуск

                ; новая строка
                INC D
                DJNZ NextRow
                JP (IY)                                                         ; завершено отображение знакоместа

._OXA_X_XXX     LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска
                XOR B       ; спрайт
                EXX

                LD (DE), A  ; запись байта в экран

                POP AF      ; пропуск
                POP AF      ; пропуск
                POP AF      ; пропуск

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
._OXA_XXX_X     EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                INC E       ; следующее знакоместо
                EXX

._OXA_XX_X      EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                INC E       ; следующее знакоместо
                EXX

._OXA_X_X       EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                EXX

                POP AF      ; пропуск
                JP NextRowAttr

._OXA_XX_XX     EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                INC E       ; следующее знакоместо
                EXX

._OXA_X_XX      EXX
                POP BC
                LD A, (DE)  ; чтение байта из экрана атрибутов
                OR C        ; маска
                XOR B       ; спрайт
                LD (DE), A  ; запись байта в экран атрибутов
                EXX

                POP AF      ; пропуск
                POP AF      ; пропуск
                JP NextRowAttr

._OXA_X_XXX     EXX
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
.OXA_8          DW NoShift._OXA_X,          NoShiftAttr._OXA_X                  ;  1.0

                DW NoShiftLeft._OXA_X_X,    NoShiftAttrLeft._OXA_X_X            ; -1.0
.OXA_16         DW NoShift._OXA_XX,         NoShiftAttr._OXA_XX                 ;  2.0
                DW NoShiftRight._OXA_X_X,   NoShiftAttrRight._OXA_X_X           ; +1.0

                DW NoShiftLeft._OXA_XX_X,   NoShiftAttrLeft._OXA_XX_X           ; -2.0
                DW NoShiftLeft._OXA_X_XX,   NoShiftAttrLeft._OXA_X_XX           ; -1.0
.OXA_24         DW NoShift._OXA_XXX,        NoShiftAttr._OXA_XXX                ;  3.0
                DW NoShiftRight._OXA_XX_X,  NoShiftAttrRight._OXA_XX_X          ; +1.0
                DW NoShiftRight._OXA_X_XX,  NoShiftAttrRight._OXA_X_XX          ; +2.0

                DW NoShiftLeft._OXA_XXX_X,  NoShiftAttrLeft._OXA_XXX_X          ; -3.0
                DW NoShiftLeft._OXA_XX_XX,  NoShiftAttrLeft._OXA_XX_XX          ; -2.0
                DW NoShiftLeft._OXA_X_XXX,  NoShiftAttrLeft._OXA_X_XXX          ; -1.0
.OXA_32         DW NoShift._OXA_XXXX,       NoShiftAttr._OXA_XXXX               ;  4.0
                DW NoShiftRight._OXA_XXX_X, NoShiftAttrRight._OXA_XXX_X         ; +1.0
                DW NoShiftRight._OXA_XX_XX, NoShiftAttrRight._OXA_XX_XX         ; +2.0
                DW NoShiftRight._OXA_X_XXX, NoShiftAttrRight._OXA_X_XXX         ; +3.0

                display " - Draw function 'No Shift OR & XOR Attribute':\t", /A, Begin_NoShift, "\t= busy [ ", /D, $-Begin_NoShift, " byte(s)  ]"
                endmodule

                endif ; ~ _DRAW_SPRITE_FUNCTION_NO_SHIFT_OR_XOR_ATTR_
