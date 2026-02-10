
                ifndef _DRAW_UTILS_TRANSFORM_POSITION_OBJECT_TO_SCREEN_
                define _DRAW_UTILS_TRANSFORM_POSITION_OBJECT_TO_SCREEN_

                module Utilities
; -----------------------------------------
; преобразование положения объекта относительно экрана
; In:
; Out:
;   IY - адрес структуры FObject
;   HL - позиция по вертикали
;   DE - позиция по горизонтали
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
TransformToScr: ; расчёт положения объекта относительно верхнего-левого видимойго края (по горизонтали)
                LD A, (IY + FObject.Position.Y.High)
                RRA
                CCF
                SBC A, A
                AND #03
                LD B, A

                LD A, (IY + FObject.Position.X.High)                            ; положение в гексагонах (6)
                ADD A, A    ; x2
                LD C, A
                ADD A, A    ; x4
                ADD A, C    ; x6
                SUB B       ; вычесть смещение по горизонтали в зависимости от чётности строки
                LD C, #00
                LD B, A
                RR B
                RR C
                LD A, (IY + FObject.Position.X.Low)                             ; положение в пикселях, сдвинутое в левую часть (биты 7-3)
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, BC
.MapPositionX   EQU $+1
                LD BC, #0000
                SBC HL, BC
                EX DE, HL

                ; расчёт положения объекта относительно верхнего-левого видимойго края (по вертикали)
                LD A, (IY + FObject.Position.Y.High)                            ; положение в гексагонах (4)
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD C, #00
                LD B, A
                RR B
                RR C
                LD A, (IY + FObject.Position.Y.Low)                             ; положение в пикселях, сдвинутое в левую часть (биты 7-3)
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, BC
.MapPositionY   EQU $+1
                LD BC, #0000
                SBC HL, BC

                RET

                display " - Transform position object to screen:\t\t", /A, TransformToScr, "\t= busy [ ", /D, $ - TransformToScr, " byte(s)  ]"
                endmodule

                endif ; ~ _DRAW_UTILS_TRANSFORM_POSITION_OBJECT_TO_SCREEN_
