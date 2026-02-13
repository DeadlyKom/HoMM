
                ifndef _DRAW_SPRITE_DRAW_LOAD_ATTR_
                define _DRAW_SPRITE_DRAW_LOAD_ATTR_
; -----------------------------------------
; отображение спрайта Load с атрибутами
; In:
;   A   - позиции спрайта по горизонтали в пикселях
;   A'  - хранит при левом клипе -отрицательное смещение, в остальных позиции спрайта по горизонтали в пикселях
;   H'  - позиция спрайта по вертикали в пикселях
;   L'  - высота невидимой части спрайта в пикселях
;   DE  - адрес экрана с учётом переменной GameState.Screen
;   DE' - адрес спрайта
;   B   - новая высота спрайта видимой части спрайта в пикселях
;   B'  - новая ширина спрайта в пикселях
;   C   - ширина невидимой части спрайта в знакоместах (-/+)
;   C'  - ширина спрайта в знакоместах
; Out:
; Corrupt:
; Note:
; -----------------------------------------
DrawLD_ATTR:    ; сохранение данных bound спрайта
                LD (GameState.SpriteBound + FSpriteBound.Location.X), A
                LD A, B
                LD (GameState.SpriteBound + FSpriteBound.Size.Height), A
                EXX
                LD A, H
                LD (GameState.SpriteBound + FSpriteBound.Location.Y), A
                LD A, B
                LD (GameState.SpriteBound + FSpriteBound.Size.Width), A

                DEC C       ; началос с 1
                LD A, C                                                         ; ширины спрайта в знакоместах
                EX AF, AF'
                LD B, A                                                         ; ширина невидимой части спрайта в пикселях (-/+)

                ; расчёт смещения от начала адреса спрайта
                LD A, (DrawClipping.Flags)
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
                display " - Draw function 'LD ATTR':\t\t\t\t", /A, DrawLD_ATTR, "\t= busy [ ", /D, $-DrawLD_ATTR, " byte(s)  ]"

                endif ; ~ _DRAW_SPRITE_DRAW_LOAD_ATTR_
