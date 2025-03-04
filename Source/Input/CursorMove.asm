
                    ifndef _INPUT_CURSOR_MOVE_
                    define _INPUT_CURSOR_MOVE_

                    module Cursor
MoveLeft:           LD HL, Mouse.PositionX
                    LD A, (NegSpeed)
                    ADD A, (HL)
                    JR C, SetMouseLocationX                                     ; проверка на переполнение (курсор достиг левого края экрана)
                    XOR A                                                       ; фиксируем значение
SetMouseLocationX:  LD (HL), A                                                  ; изменить значение положение мыши по оси X
                    LD A, #FF
                    LD (Mouse.PositionFlag), A                                  ; установка флага изменения позиции мыши
                    RET

MoveRight:          LD HL, Mouse.PositionX
                    LD A, (Speed)
                    ADD A, (HL)
                    JR NC, SetMouseLocationX                                    ; проверка на переполнение (курсор достих правого края экрана)
                    LD A, #FF                                                   ; фиксируем значение
                    JR SetMouseLocationX
MoveUp:             LD HL, Mouse.PositionY
                    LD A, (NegSpeed)
                    ADD A, (HL)
                    JR C, SetMouseLocationY                                     ; проверка на переполнение (курсор достиг верхнего края экрана)
                    XOR A                                                       ; фиксируем значение
SetMouseLocationY:  LD (HL), A
                    LD A, #FF
                    LD (Mouse.PositionFlag), A
                    RET

MoveDown:           LD HL, Mouse.PositionY
                    LD A, (Speed)
                    ADD A, (HL)
                    JR C, .SetMaxLocationY                  ; проверка на переполнение (курсор достих нижнего края экрана)
                    CP #C0
                    JR C, SetMouseLocationY
.SetMaxLocationY    LD A, #BF                               ; фиксируем значение
                    JR SetMouseLocationY

InitAcceleration:   LD A, (GameConfig.CursorSpeedMin)
.Set                LD (Speed), A
                    NEG
                    LD (NegSpeed), A
                    RET
AccelerateCursor:   LD HL, GameConfig.CursorSpeedMax
                    LD A, (Speed)
                    INC A
                    CP (HL)
                    RET NC

                    JR InitAcceleration.Set
DecelerateCursor:   LD HL, GameConfig.CursorSpeedMin
                    LD A, (Speed)
                    DEC A
                    CP (HL)
                    RET C

                    JR InitAcceleration.Set
Speed:              DB #04
NegSpeed            DB #FC

                    endmodule

                    endif ; ~_INPUT_CURSOR_MOVE_