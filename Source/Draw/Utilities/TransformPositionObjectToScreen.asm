
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
TransformToScr: ; -----------------------------------------
                ; расчёт положения объекта относительно верхнего-левого видимойго края (по горизонтали)
                ; -----------------------------------------
                
                ; преобразование координаты гекса по горизонтали в формат 12.4
                LD A, (IY + FObject.Position.X.High)
                LD C, A
                ADD A, A    ; x2
                ADD A, C    ; x3
                LD B, A
                LD C, #00                                                       ; BC = X * 48 * 16

                ; смещение чётной строки влево на половину ширины гексагона
                BIT 0, (IY + FObject.Position.Y.High)
                JR NZ, .LocalPositionX                                          ; переход для нечётной строки

                DEC B
                DEC B
                LD C, #80                                                       ; BC -= 24 * 16 (#0180)

.LocalPositionX LD A, (IY + FObject.Position.X.Low)                             ; положение в пикселях, сдвинутое в левую часть (биты 7-3)
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, BC
.MapPositionX   EQU $+1
                LD BC, #0000
                SBC HL, BC
                EX DE, HL

                ; -----------------------------------------
                ; расчёт положения объекта относительно верхнего-левого видимойго края (по вертикали)
                ; -----------------------------------------
                
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
; -----------------------------------------
; преобразование положения объекта относительно экрана
; и сохранение результата для отображения спрайта
; In:
;   IY - адрес структуры объекта (FObject)
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
TransformToScr.Store:
                CALL TransformToScr
                LD (Kernel.Sprite.DrawClipping.PositionX), DE
                LD (Kernel.Sprite.DrawClipping.PositionY), HL
                RET

                display " - Transform position object to screen:\t\t", /A, TransformToScr, "\t= busy [ ", /D, $ - TransformToScr, " byte(s)  ]"
                endmodule

                endif ; ~ _DRAW_UTILS_TRANSFORM_POSITION_OBJECT_TO_SCREEN_
