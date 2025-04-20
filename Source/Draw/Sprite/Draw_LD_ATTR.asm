
                ifndef _DRAW_SPRITE_DRAW_LOAD_ATTR_
                define _DRAW_SPRITE_DRAW_LOAD_ATTR_
; -----------------------------------------
; отображение спрайта Load с атрибутами
; In:
;   A'  - ширина невидимой части спрайта в пикселях (-/+)
;   L'  - высота невидимой части спрайта в пикселях
;   DE  - адрес экрана с учётом переменной GameState.Screen
;   B   - новая высота спрайта видимой/невидимой части спрайта в пикселях (-/+)
;   C   - ширина невидимой части спрайта в знакоместах (-/+)
;   C'  - ширина спрайта в знакоместах
;   DE' - адрес спрайта
; Out:
; Corrupt:
; Note:
; -----------------------------------------
DrawLD_ATTR     EXX
                DEC C       ; началос с 1
                LD A, C                                                         ; ширины спрайта в знакоместах
                EX AF, AF'
                LD B, A                                                         ; ширина невидимой части спрайта в пикселях (-/+)

                ; расчёт смещения от начала адреса спрайта
                LD A, (DrawClipped.Flags)
                LD H, A     ; %ddmppppp                                         ; FSpriteData.Page
                XOR C
                AND %10000000
                XOR C
                LD C, H     ; %ddmppppp                                         ; значение LD/OR & XOR
                LD H, A     ; %a0000ww

                ; определение необходимости обрезать спрайт сверху
                LD A, L
                OR A
                LD L, H
                LD H, HIGH Adr.MultiplySprite
                JP Z, DrawOR_XOR_ATTR.ToCopy

                ; 
                LD H, A ; 8
                LD A, L
                AND #03
                INC A       ; начало с 0
                LD L, A

                XOR A

.PixelLoop      ADD A, H
                DEC L
                JR NZ, .PixelLoop

                LD L, A
                RRA     ; /2
                RRA     ; /4
                ADD A, L

                ; приращение смещение к адресу спрайта
                ADD A, E
                LD E, A
                ADC A, D
                SUB E
                LD D, A

                JP DrawOR_XOR_ATTR.ToCopy

                endif ; ~ _DRAW_SPRITE_DRAW_LOAD_ATTR_
